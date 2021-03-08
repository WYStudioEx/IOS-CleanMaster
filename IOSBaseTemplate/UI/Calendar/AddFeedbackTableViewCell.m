//
//  AddFeedbackTableViewCell.m
//  IOSBaseTemplate
//
//  Created by WYStudio on 2021/2/19.
//

#import "AddFeedbackTableViewCell.h"

@interface AddFeedbackTableViewCell ()

@property (strong, nonatomic) UIImageView *selectImageView;
@property (strong, nonatomic) QMUILabel *titleLabel;

@end



@implementation AddFeedbackTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        if(nil == _selectImageView) {
            self.selectImageView = [[UIImageView alloc] init];
            [self.contentView addSubview:_selectImageView];
        }

        if(nil == _titleLabel) {
            self.titleLabel = [[QMUILabel alloc] init];
            _titleLabel.numberOfLines = 1;
            
            _titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
            _titleLabel.textColor = [UIColor blackColor];
            [self.contentView addSubview:_titleLabel];
        }
        
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

- (void)layoutSubviews {
    [super layoutSubviews];
    [_selectImageView sizeToFit];
    _selectImageView.qmui_left = _size_W_S_X(12);
    _selectImageView.qmui_top = (self.qmui_height - _selectImageView.qmui_height) / 2.0;
    
    [_titleLabel sizeToFit];
    _titleLabel.qmui_left = _selectImageView.qmui_right + _size_W_S_X(30);
    _titleLabel.qmui_width = self.qmui_width - _titleLabel.qmui_left - _size_W_S_X(10);
    _titleLabel.qmui_top = (self.qmui_height - _titleLabel.qmui_height) / 2.0;
    
    _horizontalLine.frame = CGRectMake(0, self.contentView.qmui_height - _size_H_S_X(1), self.contentView.qmui_width, _size_H_S_X(1));
}

- (void)setChildModel:(CalendarContentModel *)childModel{
    _childModel = childModel;
    
    _selectImageView.image = UIImageMake(_childModel.isSelect ? @"feedback_select" : @"feedback_noSelect");
    self.titleLabel.text = _childModel.desc;
    
    [self setNeedsLayout];
}

@end
