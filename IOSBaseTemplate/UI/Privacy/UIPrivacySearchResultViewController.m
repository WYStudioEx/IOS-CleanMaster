//
//  UIContactSearchResultViewController.m
//  IOSBaseTemplate
//
//  Created by WYStudio on 21/2/22.
//  Copyright (c) 2021年 WYStudio. All rights reserved.
//

#import "UIPrivacySearchResultViewController.h"
#import "XLGesturepassword.h"
#import "DataManger.h"
#import "AJPhotoPickerViewController.h"
#import "AJPhotoListView.h"
#import "AJPhotoListCell.h"
#import "UIImgPreviewViewController.h"

#import <EventKit/EventKit.h>

@interface UIPrivacySearchResultViewController ()
<AJPhotoPickerProtocol,
UIImgPreviewViewControllerProtocol,
UICollectionViewDataSource,
UICollectionViewDelegate,
UICollectionViewDelegateFlowLayout>

@property(nonatomic, strong) UIView *passwordBackView;
@property(nonatomic, strong) QMUILabel *tipLabel;
@property(nonatomic, strong) XLGesturePassword *passwordView;


@property(nonatomic, strong) UIView *photoBackView;
@property(nonatomic, strong) QMUIButton *addPhotoBtn;

@property(nonatomic, strong) NSString *password;
@property(nonatomic, strong) NSString *setPassword;

@property (strong, nonatomic) AJPhotoListView *photoListView;
@property (strong, nonatomic) NSMutableArray *assets;
@property (strong, nonatomic) NSMutableArray *assetsIndex;

@end

//-----------------------------------------------------------
@implementation UIPrivacySearchResultViewController

- (void)loadView {
    [super loadView];
    
    //-----------
    self.passwordBackView = [[UIView alloc] init];
    [self.view addSubview:_passwordBackView];
    
    self.tipLabel = [[QMUILabel alloc] init];
    [_tipLabel sizeToFit];
    _tipLabel.textAlignment = NSTextAlignmentCenter;
    _tipLabel.font = UIDynamicFontBoldMake(17);
    _tipLabel.textColor = [UIColor qmui_colorWithHexString:@"#272E46"];
    self.password = [[NSUserDefaults standardUserDefaults] objectForKey:@"password"];
    _tipLabel.text = self.password.length ? @"请输入密码" : @"请设置密码";
    [_passwordBackView addSubview:_tipLabel];
    
    self.passwordView = [[XLGesturePassword alloc] init];
    _passwordView.itemCenterBallColor = [UIColor greenColor];
    _passwordView.lineNormalColor = [UIColor qmui_colorWithHexString:@"#00A784"];
    _passwordView.lineErrorColor = [UIColor redColor];
    __weak typeof(self) weakSelf = self;
    [_passwordView addPasswordBlock:^(NSString *password) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf handlepassword:password];
    }];
    [_passwordBackView addSubview:_passwordView];
    
    //-------------
    self.photoBackView = [[UIView alloc] init];
    _photoBackView.hidden = YES;
    [self.view addSubview:_photoBackView];
    
    self.photoListView = [[AJPhotoListView alloc] init];
    _photoListView.dataSource = self;
    _photoListView.delegate = self;
    _photoListView.backgroundColor = [UIColor clearColor];
    [self.photoBackView insertSubview:_photoListView atIndex:0];
    
    self.addPhotoBtn = [[QMUIButton alloc] qmui_initWithImage:UIImageMake(@"add_photo_btn") title:nil];
    [_addPhotoBtn addTarget:self action:@selector(addPhotoBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.photoBackView addSubview:_addPhotoBtn];
    
    self.title = @"隐私空间";
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    self.passwordBackView.frame = self.view.bounds;
    _passwordView.frame = CGRectMake(0, 0, _passwordBackView.qmui_width, _passwordBackView.qmui_width);
    _passwordView.center = _passwordBackView.center;
    
    [_tipLabel sizeToFit];
    _tipLabel.qmui_width = _passwordBackView.qmui_width;
    _tipLabel.qmui_left = 0;
    _tipLabel.qmui_bottom = _passwordView.qmui_top -  _size_H_S_X(20);
    
    self.photoBackView.frame = self.view.bounds;
    [_addPhotoBtn sizeToFit];
    _addPhotoBtn.qmui_bottom = _photoBackView.qmui_height - _size_H_S_X(69);
    _addPhotoBtn.qmui_left = (_photoBackView.qmui_width - _addPhotoBtn.qmui_width) / 2.0;
    
    self.photoListView.frame = CGRectMake(0, self.navigationController.navigationBar.qmui_height, self.photoBackView.qmui_width, self.photoBackView.qmui_height - self.navigationController.navigationBar.qmui_bottom);
}

