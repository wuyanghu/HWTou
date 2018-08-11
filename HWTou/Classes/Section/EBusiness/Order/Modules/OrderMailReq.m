//
//  OrderMailReq.m
//  HWTou
//
//  Created by 彭鹏 on 2017/4/12.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "OrderMailReq.h"

@implementation OrderMailDM

@end

@implementation OrderMailResult

+ (NSDictionary *)modelContainerPropertyGenericClass
{
    return @{@"list" : [OrderMailDM class]};
}

@end

@implementation OrderMailResp

@end

@implementation OrderMailParam

@end

@implementation OrderMailReq

+ (NSString *)requestApiPath
{
    return @"order/mail-api/index";
}

+ (void)mailWithParam:(OrderMailParam *)param success:(void (^)(OrderMailResp *))success failure:(void (^)(NSError *))failure
{
    [super requestWithParam:param responseClass:[OrderMailResp class] success:success failure:failure];
}
@end
