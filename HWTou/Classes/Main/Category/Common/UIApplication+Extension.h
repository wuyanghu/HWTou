//
//  UIApplication+Extension.h
//
//  Created by PP on 16/1/6.
//  Copyright (c) 2016年 PP. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIApplication (Extension)

/**
 *  @brief  获取应用程序主窗口
 *
 *  @return 主窗口
 */
+ (UIWindow *)keyWindow;

/**
 *  @brief  获取应用程序第一个窗口
 *
 *  @return 第一个窗口
 */
+ (UIWindow *)firstWindow;

/**
 *  @brief  获取当前最顶部显示的viewController
 *
 *  @return viewController
 */
+ (UIViewController *)topViewController;

@end
