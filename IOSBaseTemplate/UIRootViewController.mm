//
//  UIRootViewController.m
//  IOSBaseTemplate
//
//  Created by fengchiwei on 2018/6/21.
//  Copyright © 2018年 fengchiwei. All rights reserved.
//

#import "UIRootViewController.h"
#import "UINextViewController.h"

@interface UIRootViewController ()

@end

//------------------------------------------------------------------
@implementation UIRootViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    
    self.view.backgroundColor = UIColorMake(159, 214, 97);;

    UIButton *tempBtn = [[UIButton alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 100) / 2.0, 350, 100, 50)];
    tempBtn.backgroundColor = [UIColor blueColor];
    [tempBtn setTitle:@"NEXT" forState:UIControlStateNormal];
    [tempBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:tempBtn];
}

- (void)btnClick:(id)btn {
    UINextViewController *nextVC = [[UINextViewController alloc] init];
    [self.navigationController pushViewController:nextVC animated:YES];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.title = @"RootVC";
}

- (BOOL)preferredNavigationBarHidden {
    return YES;
}

@end
