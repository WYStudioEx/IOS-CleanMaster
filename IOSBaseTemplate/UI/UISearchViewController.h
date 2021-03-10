//
//  UISearchViewController.h
//  IOSBaseTemplate
//
//  Created by WYStudio on 2021/2/19.
//

#import <UIKit/UIKit.h>
#import "UIBaseViewController.h"

typedef enum : NSUInteger {
    e_Normal_Type= 0,
    e_aiCleare_Type,
    e_CalendarSearch_Type,
    e_PhoneSearch_Type,
} SearchType;

NS_ASSUME_NONNULL_BEGIN

@interface UISearchViewController : UIBaseViewController

@property(nonatomic, assign) SearchType searchType;

@end

NS_ASSUME_NONNULL_END
