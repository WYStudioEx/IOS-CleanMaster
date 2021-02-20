//
//  WYComponentTableItem.m
//  WYComponentTableView
//
//  Created by WYStudio on 2020/8/24.
//  Copyright © 2020 WYStudio. All rights reserved.
//

#import "WYComponentTableItem.h"
#import "WYComponentTableCategory.h"


@interface WYComponentTableItem()

/** 当前控制器 */
@property (nonatomic, weak) NSObject *eventObserver;
/** 是否关闭cell复用，默认是NO */
@property (nonatomic, assign, getter = isCloseReused) BOOL closeReused;
/** 是否关闭cellCache，默认是NO */
@property (nonatomic, assign, getter = isCloseCellCache) BOOL closeCellCache;
/** 临时的cell */
@property (nonatomic, strong) UITableViewCell *tmpCell;

/** 防止递归 */
@property (nonatomic, assign) BOOL cellUpdating;

/** 当禁止重用时，应该强持有这个cell */
@property (nonatomic, strong) UITableViewCell *strongRefCellWhenDisableReuse;

/** 计算时tblview的宽度 */
@property (nonatomic, assign) CGFloat easy_lastTblWidth;
@end

@implementation WYComponentTableItem


- (void)updateCell:(WYComponentTableUpdateType)updateType {
    if (self.cellUpdating) return;
    self.cellUpdating = YES;
    if (updateType & WYComponentTableUpdateTypeContent) {
        if (self.configCellBlock) {
            self.configCellBlock(self.cell, self);
        }
        // 因为改变颜色需要强制渲染，但是在didSelectCell 有animate的模式，会导致又被渲染回去，实际上apple需要在displayCell进行处理。所以需要触发reloadCell
        [self.cell setNeedsFocusUpdate];
        [self.cell updateFocusIfNeeded];
    }
    if (updateType & WYComponentTableUpdateTypeHeight) {
        if (self.configHeightBlock) {
           self.cellHeight = self.configHeightBlock(self);
        }
        if (self.autoCalculateHeight) {
            self.cellHeight = 0;
        }
        [UIView performWithoutAnimation:^{
            [self.tableView beginUpdates];
            [self.tableView endUpdates];
        }];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.02 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter] postNotificationName:@"WYComponentTableItemLayout" object:self.tableView];
        });
    } else if (updateType & WYComponentTableUpdateTypeHeightAnimated) {
        if (self.configHeightBlock) {
            self.cellHeight = self.configHeightBlock(self);
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView beginUpdates];
            [self.tableView endUpdates];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{ // 因为有动画所以延时时间更久
                [[NSNotificationCenter defaultCenter] postNotificationName:@"WYComponentTableItemLayout" object:self.tableView];
            });
        });
    }
    self.cellUpdating = NO;
}

- (void)reloadCell:(UITableViewRowAnimation)animation {
    if (![self isIsVisible] || !self.indexPath) return;
    // 因为有高度缓存，所以reload的时候尝试刷新高度
    if (self.cellUpdating) return;
    self.cellUpdating = YES;
    if (self.configCellBlock && self.cell) {
        self.configCellBlock(self.cell, self);
        if (self.configHeightBlock) {
           self.cellHeight = self.configHeightBlock(self);
        }
    }
    if (self.autoCalculateHeight) {
        self.cellHeight = 0;
    }
    if (animation == UITableViewRowAnimationNone) {
        [UIView performWithoutAnimation:^{
            [self.tableView reloadRowsAtIndexPaths:@[self.indexPath] withRowAnimation:animation];
        }];
    } else {
        [self.tableView reloadRowsAtIndexPaths:@[self.indexPath] withRowAnimation:animation];
    }
    self.cellUpdating = NO;
}


- (BOOL)isIsVisible {
    return [self.tableView.visibleCells containsObject:self.cell];
}

- (UITableViewCell *)cell {
    if (!_cell) {
        return self.tmpCell;
    }
    return _cell;
}

- (void)setCellHeight:(CGFloat)cellHeight {
    _cellHeight = cellHeight;
}

- (void)setHidden:(BOOL)hidden {
    _hidden = hidden;
}

-(UIRectCorner)cornerStyle {
    if (!self.indexPath) {
        return 0;
    }
    if (_cornerStyle > 0) {
        return _cornerStyle;
    }
    
//    QMUITableViewCellPosition postion = (QMUITableViewCellPosition)[self.tableView qmui_positionForRowAtIndexPath:self.indexPath];
//    UIRectCorner cornerStyle = 0;
//
//    if (postion == QMUITableViewCellPositionSingleInSection) {
//        cornerStyle = UIRectCornerAllCorners;
//    }else if (postion == QMUITableViewCellPositionLastInSection){
//        cornerStyle = UIRectCornerBottomLeft | UIRectCornerBottomRight;
//    }else if (postion == QMUITableViewCellPositionFirstInSection){
//        cornerStyle = UIRectCornerTopLeft | UIRectCornerTopRight;
//    }
//
//    return cornerStyle;
    return 0;
}

