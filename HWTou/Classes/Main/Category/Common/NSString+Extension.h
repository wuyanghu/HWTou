//
//  NSString+Extension.h
//
//  Created by PP on 16/5/21.
//  Copyright © 2016年 PP. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Extension)

/**
 *  @brief  转换BGK编码
 *
 *  @return 编码后的字符串
 */
- (NSString *)convertToGBK;

/**
 *  @brief  剔除空格字符
 *
 *  @return 剔除后的字符串
 */
- (NSString *)trimming;

/**
 *  @brief  url特殊字符编码
 *
 *  @return 编码后的字符串
 */
- (NSString *)urlEncode;

/**
 *  @brief 是否包含emoji字符
 *
 *  @return YES:包含 NO:不包含
 */
- (BOOL)isContainEmoji;

@end
