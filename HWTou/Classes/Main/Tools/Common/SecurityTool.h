//
//  SecurityTool.h
//
//  Created by 彭鹏 on 14-9-20.
//  Copyright (c) 2014年 PP. All rights reserved.
//
//  加密、解密 安全工具类
//  1. MD5加密
//  2. AES加解密

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, MD5EncodeType)
{
    MD5EncodeType16Lowercase,           // 16位小写
    MD5EncodeType16Capital,             // 16位大写
    MD5EncodeType32Lowercase,           // 32位小写
    MD5EncodeType32Capital,             // 32位大写
};

@interface SecurityTool : NSObject

/**
 *  @brief  MD5加密一段字符串
 *
 *  @param input      输入加密字符串
 *  @param encodeType 加密类型
 *
 *  @return MD5加密后的字符串
 */
+ (NSString *)md5Encode:(NSString *)input encodeType:(MD5EncodeType)encodeType;

/**
 *  @brief  AES加密一段字符串
 *
 *  @param input     输入加密字符串
 *  @param secretKey 密钥
 *
 *  @return AES加密后的字符串
 */
+ (NSString *)aesEncode:(NSString *)input secretKey:(NSString *)secretKey;

/**
 *  @brief  解密一段AES加密过的字符串
 *
 *  @param input     输入需要解密的字符串
 *  @param secretKey 密钥
 *
 *  @return AES解密后的字符串
 */
+ (NSString *)aesDecode:(NSString *)input secretKey:(NSString *)secretKey;

/**
 *  @brief SHA256加密算法
 *
 *  @param input 输入加密字符串
 *
 *  @return 加密后的字符串
 */
+ (NSString *)sha256Encode:(NSString *)input;
//字典转json字符串方法
+ (NSString *)convertToJsonData:(NSDictionary *)dict;
+ (NSDictionary *)getAesDict:(NSDictionary *)paramsDict;
@end
