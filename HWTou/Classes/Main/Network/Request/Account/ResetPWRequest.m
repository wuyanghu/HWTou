//
//  ResetPWRequest.m
//  HWTou
//
//  Created by LeoSteve on 16/9/7.
//  Copyright © 2016年 LieMi. All rights reserved.
//

#import "ResetPWRequest.h"


#pragma mark - 请求响应
@implementation ResetPWResponse

@end

#pragma mark - 请求参数
@implementation ResetPWParam

@end

#pragma mark - 请求执行
@implementation ResetPWRequest
+ (NSString *)requestServerHost{
    return kApiUserServerHost;
}

+ (NSString *)requestApiPath{
    
    return @"user/changePwd";
    
}

+ (HttpRequestMethod)requestMethod
{
    return HttpRequestMethodPost;
}

+ (void)resetPWWithParam:(ResetPWParam *)param
                 success:(void (^)(ResetPWResponse *))success
                 failure:(void (^)(NSError *))failure{
    
    [self requestWithParam:param
             responseClass:[ResetPWResponse class]
                   success:success failure:failure];
    
}

@end
