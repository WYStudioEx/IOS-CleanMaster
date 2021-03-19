//
//  AJPhotoPickerViewController.m
//  AJPhotoPicker
//
//  Created by AlienJunX on 15/11/2.
//  Copyright (c) 2015 AlienJunX
//
//  This source code is licensed under the MIT-style license found in the
//  LICENSE file in the root directory of this source tree.
//

#import "AJPhotoPickerViewController.h"
#import "AJPhotoGroupView.h"
#import "AJPhotoListView.h"
#import "AJPhotoListCell.h"
#import "DataManger.h"

@interface AJPhotoPickerViewController()<AJPhotoGroupViewProtocol,
UICollectionViewDataSource,
UICollectionViewDelegate,
UICollectionViewDelegateFlowLayout>

@property (strong, nonatomic) UIView *customTitleView;
@property (strong, nonatomic) AJPhotoGroupView *photoGroupView;
@property (strong, nonatomic) UIView *bgMaskView;
@property (strong, nonatomic) AJPhotoListView *photoListView;

@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UIImageView *selectTip;
@property (strong, nonatomic) UIButton *titleBtn;

@property (strong, nonatomic) NSMutableArray *assets;
@property (strong, nonatomic) NSIndexPath *lastAccessed;

@end

@implementation AJPhotoPickerViewController

#pragma mark - init

#pragma mark - lifecycle
- (void)loadView {
    [super loadView];
    //导航条
    [self setupNavBar];
    
    //列表view
    [self setupPhotoListView];
    
    //相册分组
    [self setupGroupView];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.layer.contents = nil;
    self.view.layer.backgroundColor = [UIColor blackColor].CGColor;
    self.view.backgroundColor = [UIColor blackColor];
    
    //数据初始花
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if(nil == strongSelf) {
            return;
        }
        [strongSelf setupData];
    });
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    [_titleLabel sizeToFit];
    [_selectTip sizeToFit];
    _selectTip.qmui_left = _titleLabel.qmui_right + _size_H_S_X(5);
    _selectTip.qmui_top = (_titleLabel.qmui_height - _selectTip.qmui_height) / 2.0;
    _titleBtn.qmui_width = _selectTip.qmui_right;
    _titleBtn.qmui_height = _titleLabel.qmui_height;
    
    _bgMaskView.frame = self.view.bounds;

    _customTitleView.qmui_width = _titleBtn.qmui_width;
    _customTitleView.qmui_height = _titleBtn.qmui_height;
    
    _photoGroupView.qmui_width = self.view.qmui_width;
    _photoListView.frame = CGRectMake(0, self.navigationController.navigationBar.qmui_bottom, self.view.qmui_width, self.view.qmui_height - self.navigationController.navigationBar.qmui_bottom);
}


#pragma mark - 界面初始化

/**
 *  头部导航
 */
- (void)setupNavBar {
    self.customTitleView = [[UIView alloc] init];
    _customTitleView.hidden = YES;
    
    //title
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.textColor = [UIColor whiteColor];
    [_customTitleView addSubview:_titleLabel];
    
    //selectTipImageView
    self.selectTip = [[UIImageView alloc] initWithFrame:CGRectZero];
    _selectTip.image = UIImageMake(@"feedback_select");
    [_selectTip sizeToFit];
    [_customTitleView addSubview:_selectTip];

    self.titleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _titleBtn.frame = CGRectZero;
    _titleBtn.backgroundColor = [UIColor clearColor];
    [_titleBtn addTarget:self action:@selector(selectGroupAction:) forControlEvents:UIControlEventTouchUpInside];
    [_customTitleView addSubview:_titleBtn];
}

/**
 *  照片列表
 */
- (void)setupPhotoListView {
    self.photoListView = [[AJPhotoListView alloc] init];
    _photoListView.dataSource = self;
    _photoListView.delegate = self;
    _photoListView.backgroundColor = [UIColor clearColor];
    [self.view insertSubview:_photoListView atIndex:0];
}

/**
 *  相册
 */
- (void)setupGroupView {
    self.photoGroupView = [[AJPhotoGroupView alloc] init];
    _photoGroupView.my_delegate = self;
    _photoGroupView.frame = CGRectMake(0, self.navigationController.navigationBar.qmui_height - _size_H_S_X(360), self.view.qmui_width, _size_H_S_X(360));
    [self.view addSubview:_photoGroupView];
}

- (void)setupData {
    [self.photoGroupView setupGroup];
}

