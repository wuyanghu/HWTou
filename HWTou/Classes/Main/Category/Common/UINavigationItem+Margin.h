//
//  UINavigationItem+Margin.h
//  HWTou
//
//  Created by PP on 16/7/27.
//  Copyright (c) 2016年 PP. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationItem (Margin)

/**
 *  @brief [添加|设置]导航栏左边按钮
 *
 *  @param barItem  导航栏按钮
 *  @param space    间距位置: 0: 不调整间距 >0:往右偏移 <0:往左偏移
 */
- (void)addLeftBarButtonItem:(UIBarButtonItem *)barItem fixedSpace:(CGFloat)space;
- (void)setLeftBarButtonItem:(UIBarButtonItem *)barItem fixedSpace:(CGFloat)space;

/**
 *  @brief [添加|设置]导航栏右边按钮
 *
 *  @param barItem  导航栏按钮
 *  @param space    间距位置: 0: 不调整间距 >0:往右偏移 <0:往左偏移
 */
- (void)addRightBarButtonItem:(UIBarButtonItem *)barItem fixedSpace:(CGFloat)space;
- (void)setRightBarButtonItem:(UIBarButtonItem *)barItem fixedSpace:(CGFloat)space;

@end
