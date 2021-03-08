//
//  UIImgPreviewViewController.hm
//  IOSBaseTemplate
//
//  Created by WYStudio on 2018/6/21.
//  Copyright © 2021年 WYStudio. All rights reserved.
//

#import "UIImgPreviewViewController.h"
#import "UIImgPreviewCollectionView.h"

@interface UIImgPreviewViewController()

@property (nonatomic, strong) UIImgPreviewCollectionView *imgPreviewCollectionView;
@property (nonatomic, strong) QMUIButton *addToSysBtn;
@property (nonatomic, strong) QMUIButton *delBtn;

@end

//---------------------------------------------------------------
@implementation UIImgPreviewViewController


#pragma mark - lifecycle
- (void)loadView {
    [super loadView];
    
    self.imgPreviewCollectionView = [[UIImgPreviewCollectionView alloc] initWithFrame:self.view.bounds];
    _imgPreviewCollectionView.imageModels = self.imageModels;
    _imgPreviewCollectionView.currentIndex = self.selIndex;
    [self.view addSubview:_imgPreviewCollectionView];
    
    self.addToSysBtn = [[QMUIButton alloc] qmui_initWithImage:UIImageMake(@"action_button_normal") title:nil];
    _addToSysBtn.frame =CGRectMake(0, 0, _size_W_S_X(155), _size_W_S_X(56));
    [_addToSysBtn addTarget:self action:@selector(addToSysBtnBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_addToSysBtn];
    
    self.delBtn = [[QMUIButton alloc] qmui_initWithImage:UIImageMake(@"action_button_normal") title:nil];
    _delBtn.frame =CGRectMake(0, 0, _size_W_S_X(155), _size_W_S_X(56));
    [_delBtn addTarget:self action:@selector(delBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_delBtn];
    
    self.title = @"预览";
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.layer.contents = nil;
    self.view.layer.backgroundColor = [UIColor blackColor].CGColor;
    self.view.backgroundColor = [UIColor blackColor];
    
    [_imgPreviewCollectionView load];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    _imgPreviewCollectionView.frame = self.view.bounds;
    
    CGFloat left = self.view.qmui_width - (_size_W_S_X(155) * 2 + _size_W_S_X(20));
    _addToSysBtn.qmui_left = left;
    _addToSysBtn.qmui_bottom = self.view.qmui_height - _size_H_S_X(40);
    _delBtn.qmui_left = _addToSysBtn.qmui_right + _size_W_S_X(20);
    _delBtn.qmui_bottom = self.view.qmui_height - _size_H_S_X(40);
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (nullable UIColor *)navigationBarTintColor {
    return [UIColor whiteColor];
}

- (nullable UIColor *)titleViewTintColor {
    return [UIColor whiteColor];
}

- (nullable UIColor *)navigationBarBarTintColor {
    return [UIColor blackColor];
}

- (void)addToSysBtnBtnClick:(id) btn {
    if (_delegate && [_delegate respondsToSelector:@selector(previewView:addIndex:)])
        [_delegate previewView:self addIndex:_imgPreviewCollectionView.currentIndex];
}

- (void)delBtnClick:(id) btn {
    if (_delegate && [_delegate respondsToSelector:@selector(previewView:delIndex:)])
        [_delegate previewView:self delIndex:_imgPreviewCollectionView.currentIndex];
    
    
    [self.imageModels removeObjectAtIndex:_imgPreviewCollectionView.currentIndex];
    if(_imgPreviewCollectionView.currentIndex == self.imageModels.count) {
        self.selIndex = self.imageModels.count - 1;
    }else {
        self.selIndex = _imgPreviewCollectionView.currentIndex;
    }
    
    [self.imgPreviewCollectionView removeFromSuperview];
    self.imgPreviewCollectionView = [[UIImgPreviewCollectionView alloc] initWithFrame:self.view.bounds];
    _imgPreviewCollectionView.imageModels = self.imageModels;
    _imgPreviewCollectionView.currentIndex = self.selIndex;
    [self.view addSubview:_imgPreviewCollectionView];
    [self.view insertSubview:_imgPreviewCollectionView belowSubview:_addToSysBtn];
    [_imgPreviewCollectionView load];
    
    if(0 == self.imageModels.count) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)setImageModels:(NSMutableArray *)imageModels {
    _imageModels = [[NSMutableArray alloc] initWithArray:imageModels];
}

#pragma QMUICustomNavigationBarTransitionDelegate

- (nullable UIImage *)navigationBarBackgroundImage {
    return [[UIImage alloc] init];
}

- (nullable UIImage *)navigationBarShadowImage {
    return [[UIImage alloc] init];
}

@end
