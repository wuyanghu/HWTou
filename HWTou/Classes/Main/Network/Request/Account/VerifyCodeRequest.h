//
//  VerifyCodeRequest.h
//  HWTou
//
//  Created by 彭鹏 on 16/8/13.
//  Copyright © 2016年 LieMi. All rights reserved.
//

#import "BaseRequest.h"
#import "BaseResponse.h"

#pragma mark - 请求参数
@interface VerifyCodeParam : NSObject

@property (nonatomic, strong) NSString *phone;

@end

@interface CodeValidImageParam:NSObject

@property (nonatomic, strong) NSData * imageData;//验证码二进制
@property (nonatomic,copy) NSString * codeImage;//验证码值

@end

@interface SMSCodeParam : VerifyCodeParam

@property (nonatomic, strong) NSString *md_protect; // 数据保护方法：MD5（手机号+图片验证码）

@end

@interface VerifyPhoneCodeParam : VerifyCodeParam

@property (nonatomic, strong) NSString * smsCode;

@end

#pragma mark - 请求执行
@interface VerifyCodeRequest : BaseRequest
/**
 *  @brief 发送注册短信验证码
 *
 *  @param param    VerifyCodeParam
 *  @param success  请求成功回调的block
 *  @param failure  请求失败回调的block
 *
 */
+ (void)singupWithParam:(SMSCodeParam *)param
                success:(void (^)(BaseResponse *response))success
                failure:(void (^)(NSError *error))failure;

/**
 *  @brief 发送找回密码短信验证码
 *
 *  @param param    VerifyCodeParam
 *  @param success  请求成功回调的block
 *  @param failure  请求失败回调的block
 *
 */
+ (void)forgetPWWithParam:(SMSCodeParam *)param
                  success:(void (^)(BaseResponse *response))success
                  failure:(void (^)(NSError *error))failure;

/**
 *  @brief 发送绑定手机短信验证码
 *
 *  @param param    VerifyCodeParam
 *  @param success  请求成功回调的block
 *  @param failure  请求失败回调的block
 *
 */
+ (void)bindingPhoneWithParam:(SMSCodeParam *)param
                      success:(void (^)(BaseResponse *response))success
                      failure:(void (^)(NSError *error))failure;

/**
 *  @brief 验证手机短信验证码
 *
 *  @param param    VerifyPhoneCodeParam
 *  @param success  请求成功回调的block
 *  @param failure  请求失败回调的block
 *
 */
+ (void)verifyPhoneCodeWithParam:(VerifyPhoneCodeParam *)param
                         success:(void (^)(BaseResponse *response))success
                         failure:(void (^)(NSError *error))failure;


// 图片验证码获取接口
+ (void)imgCodeWithParam:(VerifyCodeParam *)param
                 success:(void (^)(BaseResponse *response))success
                 failure:(void (^)(NSError *error))failure;
@end

//图片验证码
@interface CodeValidImageRequest : BaseRequest

+ (void)getCodeValidImageWithParam:(void (^) (CodeValidImageParam *response))success
                     failure:(void (^) (NSError *error))failure;

@end
