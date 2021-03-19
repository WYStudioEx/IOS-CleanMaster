//
//  UIBaseViewController.m
//  IOSBaseTemplate
//
//  Created by WYStudio on 2018/6/21.
//  Copyright © 2021年 WYStudio. All rights reserved.
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
    self.view.backgroundColor = [UIColor whiteColor];
    
    if ([[UIDevice currentDevice].systemVersion floatValue]>=7.0) {
        if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
            self.navigationController.interactivePopGestureRecognizer.enabled = YES;
            self.navigationController.interactivePopGestureRecognizer.delegate = self;
        }
    }
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return QMUIStatusBarStyleDarkContent;
}

#pragma --UIGestureRecognizerDelegate

//控制是否支持左滑返回
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    return NO;
}

- (nullable NSString *)backBarButtonItemTitleWithPreviousViewController:(nullable UIViewController *)viewController {
    return @"返回";
}

@end
