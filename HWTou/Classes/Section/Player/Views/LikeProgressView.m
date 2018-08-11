//
//  WJProgressView.m
//  test2
//
//  Created by robinson on 2018/1/24.
//  Copyright © 2018年 robinson. All rights reserved.
//

#import "LikeProgressView.h"
#import "PublicHeader.h"

@interface LikeProgressView ()
{
    CGFloat viewHeight;
}
@property (nonatomic,strong)CALayer *progressLayer;

@end

@implementation LikeProgressView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)awakeFromNib{
    [super awakeFromNib];
    viewHeight = 28;
    //储存当前view的宽度值
    
    self.progressLayer = [CALayer layer];
    self.backgroundColor = [UIColor clearColor];
    self.progressLayer.backgroundColor = UIColorFromHex(0xFFE7B9).CGColor;
    [self.layer addSublayer:self.progressLayer];
    
    self.progressLayer.frame = CGRectMake(self.frame.size.width, 0, 0, viewHeight);
    
}


#pragma mark - 重写setter,getter方法

@synthesize progress = _progress;
- (void)setProgress:(CGFloat)progress {
    _progress = progress;
    
    [CATransaction begin];
    [CATransaction setDisableActions:NO];
    
    if (progress <= 0) {
        self.progressLayer.frame = CGRectMake(self.frame.size.width, 0, 0, viewHeight);
    }else if (progress <= 1){
        //        进度 * 总宽度 得到对应的宽度
        self.progressLayer.frame = CGRectMake(self.frame.size.width, 0, -self.frame.size.width * progress, viewHeight);
    }else{
        self.progressLayer.frame = CGRectMake(self.frame.size.width, 0, self.frame.size.width, viewHeight);
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
}

- (UIColor *)progressColor {
    return _progressColor;
}

@end
