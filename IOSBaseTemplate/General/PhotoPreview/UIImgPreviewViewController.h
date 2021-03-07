//
//  UIImgPreviewViewController.h
//  IOSBaseTemplate
//
//  Created by WYStudio on 2018/6/21.
//  Copyright © 2021年 WYStudio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "UIBaseViewController.h"

@class UIImgPreviewViewController;


@protocol UIImgPreviewViewControllerProtocol <NSObject>
@optional

- (void)previewView:(UIImgPreviewViewController *)picker delIndex:(NSUInteger) index;

- (void)previewView:(UIImgPreviewViewController *)picker addIndex:(NSUInteger) index;

@end


@interface UIImgPreviewViewController : UIBaseViewController

@property (weak, nonatomic) id<UIImgPreviewViewControllerProtocol> delegate;

@property (nonatomic, assign) NSUInteger selIndex;
@property (nonatomic, strong) NSMutableArray *imageModels;

@end
