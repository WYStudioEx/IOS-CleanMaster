//
//  WYComponentTableItem.h
//  WYComponentTableView
//
//  Created by WYStudio on 2020/8/24.
//  Copyright © 2020 WYStudio. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

#define WYComponentDeprecated(instead) NS_DEPRECATED(2_0, 2_0, 2_0, 2_0, instead)

typedef SEL WYComponentItemSEL; // 固定的方法签名： - (void)funcName:(WYComponentTableItem *)item

typedef NS_ENUM(NSUInteger, WYComponentTableHover) {
    EasyTableHoverNone = 0,
    EasyTableHoverTop,
//    EasyTableHoverBottom, 暂不支持
};

typedef NS_OPTIONS(NSUInteger, WYComponentTableUpdateType) {
    WYComponentTableUpdateTypeContent = 1 << 1,         // 刷新内容，不会更新高度，调用configCellBlock
    WYComponentTableUpdateTypeHeight  = 1 << 2,         // 刷新高度，键盘不会下去，调用configHeightBlock
    WYComponentTableUpdateTypeHeightAnimated  = 1 << 3, // 刷新高度带动画，键盘不会下去，键盘不会下去，调用configHeightBlock
    // 刷新内容并且刷新高度 configCellBlock和configHeightBlock都会调用
    WYComponentTableUpdateTypeAnimated = WYComponentTableUpdateTypeContent | WYComponentTableUpdateTypeHeightAnimated,
    WYComponentTableUpdateTypeDefault = WYComponentTableUpdateTypeContent | WYComponentTableUpdateTypeHeight,
};


@class WYComponentTableItem;
typedef void(^WYComponentTableConfigCellBlock)(__kindof UITableViewCell *cell, __kindof WYComponentTableItem *item);
typedef CGFloat(^WYComponentTableConfigHeightBlock)(__kindof WYComponentTableItem *item);

//------------------------------------------------------------
@interface WYComponentTableItem<T : NSObject *> : NSObject

/** 上下文对象 */
@property (nonatomic, strong) T contextData;

/** cell的类型 */
@property (nonatomic, strong) Class cellClass;

/** 设置cell,显示的时候会触发 -> willDisplayCell */
@property (nonatomic, copy) WYComponentTableConfigCellBlock configCellBlock;

@property (nonatomic, copy) void(^cellClickAction)(__kindof WYComponentTableItem *cellItem);

/** 设置cell高度（如果cellHeight==0，则会计算） -> heightForRowAtIndexPath */
@property (nonatomic, copy) WYComponentTableConfigHeightBlock configHeightBlock;

/** 自动计算cell高度
    会自动尝试从以下方式去拿到高度
    configHeightBlock -> cell.sizeThatFit: -> autoLayout
 */
@property (nonatomic, assign) BOOL autoCalculateHeight;

/** cell高度, 改变后需要updateCell 或者 reloadCell生效 */
@property (nonatomic, assign) CGFloat cellHeight;

/** 是否关闭cell复用，关闭后identify会被设为唯一值，默认是NO，【注意：此时item会强持有cell】 */
@property (nonatomic, assign, getter = isDisableCellReused) BOOL disableCellReused;

/** 是否关闭高度缓存，关闭后会在多次调用configHeightBlock，默认是NO */
@property (nonatomic, assign, getter = isDisableCellHeightCache) BOOL disableCellHeightCache;

/** 隐藏，数据源还在只是高度变小了看不到，无视cellHeight, 改变后需要updateCell 或者 reloadCell生效 【支持WYComponentTableGroupItem】*/
@property (nonatomic, assign, getter=isHidden) BOOL hidden;

/** cell的点击事件 - (void)funcName:(WYComponentTableItem *)item */
@property (nonatomic, assign) WYComponentItemSEL didSelectRowSelector;

/** 当前tableView */
@property (nonatomic, weak, nullable) UITableView *tableView;

/** 当前item的id，用在-(void)getEasyTableItemsWithfilterID:如果不唯一则会查询返回多个【支持WYComponentTableGroupItem】 */
@property (nonatomic, copy, nullable) NSString *filterID;

/** cornerStyle, 如果没有设置，将按照group风格计算返回 */
@property (nonatomic, assign) UIRectCorner cornerStyle;

/** 按照group风格计算返回 */
@property (nonatomic, assign, readonly) BOOL shouldShowSeparator;

/** 禁止从重用池获取cell来计算高度 */
@property (nonatomic, assign) BOOL disableDequeueCellForCaculateHeight;

/** 当前绑定的cell
    不建议拿这个视图直接操作更新，因为重用机制，滚动的时候还是会去configCellBlock，这样直接操作cell的逻辑可能会被configCellBlock覆盖，所以这业务逻辑还得在configCellBlock写一遍。
    【建议写法：cell的所有配置逻辑在configCellBlock，业务改变数据源然后updateCell或者reloadCell，也可以直接reloadData】
 eg:
 item.configCellBlock = ^(__kindof UITableViewCell * _Nonnull cell, __kindof WYComponentTableItem * _Nonnull item) {
    if (item.YourLogic) {
        cell.textLabel.text = @"文案1"；
    } else {
        cell.textLabel.text = @"文案2"；
    }
 };

 - (void)otherFunc {
    // 1.改变数据源
    item.YourLogic = YourLogic;
    // 2.刷新这个cell，触发 item.configCellBlock
    [item updateCell:WYComponentTableUpdateTypeDefault];
 }
 */
