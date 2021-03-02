//
//  UICircularDiagramView.m
//  IOSBaseTemplate
//
//  Created by WYStudio on 2021/2/19.
//


#import "UICircularDiagramView.h"

#define toRad(angle) (angle * M_PI / 180)

@interface UICircularDiagramView ()

@property (nonatomic, assign) CGPoint centerPoint;

@property (nonatomic, assign) CGFloat radius;
@property (nonatomic, assign) CGFloat lineWidth;
@property (nonatomic, assign) CGFloat lineWidth2;

@property (nonatomic, assign) CGFloat pieRadius;
@property (nonatomic, assign) CGFloat pieRadius2;
@property (nonatomic, assign) CGFloat endAngle;

@property (nonatomic, strong) CAShapeLayer *progressLayer;

@end


//----------------------------------------------------------
@implementation UICircularDiagramView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.centerPoint = CGPointMake(frame.size.width/2, frame.size.height/2);
        
        CGFloat kk = _size_W_S_X(5);
        self.radius = frame.size.width/2.0;
        
        CGFloat imageRadius = _size_W_S_X(85);  //内圆半径
        self.lineWidth = self.radius - imageRadius; //黑框宽度
        self.lineWidth2 = self.radius - imageRadius - 2 * kk;
        
        self.pieRadius = imageRadius + self.lineWidth/2.0;
        self.pieRadius2 = imageRadius + kk + self.lineWidth2 / 2.0;
    }
    
    return self;
}

- (void)drawDefaultPie {
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:self.centerPoint radius:self.pieRadius startAngle:0 endAngle:2*M_PI clockwise:YES];
    CAShapeLayer *shapeLayer = [CAShapeLayer new];
    shapeLayer.path = [path CGPath];
    shapeLayer.lineWidth = self.lineWidth;
    shapeLayer.strokeColor = [UIColor blackColor].CGColor;
    shapeLayer.fillColor = [UIColor clearColor].CGColor;
    [self.layer addSublayer:shapeLayer];
}

- (void)drawDefaultPie2 {
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:self.centerPoint radius:self.pieRadius2 startAngle:0 endAngle:2*M_PI clockwise:YES];
    CAShapeLayer *shapeLayer = [CAShapeLayer new];
    shapeLayer.path = [path CGPath];
    shapeLayer.lineWidth = self.lineWidth2;
    shapeLayer.strokeColor = [UIColor qmui_colorWithHexString:@"#DDF5EF"].CGColor;
    shapeLayer.fillColor = [UIColor clearColor].CGColor;
    [self.layer addSublayer:shapeLayer];
}

- (void)reDraw {
    [self removeAllSubLayers];
    
    [self drawDefaultPie];
    
    [self drawDefaultPie2];

    [self drawProgress];
}

- (void)removeAllSubLayers {
    NSArray * subviews = [NSArray arrayWithArray:self.subviews];
    for (UIView * view in subviews) {
        [view removeFromSuperview];
    }

    NSArray * subLayers = [NSArray arrayWithArray:self.layer.sublayers];
    for (CALayer * layer in subLayers) {
        [layer removeAllAnimations];
        [layer removeFromSuperlayer];
    }
}

- (void)drawProgress {
    if(_progressLayer) {
        [_progressLayer removeFromSuperlayer];
    }
    
    self.progressLayer = [CAShapeLayer new];
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:self.centerPoint radius:self.pieRadius2 startAngle:toRad(90) endAngle:toRad(90) + self.endAngle  clockwise:YES];
    _progressLayer.path = [path CGPath];
    _progressLayer.lineWidth = self.lineWidth2;
    _progressLayer.strokeColor = [UIColor qmui_colorWithHexString:@"#00A784"].CGColor;
    _progressLayer.fillColor = [UIColor clearColor].CGColor;
    
    [self.layer addSublayer:_progressLayer];
}

- (void)setProgressValue:(CGFloat)progressValue {
    _progressValue = progressValue;
    self.endAngle = progressValue * 2 * M_PI;
    
    [self drawProgress];
}

@end

