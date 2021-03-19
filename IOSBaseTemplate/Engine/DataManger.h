//
//  DataManger.h
//  IOSBaseTemplate
//
//  Created by WYStudio on 21/2/22.
//  Copyright (c) 2021年 WYStudio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <EventKit/EventKit.h>

@interface DataManger : NSObject

+ (instancetype)shareInstance;

//日历相关
- (void)getScheduleEvent:(void (^)(NSArray *eventArray, NSArray *eventArray2))completion;
- (BOOL)deleteEvent:(NSArray *)events;

//照片数据读取
- (void)getPhotoData:(void (^)(NSArray *recentsArray, NSArray *selfiesArray, NSArray *screenshotsArray, NSArray *liveArray))completion;
- (NSArray<UIImage *> *)getAllPhotosAssetInAblumCollection:(PHAssetCollection *)assetCollection ascending:(BOOL)ascending;

//磁盘相关
- (void)getDiskOf:(void (^)(CGFloat totalsize, CGFloat freesize))completion;

- (long long)getDateTimeTOMilliSeconds:(NSDate *)datetime;

@end
