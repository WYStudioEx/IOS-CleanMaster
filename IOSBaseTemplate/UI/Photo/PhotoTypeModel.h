//
//  PhotoTypeModel.h
//  IOSBaseTemplate
//
//  Created by WYStudio on 2021/2/19.
//

#import <Foundation/Foundation.h>
#import "PhotoContentModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface PhotoTypeModel : NSObject

/** 标题 */
@property (nonatomic, copy) NSString *title;

/** 内容 */
@property (nonatomic, strong) NSMutableArray<PhotoContentModel *> *content;

/** 是否展开 */
@property (nonatomic, assign) BOOL isExpand;

@end

NS_ASSUME_NONNULL_END
