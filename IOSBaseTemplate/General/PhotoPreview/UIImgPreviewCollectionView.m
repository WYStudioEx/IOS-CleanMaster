//
//  UIImgPreviewCollectionView.h
//  IOSBaseTemplate
//
//  Created by WYStudio on 2018/6/21.
//  Copyright © 2021年 WYStudio. All rights reserved.
//

#import "UIImgPreviewCollectionView.h"

#define WIDTH [UIScreen mainScreen].bounds.size.width
#define HEIGHT [UIScreen mainScreen].bounds.size.height
#define MARGIN 10

static NSString * const reuseIdentifier = @"browserCell";

@interface CollectionCell : UICollectionViewCell
@property (nonatomic,weak) UIImageView *imageView;
@end

//----------------------------------------------------------
@implementation CollectionCell
- (UIImageView *)imageView{
    if (_imageView == nil) {
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.userInteractionEnabled = YES;
        self.imageView = imageView;
        [self.contentView addSubview:imageView];
    }
    return _imageView;
}

@end


#pragma mark - -----------------PhotoBrowser -----------------
@interface UIImgPreviewCollectionView()

@end

@implementation UIImgPreviewCollectionView
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.imageModels.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    cell.backgroundColor = [UIColor clearColor];
    UIImage *image = self.imageModels[indexPath.item];
    cell.imageView.image = image;
    CGFloat scale = image.size.height / image.size.width;
    cell.imageView.bounds = CGRectMake(0, 0, WIDTH * 0.8, WIDTH * 0.8 * scale);
    cell.imageView.center = CGPointMake(cell.qmui_width / 2.0, cell.qmui_height / 2.0 - _size_H_S_X(40));
    
    return cell;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    NSInteger index = (scrollView.contentOffset.x + scrollView.bounds.size.width * 0.5) / scrollView.bounds.size.width;
    if (index < 0) return;
    
    self.currentIndex = index;
}

-(instancetype)initWithFrame:(CGRect)frame {
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    flowLayout.minimumLineSpacing = 0;
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.itemSize = CGSizeMake(WIDTH, HEIGHT);
    self.collectionViewLayout = flowLayout;
    
    if (self = [super initWithFrame:frame collectionViewLayout:flowLayout]){
        //背景色
        self.pagingEnabled = YES;
        self.showsHorizontalScrollIndicator = NO;
        //注册cell
        [self registerClass:[CollectionCell class] forCellWithReuseIdentifier:reuseIdentifier];
        self.backgroundColor = [UIColor clearColor];
        self.delegate = self;
        self.dataSource = self;
    }
    return self;
}

- (void)load {
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:_currentIndex inSection:0];
    [self scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
}

- (void)setCurrentIndex:(NSInteger)currentIndex {
    _currentIndex = currentIndex;
}

@end

