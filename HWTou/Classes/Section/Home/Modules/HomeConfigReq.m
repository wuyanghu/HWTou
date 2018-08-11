//
//  HomeConfigReq.m
//  HWTou
//
//  Created by 彭鹏 on 2017/5/2.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "HomeConfigReq.h"
#import "HomeConfigDM.h"
#import "BaseParam.h"

@implementation HomeConfigResp

+ (NSDictionary *)modelContainerPropertyGenericClass
{
    return @{@"data" : [HomeConfigDM class]};
}

@end

@implementation HomeConfigReq

+ (NSString *)requestApiPath
{
    return @"floor/index/configure";
}

+ (void)configSuccess:(void (^)(HomeConfigResp *response))success
              failure:(void (^) (NSError *error))failure
{
    [super requestWithParam:[BaseParam new] responseClass:[HomeConfigResp class] success:success failure:failure];
}


@end
