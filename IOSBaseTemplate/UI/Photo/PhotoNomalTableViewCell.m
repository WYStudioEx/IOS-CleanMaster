//
//  PhotoNomalTableViewCell.m
//  IOSBaseTemplate
//
//  Created by WYStudio on 2021/2/19.
//

#import "PhotoNomalTableViewCell.h"
#import "PhotoContentModel.h"

@interface PhotoNomalTableViewCell ()

@property (strong, nonatomic) UIImageView *photoImageView1;
@property (strong, nonatomic) UIImageView *photoImageView2;
@property (strong, nonatomic) UIImageView *photoImageView3;
@property (strong, nonatomic) UIImageView *photoImageView4;
@property (strong, nonatomic) UIImageView *photoImageView5;

@end

//---------------------------------------------------
@implementation PhotoNomalTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        if(nil == _photoImageView1) {
            self.photoImageView1 = [[UIImageView alloc] init];
            _photoImageView1.tag = 1000;
            [self.contentView addSubview:_photoImageView1];
            
            UIImageView *selectImageView = [[UIImageView alloc] init];
            selectImageView.tag = 1000;
            [_photoImageView1 addSubview:selectImageView];
            
            UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
            [_photoImageView1 addGestureRecognizer:singleTap];
        }
        _photoImageView1.hidden = YES;
        
        if(nil == _photoImageView2) {
            self.photoImageView2 = [[UIImageView alloc] init];
            _photoImageView2.tag = 1001;
            [self.contentView addSubview:_photoImageView2];
            
            UIImageView *selectImageView = [[UIImageView alloc] init];
            selectImageView.tag = 1000;
            [_photoImageView2 addSubview:selectImageView];
            
            UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
            [_photoImageView2 addGestureRecognizer:singleTap];
        }
        _photoImageView2.hidden = YES;
        
        if(nil == _photoImageView3) {
            self.photoImageView3 = [[UIImageView alloc] init];
            _photoImageView3.tag = 1002;
            [self.contentView addSubview:_photoImageView3];
            
            UIImageView *selectImageView = [[UIImageView alloc] init];
            selectImageView.tag = 1000;
            [_photoImageView3 addSubview:selectImageView];
            
            UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
            [_photoImageView3 addGestureRecognizer:singleTap];
        }
        _photoImageView3.hidden = YES;
        
        if(nil == _photoImageView4) {
            self.photoImageView4 = [[UIImageView alloc] init];
            _photoImageView4.tag = 1003;
            [self.contentView addSubview:_photoImageView4];
            
            UIImageView *selectImageView = [[UIImageView alloc] init];
            selectImageView.tag = 1000;
            [_photoImageView4 addSubview:selectImageView];
            
            UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
            [_photoImageView4 addGestureRecognizer:singleTap];
        }
        _photoImageView4.hidden = YES;
        
        if(nil == _photoImageView5) {
            self.photoImageView5 = [[UIImageView alloc] init];
            _photoImageView5.tag = 1004;
            [self.contentView addSubview:_photoImageView5];
            
            UIImageView *selectImageView = [[UIImageView alloc] init];
            selectImageView.tag = 1000;
            [_photoImageView5 addSubview:selectImageView];
            
            UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
            [_photoImageView5 addGestureRecognizer:singleTap];
        }
        _photoImageView5.hidden = YES;
        
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
    _childModel.photos[photoView.tag - 1000].isSelect = !(_childModel.photos[photoView.tag - 1000].isSelect);
    [photoView viewWithTag:1000].hidden = (NO == _childModel.photos[photoView.tag - 1000].isSelect);
}

- (void)layoutSubviews {
    [super layoutSubviews];
//    [_selectImageView sizeToFit];
//    _selectImageView.qmui_left = _size_W_S_X(12);
//    _selectImageView.qmui_top = (self.qmui_height - _selectImageView.qmui_height) / 2.0;
//
//    [_titleLabel sizeToFit];
//    _titleLabel.qmui_left = _selectImageView.qmui_right + _size_W_S_X(30);
//    _titleLabel.qmui_width = self.qmui_width - _titleLabel.qmui_left - _size_W_S_X(10);
//    _titleLabel.qmui_top = (self.qmui_height - _titleLabel.qmui_height) / 2.0;
    
    _horizontalLine.frame = CGRectMake(0, self.contentView.qmui_height - _size_H_S_X(1), self.contentView.qmui_width, _size_H_S_X(1));
}

- (void)setChildModel:(PhotoContentModel *)childModel{
    _childModel = childModel;
    
    _photoImageView1.hidden = YES;
    _photoImageView2.hidden = YES;
    _photoImageView3.hidden = YES;
    _photoImageView4.hidden = YES;
    _photoImageView5.hidden = YES;
    
    int index = 0;
    if(childModel.photos.count > index) {
        _photoImageView1.hidden = NO;
        _photoImageView1.image = childModel.photos[index].image;
        UIImageView *sel = [_photoImageView1 viewWithTag:1000];
        sel.hidden = (NO == childModel.photos[index].isSelect);
    }
    
    index = 1;
    if(childModel.photos.count > index) {
        _photoImageView2.hidden = NO;
        _photoImageView2.image = childModel.photos[index].image;
        UIImageView *sel = [_photoImageView2 viewWithTag:1000];
        sel.hidden = (NO == childModel.photos[0].isSelect);
    }
    
    index = 2;
    if(childModel.photos.count > index) {
        _photoImageView3.hidden = NO;
        _photoImageView3.image = childModel.photos[index].image;
        UIImageView *sel = [_photoImageView3 viewWithTag:1000];
        sel.hidden = (NO == childModel.photos[index].isSelect);
    }
    
    index = 3;
    if(childModel.photos.count > index) {
        _photoImageView4.hidden = NO;
        _photoImageView4.image = childModel.photos[index].image;
        UIImageView *sel = [_photoImageView4 viewWithTag:1000];
        sel.hidden = (NO == childModel.photos[index].isSelect);
    }

    index = 4;
    if(childModel.photos.count > index) {
        _photoImageView5.hidden = NO;
        _photoImageView5.image = childModel.photos[index].image;
        UIImageView *sel = [_photoImageView5 viewWithTag:1000];
        sel.hidden = (NO == childModel.photos[index].isSelect);
    }

    [self setNeedsLayout];
}

+ (CGFloat) calculateHeight:(PhotoContentModel *) childModel {
    return 100;
}


@end
