//
//  DataManger.m
//  IOSBaseTemplate
//
//  Created by WYStudio on 21/2/22.
//  Copyright (c) 2021年 WYStudio. All rights reserved.
//

#import "DataManger.h"

#define kSecondOfOneDay 24*60*60

@interface DataManger ()

@property (nonatomic, retain) EKEventStore *store;

@end

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

-(void)getEvent:(void (^)(NSArray *eventArray))completion {
    if(nil == self.store) {
        self.store = [[EKEventStore alloc] init];
    }
    
    __weak typeof(self) weakSelf = self;
    [_store requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error) {
        if(nil == weakSelf || NO == granted) {
            completion(nil);
            return;
        }
        
        __strong typeof(weakSelf) strongSelf = weakSelf;
    
        NSArray *calendarsArray = [strongSelf.store calendarsForEntityType:EKEntityTypeEvent];
        EKCalendar *calendar = nil;
        NSArray *events = nil;
        for (int i = 0; i < calendarsArray.count; i++) {
            EKCalendar *temp = calendarsArray[i];
            if ([temp.title isEqual:@"Calendar"] || [temp.title isEqual:@"日历"]) {
                calendar = temp;
                break;
            }
        }
        if (calendar != nil) {
            NSDate *endTime = [[NSDate alloc] init];
            NSDate *startTime = [strongSelf getPriousorLaterDateFromDate:endTime withMonth:-(12 * 4)];
            
            NSPredicate *predicate = [strongSelf.store predicateForEventsWithStartDate:startTime endDate:endTime calendars:[NSArray arrayWithObject:calendar]];
            
            events = [strongSelf.store eventsMatchingPredicate:predicate];
            completion(events);
        }
    }];
}

- (NSDate*)getPriousorLaterDateFromDate:(NSDate*)date withMonth:(int)month{

    NSDateComponents *comps = [[NSDateComponents alloc] init];
    [comps setMonth:month];
    NSCalendar *calender = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];// NSGregorianCalendar
    NSDate *mDate = [calender dateByAddingComponents:comps toDate:date options:0];
    return mDate;

}

-(BOOL)deleteEvent:(EKEvent *)event {
    NSError *err;
    [event setCalendar:[self.store defaultCalendarForNewEvents]];
    [self.store removeEvent:event span:EKSpanThisEvent commit:YES error:&err];
    if (err == nil) {
        return YES;
    }
    return NO;
}


@end