@property (nonatomic, weak, nullable) UITableViewCell *cell;

/** 对应的数据源index */
@property (nonatomic, strong, nullable) NSIndexPath *indexPath;

/** 是否在当前是否屏幕可见（滚出来没有） */
@property (nonatomic, assign, readonly, getter=isVisible) BOOL isVisible;

/** cell悬停 */
@property (nonatomic, assign) WYComponentTableHover hover;

/** 触发reloadRowsAtIndexPaths【支持WYComponentTableGroupItem】 */
- (void)reloadCell:(UITableViewRowAnimation)animation;

/** cell刷新，和reloadCell相比比较轻量级，并且键盘不会下去，textView高度的变化适合这个【支持WYComponentTableGroupItem】 */
- (void)updateCell:(WYComponentTableUpdateType)updateType;

@end

//------------------------------------------------------------
//// 关闭重并且自动计算高度
@interface WYComponentTableAutoCalAndNotReusedItem : WYComponentTableItem

@end

//------------------------------------------------------------
//// 空白item
@interface WYComponentTableBlankItem : WYComponentTableItem

+ (instancetype)itemWithHeight:(CGFloat)cellHeight;
@property (nonatomic, strong) UIColor *backgroundColor;
@property (nonatomic, assign) BOOL fixedSpace;
@end

//// 空白cell快捷创建
#define WYComponentBlank(height)  ([WYComponentTableBlankItem itemWithHeight:height])
#define WYComponentBlankColor(height, color)  ({\
WYComponentTableBlankItem *_blank_item_ = [WYComponentTableBlankItem itemWithHeight:height];\
_blank_item_.backgroundColor = color;\
_blank_item_;\
})

//------------------------------------------------------------
//// 文本item
@class WYComponentTableTextCell, WYComponentTableTextItem;

@interface WYComponentTableTextCell : UITableViewCell

@property (nonatomic, strong) UILabel *textLbl;

@property (nonatomic, weak) WYComponentTableTextItem *textItem;

@end

//------------------------------------------------------------
@interface WYComponentTableTextItem : WYComponentTableItem

/** 文本 */
@property (nonatomic, copy) NSString *text;
/** 行间距 */
@property (nonatomic, assign) CGFloat lineHeight;
/** 内边距*/
@property (nonatomic, assign) UIEdgeInsets contentInset;
/** 背景色，默认白色 */
@property (nonatomic, strong) UIColor *backgroundColor;

@end

//快捷创建
#define WYComponentText(_text)  ({\
WYComponentTableTextItem *_text_easy_item = [WYComponentTableTextItem itemWithCellConfig:^(__kindof WYComponentTableTextCell * _Nonnull cell, __kindof WYComponentTableTextItem * _Nonnull item) { \
    cell.textLbl.text = _text; \
}]; \
_text_easy_item;\
})

//------------------------------------------------------------
//// 分割线cell
#define WYComponentSeperate(left, right)  ([WYComponentTableSeperateItem itemWithLeftOffset:left rightOffset:right])
@interface WYComponentTableSeperateCell : UITableViewCell
@property (nonatomic, strong) UIView *seperateView;
@property (nonatomic, assign) CGFloat leftOffset;
@property (nonatomic, assign) CGFloat rightOffset;
@property (nonatomic, assign) CGFloat seperatorViewHeight;
@end

@interface WYComponentTableSeperateItem : WYComponentTableItem

+ (instancetype)itemWithLeftOffset:(CGFloat)leftOffset rightOffset:(CGFloat)rightOffset;

/** 左边距 */
@property (nonatomic, assign) CGFloat leftOffset;
/** 右边距 */
@property (nonatomic, assign) CGFloat rightOffset;
/** 背景色，默认白色 */
@property (nonatomic, strong) UIColor *backgroundColor;
/** 分割线颜色，默认灰色 */
@property (nonatomic, strong) UIColor *seperateColor;

@end

//------------------------------------------------------------
////  图片
@interface WYComponentTableImageCell : UITableViewCell
@property (nonatomic, strong) UIImageView *imgView;
@end

@class WYComponentTableImageItem;
typedef void(^WYComponentTableImageConfigCellBlock)(__kindof WYComponentTableImageCell *cell, __kindof WYComponentTableImageItem *item);
@interface WYComponentTableImageItem : WYComponentTableItem

+ (instancetype)itemWithSize:(CGSize)size cellConfig:(WYComponentTableImageConfigCellBlock)cellConfig;

/** size */
@property (nonatomic, assign) CGSize imgSize;

@end

//------------------------------------------------------------
//// 包装器，就是优化代码逻辑，不能直接设置到DataSouce里面
@interface WYComponentTableGroupItem : WYComponentTableItem

- (void)addItems:(NSArray<WYComponentTableItem *>*)items;
- (void)addItem:(WYComponentTableItem *)item;
- (void)removeItem:(WYComponentTableItem *)item;
- (void)removeItems:(NSArray<WYComponentTableItem *>*)items;
- (NSArray<WYComponentTableItem *> *)getItems;

@end


NS_ASSUME_NONNULL_END
