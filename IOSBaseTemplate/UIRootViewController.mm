//
//  UIRootViewController.m
//  IOSBaseTemplate
//
//  Created by WYStudio on 2018/6/21.
//  Copyright © 2021年 WYStudio. All rights reserved.
//

#import "UIRootViewController.h"
#import "UISearchViewController.h"
#import "UICircularDiagramView.h"
#import "UIPrivacySearchResultViewController.h"
#import "DataManger.h"

@interface UIRootViewController ()

@property(nonatomic, strong) QMUIButton *aiClearBtn;

@property(nonatomic, strong) UIView *actionBackView;

@property(nonatomic, strong) QMUIButton *phoneBtn;
@property(nonatomic, strong) QMUILabel *phoneBtnLabel;

@property(nonatomic, strong) QMUIButton *calendarBtn;
@property(nonatomic, strong) QMUILabel *calendarBtnLabel;

@property(nonatomic, strong) QMUIButton *privacyBtn;
@property(nonatomic, strong) QMUILabel *privacyLabel;

@property(nonatomic, strong) UICircularDiagramView *circularDiagramView;
@property(nonatomic, strong) UILabel *diskLabel;
@property(nonatomic, strong) UILabel *proportionLabel;
@property(nonatomic, strong) UILabel *percentLabel;

@property(nonatomic, strong) UILabel *checkingLabel;

@end

