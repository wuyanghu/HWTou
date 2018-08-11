//
//  ModifyPWRequest.m
//  HWTou
//
//  Created by LeoSteve on 16/8/21.
//  Copyright © 2016年 LieMi. All rights reserved.
//  

#import "ModifyPWRequest.h"


#pragma mark - 请求响应
@implementation ModifyPWResponse

@end

#pragma mark - 请求参数
@implementation ModifyPWParam

@end

#pragma mark - 请求执行
@implementation ModifyPWRequest

+ (NSString *)requestServerHost{
    return kApiUserServerHost;
}

+ (NSString *)requestApiPath
{
    return @"user/findPwd";
}

+ (HttpRequestMethod)requestMethod
{
    return HttpRequestMethodPost;
}

+ (void)modifyPWWithParam:(ModifyPWParam *)param
                  success:(void (^)(ModifyPWResponse *))success
                  failure:(void (^)(NSError *))failure
{
    [self requestWithParam:param responseClass:[ModifyPWResponse class] success:success failure:failure];
}

@end
