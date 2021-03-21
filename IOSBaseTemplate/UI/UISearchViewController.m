//
//  UISearchViewController.m
//  IOSBaseTemplate
//
//  Created by WYStudio on 2021/2/19.
//

#import "UISearchViewController.h"
#import "UICalendarSearchResultViewController.h"
#import "UIPhotoSearchResultViewController.h"
#import "UICircularDiagramView.h"
#import "CalendarTypeModel.h"
#import "CalendarContentModel.h"
#import "PhotoTypeModel.h"
#import "DataManger.h"
#import "PhotoAnalysis.h"

#define animationMinTime 5

@interface UISearchViewController ()

@property(nonatomic, strong) UICircularDiagramView *circularDiagramView;
@property(nonatomic, strong) UIImageView *centerImageView;
@property(nonatomic, strong) QMUIButton *stopBtn;

@property(nonatomic, strong) UILabel *bigLabel;
@property(nonatomic, strong) UILabel *smallLabel;

@end

//------------------------------------------------
@implementation UISearchViewController

- (void)loadView {
    [super loadView];
    
    self.circularDiagramView = [[UICircularDiagramView alloc] initWithFrame:CGRectMake(0, 0, _size_W_S_X(252), _size_W_S_X(252))];
    [self.view addSubview:_circularDiagramView];
    
    self.stopBtn = [[QMUIButton alloc] qmui_initWithImage:UIImageMake(@"cancel_check") title:nil];
    _stopBtn.frame =CGRectMake(0, 0, _size_W_S_X(155), _size_W_S_X(56));
    [_stopBtn addTarget:self action:@selector(stopBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_stopBtn];
    
    self.centerImageView = [[UIImageView alloc] init];
    _centerImageView.image = UIImageMake(@"broom_easyicon");
    [self.view addSubview:_centerImageView];
    
    self.bigLabel = [[UILabel alloc] init];
    _bigLabel.backgroundColor = [UIColor clearColor];
    _bigLabel.textAlignment = NSTextAlignmentCenter;
    _bigLabel.textColor = [UIColor blackColor];
    _bigLabel.font = [UIFont systemFontOfSize:18 weight:UIFontWeightMedium];
    [self.view addSubview:_bigLabel];
    
    self.smallLabel = [[UILabel alloc] init];
    _smallLabel.backgroundColor = [UIColor clearColor];
    _smallLabel.textAlignment = NSTextAlignmentCenter;
    _smallLabel.font = UIDynamicFontBoldMake(14);
    _smallLabel.textColor = [UIColor qmui_colorWithHexString:@"#9AA5B0"];
    [self.view addSubview:_smallLabel];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"扫描中";
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.circularDiagramView runAnimation:YES];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if(SearchTypeCalendar == self.searchType) {
        [self requestCalendar];
        return;
    }
    
    if(SearchTypePhone == self.searchType) {
        [self requestPhoto];
        return;
    }
    
    if(SearchTypeAICleare == self.searchType) {
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [self.circularDiagramView runAnimation:NO];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    _circularDiagramView.qmui_left = (self.view.qmui_width - _circularDiagramView.qmui_width) / 2.0;
    _circularDiagramView.qmui_top = _size_H_S_X(100);
    [_circularDiagramView reDraw];
    
    [_centerImageView sizeToFit];
    _centerImageView.center = _circularDiagramView.center;
    
    [_bigLabel sizeToFit];
    _bigLabel.frame = CGRectMake(0, _circularDiagramView.qmui_bottom + _size_H_S_X(49), self.view.qmui_width, _bigLabel.qmui_height);
    
    [_smallLabel sizeToFit];
    _smallLabel.frame = CGRectMake(0, _bigLabel.qmui_bottom + _size_H_S_X(12), self.view.qmui_width, _smallLabel.qmui_height);
    
    [_stopBtn sizeToFit];
    _stopBtn.qmui_bottom = self.view.qmui_height - _size_H_S_X(69);
    _stopBtn.qmui_left = (self.view.qmui_width - _stopBtn.qmui_width) / 2.0;
}

- (void)requestCalendar {
    NSTimeInterval begin = [[NSDate date] timeIntervalSince1970];
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if(nil == weakSelf) {
            return;
        }
        [[DataManger shareInstance] getScheduleEvent:^(NSArray *eventArray, NSArray *eventArray2){
            if(0 == eventArray.count + eventArray2.count) {
                dispatch_async(dispatch_get_main_queue(), ^(void){
                    __strong typeof(weakSelf) strongSelf = weakSelf;
                    strongSelf.bigLabel.text = @"没有日程";
                    [strongSelf.circularDiagramView runAnimation:NO];
                    [strongSelf.circularDiagramView setProgressValue:0 start:0];
                    [strongSelf.view setNeedsLayout];
                    [strongSelf.view layoutIfNeeded];
                });
                return;
            }
            
            NSTimeInterval end = [[NSDate date] timeIntervalSince1970];
            if(end - begin >= animationMinTime) {
                dispatch_async(dispatch_get_main_queue(), ^(void){
                    __strong typeof(weakSelf) strongSelf = weakSelf;
                    [strongSelf handelCalendarEvent:eventArray eventArray2:eventArray2];
                });
                return;
            }
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)((animationMinTime - (end - begin)) * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                __strong typeof(weakSelf) strongSelf = weakSelf;
                [strongSelf handelCalendarEvent:eventArray eventArray2:eventArray2];
            });
        }];
    });
}

