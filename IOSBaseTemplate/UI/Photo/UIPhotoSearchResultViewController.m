//
//  UIPhotoSearchResultViewController.m
//  IOSBaseTemplate
//
//  Created by WYStudio on 21/2/22.
//  Copyright (c) 2021年 WYStudio. All rights reserved.
//

#import "UIPhotoSearchResultViewController.h"
#import "PhotoSimilarTableViewCell.h"
#import "PhotoNomalTableViewCell.h"
#import "PhotoTypeModel.h"
#import "DataManger.h"

#import <EventKit/EventKit.h>

@interface UIPhotoSearchResultViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) QMUIButton *clearBtn;

@end


//-----------------------------------------------------------
@implementation UIPhotoSearchResultViewController

- (void)loadView {
    [super loadView];
    
    self.title = @"相册清理";
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:(UITableViewStyleGrouped)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.showsVerticalScrollIndicator = YES;
    if (@available(iOS 11.0, *)) {
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
    }
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tableView registerClass:PhotoSimilarTableViewCell.class forCellReuseIdentifier:@"PhotoSimilarTableViewCell"];
    [_tableView registerClass:PhotoNomalTableViewCell.class forCellReuseIdentifier:@"PhotoNomalTableViewCell"];
    [self.view addSubview:self.tableView];
    
    self.clearBtn = [[QMUIButton alloc] qmui_initWithImage:UIImageMake(@"action_button_normal") title:nil];
    _clearBtn.frame =CGRectMake(0, 0, _size_W_S_X(155), _size_W_S_X(56));
    [_clearBtn addTarget:self action:@selector(cleareBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_clearBtn];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    _clearBtn.qmui_left = (self.view.qmui_width - _clearBtn.qmui_width) / 2.0;
    _clearBtn.qmui_bottom = self.view.qmui_height - _size_H_S_X(40);
    
    _tableView.frame = CGRectMake(0, self.navigationController.navigationBar.qmui_bottom, self.view.qmui_width, _clearBtn.qmui_top - self.navigationController.navigationBar.qmui_bottom - _size_H_S_X(20));
}

#pragma mark - Action
- (void)cleareBtnClick:(id) btn{
    NSMutableArray<PHAsset *> *assetArray = [NSMutableArray<PHAsset *> array];
    for(PhotoTypeModel *typeModel in self.dataArray) {
        for(PhotoContentModel *contentModel in typeModel.content) {
            for(SiglePhotoModel *photos in contentModel.photos) {
                if(photos.isSelect) {
                    [assetArray addObject:photos.asset];
                }
            }
        }
    }
    
    if(assetArray.count) {
        [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
            [PHAssetChangeRequest deleteAssets:assetArray];
        } completionHandler:^(BOOL success, NSError *error) {
            NSLog(@"Error: %@", error);
        }];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - tableview

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.dataArray[section].isExpand) {
        return [self.dataArray[section].content count];
    }
    
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 50.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.qmui_width, 50)];
    headView.backgroundColor = [UIColor clearColor];
    
    UIControl *backView = [[UIControl alloc] initWithFrame:CGRectMake(15, 0, tableView.qmui_width - 30, headView.qmui_height)];
    backView.tag = 1000 + section;
    backView.backgroundColor = [UIColor clearColor];
    [backView addTarget:self action:@selector(didClickedSection:) forControlEvents:(UIControlEventTouchUpInside)];
    [headView addSubview:backView];
    
    UIImageView *turnImageView = [[UIImageView alloc] initWithFrame:CGRectMake(tableView.qmui_width - 50, 21, 12, 7)];
    turnImageView.image = [[UIImage imageNamed:@"fb_bottom"] imageWithRenderingMode:1];
    [backView addSubview:turnImageView];
    
    UILabel *titlelabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, tableView.qmui_width - 60, 50)];
    [backView addSubview:titlelabel];
    titlelabel.textColor = [UIColor blackColor];
    titlelabel.text = [NSString stringWithFormat:@"%ld、%@",section + 1, self.dataArray[section].title];
    titlelabel.numberOfLines = 0;
    turnImageView.image = UIImageMake(self.dataArray[section].isExpand ? @"fb_top" : @"fb_bottom");
    
    return headView;
}

- (void)didClickedSection:(UIControl *)view{
    NSInteger i = view.tag - 1000;
    self.dataArray[i].isExpand = !self.dataArray[i].isExpand;
    NSIndexSet *index = [NSIndexSet indexSetWithIndex:i];
    [_tableView reloadSections:index withRowAnimation:UITableViewRowAnimationFade];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    PhotoTypeModel *typeModel = (PhotoTypeModel *)(self.dataArray[indexPath.section]);
    
    if(PhotoTypeModelSimilar == typeModel.type) {
        PhotoSimilarTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PhotoSimilarTableViewCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.childModel = self.dataArray[indexPath.section].content[indexPath.row];
        cell.horizontalLine.hidden = YES;
        
        if(indexPath.section != self.dataArray.count - 1 && indexPath.row == self.dataArray[indexPath.section].content.count - 1){
            cell.horizontalLine.hidden = NO;
        }
        return cell;
    }
    
    PhotoNomalTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PhotoNomalTableViewCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.childModel = self.dataArray[indexPath.section].content[indexPath.row];
    cell.horizontalLine.hidden = YES;
    
    if(indexPath.section != self.dataArray.count - 1 && indexPath.row == self.dataArray[indexPath.section].content.count - 1){
        cell.horizontalLine.hidden = NO;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    PhotoTypeModel *typeModel = (PhotoTypeModel *)(self.dataArray[indexPath.section]);
    if(PhotoTypeModelSimilar == typeModel.type) {
        return [PhotoSimilarTableViewCell calculateHeight:typeModel.content[indexPath.row]];
    }
    
    return [PhotoNomalTableViewCell calculateHeight:typeModel.content[indexPath.row]];
}

#pragma QMUICustomNavigationBarTransitionDelegate

- (nullable UIImage *)navigationBarBackgroundImage {
    return [[UIImage alloc] init];
}

- (nullable UIImage *)navigationBarShadowImage {
    return [[UIImage alloc] init];
}

@end
