//
//  makeCopperReq.m
//  HWTou
//
//  Created by 张维扬 on 2017/8/11.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "makeCopperReq.h"

@implementation makeCopperReq
+ (NSString *)requestApiPath
{
    return @"/gold/ex-banner-api/index";
}
+ (void)requestWithParam:(BaseParam *)param success:(void (^)(makeCopperConfigReq *))success failure:(void (^)(NSError *))failure
{
    [super requestWithParam:param responseClass:[makeCopperConfigReq class] success:success failure:failure];
}
@end

@implementation makeCopperDataReq
+ (NSDictionary *)modelContainerPropertyGenericClass
{
    return @{@"list" : [makeCopperListReq class]};
}
@end

@implementation makeCopperConfigReq

@end

@implementation makeCopperListReq

@end
