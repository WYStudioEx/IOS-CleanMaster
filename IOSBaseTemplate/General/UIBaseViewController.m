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
    
    if ([[UIDevice currentDevice].systemVersion floatValue]>=7.0) {
        if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
            self.navigationController.interactivePopGestureRecognizer.enabled = YES;
            self.navigationController.interactivePopGestureRecognizer.delegate = self;
        }
    }
}

#pragma --UIGestureRecognizerDelegate

//控制是否支持左滑返回
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    if ([self.navigationController.viewControllers count] == 1) {
        return NO;
    }else{
        return YES;
    }
}

@end
