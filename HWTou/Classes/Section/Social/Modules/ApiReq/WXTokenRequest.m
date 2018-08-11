//
//  WXTokenRequest.m
//  HWTou
//
//  Created by 彭鹏 on 2017/4/28.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "WXTokenRequest.h"

@implementation WXTokenModel

@end

@implementation WXTokenResponse

@end

@implementation WXTokenParam

@end

@implementation WXTokenRequest

+ (NSString *)requestServerHost
{
    return kWechatServerHost;
}

+ (NSString *)requestApiPath
{
    return @"/sns/oauth2/access_token";
}

+ (HttpRequestMethod)requestMethod
{
    return HttpRequestMethodGet;
}

+ (void)accessTokenWithParam:(WXTokenParam *)param success:(void (^)(WXTokenResponse *))success failure:(void (^)(NSError *))failure
{
    [self requestWithParam:param responseClass:[WXTokenResponse class] success:success failure:failure];
}
@end
