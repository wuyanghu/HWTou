//
//  CycleView.m
//  HWTou
//
//  Created by 张维扬 on 2017/8/10.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "CycleView.h"
#import "PublicHeader.h"
@interface CycleView ()
@property CGFloat startAngle;       // 开始角度
@property (nonatomic, assign) CGFloat endAngle;         // 结束角度
@end

@implementation CycleView

- (UILabel *)label
{
    if (_label == nil) {
        _label = [BasisUITool getLabelWithTextColor:UIColorFromHex(0xfe5850) size:16];
        [self addSubview:_label];
        [_label makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.centerX);
            make.centerY.equalTo(self.centerY);
        }];
    }
    return _label;
}
- (void)drawRect:(CGRect)rect {
    CGFloat bgsAngle = _endAngle;
    CGFloat bgeAngle = _startAngle;
    if (_endAngle == 0 && _startAngle == 0 ) {
        bgsAngle = 0;
        bgeAngle = 360;
    }
    if (_endAngle == 360 && _startAngle == 360) {
        bgsAngle = 0;
        bgeAngle = 360;
    }
    CGFloat centerX = CGRectGetWidth(rect)/2.0;
    CGFloat centerY = CGRectGetHeight(rect)/2.0;
    CGFloat radius = _cusRadius;
    if (radius <= 0) radius = 30;
    
    CGFloat lineWidth = _cusLineWidth;
    if (lineWidth <= 0) lineWidth = 3.0;
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    // 边框圆 -- 背景色
    CGContextSetStrokeColorWithColor(context, _cusBackGroundColor.CGColor);
    CGContextSetLineWidth(context, lineWidth);
    CGContextAddArc(context, centerX, centerY, radius, -M_PI_2, 2*M_PI, NO);
    CGContextDrawPath(context, kCGPathStroke);
    // 边框圆 -- 前景色
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();//获取上下文
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter: CGPointMake( CGRectGetWidth(rect)/2.0 ,  CGRectGetWidth(rect)/2.0 )radius:radius startAngle:-M_PI_2 endAngle:-M_PI_2 + M_PI * 2 * (_endAngle / 100.f) clockwise:YES];
    CGContextSetLineWidth(ctx, _cusLineWidth);
    [_foreGroundColor setStroke];
    CGContextAddPath(ctx, path.CGPath);
    CGContextStrokePath(ctx);
    
}
- (void)setEndAngle:(CGFloat)eAngle
{
    _endAngle = eAngle;
    [self setNeedsDisplay];
}
@end
