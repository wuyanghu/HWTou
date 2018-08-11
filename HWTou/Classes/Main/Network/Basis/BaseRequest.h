//
//  BaseRequest.h
//
//  Created by PP on 15/11/3.
//  Copyright (c) 2016年 PP. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "InterfaceDefine.h"

@class FileUploadBody;

/**
 *  @brief HTTP请求成功回调的block
 *  @param result 请求结果(字典已转成resultClass模型)
 */
typedef void (^RequestSuccessBlock)(id result);

/**
 *  @brief HTTP请求失败回调的block
 *  @param error 错误对象
 */
typedef void (^RequestFailureBlock)(NSError *error);

@interface BaseRequest : NSObject

/**
 *  @brief  HTTP请求
 *
 *  @param param       参数模型
 *  @param response    请求响应模型类
 *  @param success     请求成功回调的block
 *  @param failure     请求失败回调的block
 */
+ (NSURLSessionTask *)requestWithParam:(id)param
                      responseClass:(Class)response
                      success:(RequestSuccessBlock)success
                      failure:(RequestFailureBlock)failure;

/**
 *  @brief  Http请求服务器地址
 *
 *  @return 服务器主机地址
 */
+ (NSString *)requestServerHost;

/**
 *  @brief  API具体路径(子类不能为空,必须填写)
 *
 *  @return API具体路径
 */
+ (NSString *)requestApiPath;

/**
 *  @brief  Http请求方法,默认为GET
 *
 *  @return 请求方法类型
 */
+ (HttpRequestMethod)requestMethod;

/**
 *  @brief  请求内容的数据类型(默认为二进制UTF-8)
 *
 *  @return 请求内容类型
 */
+ (HttpRequestSerializerType)requestSerializerType;

/**
 *  @brief  响应可接受的数据类型(默认为JSON)
 *
 *  @return 数据响应类型
 */
+ (HttpResponseSerializerType)responseSerializerType;

/**
 *  @brief  设置请求头信息
 *
 *  @return 请求头字典(key:value)
 */
+ (NSDictionary *)setRequestHeader;

/**
 *  @brief  请求超时时间, 默认为10秒
 *
 *  @return 超时时间
 */
+ (NSTimeInterval)timeoutInterval;

/**
 *  @brief  配置文件上传参数
 *
 *  @return 文件参数
 */
+ (NSArray<FileUploadBody *> *)fileUploadBody;


//+ (void)requestToken

/**
 * @brief 获取公共参数
 *
 * @return 参数信息
 */
+ (NSMutableDictionary *)getTheCommonDeviceEnvironment;

@end
