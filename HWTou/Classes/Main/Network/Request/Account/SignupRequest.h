//
//  SignupRequest.h
//  HWTou
//
//  Created by PP on 16/7/11.
//  Copyright (c) 2016年 LieMi. All rights reserved.
//  用户注册验证码

#import "BaseRequest.h"
#import "BaseResponse.h"

#pragma mark - 请求参数
@interface SignupParam : NSObject

@property (nonatomic, copy) NSString      *code;//邀请码
@property (nonatomic, copy) NSString      *nickname;//昵称
@property (nonatomic, copy) NSString      *phone;
@property (nonatomic, copy) NSString      *password;
@property (nonatomic, copy) NSString      *phoneType;//手机型号
@property (nonatomic, copy) NSString      *phoneDevice;//手机设备号
@property (nonatomic, assign) NSInteger    smsCode;//短信验证码 （提示用户10分钟之内完成注册）
@property (nonatomic, copy) NSString      *imgCode;//图片验证码
@end

#pragma mark - 请求响应
@interface SignupResponse : BaseResponse

@end

#pragma mark - 请求执行
@interface SignupRequest : BaseRequest

+ (void)signupWithParam:(SignupParam *)param
                success:(void (^)(SignupResponse *response))success
                failure:(void (^)(NSError *error))failure;

@end
