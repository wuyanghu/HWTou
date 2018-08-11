//
//  ResetPWRequest.h
//  HWTou
//
//  Created by LeoSteve on 16/9/7.
//  Copyright © 2016年 LieMi. All rights reserved.
//  修改密码

#import "BaseParam.h"
#import "BaseRequest.h"
#import "BaseResponse.h"

#pragma mark - 请求参数
@interface ResetPWParam : BaseParam

@property (nonatomic, copy) NSString      *oldPassword;
@property (nonatomic, copy) NSString      *nPassword;

@end

#pragma mark - 请求响应
@interface ResetPWResponse : BaseResponse

@end

#pragma mark - 请求执行
@interface ResetPWRequest : BaseRequest

+ (void)resetPWWithParam:(ResetPWParam *)param
                 success:(void (^)(ResetPWResponse *response))success
                 failure:(void (^)(NSError *error))failure;

@end
