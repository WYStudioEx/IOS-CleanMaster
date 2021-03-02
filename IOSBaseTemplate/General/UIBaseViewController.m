//
//  UIBaseViewController.m
//  qmuidemo
//
//  Created by QMUI Team on 15/4/13.
//  Copyright (c) 2021年 QMUI Team. All rights reserved.
//

#import "UIBaseViewController.h"

@interface UIBaseViewController()<UIGestureRecognizerDelegate>

@end

//------------------------------------------------------------
@implementation UIBaseViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.layer.contents = (id) [UIImage imageNamed:@"back_image"].CGImage;
    self.view.layer.backgroundColor = [UIColor clearColor].CGColor;
    
    if ([[UIDevice currentDevice].systemVersion floatValue]>=7.0) {
        if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
            self.navigationController.interactivePopGestureRecognizer.enabled = YES;
            self.navigationController.interactivePopGestureRecognizer.delegate = self;
        }
    }
    
    self.view.backgroundColor = [UIColor whiteColor];
}

#pragma --UIGestureRecognizerDelegate

//控制是否支持左滑返回
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    return NO;
}

#pragma QMUICustomNavigationBarTransitionDelegate
- (BOOL)shouldCustomizeNavigationBarTransitionIfHideable {
    return NO;
}

- (nullable UIImage *)navigationBarBackgroundImage {
    return [[UIImage alloc] init];
}

- (nullable UIImage *)navigationBarShadowImage {
    return [[UIImage alloc] init];
}

@end
