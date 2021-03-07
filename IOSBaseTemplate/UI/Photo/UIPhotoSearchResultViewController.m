//
//  UIPhotoSearchResultViewController.m
//  IOSBaseTemplate
//
//  Created by WYStudio on 21/2/22.
//  Copyright (c) 2021年 WYStudio. All rights reserved.
//

#import "UIPhotoSearchResultViewController.h"
#import "DataManger.h"

#import <EventKit/EventKit.h>

@interface UIPhotoSearchResultViewController ()

@end


//-----------------------------------------------------------
@implementation UIPhotoSearchResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"photoVC";
}

-(void)viewDidAppear:(BOOL)animated{
    NSMutableArray *viewControllers = [[NSMutableArray alloc] initWithArray:self.navigationController.viewControllers];
    
    for(id tempVC in viewControllers) {
        if([tempVC isKindOfClass:NSClassFromString(@"UISearchViewController")]) {
            [viewControllers removeObject:tempVC];
            break;
        }
    }
    self.navigationController.viewControllers = viewControllers;
}

#pragma QMUICustomNavigationBarTransitionDelegate

- (nullable UIImage *)navigationBarBackgroundImage {
    return [[UIImage alloc] init];
}

- (nullable UIImage *)navigationBarShadowImage {
    return [[UIImage alloc] init];
}

@end
