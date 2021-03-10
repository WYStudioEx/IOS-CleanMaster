//
//  PhotoTableViewCell.h
//  IOSBaseTemplate
//
//  Created by WYStudio on 2021/2/19.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class PhotoContentModel;

@interface PhotoTableViewCell : UITableViewCell

@property (nonatomic, strong) UIView *horizontalLine;
@property (nonatomic, strong) PhotoContentModel *childModel;

@end

NS_ASSUME_NONNULL_END
