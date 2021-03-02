//
//  UICircularDiagramView.h
//  IOSBaseTemplate
//
//  Created by WYStudio on 2021/2/19.
//


#import <UIKit/UIKit.h>

@interface UICircularDiagramView : UIView

@property (nonatomic, assign) CGFloat progressValue;

- (void)reDraw;

@end
