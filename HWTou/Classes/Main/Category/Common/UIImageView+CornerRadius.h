//
//  UIImageView+CornerRadius.h
//
//  Created by 彭鹏 on 2017/6/28.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UIImageView (CornerRadius)

/**
 初始化一个制定角度的圆形控件

 @param cornerRadius 圆角半径
 @param rectCornerType 圆角区域(上下左右)
 @return UIImageView对象
 */
- (instancetype)initWithCornerRadiusAdvance:(CGFloat)cornerRadius rectCornerType:(UIRectCorner)rectCornerType;


/**
 快速初始化一个圆形样式的圆角控件

 @return UIImageView对象
 */
- (instancetype)initWithRoundingRectImageView;

/**
 设置圆角半径

 @param cornerRadius  圆角半径
 @param rectCornerType 圆角区域(上下左右)
 */
- (void)cornerRadiusAdvance:(CGFloat)cornerRadius rectCornerType:(UIRectCorner)rectCornerType;

/**
 快速设置成圆形样式的圆角
 */
- (void)cornerRadiusRoundingRect;

/**
 设置附属边框的颜色和宽度

 @param width 宽度
 @param color 颜色
 */
- (void)attachBorderWidth:(CGFloat)width color:(UIColor *)color;

@end
