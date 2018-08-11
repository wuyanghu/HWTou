//
//  WXUserInfoRequest.m
//
//  Created by pengpeng on 16/8/19.
//  Copyright © 2016年 LieMi. All rights reserved.
//

#import "WXUserInfoRequest.h"

@implementation WXUserInfoParam

@end

@implementation WXUserInfoRequest

+ (NSString *)requestServerHost
{
    return kWechatServerHost;
}

+ (NSString *)requestApiPath
{
    return @"/sns/userinfo";
}

+ (HttpRequestMethod)requestMethod
{
    return HttpRequestMethodGet;
}

+ (void)userInfoWithParam:(WXUserInfoParam *)param success:(void (^)(WXUserInfo *))success failure:(void (^)(NSError *))failure
{
    [self requestWithParam:param responseClass:[WXUserInfo class] success:success failure:failure];
}
@end