- (void)handelCalendarEvent:(NSArray *)eventArray eventArray2:(NSArray *)eventArray2 {
    if(0 == eventArray.count && 0 == eventArray2.count) {
        return;
    }
    
    NSMutableArray *dataArray = [NSMutableArray array];
    CalendarTypeModel *overdueCalendarModel = [[CalendarTypeModel alloc] init];
    overdueCalendarModel.isExpand = YES;
    overdueCalendarModel.title = @"过期日程";
    overdueCalendarModel.content = [NSMutableArray array];
    [dataArray addObject:overdueCalendarModel];

    CalendarTypeModel *futureCalendarModel = [[CalendarTypeModel alloc] init];
    futureCalendarModel.isExpand = YES;
    futureCalendarModel.title = @"未来日程";
    futureCalendarModel.content = [NSMutableArray array];
    [dataArray addObject:futureCalendarModel];
    
    for(EKEvent* item in eventArray) {
        CalendarContentModel *cententModel = [[CalendarContentModel alloc] init];
        cententModel.event = item;
        cententModel.isSelect = YES;
        [overdueCalendarModel.content addObject:cententModel];
    }
    
    for(EKEvent* item in eventArray2) {
        CalendarContentModel *cententModel = [[CalendarContentModel alloc] init];
        cententModel.event = item;
        cententModel.isSelect = YES;
        [futureCalendarModel.content addObject:cententModel];
    }
    
    UICalendarSearchResultViewController *vc = [[UICalendarSearchResultViewController alloc] init];
    NSEnumerator *enumerator = [dataArray reverseObjectEnumerator];
      for (CalendarTypeModel *model in enumerator) {
        if(0 == model.content.count) {
          [dataArray removeObject:model];
        }
    }
    vc.dataArray = dataArray;
    
    [self.navigationController qmui_pushViewController:vc animated:YES completion:^(void){
        NSMutableArray *viewControllers = [[NSMutableArray alloc] initWithArray:self.navigationController.viewControllers];
        [viewControllers removeObject:self];
        self.navigationController.viewControllers = viewControllers;
    }];
}