//------------------------------------------------------------------
@implementation UIRootViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    
    QMUILabel *titleLabel = [[QMUILabel alloc] init];
    titleLabel.text = @"清理管家";
    [titleLabel sizeToFit];
    titleLabel.qmui_left = _size_W_S_X(16);
    titleLabel.qmui_top = _size_H_S_X(56);
    titleLabel.font = UIDynamicFontBoldMake(17);
    titleLabel.textColor = [UIColor qmui_colorWithHexString:@"#272E46"];
    [self.view addSubview:titleLabel];
    
    self.aiClearBtn = [[QMUIButton alloc] qmui_initWithImage:UIImageMake(@"action_button_normal") title:nil];
    _aiClearBtn.frame =CGRectMake(0, 0, _size_W_S_X(155), _size_W_S_X(56));
    [_aiClearBtn addTarget:self action:@selector(aiCleareBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_aiClearBtn];
    
    self.circularDiagramView = [[UICircularDiagramView alloc] initWithFrame:CGRectMake(0, 0, _size_W_S_X(252), _size_W_S_X(252))];
    [self.view addSubview:_circularDiagramView];
    
    self.checkingLabel = [[UILabel alloc] init];
    _checkingLabel.backgroundColor = [UIColor clearColor];
    _checkingLabel.textAlignment = NSTextAlignmentCenter;
    _checkingLabel.font = UIDynamicFontBoldMake(16);
    _checkingLabel.text = @"检测中...";
    [self.view addSubview:_checkingLabel];
    
    self.diskLabel = [[UILabel alloc] init];
    _diskLabel.backgroundColor = [UIColor clearColor];
    _diskLabel.textAlignment = NSTextAlignmentCenter;
    _diskLabel.font = UIDynamicFontBoldMake(16);
    [self.view addSubview:_diskLabel];
    
    self.proportionLabel = [[UILabel alloc] init];
    _proportionLabel.backgroundColor = [UIColor clearColor];
    _proportionLabel.textAlignment = NSTextAlignmentCenter;
    _proportionLabel.font = UIDynamicFontBoldMake(72);
    [self.view addSubview:_proportionLabel];
    
    self.percentLabel = [[UILabel alloc] init];
    _percentLabel.backgroundColor = [UIColor clearColor];
    _percentLabel.textAlignment = NSTextAlignmentCenter;
    _percentLabel.font = UIDynamicFontBoldMake(36);
    [self.view addSubview:_percentLabel];
    
    //----------------------------------------------------------
    self.actionBackView = [[UIView alloc] init];
    _actionBackView.layer.contents = (id) [UIImage imageNamed:@"rectangle"].CGImage;
    _actionBackView.layer.backgroundColor = [UIColor clearColor].CGColor;
    [self.view addSubview:_actionBackView];
    
    //-
    self.phoneBtn = [[QMUIButton alloc] qmui_initWithImage:UIImageMake(@"photo_btn") title:nil];
    _phoneBtn.frame =CGRectMake(0, 0, _size_W_S_X(64), _size_W_S_X(64));
    _phoneBtn.layer.cornerRadius = _phoneBtn.qmui_width /2;
    _phoneBtn.backgroundColor = [UIColor qmui_colorWithHexString:@"#F3F9F9"];
    _phoneBtn.clipsToBounds = YES;
    [_phoneBtn addTarget:self action:@selector(photoBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_actionBackView addSubview:_phoneBtn];
    
    self.phoneBtnLabel = [[QMUILabel alloc] init];
    _phoneBtnLabel.text = @"相册清理";
    [_phoneBtnLabel sizeToFit];
    _phoneBtnLabel.font = UIDynamicFontMake(16);
    _phoneBtnLabel.textColor = [UIColor blackColor];
    [_actionBackView addSubview:_phoneBtnLabel];
    
    //-
    self.calendarBtn = [[QMUIButton alloc] qmui_initWithImage:UIImageMake(@"photo_btn") title:nil];
    _calendarBtn.frame =CGRectMake(0, 0, _size_W_S_X(64), _size_W_S_X(64));
    _calendarBtn.layer.cornerRadius = _calendarBtn.qmui_width /2;
    _calendarBtn.backgroundColor = [UIColor qmui_colorWithHexString:@"#F3F9F9"];
    _calendarBtn.clipsToBounds = YES;
    [_calendarBtn addTarget:self action:@selector(calendarBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_actionBackView addSubview:_calendarBtn];
    
    self.calendarBtnLabel = [[QMUILabel alloc] init];
    _calendarBtnLabel.text = @"日历清洗";
    [_calendarBtnLabel sizeToFit];
    _calendarBtnLabel.font = UIDynamicFontMake(16);
    _calendarBtnLabel.textColor = [UIColor blackColor];
    [_actionBackView addSubview:_calendarBtnLabel];
    
    //-
    self.privacyBtn = [[QMUIButton alloc] qmui_initWithImage:UIImageMake(@"privacy_btn") title:nil];
    _privacyBtn.frame =CGRectMake(0, 0, _size_W_S_X(64), _size_W_S_X(64));
    _privacyBtn.layer.cornerRadius = _privacyBtn.qmui_width /2;
    _privacyBtn.backgroundColor = [UIColor qmui_colorWithHexString:@"#F3F9F9"];
    _privacyBtn.clipsToBounds = YES;
    [_privacyBtn addTarget:self action:@selector(privacyBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_actionBackView addSubview:_privacyBtn];
    
    self.privacyLabel = [[QMUILabel alloc] init];
    _privacyLabel.text = @"隐私空间";
    [_privacyLabel sizeToFit];
    _privacyLabel.font = UIDynamicFontMake(16);
    _privacyLabel.textColor = [UIColor blackColor];
    [_actionBackView addSubview:_privacyLabel];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    NSTimeInterval begin = [self getDateTimeTOMilliSeconds:[NSDate date]];
    
    __weak typeof(self) weakSelf = self;
    [[DataManger shareInstance] getDiskOf:^(CGFloat totalsize, CGFloat freesize){
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if(nil == strongSelf) {
            return;
        }
        
        NSTimeInterval end = [self getDateTimeTOMilliSeconds:[NSDate date]];
        if(end - begin >= 2000) {
            dispatch_async(dispatch_get_main_queue(), ^(void){
                strongSelf.diskLabel.text = [NSString stringWithFormat:@"%.1f/%.1fG", totalsize - freesize, totalsize];
                strongSelf.proportionLabel.text = [NSString stringWithFormat:@"%d",(int)((totalsize - freesize) / totalsize * 100)];
                strongSelf.circularDiagramView.progressValue = (totalsize - freesize) / totalsize;
                strongSelf.percentLabel.text = @"%";
                strongSelf.checkingLabel.hidden = YES;
                [self.view setNeedsLayout];
                [self.view layoutIfNeeded];
            });
            return;
        }
        
        __weak typeof(self) weakSelfEx = strongSelf;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)((2000 - (end - begin)) / 1000  * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            __strong typeof(weakSelf) strongSelfEx = weakSelfEx;
            if(nil == strongSelfEx) {
                return;
            }
            
            strongSelfEx.checkingLabel.hidden = YES;
            strongSelfEx.diskLabel.text = [NSString stringWithFormat:@"%.1f/%.1fG", totalsize - freesize, totalsize];
            strongSelfEx.proportionLabel.text = [NSString stringWithFormat:@"%d",(int)((totalsize - freesize) / totalsize * 100)];
            strongSelfEx.circularDiagramView.progressValue = (totalsize - freesize) / totalsize;
            strongSelfEx.percentLabel.text = @"%";
            [self.view setNeedsLayout];
            [self.view layoutIfNeeded];
        });
    }];
    
//    NSTimer * timer = [NSTimer timerWithTimeInterval:0.01 target:self selector:@selector(timerAction:) userInfo:nil repeats:YES];
//    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
}

-(long long)getDateTimeTOMilliSeconds:(NSDate *)datetime {
    NSTimeInterval interval = [datetime timeIntervalSince1970];
    NSLog(@"转换的时间戳=%f",interval);
    long long totalMilliseconds = interval*1000 ;
    NSLog(@"totalMilliseconds=%llu",totalMilliseconds);
    return totalMilliseconds;
}
#pragma mark - 定时器

//- (void)timerAction:(NSTimer *)sender{
//    static CGFloat kkk = 0;
//    kkk += 0.01;
//    if(kkk > 1.0) {
//        kkk = 0;
//    }
//    
//    self.circularDiagramView.progressValue = kkk;
//}

- (void)setupNavigationItems {
    [super setupNavigationItems];

    UIImage *img = [[UIImage imageNamed: @"set"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:img style:UIBarButtonItemStylePlain target:self action:@selector(rightBarButtonClick)];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    _aiClearBtn.qmui_top = _size_H_S_X(396);
    _aiClearBtn.qmui_left = (self.view.qmui_width - _aiClearBtn.qmui_width) / 2.0;
    
    _circularDiagramView.qmui_left = (self.view.qmui_width - _circularDiagramView.qmui_width) / 2.0;
    _circularDiagramView.qmui_top = _size_H_S_X(100);
    [_circularDiagramView reDraw];
    
    [_checkingLabel sizeToFit];
    _checkingLabel.center = _circularDiagramView.center;
    
    [_diskLabel sizeToFit];
    _diskLabel.center = _circularDiagramView.center;
    _diskLabel.qmui_top = _circularDiagramView.qmui_top + _size_H_S_X(84);
    
    [_proportionLabel sizeToFit];
    [_percentLabel sizeToFit];
    
    _proportionLabel.qmui_left = _circularDiagramView.qmui_left + (_circularDiagramView.qmui_width - (_proportionLabel.qmui_width + _percentLabel.qmui_width)) / 2.0;
    _proportionLabel.qmui_top = _diskLabel.qmui_bottom;
    _percentLabel.qmui_left = _proportionLabel.qmui_right;
    _percentLabel.qmui_bottom = _proportionLabel.qmui_bottom - _size_H_S_X(11);
    
    self.actionBackView.frame = CGRectMake(0, self.view.qmui_height - _size_H_S_X(342), self.view.qmui_width, _size_H_S_X(342));
    
    _phoneBtn.qmui_left = _size_W_S_X(66);
    _phoneBtn.qmui_top = _size_H_S_X(67);
    _phoneBtnLabel.center = _phoneBtn.center;
    _phoneBtnLabel.qmui_top = _phoneBtn.qmui_bottom + _size_H_S_X(9);
    
    _calendarBtn.qmui_right = _actionBackView.qmui_right - _size_W_S_X(66);
    _calendarBtn.qmui_top = _size_H_S_X(67);
    _calendarBtnLabel.center = _calendarBtn.center;
    _calendarBtnLabel.qmui_top = _calendarBtn.qmui_bottom + _size_H_S_X(9);
    
    _privacyBtn.qmui_left = _size_W_S_X(66);
    _privacyBtn.qmui_top = _phoneBtn.qmui_bottom + _size_H_S_X(55);
    _privacyLabel.center = _privacyBtn.center;
    _privacyLabel.qmui_top = _privacyBtn.qmui_bottom + _size_H_S_X(9);
}

- (void)photoBtnClick:(id)btn {
    UISearchViewController *nextVC = [[UISearchViewController alloc] init];
    nextVC.searchType = e_PhoneSearch_Type;
    [self.navigationController pushViewController:nextVC animated:YES];
}

- (void)calendarBtnClick:(id)btn {
    UISearchViewController *nextVC = [[UISearchViewController alloc] init];
    nextVC.searchType = e_CalendarSearch_Type;
    [self.navigationController pushViewController:nextVC animated:YES];
}

- (void)privacyBtnClick:(id)btn {
    UIPrivacySearchResultViewController *nextVC = [[UIPrivacySearchResultViewController alloc] init];
    [self.navigationController pushViewController:nextVC animated:YES];
}

- (void)aiCleareBtnClick:(id)btn {
    UISearchViewController *nextVC = [[UISearchViewController alloc] init];
    [self.navigationController pushViewController:nextVC animated:YES];
}

- (void)rightBarButtonClick {
    
}

#pragma QMUICustomNavigationBarTransitionDelegate

- (nullable UIImage *)navigationBarBackgroundImage {
    return [[UIImage alloc] init];
}

- (nullable UIImage *)navigationBarShadowImage {
    return [[UIImage alloc] init];
}

@end
