//
//  UIPhotoSearchResultViewController.h
//  IOSBaseTemplate
//
//  Created by WYStudio on 21/2/22.
//  Copyright (c) 2021年 WYStudio. All rights reserved.
//

#import "UIBaseViewController.h"
#import <UIKit/UIKit.h>

@class PhotoTypeModel;

@interface UIPhotoSearchResultViewController : UIBaseViewController

@property (strong,nonatomic) NSArray<PhotoTypeModel *> *dataArray;

@end