-(BOOL)shouldShowSeparator {
//    QMUITableViewCellPosition postion = [self.tableView qmui_positionForRowAtIndexPath:self.indexPath];
//    if (postion == QMUITableViewCellPositionSingleInSection || postion == QMUITableViewCellPositionLastInSection) {
//        return NO;
//    } else {
//        return YES;
//    }
    return NO;
}

@end

@interface WYComponentTableGroupItem()

@property (nonatomic, strong) NSMutableArray *itemArrM;

@end

@implementation WYComponentTableGroupItem

- (instancetype)init {
    if (self = [super init]) {
        self.itemArrM = [NSMutableArray array];
    }
    return self;
}

- (void)addItems:(NSArray<WYComponentTableItem *>*)items {
    if (items.count) {
        [self.itemArrM addObjectsFromArray:items];
    }
}

- (void)addItem:(WYComponentTableItem *)item {
    if (item) {
        [self.itemArrM addObject:item];
    }
}

- (void)removeItem:(WYComponentTableItem *)item {
    if (item) {
        [self.itemArrM removeObject:item];
    }
}

- (void)removeItems:(NSArray<WYComponentTableItem *>*)items {
    if (items.count) {
        [self.itemArrM removeObjectsInArray:items];
    }
}

- (NSArray<WYComponentTableItem *> *)getItems {
    // 递归取出所有item
    NSMutableArray *allItem = [NSMutableArray array];
    for (WYComponentTableItem *item in self.itemArrM) {
        if ([item isKindOfClass:[WYComponentTableGroupItem class]]) {
            WYComponentTableGroupItem *subGroupItem = (WYComponentTableGroupItem *)item;
            [allItem addObjectsFromArray:[subGroupItem getItems]];
        } else {
            [allItem addObject:item];
        }
    }
    return [allItem copy];
}

// 支持组操作
- (void)setHidden:(BOOL)hidden {
    [super setHidden:hidden];
    for (WYComponentTableItem *item in self.itemArrM) {
        item.hidden = hidden;
    }
}

- (void)setFilterID:(NSString *)filterID {
    [super setFilterID:filterID];
    for (WYComponentTableItem *item in self.itemArrM) {
        item.filterID = filterID;
    }
}

- (void)reloadCell:(UITableViewRowAnimation)animation {
    if (self.cellUpdating) return;
    self.cellUpdating = YES;
    NSMutableArray *indexPathArr = [NSMutableArray array];
    for (WYComponentTableItem *item in self.itemArrM) {
        if (![item isIsVisible] || !item.indexPath) continue;
        if (item.configCellBlock && item.cell) {
            item.configCellBlock(item.cell, item);
            if (item.configHeightBlock) {
               item.cellHeight = item.configHeightBlock(item);
            }
        }
        if (item.autoCalculateHeight) {
            item.cellHeight = 0;
        }
        if (item.indexPath) {
            [indexPathArr addObject:item.indexPath];
        }
    }

    for (WYComponentTableItem *item in self.itemArrM) {
        if (![item isIsVisible] || !item.indexPath) continue;
        if (item.configCellBlock && item.cell) {
            item.configCellBlock(item.cell, item);
            if (item.configHeightBlock) {
               item.cellHeight = item.configHeightBlock(item);
            }
        }
        if (item.autoCalculateHeight) {
            item.cellHeight = 0;
        }
        if (item.indexPath) {
            [indexPathArr addObject:item.indexPath];
        }
    }
    if (animation == UITableViewRowAnimationNone) {
        [UIView performWithoutAnimation:^{
            [self.tableView reloadRowsAtIndexPaths:indexPathArr withRowAnimation:animation];
        }];
    } else {
        [self.tableView reloadRowsAtIndexPaths:indexPathArr withRowAnimation:animation];
    }
    self.cellUpdating = NO;
}

