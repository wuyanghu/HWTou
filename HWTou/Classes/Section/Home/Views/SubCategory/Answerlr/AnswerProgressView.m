//
//  AnswerProgressView.m
//  HWTou
//
//  Created by robinson on 2018/2/7.
//  Copyright © 2018年 LieMi. All rights reserved.
//

#import "AnswerProgressView.h"
#import "PublicHeader.h"

@interface AnswerProgressView()
{
    CGFloat viewHeight;
}
@property (nonatomic,strong)CALayer *progressLayer;

@end

@implementation AnswerProgressView

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

- (void)awakeFromNib{
    [super awakeFromNib];
    
    
    viewHeight = self.frame.size.height;
    //储存当前view的宽度值
    
    self.progressLayer = [CALayer layer];
    self.backgroundColor = [UIColor clearColor];
    [self.layer addSublayer:self.progressLayer];
    
    self.progressLayer.frame = CGRectMake(0, 0,self.frame.size.width, viewHeight);
    
}


#pragma mark - 重写setter,getter方法

@synthesize progress = _progress;
- (void)setProgress:(CGFloat)progress {
    _progress = progress;
    
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    
    if (progress <= 0) {
        self.progressLayer.frame = CGRectMake(0, 0, 0, viewHeight);
    }else if (progress <= 1){
        //        进度 * 总宽度 得到对应的宽度
        self.progressLayer.frame = CGRectMake(0, 0, self.frame.size.width * progress, viewHeight);
    }else{
        self.progressLayer.frame = CGRectMake(0, 0, self.frame.size.width, viewHeight);
    }
    
    [CATransaction commit];
    
    
}

- (CGFloat)progress {
    return _progress;
}

@synthesize progressColor = _progressColor;
- (void)setProgressColor:(UIColor *)progressColor {
    _progressColor = progressColor;
    self.progressLayer.backgroundColor = progressColor.CGColor;
    
    self.layer.borderWidth = 2;
    self.layer.borderColor = [progressColor CGColor];
}

- (UIColor *)progressColor {
    return _progressColor;
}

@end
