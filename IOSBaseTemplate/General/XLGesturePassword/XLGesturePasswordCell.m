//
//  XLGestureCell.m
//  手势密码Demo
//
//  Created by MengXianLiang on 2018/5/23.
//  Copyright © 2018年 jwzt. All rights reserved.
//

#import "XLGesturePasswordCell.h"

@interface XLGesturePasswordCell () {
    UIView *_centerBall;
    BOOL _selected;
}
@end

@implementation XLGesturePasswordCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self buildUI];
    }
    return self;
}

- (void)buildUI {
    _itemBackGoundColor = [UIColor colorWithRed:129/255.0f green:129/255.0f blue:129/255.0f alpha:1];
    _itemCenterBallColor = [UIColor redColor];
    
    CGFloat dotW = self.bounds.size.width*0.45;
    _centerBall = [[UIView alloc] initWithFrame:CGRectMake(0, 0, dotW, dotW)];
    _centerBall.center = CGPointMake(self.bounds.size.width/2.0f, self.bounds.size.height/2.0f);
    _centerBall.layer.cornerRadius = _centerBall.bounds.size.height/2.0f;
    _centerBall.layer.masksToBounds = true;
    [self addSubview:_centerBall];
}

- (void)setGestureSelected:(BOOL)gestureSelected {
    _selected = gestureSelected;
    _centerBall.backgroundColor = gestureSelected ?  _itemCenterBallColor : _itemBackGoundColor;
}

- (void)setItemBackGoundColor:(UIColor *)itemBackGoundColor {
    _itemBackGoundColor = itemBackGoundColor;
    _centerBall.backgroundColor = _selected ?  _itemCenterBallColor : _itemBackGoundColor;
}

- (void)setItemCenterBallColor:(UIColor *)itemCenterBallColor {
    _itemCenterBallColor = itemCenterBallColor;
    _centerBall.backgroundColor = _selected ?  _itemCenterBallColor : _itemBackGoundColor;
}


@end
