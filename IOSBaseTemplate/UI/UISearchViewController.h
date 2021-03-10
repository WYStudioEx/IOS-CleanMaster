//
//  UISearchViewController.h
//  IOSBaseTemplate
//
//  Created by WYStudio on 2021/2/19.
//

#import <UIKit/UIKit.h>
#import "UIBaseViewController.h"

typedef NS_ENUM(NSUInteger, SearchType) {
    SearchTypeNormal,
    SearchTypeAICleare,
    SearchTypeCalendar,
    SearchTypePhone 
};

NS_ASSUME_NONNULL_BEGIN

@interface UISearchViewController : UIBaseViewController

@property(nonatomic, assign) SearchType searchType;

@end

NS_ASSUME_NONNULL_END
