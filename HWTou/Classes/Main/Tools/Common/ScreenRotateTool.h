//
//  ScreenRotateTool.h
//
//  Created by PP on 15/8/20.
//  Copyright (c) 2016年 LieMi. All rights reserved.
//
//  屏幕旋转工具类

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ScreenRotateTool : NSObject

/**
 *  @brief  强制切换屏幕方向
 *
 *  @param orientation 方向常量
 */
+ (void)screenRotateForceOrientation:(UIInterfaceOrientation)orientation;

@end
