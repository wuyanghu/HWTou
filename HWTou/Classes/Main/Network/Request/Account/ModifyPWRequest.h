//
//  ModifyPWRequest.h
//  HWTou
//
//  Created by LeoSteve on 16/8/21.
//  Copyright © 2016年 LieMi. All rights reserved.
//
//  手机找回密码

#import "BaseRequest.h"
#import "BaseResponse.h"

#pragma mark - 请求参数
@interface ModifyPWParam : NSObject

@property (nonatomic, copy) NSString      *phone;
@property (nonatomic, copy) NSString      *nPassword;
@property (nonatomic, copy) NSString      *smsCode;

@end

#pragma mark - 请求响应
@interface ModifyPWResponse : BaseResponse

@end

#pragma mark - 请求执行
@interface ModifyPWRequest : BaseRequest

+ (void)modifyPWWithParam:(ModifyPWParam *)param
                  success:(void (^)(ModifyPWResponse *response))success
                  failure:(void (^)(NSError *error))failure;

@end
