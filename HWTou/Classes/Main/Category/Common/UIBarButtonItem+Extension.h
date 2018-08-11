//
//  UIBarButtonItem+Extension.h
//
//  Created by PP on 15/10/23.
//  Copyright (c) 2016年 PP. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (Extension)

/**
 *  @brief 创建图片类型的UIBarButtonItem
 *
 *  @param image    正常图片
 *  @param hltImage 高亮图片
 *  @param target   事件响应对象
 *  @param action   事件响应方法
 *
 *  @return UIBarButtonItem对象
 */
+ (UIBarButtonItem *)itemWithImageName:(NSString *)image hltImageName:(NSString *)hltImage target:(id)target action:(SEL)action;

/**
 *  @brief 创建只有文字类型的UIBarButtonItem
 *
 *  @param title        按钮标题
 *  @param textColor    标题字体颜色
 *  @param target       事件响应对象
 *  @param action       事件响应方法
 *
 *  @return UIBarButtonItem对象
 */
+ (UIBarButtonItem *)itemWithTitle:(NSString *)title withColor:(UIColor *)textColor
                            target:(id)target action:(SEL)action;

@end
