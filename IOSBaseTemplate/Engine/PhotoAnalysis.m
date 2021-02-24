//
//  PhotoAnalysis.m
//  IOSBaseTemplate
//
//  Created by WYStudio on 21/2/24.
//  Copyright (c) 2021年 WYStudio. All rights reserved.
//

#import "PhotoAnalysis.h"

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

@interface PhotoAnalysis()

@property (nonatomic,strong) UIImage *imga;
@property (nonatomic,strong) UIImage *imgb;

@end

//------------------------------------------------------------------
@implementation PhotoAnalysis

+ (BOOL)checkSimilarityImage:(UIImage *)firstImage secondImage:(UIImage *)secondImage {
    return [PhotoAnalysis getSimilarityValueWithFirstImage:firstImage secondImage:secondImage] > 0.9;
}

+ (double)getSimilarityValueWithFirstImage:(UIImage *)firstImage secondImage:(UIImage *)secondImag
{
    int cursize = 16.0;
    int ArrSize = cursize * cursize + 1,a[ArrSize],b[ArrSize],i,j,grey,sum = 0;
    CGSize size = {cursize,cursize};
    UIImage * imga = [PhotoAnalysis reSizeImage:firstImage toSize:size];
    UIImage * imgb = [PhotoAnalysis reSizeImage:secondImag toSize:size];

    a[ArrSize] = 0;
    b[ArrSize] = 0;
    CGPoint point;
    for (i = 0 ; i < cursize; i++) {//计算a的灰度
        for (j = 0; j < cursize; j++) {
            point.x = i;
            point.y = j;
            grey = ToGrey([PhotoAnalysis UIcolorToRGB:[self colorAtPixel:point img:imga]]);
            a[cursize * i + j] = grey;
            a[ArrSize] += grey;
        }
    }
    a[ArrSize] /= (ArrSize - 1);//灰度平均值
    for (i = 0 ; i < cursize; i++) {//计算b的灰度
        for (j = 0; j < cursize; j++) {
            point.x = i;
            point.y = j;
            grey = ToGrey([PhotoAnalysis UIcolorToRGB:[PhotoAnalysis colorAtPixel:point img:imgb]]);
            b[cursize * i + j] = grey;
            b[ArrSize] += grey;
        }
    }
    b[ArrSize] /= (ArrSize - 1);//灰度平均值
    for (i = 0 ; i < ArrSize ; i++)//灰度分布计算
    {
        a[i] = (a[i] < a[ArrSize] ? 0 : 1);
        b[i] = (b[i] < b[ArrSize] ? 0 : 1);
    }
    ArrSize -= 1;
    for (i = 0 ; i < ArrSize ; i++)
    {
        sum += (a[i] == b[i] ? 1 : 0);
    }
    
    return sum * 1.0 / ArrSize;
}

+ (UIImage *)reSizeImage:(UIImage *)image toSize:(CGSize)reSize
{
    UIGraphicsBeginImageContext(CGSizeMake(reSize.width, reSize.height));
    [image drawInRect:CGRectMake(0, 0, reSize.width, reSize.height)];
    UIImage *reSizeImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return reSizeImage;
}

+ (unsigned int)UIcolorToRGB:(UIColor*)color
{
    unsigned int RGB,R,G,B;
    RGB = R = G = B = 0x00000000;
    CGFloat r,g,b,a;
    [color getRed:&r green:&g blue:&b alpha:&a];
    R = r * 256 ;
    G = g * 256 ;
    B = b * 256 ;
    RGB = (R << 16) | (G << 8) | B ;
    return RGB;
}

+ (UIColor *)colorAtPixel:(CGPoint)point img:(UIImage*)img{
    // Cancel if point is outside image coordinates
    if (!CGRectContainsPoint(CGRectMake(0.0f, 0.0f, img.size.width, img.size.height), point)) { return nil; }
    
    NSInteger   pointX  = trunc(point.x);
    NSInteger   pointY  = trunc(point.y);
    CGImageRef  cgImage = img.CGImage;
    NSUInteger  width   = img.size.width;
    NSUInteger  height  = img.size.height;
    int bytesPerPixel   = 4;
    int bytesPerRow     = bytesPerPixel * 1;
    NSUInteger bitsPerComponent = 8;
    unsigned char pixelData[4] = { 0, 0, 0, 0 };
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(pixelData, 1, 1, bitsPerComponent, bytesPerRow, colorSpace, kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    
    CGColorSpaceRelease(colorSpace);
    CGContextSetBlendMode(context, kCGBlendModeCopy);
    
    // Draw the pixel we are interested in onto the bitmap context
    CGContextTranslateCTM(context, -pointX, pointY-(CGFloat)height);
    CGContextDrawImage(context, CGRectMake(0.0f, 0.0f, (CGFloat)width, (CGFloat)height), cgImage);
    CGContextRelease(context);
    // Convert color values [0..255] to floats [0.0..1.0]
  
    CGFloat red   = (CGFloat)pixelData[0] / 255.0f;
    CGFloat green = (CGFloat)pixelData[1] / 255.0f;
    CGFloat blue  = (CGFloat)pixelData[2] / 255.0f;
    CGFloat alpha = (CGFloat)pixelData[3] / 255.0f;
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
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
