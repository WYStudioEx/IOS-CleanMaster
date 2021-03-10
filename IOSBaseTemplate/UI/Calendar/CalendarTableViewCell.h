//
//  CalendarTableViewCell.h
//  IOSBaseTemplate
//
//  Created by WYStudio on 2021/2/19.
//

#import <UIKit/UIKit.h>
#import "CalendarContentModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface CalendarTableViewCell : UITableViewCell

@property (nonatomic, strong) UIView *horizontalLine;
@property (nonatomic, strong) CalendarContentModel *childModel;

@end

NS_ASSUME_NONNULL_END
