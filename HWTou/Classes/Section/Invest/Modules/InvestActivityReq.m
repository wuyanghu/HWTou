//
//  InvestActivityReq.m
//  HWTou
//
//  Created by 彭鹏 on 2017/8/11.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "InvestActivityReq.h"
#import "InvestActivityDM.h"

@implementation InvestActivityParam

@end

@implementation InvestActivityResult

+ (NSDictionary *)modelContainerPropertyGenericClass
{
    return @{@"list" : [InvestActivityDM class]};
}

@end

@implementation InvestActivityResp

@end

@implementation InvestActivityReq

+ (NSString *)requestApiPath
{
    return @"/gold/ex-banner-api/index";
}

+ (void)activityWithParam:(InvestActivityParam *)param
                  success:(void (^)(InvestActivityResp *result))success
                  failure:(void (^)(NSError *error))failure
{
    [super requestWithParam:param responseClass:[InvestActivityResp class] success:success failure:failure];
}

@end
