//
//  WYComponentTableSectionItem.h
//  WYComponentTableView
//
//  Created by WYStudio on 2020/8/28.
//  Copyright © 2020 WYStudio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WYComponentTableItem.h"
#import "WYComponentTableCategory.h"

NS_ASSUME_NONNULL_BEGIN

@class WYComponentTableSectionItem;
typedef void(^WYComponentTableConfigSectionBlock)(__kindof UIView *view, WYComponentTableSectionItem *item);
typedef CGFloat(^WYComponentTableConfigSectionHeightBlock)(WYComponentTableSectionItem *item);

@interface WYComponentTableSectionItem<T : NSObject *> : NSObject

/** 自定义类型 */
@property (nonatomic, strong) T contextData;
/** cell数据源 */
@property (nonatomic, strong) NSMutableArray<WYComponentTableItem *> *cellDataSource;
/** section号-显示后赋值 */
@property (nonatomic, assign) NSInteger section;

/** 组头视图 */
@property (nonatomic, strong) UIView *headerView;
/** 组头高度 */
@property (nonatomic, assign) CGFloat headerHeight;
/** 组头显示时触发 */
@property (nonatomic, copy) WYComponentTableConfigSectionBlock configHeaderViewBlock;
/** 组头高度计算 */
@property (nonatomic, copy) WYComponentTableConfigSectionHeightBlock configHeaderHeightBlock;

/** 组尾视图 */
@property (nonatomic, strong) UIView *footerView;
/** 组尾高度 */
@property (nonatomic, assign) CGFloat footerHeight;
/** 组尾 */
@property (nonatomic, copy) WYComponentTableConfigSectionBlock configFooterViewBlock;
/** 组尾高度计算 */
@property (nonatomic, copy) WYComponentTableConfigSectionHeightBlock configFooterHeightBlock;

@end

NS_ASSUME_NONNULL_END
