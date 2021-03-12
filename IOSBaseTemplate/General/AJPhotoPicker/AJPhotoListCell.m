//
//  AJPhotoListCell.m
//  AJPhotoPicker
//
//  Created by AlienJunX on 15/11/2.
//  Copyright (c) 2015 AlienJunX
//
//  This source code is licensed under the MIT-style license found in the
//  LICENSE file in the root directory of this source tree.
//

#import "AJPhotoListCell.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "AJPhotoListCellTapView.h"

@interface AJPhotoListCell()

@property (weak, nonatomic) UIImageView *imageView;
@property (weak, nonatomic) AJPhotoListCellTapView *tapAssetView;
@property (strong, nonatomic) UIImage *asset;

@end

@implementation AJPhotoListCell

- (void)bind:(UIImage *)asset isSelected:(BOOL)isSelected {
    self.asset = asset;
    if (self.imageView == nil) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
        [self.contentView addSubview:imageView];
        self.imageView = imageView;
        
        [self.imageView setContentMode:UIViewContentModeScaleAspectFill];
        self.imageView.layer.cornerRadius = 6;
        self.imageView.clipsToBounds = YES;
        self.backgroundColor = [UIColor clearColor];
    }
    [self.imageView setImage:(UIImage *)asset];
    
    if (!self.tapAssetView) {
        AJPhotoListCellTapView *tapView = [[AJPhotoListCellTapView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
        [self.contentView addSubview:tapView];
        self.tapAssetView = tapView;
    }
    _tapAssetView.selected = isSelected;
}

- (void)isSelected:(BOOL)isSelected {
    _tapAssetView.selected = isSelected;
}

@end