- (void)updateCell:(WYComponentTableUpdateType)updateType {
    if (self.cellUpdating) return;
    self.cellUpdating = YES;
    for (WYComponentTableItem *item in self.itemArrM) {
        if (updateType & WYComponentTableUpdateTypeContent) {
            if (item.configCellBlock) {
                item.configCellBlock(item.cell, item);
            }
            // 因为改变颜色需要强制渲染，但是在didSelectCell 有animate的模式，会导致又被渲染回去，实际上apple需要在displayCell进行处理。所以需要触发reloadCell
            [item.cell setNeedsFocusUpdate];
            [item.cell updateFocusIfNeeded];
        }
        if (updateType & WYComponentTableUpdateTypeHeight) {
            if (item.configHeightBlock) {
               item.cellHeight = item.configHeightBlock(item);
            }
            if (item.autoCalculateHeight) {
                item.cellHeight = 0;
            }
        } else if (updateType & WYComponentTableUpdateTypeHeightAnimated) {
            if (item.configHeightBlock) {
                item.cellHeight = item.configHeightBlock(item);
            }
        }
    }
    // 刷新
    if (updateType & WYComponentTableUpdateTypeHeight) {
        [UIView performWithoutAnimation:^{
            [self.tableView beginUpdates];
            [self.tableView endUpdates];
        }];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.02 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter] postNotificationName:@"WYComponentTableItemLayout" object:self.tableView];
        });
    } else if (updateType & WYComponentTableUpdateTypeHeightAnimated) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView beginUpdates];
            [self.tableView endUpdates];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{ // 因为有动画所以延时时间更久
                [[NSNotificationCenter defaultCenter] postNotificationName:@"WYComponentTableItemLayout" object:self.tableView];
            });
        });
    }
    self.cellUpdating = NO;
}
@end

@implementation WYComponentTableBlankItem

- (instancetype)init {
    if (self= [super init]) {
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)setFixedSpace:(BOOL)fixedSpace {
    _fixedSpace = fixedSpace;
    if (_fixedSpace) { // 这个时候需要通知easyTableView 计算高度，调整自己的高度
        [[NSNotificationCenter defaultCenter] postNotificationName:@"WYComponentTableItemFixedSpace" object:self];
    }
}

+ (instancetype)itemWithHeight:(CGFloat)cellHeight {
    WYComponentTableBlankItem *blankItem = [WYComponentTableBlankItem new];
    blankItem.cellHeight = cellHeight;
    blankItem.cellClass = UITableViewCell.class;
    blankItem.configCellBlock = ^(__kindof UITableViewCell * _Nonnull cell, __kindof WYComponentTableBlankItem * _Nonnull item) {
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.contentView.backgroundColor = item.backgroundColor;
    };
    return blankItem;
}

@end

@implementation WYComponentTableSeperateCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(nullable NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupUI];
    }
    return self;
}
- (void)setupUI {
    self.seperateView = [UIView new];
    self.seperatorViewHeight = 0.f;
    [self.contentView addSubview:self.seperateView];
}
- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat spH = self.seperatorViewHeight > 0 ? self.seperatorViewHeight : self.contentView.bounds.size.height;
    CGFloat vMargin = (self.contentView.bounds.size.height - spH)/2.f;
    self.seperateView.frame = CGRectMake(self.leftOffset, vMargin, self.contentView.bounds.size.width-self.rightOffset-self.leftOffset, spH);
}
@end

@interface WYComponentTableTextCell()

@end

@implementation WYComponentTableTextCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(nullable NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.textLbl = [UILabel new];
    self.textLbl.font = [UIFont systemFontOfSize:13.f];
    self.textLbl.numberOfLines = 0.0;
    //self.textLbl.textColor = [UIColor qmui_colorWithHexString:@"#888888"];
    [self.contentView addSubview:self.textLbl];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self sizeThatFits:CGSizeMake(self.bounds.size.width, CGFLOAT_MAX)];
}

- (CGSize)sizeThatFits:(CGSize)size {
    CGFloat textW = size.width - self.textItem.contentInset.left - self.textItem.contentInset.right;
    CGFloat textH = 0;
    if (self.textLbl.attributedText) {
       textH = [self.textLbl.attributedText easy_attributeStringGetHeightWithMaxWidth:textW];
    } else {
       textH = [self.textLbl.text easy_getHeightWithMaxWidth:textW font:self.textLbl.font];
    }
    if (self.textItem) {
        self.textLbl.frame = CGRectMake(self.textItem.contentInset.left, self.textItem.contentInset.top, textW, textH);
    }
    
    return CGSizeMake(size.width, self.textItem.contentInset.top+textH+self.textItem.contentInset.bottom);
}

@end

@implementation WYComponentTableSeperateItem : WYComponentTableItem

