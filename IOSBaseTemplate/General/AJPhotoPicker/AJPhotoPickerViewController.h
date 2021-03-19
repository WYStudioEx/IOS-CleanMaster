//
//  AJPhotoPickerViewController.h
//  AJPhotoPicker
//
//  Created by AlienJunX on 15/11/2.
//  Copyright (c) 2015 AlienJunX
//
//  This source code is licensed under the MIT-style license found in the
//  LICENSE file in the root directory of this source tree.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "UIBaseViewController.h"
#import "AJPhotoGroupCell.h"

@class AJPhotoPickerViewController;


@protocol AJPhotoPickerProtocol <NSObject>
@optional
//选择完成
- (void)photoPicker:(AJPhotoPickerViewController *)picker didSelectAssets:(NSArray *)assets;

//点击选中
- (void)photoPicker:(AJPhotoPickerViewController *)picker didSelectAsset:(UIImage*)asset;

//取消选中
- (void)photoPicker:(AJPhotoPickerViewController *)picker didDeselectAsset:(UIImage*)asset;

@end


@interface AJPhotoPickerViewController : UIBaseViewController

@property (weak, nonatomic) id<AJPhotoPickerProtocol> delegate;

//选中的项
@property (nonatomic, strong) NSMutableArray *indexPathsForSelectedItems;

@end
