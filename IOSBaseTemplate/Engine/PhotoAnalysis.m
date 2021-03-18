//
//  PhotoAnalysis.m
//  IOSBaseTemplate
//
//  Created by WYStudio on 21/2/24.
//  Copyright (c) 2021年 WYStudio. All rights reserved.
//

#import "PhotoAnalysis.h"
#import "GetSimilarity.h"

unsigned int ToGrey(unsigned int rgb)
{
    unsigned int blue   = (rgb & 0x000000FF) >> 0;
    unsigned int green  = (rgb & 0x0000FF00) >> 8;
    unsigned int red    = (rgb & 0x00FF0000) >> 16;
    return ( red*38 +  green * 75 +  blue * 15 )>>7;
}

double getImgBlurDegree(unsigned char* ImgdataGray, int nWidth, int nHeight)
{
    if(ImgdataGray == NULL || nWidth <= 4 || nHeight <= 4) {
        return 0.0;
    }
    int row= nHeight;
    int col= nWidth;
    int widthstep=nWidth;
    double S=0;
    unsigned char* data  = ImgdataGray;
    for(int x = 1;x<row-1;x+=2) {
        unsigned char *pre_row=data +(x-1)*widthstep;
        unsigned char *cur_row=data +x*widthstep;
        unsigned char *nex_row=data +(x+1)*widthstep;
        int Sx,Sy;
        for(int y = 1;y<col-1;y+=2)
        {
           Sx=(int)pre_row[y+1]+2*(int)cur_row[y+1]+(int)nex_row[y+1]//一定要转为uchar
           -(int)pre_row[y-1]-2*(int)cur_row[y-1]-(int)nex_row[y-1];
           Sy=(int)nex_row[y-1]+2*(int)nex_row[y]+(int)nex_row[y+1]
           -(int)pre_row[y-1]-2*(int)pre_row[y]-(int)pre_row[y+1];
           S+=Sx*Sx+Sy*Sy;
        }
    }
    return S/(row/2-2)/(col/2-2);
}

//------------------------------------------------------------------
@implementation PhotoAnalysis

+ (BOOL)checkSimilarityImage:(UIImage *)firstImage secondImage:(UIImage *)secondImage {
    return [GetSimilarity getSimilarityValueWithImgA:firstImage ImgB:secondImage] > 0.9;
}

+ (BOOL)checkBlurryWihtImage:(UIImage *)image {
    if (!image) {
        return 0;
    }
    UIImage *grayscale = [self getGrayscale:image];

    CGImageRef imageRef = [grayscale CGImage];
    CGFloat width = CGImageGetWidth(imageRef);
    CGFloat height = CGImageGetHeight(imageRef);

    CGDataProviderRef provider =  CGImageGetDataProvider(imageRef);
    NSData* data = (id)CFBridgingRelease(CGDataProviderCopyData(provider));
    uint8_t *grayscaleData = (uint8_t *)[data bytes];

    //小于300认为是模糊图
    return getImgBlurDegree(grayscaleData, width, height) < 300;
}

+ (UIImage*)getGrayscale:(UIImage*)sourceImage {
    int width = sourceImage.size.width;
    int height = sourceImage.size.height;
    CGColorSpaceRef colorSpace =  CGColorSpaceCreateDeviceGray();
    CGContextRef context = CGBitmapContextCreate (nil,width,height,8,width,colorSpace,kCGImageAlphaNone);
    CGColorSpaceRelease(colorSpace);
    if (context == NULL) {
        return nil;
    }
    CGContextDrawImage(context,CGRectMake(0, 0, width, height), sourceImage.CGImage);
    UIImage *grayImage = [UIImage imageWithCGImage:CGBitmapContextCreateImage(context)];
    CGContextRelease(context);

    return grayImage;
}

@end