+ (instancetype)itemWithLeftOffset:(CGFloat)leftOffset rightOffset:(CGFloat)rightOffset {
    WYComponentTableSeperateItem *seperateItem = [WYComponentTableSeperateItem new];
    seperateItem.cellHeight = (1 / [[UIScreen mainScreen] scale]);
    seperateItem.cellClass = WYComponentTableSeperateCell.class;
    seperateItem.leftOffset = leftOffset;
    seperateItem.rightOffset = rightOffset;
    seperateItem.backgroundColor = [UIColor whiteColor];
    //seperateItem.seperateColor = [UIColor qmui_colorWithHexString:@"#D5D5D5"];
    seperateItem.configCellBlock = ^(__kindof WYComponentTableSeperateCell * _Nonnull cell, __kindof WYComponentTableSeperateItem * _Nonnull item) {
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = item.backgroundColor;
        cell.leftOffset = item.leftOffset;
        cell.rightOffset = item.rightOffset;
        cell.seperateView.backgroundColor = item.seperateColor;
    };
    return seperateItem;
}

@end

@implementation WYComponentTableAutoCalAndNotReusedItem

- (instancetype)init {
    if (self = [super init]) {
        self.autoCalculateHeight = YES;
        self.disableCellReused = YES;
    }
    return self;
}

@end

@implementation WYComponentTableTextItem : WYComponentTableItem

- (instancetype)init {
    if (self = [super init]) {
        self.cellClass = WYComponentTableTextCell.class;
        self.autoCalculateHeight = YES;
    }
    return self;
}

+ (instancetype)itemWithCellConfig:(WYComponentTableConfigCellBlock)cellConfig {
    return [WYComponentTableTextItem itemWithLeftOffset:12 rightOffset:12 lineHeight:18 cellConfig:cellConfig];
}

+ (instancetype)itemWithLeftOffset:(CGFloat)leftOffset rightOffset:(CGFloat)rightOffset lineHeight:(CGFloat)lineHeight cellConfig:(WYComponentTableConfigCellBlock)cellConfig {
    WYComponentTableTextItem *textItem = [WYComponentTableTextItem new];
    textItem.cellClass = WYComponentTableTextCell.class;
    textItem.contentInset = UIEdgeInsetsMake(0, leftOffset, 0, rightOffset);
    textItem.lineHeight = lineHeight;
    textItem.autoCalculateHeight = YES;
    textItem.configCellBlock = ^(__kindof WYComponentTableTextCell * _Nonnull cell, __kindof WYComponentTableTextItem * _Nonnull item) {
        cell.textItem = item;
        cell.textLbl.text = item.text;
        if (cellConfig) {
            cellConfig(cell, item);
        }
        if (item.lineHeight) {
            if (cell.textLbl.attributedText) { // 其实应该拷贝一下只修改lineHeight
                
            } else { // 重新设置富文本
                
            }
            // 设置富文本
            cell.textLbl.attributedText = [cell.textLbl.text easy_attributeStringFont:cell.textLbl.font textColor:cell.textLbl.textColor lineHeight:cell.textItem.lineHeight lineSpacing:0 wordSpacing:0 underlineStyle:NSUnderlineStyleNone alignment:cell.textLbl.textAlignment];
        }
    };
    return textItem;
}


@end

////  图片
@interface WYComponentTableImageCell ()
@property (nonatomic, assign) CGSize si;
@end

@implementation  WYComponentTableImageCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(nullable NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self p_setupUI];
    }
    return self;
}

- (void)p_setupUI {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.imgView = [UIImageView new];
    [self.contentView addSubview:self.imgView];
}

- (CGFloat)p_layoutUI:(CGFloat)width {
    CGFloat imgw = self.si.width;
    CGFloat imgh = self.si.height;
    if (imgw == CGFLOAT_MAX) {
        imgw = width;
    }
    if (imgh == CGFLOAT_MAX) {
        imgh = [self.imgView sizeThatFits:CGSizeMake(width, CGFLOAT_MAX)].height;
    }
    self.imgView.frame  = CGRectMake((width-imgw)*0.5, 0, imgw, imgh);
    return imgh;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self p_layoutUI:self.bounds.size.width];
}

- (CGSize)sizeThatFits:(CGSize)size {
    return CGSizeMake(size.width, [self p_layoutUI:size.width]);
}

@end

@implementation WYComponentTableImageItem : WYComponentTableItem

+ (instancetype)itemWithSize:(CGSize)size cellConfig:(WYComponentTableImageConfigCellBlock)cellConfig {
    WYComponentTableImageItem *item = [WYComponentTableImageItem new];
    item.imgSize = size;
    item.cellClass = WYComponentTableImageCell.class;
    item.cellHeight = size.height;
    item.autoCalculateHeight = YES;
    item.configCellBlock = ^(__kindof WYComponentTableImageCell * _Nonnull cell, __kindof WYComponentTableImageItem * _Nonnull ii) {
        cell.si = size;
        if (cellConfig) {
            cellConfig(cell, ii);
        }
        cell.si = ii.imgSize;
    };
    return item;
}


@end
