//
//  UICircularDiagramView.h
//  IOSBaseTemplate
//
//  Created by WYStudio on 2021/2/19.
//


#import <UIKit/UIKit.h>

@interface UICircularDiagramView : UIView

- (void)setProgressValue:(CGFloat) value start:(CGFloat) startValue;

- (void)reDraw;

- (void)runAnimation:(BOOL) bRun;

@end
