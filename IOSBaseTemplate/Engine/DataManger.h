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

+(instancetype)shareInstance;

//日历相关
-(void)getEvent:(void (^)(NSArray *eventArray))completion;
-(BOOL)deleteEvent:(EKEvent *)event;

@end