- (void)setupNavigationItems {
    [super setupNavigationItems];

    UIImage *img = [[UIImage imageNamed: @"set"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:img style:UIBarButtonItemStylePlain target:self action:@selector(rightBarButtonClick:)];
}

- (void)handlepassword:(NSString *) password{
    if(self.password.length) {
        if([self.password isEqualToString:password]) {
            [self showPhotoView];
        }else {
            _tipLabel.text = @"密码错误，请重新输入";
            [self.passwordView showError];
        }
        
        return;
    }
    
    if(0 == self.setPassword.length) {
        self.setPassword = password;
        [self.passwordView refresh];
        
        _tipLabel.text = @"请再次输入密码";
        return;
    }
    
    if([self.setPassword isEqualToString:password]) {
        [[NSUserDefaults standardUserDefaults] setObject:self.setPassword forKey:@"password"];
        [self showPhotoView];
        
        return;
    }
    
    _tipLabel.text = @"两次密码不一致，请重新输入";
    [self.passwordView showError];
}

- (void)showPhotoView {
    _passwordBackView.hidden = YES;
    _photoBackView.hidden = NO;
    
    NSNumber* index = [[NSUserDefaults standardUserDefaults] objectForKey:@"photo_index"];
    for(int i = 0; i < index.unsignedIntValue; i++) {
        NSString * PATH =[NSString stringWithFormat:@"%@/Documents/photo_%d.png",NSHomeDirectory(), i];
        UIImage* image = [[UIImage alloc]initWithContentsOfFile:PATH];
        if(image) {
            [self.assets addObject:image];
            [self.assetsIndex addObject:@(i)];
        }
    }
    
    if(self.assets.count) {
        [_photoListView reloadData];
    }
}

- (void)addPhotoBtnClick:(id)btn {
    AJPhotoPickerViewController *picker = [[AJPhotoPickerViewController alloc] init];
    picker.delegate = self;
    [self.navigationController pushViewController:picker animated:YES];
}

- (void)rightBarButtonClick:(id)btn {
//    AJPhotoPickerViewController *picker = [[AJPhotoPickerViewController alloc] init];
//    picker.delegate = self;
//    [self.navigationController pushViewController:picker animated:YES];
}

#pragma QMUICustomNavigationBarTransitionDelegate

- (nullable UIImage *)navigationBarBackgroundImage {
    return [[UIImage alloc] init];
}

- (nullable UIImage *)navigationBarShadowImage {
    return [[UIImage alloc] init];
}

#pragma mark - uicollectionDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.assets.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifer = @"cell";
    AJPhotoListCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifer forIndexPath:indexPath];
    [cell bind:self.assets[indexPath.row] isSelected:NO];
    return cell;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(5, 5, 5, 5);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat wh = (collectionView.bounds.size.width - 20)/3.0;
    return CGSizeMake(wh, wh);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 5.0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 5.0;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    UIImgPreviewViewController *vc = [[UIImgPreviewViewController alloc] init];
    vc.imageModels = self.assets;
    vc.selIndex = indexPath.row;
    vc.delegate = self;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma set/get
- (NSMutableArray *)assets {
    if(nil == _assets) {
        _assets = [NSMutableArray array];
    }
    
    return _assets;
}

- (NSMutableArray *)assetsIndex {
    if(nil == _assetsIndex) {
        _assetsIndex = [NSMutableArray array];
    }
    
    return _assetsIndex;
}

#pragma AJPhotoPickerProtocol
- (void)photoPicker:(AJPhotoPickerViewController *)picker didSelectAssets:(NSArray *)assets {
    NSUInteger oldIndex = 0;
    NSNumber* index = [[NSUserDefaults standardUserDefaults] objectForKey:@"photo_index"];
    if(index) {
        oldIndex = [index unsignedIntegerValue];
    }
    [[NSUserDefaults standardUserDefaults] setObject:@(oldIndex + assets.count) forKey:@"photo_index"];
    
    for(UIImage* image in assets) {
        [self.assetsIndex addObject:@(oldIndex)];
        NSString * path = [NSString stringWithFormat:@"%@/Documents/photo_%lu.png", NSHomeDirectory(), oldIndex++];
        [UIImagePNGRepresentation(image) writeToFile:path atomically:YES];
    }
    
    [self.assets addObjectsFromArray:assets];
    [self.photoListView reloadData];
}

#pragma AJPhotoPickerProtocol
- (void)previewView:(UIImgPreviewViewController *)picker delIndex:(NSUInteger) index {
    [self.assets removeObjectAtIndex:index];
    [self.photoListView reloadData];
    
    NSString *path = [NSString stringWithFormat:@"%@/Documents/photo_%lu.png", NSHomeDirectory(), [(NSNumber *)(self.assetsIndex[index]) integerValue]];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    [fileManager removeItemAtPath:path error:nil];
}

- (void)previewView:(UIImgPreviewViewController *)picker addIndex:(NSUInteger) index {
    UIImageWriteToSavedPhotosAlbum(self.assets[index], self, nil, nil);
}

@end
