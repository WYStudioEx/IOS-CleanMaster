//
//  UISearchViewController.m
//  IOSBaseTemplate
//
//  Created by WYStudio on 2021/2/19.
//

#import "UISearchViewController.h"
#import "UICalendarSearchResultViewController.h"
#import "UIPrivacySearchResultViewController.h"
#import "UIPhotoSearchResultViewController.h"
#import "DataManger.h"

@interface UISearchViewController ()

@end

//------------------------------------------------
@implementation UISearchViewController

- (void)loadView {
    [super loadView];  
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"SearchVC";
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //做旋转动画
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    __weak typeof(self) weakSelf = self;
    if(e_CalendarSearch_Type == _searchType) {
        [[DataManger shareInstance] getScheduleEvent:^(NSArray *eventArray){
            __strong typeof(weakSelf) strongSelf = weakSelf;
            [strongSelf handelCalendarEvent:eventArray];
        }];
        
        return;
    }
    
    if(e_PhoneSearch_Type == _searchType) {
        [[DataManger shareInstance] getPhotoData:^(NSArray *photoArray){
            __strong typeof(weakSelf) strongSelf = weakSelf;
            [strongSelf handelPhotoData:photoArray];
        }];
        
        return;
    }
}

- (void)handelCalendarEvent:(NSArray *)eventArray {
    if(0 == eventArray.count) {
        return;
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
         UICalendarSearchResultViewController *vc = [[UICalendarSearchResultViewController alloc] init];
         vc.eventArray = eventArray;
         [self.navigationController pushViewController:vc animated:YES];
    });
}

- (void)handelPhotoData:(NSArray *)phoneArray {
    if(0 == phoneArray.count) {
        return;
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        UIPhotoSearchResultViewController *vc = [[UIPhotoSearchResultViewController alloc] init];
        vc.photoArray = phoneArray;
        [self.navigationController pushViewController:vc animated:YES];
    });
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    return NO;
}

#pragma QMUICustomNavigationBarTransitionDelegate

- (nullable UIImage *)navigationBarBackgroundImage {
    return [[UIImage alloc] init];
}

- (nullable UIImage *)navigationBarShadowImage {
    return [[UIImage alloc] init];
}

@end
