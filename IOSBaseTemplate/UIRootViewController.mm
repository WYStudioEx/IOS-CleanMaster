//
//  UIRootViewController.m
//  IOSBaseTemplate
//
//  Created by WYStudio on 2018/6/21.
//  Copyright © 2018年 WYStudio. All rights reserved.
//

#import "UIRootViewController.h"
#import "UISearchViewController.h"

@interface UIRootViewController ()

@property(nonatomic, strong) QMUIButton *phoneBtn;
@property(nonatomic, strong) QMUIButton *contactBtn;
@property(nonatomic, strong) QMUIButton *calendarBtn;
@property(nonatomic, strong) QMUIButton *privacyBtn;

@end

//------------------------------------------------------------------
@implementation UIRootViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    
    self.title = @"RootVC";
    self.view.backgroundColor = UIColorMake(159, 214, 97);
    
    
    self.phoneBtn = [[QMUIButton alloc] init];
    _phoneBtn.backgroundColor = [UIColor blueColor];
    [_phoneBtn setTitle:@"图库" forState:UIControlStateNormal];
    [_phoneBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [_phoneBtn addTarget:self action:@selector(photoBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_phoneBtn];
    
    self.contactBtn = [[QMUIButton alloc] init];
    _contactBtn.backgroundColor = [UIColor blueColor];
    [_contactBtn setTitle:@"通讯录" forState:UIControlStateNormal];
    [_contactBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [_contactBtn addTarget:self action:@selector(contactBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_contactBtn];
    
    self.calendarBtn = [[QMUIButton alloc] init];
    _calendarBtn.backgroundColor = [UIColor blueColor];
    [_calendarBtn setTitle:@"日历" forState:UIControlStateNormal];
    [_calendarBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [_calendarBtn addTarget:self action:@selector(calendarBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_calendarBtn];
    
    self.privacyBtn = [[QMUIButton alloc] init];
    _privacyBtn.backgroundColor = [UIColor blueColor];
    [_privacyBtn setTitle:@"隐私" forState:UIControlStateNormal];
    [_privacyBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [_privacyBtn addTarget:self action:@selector(privacyBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_privacyBtn];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    CGFloat HMargin = 10;
    CGFloat btnWidth = 100;
    CGFloat btnHeight = 50;
    CGFloat CMargin = (self.view.qmui_width - 2 * HMargin - 3 * btnWidth) / 2.0;
    
    _phoneBtn.frame = CGRectMake((self.view.qmui_width - btnWidth) / 2.0, (self.view.qmui_height - btnHeight) / 2.0, btnWidth, btnHeight);
    _contactBtn.frame = CGRectMake(HMargin, self.view.qmui_height - btnHeight - 40, btnWidth, btnHeight);
    _calendarBtn.frame = CGRectMake(_contactBtn.qmui_right + CMargin, self.view.qmui_height - btnHeight - 40, btnWidth, btnHeight);
    _privacyBtn.frame = CGRectMake(_calendarBtn.qmui_right + CMargin, self.view.qmui_height - btnHeight - 40, btnWidth, btnHeight);
}

- (void)photoBtnClick:(id)btn {
    UISearchViewController *nextVC = [[UISearchViewController alloc] init];
    nextVC.searchType = e_PhoneSearch_Type;
    [self.navigationController pushViewController:nextVC animated:YES];
}

- (void)contactBtnClick:(id)btn {
    UISearchViewController *nextVC = [[UISearchViewController alloc] init];
    nextVC.searchType = e_Contact_Type;
    [self.navigationController pushViewController:nextVC animated:YES];
}

- (void)calendarBtnClick:(id)btn {
    UISearchViewController *nextVC = [[UISearchViewController alloc] init];
    nextVC.searchType = e_CalendarSearch_Type;
    [self.navigationController pushViewController:nextVC animated:YES];
}

- (void)privacyBtnClick:(id)btn {
    UISearchViewController *nextVC = [[UISearchViewController alloc] init];
    [self.navigationController pushViewController:nextVC animated:YES];
}

- (BOOL)preferredNavigationBarHidden {
    return YES;
}

@end
