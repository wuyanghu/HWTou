//
//  InvestReq.m
//  HWTou
//
//  Created by 张维扬 on 2017/8/11.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "InvestReq.h"

@implementation InvestConfigResponse

@end

@implementation InvestDataResp

+ (NSDictionary *)modelContainerPropertyGenericClass
{
    return @{@"list" : [InvestListResp class]};
}

@end

@implementation InvestListResp

@end

@implementation InvestSwitchResp

@end

@implementation InvestSwitchResult

@end

@implementation InvestReq

static NSString *kApiPath = nil;

+ (NSString *)requestApiPath
{
    return kApiPath;
}

+ (void)redPackWithParam:(BaseParam *)param success:(void (^)(InvestConfigResponse *))success failure:(void (^)(NSError *))failure
{
    kApiPath = @"red/red-api/index";
    [super requestWithParam:param responseClass:[InvestConfigResponse class] success:success failure:failure];
}

+ (NSTimeInterval)timeoutInterval
{
    return 5.0f;
}

+ (void)switchSuccess:(void (^)(InvestSwitchResp *))success failure:(void (^)(NSError *))failure
{
    kApiPath = @"base/open/index";
    [super requestWithParam:nil responseClass:[InvestSwitchResp class] success:success failure:failure];
}

@end
