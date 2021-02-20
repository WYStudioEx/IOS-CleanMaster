//
//  WYComponentTableViewController.h
//  WYComponentTableView
//
//  Created by WYStudio on 2020/8/24.
//  Copyright © 2020 WYStudio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WYComponentTableSectionItem.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, WYComponentInputHandleOption) {
    WYComponentKeyboardHandleOptionNone,    // 不滚动table
    WYComponentKeyboardHandleOptionSystem,  // 滚动table按照系统行为 [系统行为在tableview上会有bug，会触发tableview往下拉]
    WYComponentKeyboardHandleOptionCell,    // 滚动到输入框cell底部
    WYComponentKeyboardHandleOptionCursor,  // 滚动到输入框光标底部
    WYComponentKeyboardHandleOptionDisable=100  // 完全屏蔽掉所有的键盘逻辑，包括endEditingWhenBeginDragging和endEditingWhenTouch
};

@interface WYComponentTableViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray<WYComponentTableSectionItem *> *dataSource;

// Debug开关，所有cell会显示背景色
@property (nonatomic, assign) BOOL OPEN_DEBUG;

// cell的背景色跟随tableview的背景色 默认是NO
@property (nonatomic, assign) BOOL autoCellBackgroundColor;

// tableview里有键盘唤起时，自动滚动逻辑
// 默认是WYComponentKeyboardHandleOptionNone
// WYComponentKeyboardHandleOptionSystem： 当唤起键盘的输入框所在的cell，cell被键盘遮挡时，tableview会自动滚动，表现是系统操作 : textView:intertText -> containScroll:scrollRectToVisible
// WYComponentKeyboardHandleOptionCell  ： 当唤起键盘的输入框所在的cell，cell被键盘遮挡时，tableview会自动滚动，保持cell在键盘上面
// WYComponentKeyboardHandleOptionCursor： 当唤起键盘的输入框所在的cell，光标所在行被键盘遮挡时，tableview会自动滚动，保持该行在键盘上面
@property (nonatomic, assign) WYComponentInputHandleOption inputHandleOption;

// 当inputHandleOption == WYComponentKeyboardHandleOptionCell 或者 inputHandleOption == WYComponentKeyboardHandleOptionCursor 时生效
// 自动滚动时底部的间距
@property (nonatomic, assign) CGFloat inputBottomMargin;

// 拖拽tableview时收起键盘 默认是NO
@property (nonatomic, assign) BOOL endEditingWhenBeginDragging;

// 点击tableview时收起键盘 默认是YES
@property (nonatomic, assign) BOOL endEditingWhenTouch;
// 当endEditingWhenTouch=YES时，可以传入此回调用于自定义点击不同地方时是否需要收起键盘
@property (nonatomic, copy) BOOL(^customEndEditingWhenTouchBlock)(UITouch *touchInTableView);

// 大神因为冲动的设置了一些estimated属性，因此加个变量干掉
@property (nonatomic, assign) BOOL disableTableEstimatedType;

// 大神喜欢自己layout tableview一把
@property (nonatomic, assign) BOOL ignoreLayoutTableView;

// cellforRow的实现有点问题，如果触发MemoryWarning，cell会被移掉；默认是NO
@property (nonatomic, assign) BOOL ignoreMemoryWarning;

//禁止tableview setContentOffset，默认是NO（临时解决通过openPopupAnimated弹出的controller，会在presentViewController之后tableview乱滚动的问题）
@property (nonatomic, assign) BOOL disableTableViewSetContentOffset;

// 禁止自动deselectRow 由子类自行管理 default = NO
@property (nonatomic, assign) BOOL disableAutoDeselectRow;

// 默认是UITableViewStylePlain
- (UITableViewStyle)tableViewStyle;

// 根据WYComponentTableItem的filterID查询对应的WYComponentTableItem，循环查效率低
- (NSArray<__kindof WYComponentTableItem *> *)getEasyTableItemsWithfilterID:(NSString *)filterID;

@end

NS_ASSUME_NONNULL_END
