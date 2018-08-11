//
//  AdLaunchReq.m
//  HWTou
//
//  Created by 彭鹏 on 2017/6/16.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "AdLaunchReq.h"

@implementation AdLaunchDM

@end

@implementation AdLaunchResp

@end

@implementation AdLaunchReq

+ (void)adLaunchSuccess:(void (^)(AdLaunchResp *))success failure:(void (^)(NSError *))failure
{
    [self requestWithParam:nil responseClass:[AdLaunchResp class] success:success failure:failure];
}

+ (NSString *)requestApiPath
{
    return @"/adv/index/ad";
}

// 启动太久，影响用户体验
+ (NSTimeInterval)timeoutInterval
{
    return 3.0f;
}

@end
