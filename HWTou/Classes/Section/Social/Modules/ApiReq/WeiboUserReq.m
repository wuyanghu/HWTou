//
//  WeiboUserReq.m
//
//  Created by 彭鹏 on 16/10/26.
//  Copyright © 2016年 LieMi. All rights reserved.
//

#import "WeiboUserReq.h"

@implementation WeiboUserInfo

@end

@implementation WeiboUserParam

@end

@implementation WeiboUserReq

+ (NSString *)requestServerHost
{
    return kWeiboServerHost;
}

+ (NSString *)requestApiPath
{
    return @"/2/users/show.json";
}

+ (HttpRequestMethod)requestMethod
{
    return HttpRequestMethodGet;
}

+ (void)userInfoWithParam:(WeiboUserParam *)param success:(void (^)(WeiboUserInfo *))success failure:(void (^)(NSError *))failure
{
    [self requestWithParam:param responseClass:[WeiboUserInfo class] success:success failure:failure];
}

@end
