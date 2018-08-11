//
//  WXRefreshTokenReq.m
//
//  Created by pengpeng on 16/8/22.
//  Copyright © 2016年 LieMi. All rights reserved.
//

#import "WXRefreshTokenReq.h"

@implementation WXRefreshTokenParam

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.grant_type = @"refresh_token";
    }
    return self;
}

@end

@implementation WXRefreshTokenResp

@end

@implementation WXRefreshTokenReq

+ (NSString *)requestServerHost
{
    return kWechatServerHost;
}

+ (NSString *)requestApiPath
{
    return @"sns/oauth2/refresh_token";
}

+ (HttpRequestMethod)requestMethod
{
    return HttpRequestMethodGet;
}

+ (void)refreshTokenWithParam:(WXRefreshTokenParam *)param success:(void (^)(WXRefreshTokenResp *))success failure:(void (^)(NSError *))failure
{
    [self requestWithParam:param responseClass:[WXRefreshTokenResp class] success:success failure:failure];
}

@end
