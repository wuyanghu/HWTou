//
//  HUDProgressTool.h
//
//  Created by PP on 15/12/8.
//  Copyright (c) 2016年 LieMi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HUDProgressTool : NSObject

/**
 *  @brief  指示器类型的HUD提示
 *
 *  @param  text   文字描述
 *  @param  inView 显示的view
 */
+ (void)showIndicatorWithText:(NSString *)text inView:(UIView *)inView;
+ (void)showIndicatorWithText:(NSString *)text;

/**
 *  @brief  成功类型的HUD提示
 *
 *  @param  text   文字描述
 *  @param  inView 显示的view
 */
+ (void)showSuccessWithText:(NSString *)text inView:(UIView *)inView;
+ (void)showSuccessWithText:(NSString *)text;

/**
 *  @brief  错误类型的HUD提示
 *
 *  @param  text   文字描述
 *  @param  inView 显示的view
 */
+ (void)showErrorWithText:(NSString *)text inView:(UIView *)inView;
+ (void)showErrorWithText:(NSString *)text;

/**
 *  @brief  只有文字类型的HUD提示
 *
 *  @param  text   文字描述
 *  @param  inView 显示的view
 */
+ (void)showOnlyText:(NSString *)text inView:(UIView *)inView;
+ (void)showOnlyText:(NSString *)text;

/**
 *  @brief 隐藏HUD显示
 *
 *  @param view 从view中移除
 *  @param animated 是否带动画
 */
+ (void)dismissFormView:(UIView *)view animated:(BOOL)animated;
+ (void)dismiss;

@end
