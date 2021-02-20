//
//  WYComponentTableSectionItem.m
//  WYComponentTableView
//
//  Created by WYStudio on 2020/8/28.
//  Copyright © 2020 WYStudio. All rights reserved.
//

#import "WYComponentTableSectionItem.h"

@implementation WYComponentTableSectionItem

- (NSMutableArray<WYComponentTableItem *> *)cellDataSource {
    if (!_cellDataSource) {
        _cellDataSource = [NSMutableArray array];
    }
    return _cellDataSource;
}

@end
