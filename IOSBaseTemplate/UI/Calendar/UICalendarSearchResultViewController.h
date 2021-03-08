//
//  UICalendarSearchResultViewController.h
//  IOSBaseTemplate
//
//  Created by WYStudio on 2021/2/19.
//

#import <UIKit/UIKit.h>
#import "UIBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@class CalendarTypeModel;

@interface UICalendarSearchResultViewController : UIBaseViewController

@property (nonatomic, strong) NSArray<CalendarTypeModel *> *dataArray;

@end

NS_ASSUME_NONNULL_END
