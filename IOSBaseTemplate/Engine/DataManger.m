//
//  DataManger.m
//  IOSBaseTemplate
//
//  Created by WYStudio on 21/2/22.
//  Copyright (c) 2021年 WYStudio. All rights reserved.
//

#import "DataManger.h"

@interface DataManger ()

@property (nonatomic, retain) EKEventStore *store;

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

-(void)getScheduleEvent:(void (^)(NSArray *eventArray))completion {
    if(nil == self.store) {
        self.store = [[EKEventStore alloc] init];
    }
    
    __weak typeof(self) weakSelf = self;
    [_store requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        
        if(nil == strongSelf || NO == granted) {
            completion(nil);
            return;
        }
    
        NSArray *calendarsArray = [strongSelf.store calendarsForEntityType:EKEntityTypeEvent];
        for (int i = 0; i < calendarsArray.count; i++) {
            EKCalendar *temp = calendarsArray[i];
            if (NO == [temp.title isEqual:@"Calendar"] && NO == [temp.title isEqual:@"日历"]) {
                continue;
            }
            
            NSDate *endTime = [[NSDate alloc] init];
            NSDate *startTime = [strongSelf getPriousorLaterDateFromDate:endTime withMonth:-(12 * 4)];
            
            NSPredicate *predicate = [strongSelf.store predicateForEventsWithStartDate:startTime endDate:endTime calendars:[NSArray arrayWithObject:temp]];
            
            NSArray *events = [strongSelf.store eventsMatchingPredicate:predicate];
            completion(events);
            return;
        }
        
        completion(nil);
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
    [event setCalendar:[self.store defaultCalendarForNewEvents]];
    
    NSError *err;
    [self.store removeEvent:event span:EKSpanThisEvent commit:YES error:&err];
    return err == nil;
}


@end