#pragma mark - 相册切换
- (void)selectGroupAction:(UIButton *)sender {
    if (self.photoGroupView.hidden) {
        self.bgMaskView.hidden = NO;
        self.photoGroupView.hidden = NO;
        [UIView animateWithDuration:0.3 animations:^{
            self.photoGroupView.transform = CGAffineTransformMakeTranslation(0, _size_H_S_X(360));
            self.selectTip.transform = CGAffineTransformMakeRotation(M_PI);
        }];
    } else {
        [self hidenGroupView];
    }
}

- (void)hidenGroupView {
    self.bgMaskView.hidden = YES;
    [UIView animateWithDuration:0.3 animations:^{
        self.photoGroupView.transform = CGAffineTransformIdentity;
        self.selectTip.transform = CGAffineTransformIdentity;
    }completion:^(BOOL finished) {
        self.photoGroupView.hidden = YES;
    }];
}

#pragma mark - BoPhotoGroupViewProtocol
- (void)didSelectGroup:(PHAssetCollection *)assetsGroup {
    self.titleLabel.text = assetsGroup.localizedTitle;
    self.customTitleView.hidden = NO;
    
    [self loadAssets:assetsGroup];
    [self hidenGroupView];
}

//加载图片
- (void)loadAssets:(PHCollection *)assetsGroup {
    [self.indexPathsForSelectedItems removeAllObjects];
    [self.assets removeAllObjects];
    
    [self.assets addObjectsFromArray:[[DataManger shareInstance] getAllPhotosAssetInAblumCollection:(PHAssetCollection *)assetsGroup ascending:YES]];
    [self.photoListView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:YES];
    [self.photoListView reloadData];
}

#pragma mark - uicollectionDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.assets.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifer = @"cell";
    AJPhotoListCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifer forIndexPath:indexPath];
    
    BOOL isSelected = [self.indexPathsForSelectedItems containsObject:self.assets[indexPath.row]];
    [cell bind:self.assets[indexPath.row] isSelected:isSelected];
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
    AJPhotoListCell *cell = (AJPhotoListCell *)[self.photoListView cellForItemAtIndexPath:indexPath];
    UIImage *asset = self.assets[indexPath.row];
    
    //取消选中
    if ([self.indexPathsForSelectedItems containsObject:asset]) {
        [self.indexPathsForSelectedItems removeObject:asset];
        [cell isSelected:NO];
        if (_delegate && [_delegate respondsToSelector:@selector(photoPicker:didDeselectAsset:)])
            [_delegate photoPicker:self didDeselectAsset:asset];
        return;
    }
    
    //选中
    [self.indexPathsForSelectedItems addObject:asset];
    [cell isSelected:YES];
    if (_delegate && [_delegate respondsToSelector:@selector(photoPicker:didSelectAsset:)])
        [_delegate photoPicker:self didSelectAsset:asset];
}


#pragma mark - Action
- (void)rightBtnAction:(UIButton *)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(photoPicker:didSelectAssets:)]) {
        [_delegate photoPicker:self didSelectAssets:self.indexPathsForSelectedItems];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - 遮罩背景
- (UIView *)bgMaskView {
    if (_bgMaskView == nil) {
        UIView *bgMaskView = [[UIView alloc] init];
        bgMaskView.alpha = 0.4;
        bgMaskView.backgroundColor = [UIColor blackColor];
        [self.view insertSubview:bgMaskView aboveSubview:_photoListView];
        bgMaskView.userInteractionEnabled = YES;
        [bgMaskView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapBgMaskView:)]];
        _bgMaskView = bgMaskView;
    }
    return _bgMaskView;
}

- (void)tapBgMaskView:(UITapGestureRecognizer *)sender {
    if (!self.photoGroupView.hidden) {
        [self hidenGroupView];
    }
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

- (void)setupNavigationItems {
    [super setupNavigationItems];

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(rightBtnAction:)];
    self.navigationItem.titleView = self.customTitleView;
}

#pragma mark - getter/setter

- (NSMutableArray *)indexPathsForSelectedItems {
    if (!_indexPathsForSelectedItems) {
        _indexPathsForSelectedItems = [[NSMutableArray alloc] init];
    }
    return _indexPathsForSelectedItems;
}

- (NSMutableArray *)assets {
    if (!_assets) {
        _assets = [[NSMutableArray alloc] init];
    }
    return _assets;
}

#pragma QMUICustomNavigationBarTransitionDelegate

- (nullable UIImage *)navigationBarBackgroundImage {
    return [[UIImage alloc] init];
}

- (nullable UIImage *)navigationBarShadowImage {
    return [[UIImage alloc] init];
}

@end