- (void)requestPhoto {
    NSTimeInterval begin = [[NSDate date] timeIntervalSince1970];
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if(nil == weakSelf) {
            return;
        }
        
        [[DataManger shareInstance] getPhotoData:^(NSArray *recentsArray, NSArray *selfiesArray, NSArray *screenshotsArray, NSArray *liveArray){
            if(0 == recentsArray.count) {
                dispatch_async(dispatch_get_main_queue(), ^(void){
                    __strong typeof(weakSelf) strongSelf = weakSelf;
                    strongSelf.bigLabel.text = @"真棒，没有需要清理的图片";
                    [strongSelf.circularDiagramView runAnimation:NO];
                    [strongSelf.circularDiagramView setProgressValue:0 start:0];
                    [strongSelf.view setNeedsLayout];
                    [strongSelf.view layoutIfNeeded];
                });
                return;
            }
            
            NSTimeInterval end = [[NSDate date] timeIntervalSince1970];
            if(end - begin >= animationMinTime) {
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
                    __strong typeof(weakSelf) strongSelf = weakSelf;
                    [strongSelf handelPhotoData:recentsArray selfiesArray:selfiesArray screenshotsArray:screenshotsArray liveArray:liveArray];
                });
                return;
            }
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)((animationMinTime - (end - begin)) * NSEC_PER_SEC)), dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                __strong typeof(weakSelf) strongSelf = weakSelf;
                [strongSelf handelPhotoData:recentsArray selfiesArray:selfiesArray screenshotsArray:screenshotsArray liveArray:liveArray];
            });
        }];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            __block int i = 1;
            self.bigLabel.text = [NSString stringWithFormat:@"步骤：%d/5", 1];
            self.smallLabel.text = @"正在寻找相似照片...";
            [self.view setNeedsLayout];
            [self.view layoutIfNeeded];
            [NSTimer scheduledTimerWithTimeInterval:1
                                                repeats:YES
                                                  block:^(NSTimer * _Nonnull timer) {
                __strong typeof(weakSelf) strongSelf = weakSelf;
                strongSelf.bigLabel.text = [NSString stringWithFormat:@"步骤：%d/5", ++i];
                switch (i) {
                    case 1:
                        strongSelf.smallLabel.text = @"正在寻找相似照片...";
                        break;
                    case 2:
                        strongSelf.smallLabel.text = @"正在寻找模糊照片...";
                        break;
                    case 3:
                        strongSelf.smallLabel.text = @"正在寻找实况图片...";
                        break;
                    case 4:
                        strongSelf.smallLabel.text = @"正在寻找屏幕截图...";
                        break;
                    case 5:
                        strongSelf.smallLabel.text = @"正在寻找连拍自拍照片...";
                        break;
                        
                    default:
                        break;
                }
                
                if(i == 5) {
                    [timer invalidate];
                }
            }];
        });
    });

}

