//
//  PhotoNomalTableViewCell.m
//  IOSBaseTemplate
//
//  Created by WYStudio on 2021/2/19.
//

#import "PhotoNomalTableViewCell.h"
#import "PhotoContentModel.h"

#define left_margin _size_W_S_X(5)
#define item_margin _size_W_S_X(5)
#define beginPhotoViewTag 1000
#define selViewTag 2000
#define itemCount 3

@interface PhotoNomalTableViewCell()

@end

//---------------------------------------------------
@implementation PhotoNomalTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView qmui_removeAllSubviews];
        
        //-------
        if(nil == _horizontalLine) {
            self.horizontalLine = [[UIView alloc] init];
            _horizontalLine.backgroundColor = [UIColor greenColor];
            [self.contentView addSubview:_horizontalLine];
        }
        _horizontalLine.hidden = YES;
        
        self.contentView.backgroundColor = [UIColor clearColor];
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)handleSingleTap:(UIGestureRecognizer *)gestureRecognizer{
    UIImageView *photoView = (UIImageView *)(gestureRecognizer.view);
    _childModel.photos[photoView.tag - beginPhotoViewTag].isSelect = !(_childModel.photos[photoView.tag - beginPhotoViewTag].isSelect);
    ((UIImageView *)[photoView viewWithTag:selViewTag]).image = UIImageMake(_childModel.photos[photoView.tag - beginPhotoViewTag].isSelect ? @"feedback_select" : @"feedback_noSelect");
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat itemWidth = (SCREEN_WIDTH - (left_margin * 2) - 2 * item_margin) / itemCount;
    CGFloat left = left_margin;
    CGFloat top = 0;
    for(int i = 0; i < _childModel.photos.count; i++) {
        UIImageView *photoImageView = [self.contentView viewWithTag:beginPhotoViewTag + i];
        photoImageView.frame = CGRectMake(left, top, itemWidth, itemWidth);
        left = photoImageView.qmui_right + item_margin;
        
        UIImageView *selImageView = [photoImageView viewWithTag:selViewTag];
        selImageView.qmui_right = photoImageView.qmui_width - 10;
        selImageView.qmui_top = 10;
        
        if((i % itemCount) == 2){
            left = left_margin;
            top = photoImageView.qmui_bottom + item_margin;
        }
    }
    
    _horizontalLine.frame = CGRectMake(0, self.contentView.qmui_height - _size_H_S_X(1), self.contentView.qmui_width, _size_H_S_X(1));
}

- (void)setChildModel:(PhotoContentModel *)childModel{
    _childModel = childModel;
    [self.contentView qmui_removeAllSubviews];
    
    for(int i = 0; i < _childModel.photos.count; i++) {
        UIImageView *photoImageView = [[UIImageView alloc] init];
        photoImageView.tag = beginPhotoViewTag + i;
        photoImageView.image = _childModel.photos[i].image;
        photoImageView.userInteractionEnabled = YES;
        photoImageView.layer.cornerRadius = 6;
        photoImageView.clipsToBounds = YES;
        photoImageView.userInteractionEnabled = YES;
        [self.contentView addSubview:photoImageView];
        
        UIImageView *selectImageView = [[UIImageView alloc] init];
        selectImageView.tag = selViewTag;
        selectImageView.image = UIImageMake(_childModel.photos[i].isSelect ? @"feedback_select" : @"feedback_noSelect");
        [selectImageView sizeToFit];
        [photoImageView addSubview:selectImageView];
        
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
        [photoImageView addGestureRecognizer:singleTap];
    }
    
    if(_horizontalLine) {
        [self.contentView addSubview:_horizontalLine];
    }
    [self setNeedsLayout];
}

+ (CGFloat)calculateHeight:(PhotoContentModel *) childModel {
    NSUInteger rowCount = childModel.photos.count / itemCount  + (childModel.photos.count % itemCount == 0 ? 0 : 1);
    CGFloat itemWidth = (SCREEN_WIDTH - (left_margin * 2) - 2 * item_margin) / itemCount;
    return (itemWidth + item_margin) * rowCount - item_margin;
}


@end
