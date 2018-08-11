//
//  RegularExTool.h
//
//  Created by PP on 16/7/12.
//  Copyright (c) 2016年 LieMi. All rights reserved.
//

#import <Foundation/Foundation.h>

#define HINTNickName @"仅支持数字/汉字/字母/下划线；4-20个字符；"
#define HINTSign @"最多输入一百个字"

@interface RegularExTool : NSObject

//昵称 4-20个字符，包含汉字，字母，下划线
+ (BOOL)validateNickName:(NSString *)nickName;
//签名
+ (BOOL)validateSign:(NSString *)sign;
#pragma mark - 常用且固定类型的正则表达式
/**
 *  @brief  校验手机号码
 *
 *  @param  mobile 手机号字符串
 *
 *  @return YES:符合条件 NO:不符合条件
 */
+ (BOOL)validateMobile:(NSString *)mobile;

/**
 *  @brief  校验邮箱
 *
 *  @param  email 邮箱字符串
 *
 *  @return YES:符合条件 NO:不符合条件
 */
+ (BOOL)validateEmail:(NSString *)email;

/**
 *  @brief  校验车牌号
 *
 *  @param  carNo 车牌号字符串
 *
 *  @return YES:符合条件 NO:不符合条件
 */
+ (BOOL)validateCarNo:(NSString *)carNo;

/**
 *  @brief  校验身份证号
 *
 *  @param  identityCard 身份证号字符串
 *
 *  @return YES:符合条件 NO:不符合条件
 */
+ (BOOL)validateIdentityCard: (NSString *)identityCard;

/**
 *  @brief  校验IP地址
 *
 *  @param  ipAddress IP地址字符串
 *
 *  @return YES:符合条件 NO:不符合条件
 */
+ (BOOL)validateIPAddress:(NSString *)ipAddress;

/**
 *  @brief  校验端口号
 *
 *  @param  port 端口号字符串
 *
 *  @return YES:符合条件 NO:不符合条件
 */
+ (BOOL)validatePort:(NSString *)port;

/**
 *  @brief  校验是否只包含数字或字母(不能输入特殊字符)
 *
 *  @param  input 输入字符串
 *
 *  @return YES:符合条件 NO:不符合条件
 */
+ (BOOL)validateLetterOrNumber:(NSString *)input;

/**
 *  @brief  校验是否只包含数字
 *
 *  @param  input 输入字符串
 *
 *  @return YES:符合条件 NO:不符合条件
 */
+ (BOOL)validateOnlyIsNumber:(NSString *)input;

/**
 *  @brief  校验是否只包含字母
 *
 *  @param  input 输入字符串
 *
 *  @return YES:符合条件 NO:不符合条件
 */
+ (BOOL)validateOnlyIsLetter:(NSString *)input;

/**
 *  @brief  验证输入的密码是否符合标准 (6位以上的数字和字母组成)
 *
 *  @param  input 输入字符串
 *
 *  @return YES:符合条件 NO:不符合条件
 */
+ (BOOL)validatePassWord:(NSString *)input;

@end
