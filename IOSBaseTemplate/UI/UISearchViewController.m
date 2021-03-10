//
//  UISearchViewController.m
//  IOSBaseTemplate
//
//  Created by WYStudio on 2021/2/19.
//

#import "UISearchViewController.h"
#import "UICalendarSearchResultViewController.h"
#import "UIPhotoSearchResultViewController.h"
#import "UICircularDiagramView.h"
#import "CalendarTypeModel.h"
#import "CalendarContentModel.h"
#import "DataManger.h"

@interface UISearchViewController ()

@property(nonatomic, strong) UICircularDiagramView *circularDiagramView;
@property(nonatomic, strong) UILabel *checkingLabel;

@end

//------------------------------------------------
@implementation UISearchViewController

- (void)loadView {
    [super loadView];
    
    self.circularDiagramView = [[UICircularDiagramView alloc] initWithFrame:CGRectMake(0, 0, _size_W_S_X(252), _size_W_S_X(252))];
    [self.view addSubview:_circularDiagramView];
    
    self.checkingLabel = [[UILabel alloc] init];
    _checkingLabel.backgroundColor = [UIColor clearColor];
    _checkingLabel.textAlignment = NSTextAlignmentCenter;
    _checkingLabel.font = UIDynamicFontBoldMake(16);
    _checkingLabel.text = @"检测中...";
    [self.view addSubview:_checkingLabel];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"扫描中";
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.circularDiagramView runAnimation:YES];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    NSTimeInterval begin = [[DataManger shareInstance] getDateTimeTOMilliSeconds:[NSDate date]];
    
    __weak typeof(self) weakSelf = self;
    if(e_CalendarSearch_Type == _searchType) {
        [[DataManger shareInstance] getScheduleEvent:^(NSArray *eventArray){
            __strong typeof(weakSelf) strongSelf = weakSelf;
            
            NSTimeInterval end = [[DataManger shareInstance] getDateTimeTOMilliSeconds:[NSDate date]];
            if(end - begin >= 1500) {
                dispatch_async(dispatch_get_main_queue(), ^(void){
                    [strongSelf handelCalendarEvent:eventArray];
                });
                return;
            }
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)((1500 - (end - begin)) / 1500  * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                __strong typeof(weakSelf) strongSelf = weakSelf;
                if(nil == strongSelf) {
                    return;
                }
                [strongSelf handelCalendarEvent:eventArray];
            });
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
    
    if(e_aiCleare_Type == _searchType) {
        
    }
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [self.circularDiagramView runAnimation:NO];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    _circularDiagramView.qmui_left = (self.view.qmui_width - _circularDiagramView.qmui_width) / 2.0;
    _circularDiagramView.qmui_top = _size_H_S_X(100);
    [_circularDiagramView reDraw];
    
    [_checkingLabel sizeToFit];
    _checkingLabel.center = _circularDiagramView.center;
}

- (void)handelCalendarEvent:(NSArray *)eventArray {
    if(0 == eventArray.count) {
        return;
    }
    
    NSMutableArray *dataArray = [NSMutableArray array];
    CalendarTypeModel *overdueCalendarModel = [[CalendarTypeModel alloc] init];
    overdueCalendarModel.isExpand = YES;
    overdueCalendarModel.title = @"过期日程";
    overdueCalendarModel.content = [NSMutableArray array];
    [dataArray addObject:overdueCalendarModel];
    
    CalendarTypeModel *fraudCalendarModel = [[CalendarTypeModel alloc] init];
    fraudCalendarModel.isExpand = YES;
    fraudCalendarModel.title = @"诈骗日程";
    fraudCalendarModel.content = [NSMutableArray array];
    [dataArray addObject:fraudCalendarModel];
    
    for(EKEvent* item in eventArray) {
        if(NSOrderedAscending != [[NSDate date] compare:item.endDate]) {
            CalendarContentModel *cententModel = [[CalendarContentModel alloc] init];
            cententModel.event = item;
            cententModel.isSelect = YES;
            [overdueCalendarModel.content addObject:cententModel];
            continue;
        }
    }
    
    UICalendarSearchResultViewController *vc = [[UICalendarSearchResultViewController alloc] init];
    vc.dataArray = dataArray;
    
    [self.navigationController qmui_pushViewController:vc animated:YES completion:^(void){
        NSMutableArray *viewControllers = [[NSMutableArray alloc] initWithArray:self.navigationController.viewControllers];
        [viewControllers removeObject:self];
        self.navigationController.viewControllers = viewControllers;
    }];
}

- (void)handelPhotoData:(NSArray *)phoneArray {
    if(0 == phoneArray.count) {
        return;
    }
    
    UIPhotoSearchResultViewController *vc = [[UIPhotoSearchResultViewController alloc] init];
    vc.dataArray = phoneArray;
    [self.navigationController qmui_pushViewController:vc animated:YES completion:^(void){
        NSMutableArray *viewControllers = [[NSMutableArray alloc] initWithArray:self.navigationController.viewControllers];
        [viewControllers removeObject:self];
        self.navigationController.viewControllers = viewControllers;
    }];
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
