//
//  UIContactSearchResultViewController.m
//  IOSBaseTemplate
//
//  Created by WYStudio on 21/2/22.
//  Copyright (c) 2021年 WYStudio. All rights reserved.
//

#import "UIPrivacySearchResultViewController.h"
#import "XLGesturePassword.h"
#import "DataManger.h"

#import <EventKit/EventKit.h>

@interface UIPrivacySearchResultViewController ()

@property(nonatomic, strong) XLGesturePassword *passWordView;
@property(nonatomic, strong) NSString *passWord;

@end


//-----------------------------------------------------------
@implementation UIPrivacySearchResultViewController

- (void)loadView {
    [super loadView];

    //密码输入
    self.passWordView = [[XLGesturePassword alloc] init];
    _passWordView.bounds = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.width);
    _passWordView.center = self.view.center;
    _passWordView.itemCenterBallColor = [UIColor greenColor];
    _passWordView.lineNormalColor = [UIColor greenColor];
    _passWordView.lineErrorColor = [UIColor redColor];
    __weak typeof(self) weakSelf = self;
    [_passWordView addPasswordBlock:^(NSString *password) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        strongSelf.passWord = password;
        [strongSelf.passWordView refresh];
    }];
    
    [self.view addSubview:_passWordView];
}


@end
