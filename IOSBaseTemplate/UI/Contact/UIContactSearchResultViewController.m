//
//  UIContactSearchResultViewController.m
//  IOSBaseTemplate
//
//  Created by WYStudio on 21/2/22.
//  Copyright (c) 2021年 WYStudio. All rights reserved.
//

#import "UIContactSearchResultViewController.h"
#import "DataManger.h"

#import <EventKit/EventKit.h>

@interface UIContactSearchResultViewController ()

@end


//-----------------------------------------------------------
@implementation UIContactSearchResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"ContactVC";
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

@end
