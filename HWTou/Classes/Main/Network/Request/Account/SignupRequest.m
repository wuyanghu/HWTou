//
//  SignupRequest.m
//  HWTou
//
//  Created by PP on 16/7/11.
//  Copyright (c) 2016年 LieMi. All rights reserved.
//

#import "SignupRequest.h"
#import "SecurityTool.h"
#import "YYModel.h"

#pragma mark - 请求响应
@implementation SignupResponse

@end

#pragma mark - 请求参数
@implementation SignupParam

@end

#pragma mark - 请求执行
@implementation SignupRequest

+ (NSString *)requestServerHost {
    return kApiUserServerHost;
//    return @"http://192.168.11.142:8996";
}

+ (NSString *)requestApiPath{
    
    return @"user/register";
    
}

+ (HttpRequestMethod)requestMethod{
    
    return HttpRequestMethodPost;
    
}

+ (void)signupWithParam:(SignupParam *)param
                success:(void (^)(SignupResponse *))success
                failure:(void (^)(NSError *))failure{
    NSDictionary *paramDict = [param yy_modelToJSONObject];
    paramDict = [SecurityTool getAesDict:paramDict];
    [self requestWithParam:paramDict responseClass:[SignupResponse class] success:success failure:failure];
    
}

@end
