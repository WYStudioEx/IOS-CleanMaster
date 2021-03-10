//
//  PhotoContentModel.h
//  IOSBaseTemplate
//
//  Created by WYStudio on 2021/2/19.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SiglePhotoModel : NSObject

@property (nonatomic, strong) PHAsset *asset;

@property (nonatomic, strong) UIImage *image;

@property (nonatomic, assign) BOOL isSelect;

@end

//----------------------------------------------------
@interface PhotoContentModel : NSObject

@property (nonatomic, strong) NSArray<SiglePhotoModel *> *photos;

@end

NS_ASSUME_NONNULL_END
