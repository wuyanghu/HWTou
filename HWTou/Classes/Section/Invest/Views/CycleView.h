//
//  CycleView.h
//  HWTou
//
//  Created by 张维扬 on 2017/8/10.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CycleView : UIView
@property (nonatomic, assign) CGFloat cusRadius;        // 圆半径
@property (nonatomic, assign) CGFloat cusLineWidth;     // 线宽
@property (copy, nonatomic) NSString *ratio;          // 百分比
@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) UIColor *foreGroundColor;
@property (nonatomic, strong) UIColor *cusBackGroundColor;
- (void)setEndAngle:(CGFloat)eAngle;
@end
