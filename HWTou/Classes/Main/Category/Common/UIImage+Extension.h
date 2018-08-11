//
//  UIImage+Extension.h
//
//  Created by PP on 15/7/3.
//  Copyright (c) 2016年 PP. All rights reserved.
//
//  提供图片分类, 主要有以下功能:
//  1.根据颜色值生成图片对象
//  2.自由拉伸图片,保持不变形

#import <UIKit/UIKit.h>

@interface UIImage (Extension)

/**
 *  @brief 通过指定颜色生成图片
 *
 *  @param color 颜色
 *
 *  @return 图片对象
 */
+ (UIImage *)imageWithColor:(UIColor *)color;

/**
 *  @brief  根据图片名返回一张能够自由拉伸的图片
 *
 *  @param name 图片名称
 *
 *  @return 图片对象
 */
+ (UIImage *)resizedImage:(NSString *)name;

@end
