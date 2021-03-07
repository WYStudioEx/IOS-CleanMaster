//
//  UIImgPreviewCollectionView.h
//  IOSBaseTemplate
//
//  Created by WYStudio on 2018/6/21.
//  Copyright © 2021年 WYStudio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImgPreviewCollectionView : UICollectionView  <UICollectionViewDataSource,UICollectionViewDelegate>

@property(nonatomic, assign) NSInteger currentIndex;
@property(nonatomic, strong) NSArray  *imageModels;

- (void)load;

@end
