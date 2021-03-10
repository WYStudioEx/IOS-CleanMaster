//
//  ChildFeedbackModel.h
//  IOSBaseTemplate
//
//  Created by WYStudio on 2021/2/19.
//

#import <Foundation/Foundation.h>
#import <EventKit/EKEvent.h>

NS_ASSUME_NONNULL_BEGIN

@interface CalendarContentModel : NSObject

@property (nonatomic, strong) EKEvent *event;

@property (nonatomic, assign) BOOL isSelect;


@end

NS_ASSUME_NONNULL_END
