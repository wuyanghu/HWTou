//
//  UIView+Extension.h
//
//  Created by PP on 15/11/4.
//  Copyright (c) 2016年 PP. All rights reserved.
//
//  提供UIView分类, 主要有以下功能:
//  1. 设置视图圆角
//  2. 获取当前view所属的Controller

#import <UIKit/UIKit.h>

@interface UIView (Extension)

/**
 *  @brief  设置视图圆角
 *
 *  @param corner 角度值
 */
- (void)setRoundWithCorner:(CGFloat)corner;

/**
 *  @brief  获取当前view所在的控制器对象
 *
 *  @return 返回当前view所在的控制器对象
 */
- (UIViewController *)viewController;

@end
