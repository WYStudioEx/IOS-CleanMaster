//
//  PhotoAnalysis.h
//  IOSBaseTemplate
//
//  Created by WYStudio on 21/2/24.
//  Copyright (c) 2021年 WYStudio. All rights reserved.
//


#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface PhotoAnalysis : NSObject

+ (BOOL)checkSimilarityImage:(UIImage *)firstImage secondImage:(UIImage *)secondImage;

+ (BOOL)checkBlurryWihtImage:(UIImage *)image;


@end