- (void)handelPhotoData:(NSArray *)recentsArray selfiesArray:(NSArray *)selfiesArray screenshotsArray:(NSArray *)screenshotsArray liveArray:(NSArray *)liveArray{
    if(0 == recentsArray.count) {
        return;
    }
    
    PHImageRequestOptions *imageRequestOptions = [[PHImageRequestOptions alloc] init];
    imageRequestOptions.resizeMode = PHImageRequestOptionsResizeModeExact;
    imageRequestOptions.synchronous = YES;
    NSMutableArray<SiglePhotoModel *> *newPhotoArray = [NSMutableArray<SiglePhotoModel *> array];
    [recentsArray enumerateObjectsUsingBlock:^(PHAsset *asset, NSUInteger idx, BOOL * _Nonnull stop) {
        [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:CGSizeMake(300, 300) contentMode:PHImageContentModeDefault options:imageRequestOptions resultHandler:^(UIImage * _Nullable image, NSDictionary * _Nullable info) {
            SiglePhotoModel *sigPhotoModel = [[SiglePhotoModel alloc] init];
            sigPhotoModel.asset = asset;
            sigPhotoModel.image = image;
            [newPhotoArray addObject:sigPhotoModel];
        }];
    }];
    
    NSMutableArray *dataArray = [NSMutableArray array];
    //--------------------
    PhotoTypeModel *fuzzyPhotoModel = [[PhotoTypeModel alloc] init];
    fuzzyPhotoModel.isExpand = YES;
    fuzzyPhotoModel.title = @"模糊图片";
    fuzzyPhotoModel.type = PhotoTypeModelFuzzy;
    fuzzyPhotoModel.content = [NSMutableArray array];
    [dataArray addObject:fuzzyPhotoModel];

    NSMutableArray<SiglePhotoModel *> *temPhotoArray = [NSMutableArray<SiglePhotoModel *> array];
    NSEnumerator *enumerator = [newPhotoArray reverseObjectEnumerator];
    for(SiglePhotoModel *siglePhotoModel in enumerator) {
        if([PhotoAnalysis checkBlurryWihtImage:siglePhotoModel.image]) {
            siglePhotoModel.isSelect = YES;
            [temPhotoArray addObject:siglePhotoModel];
            [newPhotoArray removeObject:siglePhotoModel];
        }
    }
    
    if(temPhotoArray.count) {
        PhotoContentModel *photoContentModel = [[PhotoContentModel alloc] init];
        photoContentModel.photos = temPhotoArray;
        [fuzzyPhotoModel.content addObject:photoContentModel];
    }

    //--------------------
    PhotoTypeModel *similarPhotoModel = [[PhotoTypeModel alloc] init];
    similarPhotoModel.isExpand = YES;
    similarPhotoModel.title = @"相似图片";
    similarPhotoModel.type = PhotoTypeModelSimilar;
    similarPhotoModel.content = [NSMutableArray array];
    [dataArray addObject:similarPhotoModel];

    if(newPhotoArray.count > 1) {
        NSMutableArray<SiglePhotoModel *> *temPhotoArray = [NSMutableArray<SiglePhotoModel *> array];
        SiglePhotoModel *first = newPhotoArray[0];
        for(int index = 1; index < newPhotoArray.count; index++) {
            SiglePhotoModel *second = newPhotoArray[index];
            if(temPhotoArray.count < 5 && [PhotoAnalysis checkSimilarityImage:first.image secondImage:second.image]) {
                if(temPhotoArray.count) {
                    [temPhotoArray addObject:second];
                }else {
                    [temPhotoArray addObject:first];
                    [temPhotoArray addObject:second];
                }
                second.isSelect = YES;
                continue;;
            }

            first = second;
            if(temPhotoArray.count) {
                PhotoContentModel *photoContentModel = [[PhotoContentModel alloc] init];
                photoContentModel.photos = [[NSArray alloc] initWithArray:temPhotoArray];
                temPhotoArray = [NSMutableArray<SiglePhotoModel *> array];
                [similarPhotoModel.content addObject:photoContentModel];
                [temPhotoArray removeAllObjects];
            }
        }
        
        if(temPhotoArray.count) {
            PhotoContentModel *photoContentModel = [[PhotoContentModel alloc] init];
            photoContentModel.photos = [[NSArray alloc] initWithArray:temPhotoArray];;
            temPhotoArray = [NSMutableArray<SiglePhotoModel *> array];
            [similarPhotoModel.content addObject:photoContentModel];
        }
    }
    
    //--------------------
    if(selfiesArray.count) {
        NSMutableArray<SiglePhotoModel *> *temPhotoArray = [NSMutableArray<SiglePhotoModel *> array];
        PhotoTypeModel *selfiesPhotoModel = [[PhotoTypeModel alloc] init];
        selfiesPhotoModel.isExpand = YES;
        selfiesPhotoModel.title = @"自拍";
        selfiesPhotoModel.type = PhotoTypeModelSelfies;
        selfiesPhotoModel.content = [NSMutableArray array];
        [dataArray addObject:selfiesPhotoModel];

        [selfiesArray enumerateObjectsUsingBlock:^(PHAsset *asset, NSUInteger idx, BOOL * _Nonnull stop) {
            [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:CGSizeMake(300, 300) contentMode:PHImageContentModeDefault options:imageRequestOptions resultHandler:^(UIImage * _Nullable image, NSDictionary * _Nullable info) {
                SiglePhotoModel *sigPhotoModel = [[SiglePhotoModel alloc] init];
                sigPhotoModel.asset = asset;
                sigPhotoModel.image = image;
                [temPhotoArray addObject:sigPhotoModel];
            }];
        }];
        
        if(temPhotoArray.count) {
            PhotoContentModel *photoContentModel = [[PhotoContentModel alloc] init];
            photoContentModel.photos = temPhotoArray;
            [selfiesPhotoModel.content addObject:photoContentModel];
        }
    }
    
    //--------------------
    if(screenshotsArray.count) {
        NSMutableArray<SiglePhotoModel *> *temPhotoArray = [NSMutableArray<SiglePhotoModel *> array];
        PhotoTypeModel *screenshotsPhotoModel = [[PhotoTypeModel alloc] init];
        screenshotsPhotoModel.isExpand = YES;
        screenshotsPhotoModel.title = @"截屏";
        screenshotsPhotoModel.type = PhotoTypeModelScreenshotsArray;
        screenshotsPhotoModel.content = [NSMutableArray array];
        [dataArray addObject:screenshotsPhotoModel];

        [screenshotsArray enumerateObjectsUsingBlock:^(PHAsset *asset, NSUInteger idx, BOOL * _Nonnull stop) {
            [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:CGSizeMake(300, 300) contentMode:PHImageContentModeDefault options:imageRequestOptions resultHandler:^(UIImage * _Nullable image, NSDictionary * _Nullable info) {
                SiglePhotoModel *sigPhotoModel = [[SiglePhotoModel alloc] init];
                sigPhotoModel.asset = asset;
                sigPhotoModel.image = image;
                [temPhotoArray addObject:sigPhotoModel];
            }];
        }];
        
        if(temPhotoArray.count) {
            PhotoContentModel *photoContentModel = [[PhotoContentModel alloc] init];
            photoContentModel.photos = temPhotoArray;
            [screenshotsPhotoModel.content addObject:photoContentModel];
        }
    }
    
    //--------------------
    if(liveArray.count) {
        NSMutableArray<SiglePhotoModel *> *temPhotoArray = [NSMutableArray<SiglePhotoModel *> array];
        PhotoTypeModel *liveModel = [[PhotoTypeModel alloc] init];
        liveModel.isExpand = YES;
        liveModel.title = @"实况";
        liveModel.type = PhotoTypeModelLiveArray;
        liveModel.content = [NSMutableArray array];
        [dataArray addObject:liveModel];

        [liveArray enumerateObjectsUsingBlock:^(PHAsset *asset, NSUInteger idx, BOOL * _Nonnull stop) {
            [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:CGSizeMake(300, 300) contentMode:PHImageContentModeDefault options:imageRequestOptions resultHandler:^(UIImage * _Nullable image, NSDictionary * _Nullable info) {
                SiglePhotoModel *sigPhotoModel = [[SiglePhotoModel alloc] init];
                sigPhotoModel.asset = asset;
                sigPhotoModel.image = image;
                [temPhotoArray addObject:sigPhotoModel];
            }];
        }];
        
        if(temPhotoArray.count) {
            PhotoContentModel *photoContentModel = [[PhotoContentModel alloc] init];
            photoContentModel.photos = temPhotoArray;
            [liveModel.content addObject:photoContentModel];
        }
    }

    //清理空cell
    enumerator = [dataArray reverseObjectEnumerator];
    for(PhotoTypeModel *typeModel in enumerator) {
        if(0 == typeModel.content.count) {
            [dataArray removeObject:typeModel];
        }
    }
    
    //------------
    dispatch_async(dispatch_get_main_queue(), ^(void){
        UIPhotoSearchResultViewController *vc = [[UIPhotoSearchResultViewController alloc] init];
        vc.dataArray = dataArray;
        [self.navigationController qmui_pushViewController:vc animated:YES completion:^(void){
            NSMutableArray *viewControllers = [[NSMutableArray alloc] initWithArray:self.navigationController.viewControllers];
            [viewControllers removeObject:self];
            self.navigationController.viewControllers = viewControllers;
        }];
    });
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    return NO;
}

- (void)stopBtnClick:(id)btn {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma QMUICustomNavigationBarTransitionDelegate

- (nullable UIImage *)navigationBarBackgroundImage {
    return [[UIImage alloc] init];
}

- (nullable UIImage *)navigationBarShadowImage {
    return [[UIImage alloc] init];
}

@end
