//
//  DataManger.m
//  IOSBaseTemplate
//
//  Created by WYStudio on 21/2/22.
//  Copyright (c) 2021年 WYStudio. All rights reserved.
//

#import "DataManger.h"
#import "PhotoAnalysis.h"

#import <Contacts/CNContact.h>
#import <Contacts/CNContactStore.h>
#import <Contacts/CNContact+Predicates.h>
#import <Contacts/CNContactFetchRequest.h>
#import <Contacts/CNSaveRequest.h>

@interface DataManger ()

@property (nonatomic, strong) EKEventStore *scheduleStore;
@property (nonatomic, strong) CNContactStore *contactStore;


@end

//--------------------------------------------------------------------
@implementation DataManger

+ (instancetype)shareInstance
{
    static dispatch_once_t once;
    static DataManger *sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[DataManger alloc] init];
    });
    return sharedInstance;
}

#pragma 日程
- (void)getScheduleEvent:(void (^)(NSArray *eventArray))completion {
    if(nil == self.scheduleStore) {
        self.scheduleStore = [[EKEventStore alloc] init];
    }
    
    __weak typeof(self) weakSelf = self;
    [_scheduleStore requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        
        if(nil == strongSelf || NO == granted) {
            completion(nil);
            return;
        }
    
        NSArray *events = [NSArray array];
        NSArray *calendarsArray = [strongSelf.scheduleStore calendarsForEntityType:EKEntityTypeEvent];
        for (int i = 0; i < calendarsArray.count; i++) {
            EKCalendar *temp = calendarsArray[i];
            if (NO == [temp.title isEqual:@"Calendar"] && NO == [temp.title isEqual:@"日历"]) {
                continue;
            }
            
            NSDate *endTime = [[NSDate alloc] init];
            NSDate *startTime = [strongSelf getPriousorLaterDateFromDate:endTime withMonth:-(12 * 4)];
            NSPredicate *predicate = [strongSelf.scheduleStore predicateForEventsWithStartDate:startTime endDate:endTime calendars:[NSArray arrayWithObject:temp]];
            events = [strongSelf.scheduleStore eventsMatchingPredicate:predicate];
            break;
        }
        
        completion(events);
    }];
}

- (NSDate*)getPriousorLaterDateFromDate:(NSDate*)date withMonth:(int)month{
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    [comps setMonth:month];
    NSCalendar *calender = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDate *mDate = [calender dateByAddingComponents:comps toDate:date options:0];
    return mDate;

}

- (BOOL)deleteEvent:(NSArray *)events {
    BOOL bDelete = NO;
    for(EKEvent *event in events) {
        [event setCalendar:[self.scheduleStore defaultCalendarForNewEvents]];
        
        NSError *err;
        [self.scheduleStore removeEvent:event span:EKSpanThisEvent commit:YES error:&err];
        bDelete = (err == nil);
    }
    
    return bDelete;
}

- (void)getPhotoData:(void (^)(NSArray *photoList))completion {
    NSMutableArray *photoArray = [NSMutableArray array];
    
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
        if (@available(iOS 14.0, *)) {
            if(status != PHAuthorizationStatusAuthorized &&  status != PHAuthorizationStatusLimited) {
                return;
            }
        } else {
            if(status != PHAuthorizationStatusAuthorized) {
                return;
            }
        }
        
        PHFetchResult *smartAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
        
        for(PHCollection *collection in smartAlbums) {
            if (NO == [collection isKindOfClass:[PHAssetCollection class]] || NO == [collection.localizedTitle isEqualToString:@"Recents"]) {
                continue;
            }
            
            [photoArray addObjectsFromArray:[self getAllPhotosAssetInAblumCollectionEx:(PHAssetCollection *)collection ascending:YES]];
        }
        
        completion(photoArray);
    }];
}

- (NSArray<PHAsset *> *)getAllPhotosAssetInAblumCollectionEx:(PHAssetCollection *)assetCollection ascending:(BOOL)ascending {
    PHFetchOptions *fetchOption = [[PHFetchOptions alloc] init];
    fetchOption.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:ascending]];
    fetchOption.predicate = [NSPredicate predicateWithFormat:@"mediaType == %ld", PHAssetMediaTypeImage];
    PHFetchResult *result = [PHAsset fetchAssetsInAssetCollection:assetCollection options:fetchOption];
    if(result.count <= 0) {
        return nil;
    }
    
    NSMutableArray<PHAsset *> *assetArray = [[NSMutableArray alloc] initWithCapacity:result.count];
    PHImageRequestOptions *imageRequestOptions = [[PHImageRequestOptions alloc] init];
    imageRequestOptions.synchronous = YES;
    imageRequestOptions.resizeMode = PHImageRequestOptionsResizeModeExact;
    [result enumerateObjectsUsingBlock:^(PHAsset *asset, NSUInteger idx, BOOL * _Nonnull stop) {
        [assetArray addObject:asset];
    }];
    
    return assetArray;
}


- (NSArray<UIImage *> *)getAllPhotosAssetInAblumCollection:(PHAssetCollection *)assetCollection ascending:(BOOL)ascending {
    PHFetchOptions *fetchOption = [[PHFetchOptions alloc] init];
    fetchOption.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:ascending]];
    fetchOption.predicate = [NSPredicate predicateWithFormat:@"mediaType == %ld", PHAssetMediaTypeImage];
    PHFetchResult *result = [PHAsset fetchAssetsInAssetCollection:assetCollection options:fetchOption];
    if(result.count <= 0) {
        return nil;
    }
    
    NSMutableArray<UIImage *> *imageArray = [[NSMutableArray alloc] initWithCapacity:result.count];
    PHImageRequestOptions *imageRequestOptions = [[PHImageRequestOptions alloc] init];
    imageRequestOptions.synchronous = YES;
    imageRequestOptions.resizeMode = PHImageRequestOptionsResizeModeExact;
    [result enumerateObjectsUsingBlock:^(PHAsset *asset, NSUInteger idx, BOOL * _Nonnull stop) {
        [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:PHImageManagerMaximumSize contentMode:PHImageContentModeDefault options:imageRequestOptions resultHandler:^(UIImage * _Nullable image, NSDictionary * _Nullable info) {
            [imageArray addObject:image];
        }];
    }];
    
    return imageArray;
}

- (void)getDiskOf:(void (^)(CGFloat totalsize, CGFloat freesize))completion {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        /// 总大小
         float totalsize = 0.0;
         /// 剩余大小
         float freesize = 0.0;
         /// 是否登录
         NSError *error = nil;
         NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
         NSDictionary *dictionary = [[NSFileManager defaultManager] attributesOfFileSystemForPath:[paths lastObject] error: &error];
         if (dictionary)
         {
             NSNumber *_free = [dictionary objectForKey:NSFileSystemFreeSize];
             freesize = [_free unsignedLongLongValue]*1.0/(1024);
             
             NSNumber *_total = [dictionary objectForKey:NSFileSystemSize];
             totalsize = [_total unsignedLongLongValue]*1.0/(1024);
             
             completion(totalsize/1024.0/1024.0, freesize/1024.0/1024.0);
         } else
         {
             NSLog(@"Error Obtaining System Memory Info: Domain = %@, Code = %ld", [error domain], (long)[error code]);
         }
    });
}

- (long long)getDateTimeTOMilliSeconds:(NSDate *)datetime {
    NSTimeInterval interval = [datetime timeIntervalSince1970];
    NSLog(@"转换的时间戳=%f",interval);
    long long totalMilliseconds = interval*1000 ;
    NSLog(@"totalMilliseconds=%llu",totalMilliseconds);
    return totalMilliseconds;
}

@end
