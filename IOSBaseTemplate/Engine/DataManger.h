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
- (void)getScheduleEvent:(void (^)(NSArray *eventArray))completion;
- (BOOL)deleteEvent:(NSArray *)events;

//通讯录数据读取
- (void)getContactData:(void (^)(NSArray *contactList))completion;

//照片数据读取
- (void)getPhotoData:(void (^)(NSArray *photoList))completion;

//照片数据读取
- (void)getDiskOf:(void (^)(CGFloat totalsize, CGFloat freesize))completion;

- (NSArray *)getAllPhotosAssetInAblumCollection:(PHAssetCollection *)assetCollection ascending:(BOOL)ascending;

- (long long)getDateTimeTOMilliSeconds:(NSDate *)datetime;

@end
