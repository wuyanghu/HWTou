//
//  BaseViewController.h
//
//  Created by PP on 15/7/3.
//  Copyright (c) 2016年 LieMi. All rights reserved.
//
//  所有控制器的基类, 提供派生控制器公共的功能

#import <UIKit/UIKit.h>
#import "UIView+Toast.h"

@interface BaseViewController : UIViewController

/**
 *  @brief  创建UI
 */
- (void)createUI;

/**
 *  @brief  设置背景图片
 *
 *  @param image 背景图
 */
- (void)setBackgroupImage:(UIImage *)image;

@end
