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

#define animationMinTime 1500

@interface UISearchViewController ()

@property(nonatomic, strong) UICircularDiagramView *circularDiagramView;
@property(nonatomic, strong) UILabel *checkingLabel;

@end

//------------------------------------------------
@implementation UISearchViewController

- (void)loadView {
    [super loadView];
    
    self.circularDiagramView = [[UICircularDiagramView alloc] initWithFrame:CGRectMake(0, 0, _size_W_S_X(252), _size_W_S_X(252))];
    [self.view addSubview:_circularDiagramView];
    
    self.checkingLabel = [[UILabel alloc] init];
    _checkingLabel.backgroundColor = [UIColor clearColor];
    _checkingLabel.textAlignment = NSTextAlignmentCenter;
    _checkingLabel.font = UIDynamicFontBoldMake(16);
    _checkingLabel.text = @"检测中...";
    [self.view addSubview:_checkingLabel];
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
    
    NSTimeInterval begin = [[DataManger shareInstance] getDateTimeTOMilliSeconds:[NSDate date]];
    
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if(nil == weakSelf) {
            return;
        }
        
        if(SearchTypeCalendar == weakSelf.searchType) {
            [[DataManger shareInstance] getScheduleEvent:^(NSArray *eventArray){
                NSTimeInterval end = [[DataManger shareInstance] getDateTimeTOMilliSeconds:[NSDate date]];
                if(end - begin >= animationMinTime) {
                    dispatch_async(dispatch_get_main_queue(), ^(void){
                        __strong typeof(weakSelf) strongSelf = weakSelf;
                        [strongSelf handelCalendarEvent:eventArray];
                    });
                    return;
                }
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)((animationMinTime - (end - begin)) / animationMinTime  * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    __strong typeof(weakSelf) strongSelf = weakSelf;
                    [strongSelf handelCalendarEvent:eventArray];
                });
            }];
            
            return;
        }
        
        if(SearchTypePhone == weakSelf.searchType) {
            [[DataManger shareInstance] getPhotoData:^(NSArray *photoArray){
                __strong typeof(weakSelf) strongSelf = weakSelf;
                [strongSelf handelPhotoData:photoArray];
            }];
            
            return;
        }
        
        if(SearchTypeAICleare == weakSelf.searchType) {
        }
    });
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
    
    [_checkingLabel sizeToFit];
    _checkingLabel.center = _circularDiagramView.center;
}

- (void)handelCalendarEvent:(NSArray *)eventArray {
    if(0 == eventArray.count) {
        return;
    }
    
    NSMutableArray *dataArray = [NSMutableArray array];
    CalendarTypeModel *overdueCalendarModel = [[CalendarTypeModel alloc] init];
    overdueCalendarModel.isExpand = YES;
    overdueCalendarModel.title = @"过期日程";
    overdueCalendarModel.content = [NSMutableArray array];
    [dataArray addObject:overdueCalendarModel];
    
    CalendarTypeModel *fraudCalendarModel = [[CalendarTypeModel alloc] init];
    fraudCalendarModel.isExpand = YES;
    fraudCalendarModel.title = @"诈骗日程";
    fraudCalendarModel.content = [NSMutableArray array];
    [dataArray addObject:fraudCalendarModel];
    
    for(EKEvent* item in eventArray) {
        if(NSOrderedAscending != [[NSDate date] compare:item.endDate]) {
            CalendarContentModel *cententModel = [[CalendarContentModel alloc] init];
            cententModel.event = item;
            cententModel.isSelect = YES;
            [overdueCalendarModel.content addObject:cententModel];
            continue;
        }
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

- (void)handelPhotoData:(NSArray *)phoneArray {
    if(0 == phoneArray.count) {
        return;
    }
    
    PHImageRequestOptions *imageRequestOptions = [[PHImageRequestOptions alloc] init];
    imageRequestOptions.synchronous = YES;
    imageRequestOptions.resizeMode = PHImageRequestOptionsResizeModeExact;
    NSMutableArray<SiglePhotoModel *> *newPhotoArray = [NSMutableArray<SiglePhotoModel *> array];
    [phoneArray enumerateObjectsUsingBlock:^(PHAsset *ssset, NSUInteger idx, BOOL * _Nonnull stop) {
        [[PHImageManager defaultManager] requestImageForAsset:ssset targetSize:PHImageManagerMaximumSize contentMode:PHImageContentModeDefault options:imageRequestOptions resultHandler:^(UIImage * _Nullable image, NSDictionary * _Nullable info) {
            SiglePhotoModel *sigPhotoModel = [[SiglePhotoModel alloc] init];
            sigPhotoModel.asset = ssset;
            sigPhotoModel.image = image;
            [newPhotoArray addObject:sigPhotoModel];
        }];
    }];
    
    NSMutableArray *dataArray = [NSMutableArray array];
    PhotoTypeModel *fuzzyPhotoModel = [[PhotoTypeModel alloc] init];
    fuzzyPhotoModel.isExpand = YES;
    fuzzyPhotoModel.title = @"模糊图片";
    fuzzyPhotoModel.type = PhotoTypeModelFuzzy;
    fuzzyPhotoModel.content = [NSMutableArray array];
    [dataArray addObject:fuzzyPhotoModel];

    NSMutableArray<SiglePhotoModel *> *temPhotoArray = [NSMutableArray<SiglePhotoModel *> array];
    PhotoContentModel *photoContentModel = [[PhotoContentModel alloc] init];
    NSEnumerator *enumerator = [newPhotoArray reverseObjectEnumerator];
    for(SiglePhotoModel *siglePhotoModel in enumerator) {
        if([PhotoAnalysis checkBlurryWihtImage:siglePhotoModel.image]) {
            siglePhotoModel.isSelect = YES;
            [temPhotoArray addObject:siglePhotoModel];
            [newPhotoArray removeObject:siglePhotoModel];
        }
    }
    if(temPhotoArray.count) {
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
                photoContentModel.photos = temPhotoArray;
                temPhotoArray = [NSMutableArray<SiglePhotoModel *> array];
                [similarPhotoModel.content addObject:photoContentModel];
                [temPhotoArray removeAllObjects];
            }
        }
        
        if(temPhotoArray.count) {
            PhotoContentModel *photoContentModel = [[PhotoContentModel alloc] init];
            photoContentModel.photos = temPhotoArray;
            temPhotoArray = [NSMutableArray<SiglePhotoModel *> array];
            [similarPhotoModel.content addObject:photoContentModel];
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

#pragma QMUICustomNavigationBarTransitionDelegate

- (nullable UIImage *)navigationBarBackgroundImage {
    return [[UIImage alloc] init];
}

- (nullable UIImage *)navigationBarShadowImage {
    return [[UIImage alloc] init];
}

@end
