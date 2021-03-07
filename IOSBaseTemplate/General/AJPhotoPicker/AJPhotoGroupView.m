//
//  BoPhotoGroupView.m
//  PhotoPicker
//
//  Created by AlienJunX on 15/11/2.
//  Copyright © 2015年 com.alienjun.demo. All rights reserved.
//

#import "AJPhotoGroupView.h"
#import "AJPhotoGroupCell.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "AJPhotoPickerViewController.h"

@interface AJPhotoGroupView()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) NSMutableArray *groups;
@end

@implementation AJPhotoGroupView

#pragma mark - init
- (instancetype)init {
    self = [super init];
    if (self) {
        [self initCommon];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self initCommon];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initCommon];
    }
    return self;
}

- (void)initCommon {
    self.delegate = self;
    self.dataSource = self;
    [self registerClass:[AJPhotoGroupCell class] forCellReuseIdentifier:@"cell"];
    self.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.backgroundColor = [UIColor clearColor];
}

- (void)setupGroup {
    [self.groups removeAllObjects];
    
    __weak typeof(self) weakSelf = self;
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        
        if(nil == strongSelf) {
            return;
        }
            
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
            if (NO == [collection isKindOfClass:[PHAssetCollection class]]) {
                continue;
            }
            
            if([collection.localizedTitle isEqualToString:@"Recents"]) {
                [strongSelf.groups insertObject:collection atIndex:0];
                continue;;
            }
            
            PHFetchOptions *fetchOption = [[PHFetchOptions alloc] init];
            fetchOption.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:YES]];
            fetchOption.predicate = [NSPredicate predicateWithFormat:@"mediaType == %ld", PHAssetMediaTypeImage];
            PHFetchResult *result = [PHAsset fetchAssetsInAssetCollection:(PHAssetCollection *)collection options:fetchOption];
            if(result.count) {
                [strongSelf.groups addObject:collection];
            }
        }
        
        [strongSelf dataReload];
    }];
}

#pragma mark - Reload Data
- (void)dataReload {
    
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        
        if(nil == strongSelf) {
            return;
        }
        
        if (strongSelf.groups.count == 0) {
            [strongSelf showNoAssets];
        }
        
        if (strongSelf.groups.count >0 && [strongSelf.my_delegate respondsToSelector:@selector(didSelectGroup:)]) {
            [strongSelf.my_delegate didSelectGroup:self.groups[0]];
        }
        [strongSelf reloadData];
    });
}

#pragma mark - Not allowed / No assets
- (void)showNotAllowed {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"NotAllowedPhoto" object:nil];
    if ([_my_delegate respondsToSelector:@selector(didSelectGroup:)]) {
        [_my_delegate didSelectGroup:nil];
    }
}

- (void)showNoAssets {
    NSLog(@"%s",__func__);
}

#pragma mark - uitableviewDelegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifer = @"cell";
    AJPhotoGroupCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifer forIndexPath:indexPath];
    if(cell == nil){
        cell = [[AJPhotoGroupCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifer];
    }
    
    [cell bind:[self.groups objectAtIndex:indexPath.row]];
    if (indexPath.row == self.selectIndex) {
        cell.backgroundColor = [UIColor colorWithRed:217.0/255.0 green:217.0/255.0 blue:217.0/255.0 alpha:1.0];
    }
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.groups.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    self.selectIndex = indexPath.row;
    [self reloadData];
    PHAssetCollection *group = [self.groups objectAtIndex:indexPath.row];
    if ([_my_delegate respondsToSelector:@selector(didSelectGroup:)]) {
        [_my_delegate didSelectGroup:group];
    }
}

#pragma mark - getter/setter
- (NSMutableArray *)groups {
    if (!_groups) {
        _groups = [[NSMutableArray alloc] init];
    }
    return _groups;
}

@end
