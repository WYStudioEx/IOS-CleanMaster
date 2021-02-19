//
//  UINextViewController.m
//  IOSBaseTemplate
//
//  Created by fengchiwei on 2021/2/19.
//

#import "UINextViewController.h"

@interface UINextViewController ()

@end

@implementation UINextViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.title = @"NextVC";
    
    QMUICMI.needsBackBarButtonItemTitle = NO;
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    return NO;
}

@end
