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

@property(nonatomic, strong) QMUIButton *addressBookBtn;
@property(nonatomic, strong) QMUIButton *calendarBtn;
@property(nonatomic, strong) QMUIButton *privacyBtn;

@end

//------------------------------------------------------------------
@implementation UIRootViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    
    self.title = @"RootVC";
    self.view.backgroundColor = UIColorMake(159, 214, 97);;
    
    self.addressBookBtn = [[QMUIButton alloc] init];
    _addressBookBtn.backgroundColor = [UIColor blueColor];
    [_addressBookBtn setTitle:@"通讯录" forState:UIControlStateNormal];
    [_addressBookBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [_addressBookBtn addTarget:self action:@selector(addressBookBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_addressBookBtn];
    
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
    
    _addressBookBtn.frame = CGRectMake(HMargin, self.view.qmui_height - btnHeight - 40, btnWidth, btnHeight);
    _calendarBtn.frame = CGRectMake(_addressBookBtn.qmui_right + CMargin, self.view.qmui_height - btnHeight - 40, btnWidth, btnHeight);
    _privacyBtn.frame = CGRectMake(_calendarBtn.qmui_right + CMargin, self.view.qmui_height - btnHeight - 40, btnWidth, btnHeight);
}

- (void)addressBookBtnClick:(id)btn {
    UISearchViewController *nextVC = [[UISearchViewController alloc] init];
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
