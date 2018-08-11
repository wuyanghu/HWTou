//
//  FloorListReq.m
//  HWTou
//
//  Created by 彭鹏 on 2017/3/21.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "FloorListReq.h"
#import "ComFloorDM.h"

@implementation FloorListParam

@end

@implementation FloorListResult

+ (NSDictionary *)modelContainerPropertyGenericClass
{
    return @{@"list" : [FloorListDM class]};
}

@end

@implementation FloorListResp

@end

@implementation FloorListReq

+ (NSString *)requestServerHost{
    return kApiServerHost;
}

+ (NSString *)requestApiPath
{
    return @"floor/index/index";
}

+ (void)floorWithParam:(FloorListParam *)param
               success:(void (^)(FloorListResp *response))success
               failure:(void (^) (NSError *error))failure
{
    [super requestWithParam:param responseClass:[FloorListResp class] success:success failure:failure];
}

@end
