//
//  PaymentRequest.m
//  HWTou
//
//  Created by 彭鹏 on 2017/3/31.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "PaymentRequest.h"

@implementation PaymentParam

@end

@implementation PayThirdParam

@end

@implementation PayAliResult

@end

@implementation PayAliResp

@end

@implementation PayWechatResp

@end


@implementation PaymentRequest

static NSString *sApiPath;

+ (NSString *)requestApiPath
{
    return sApiPath;
}

+ (void)paymentWithParam:(PaymentParam *)param success:(void (^)(BaseResponse *))success failure:(void (^)(NSError *))failure
{
    sApiPath = @"pay/pay/index";
    [super requestWithParam:param responseClass:[BaseResponse class] success:success failure:failure];
}

+ (void)alipayWithParam:(PayThirdParam *)param success:(void (^)(PayAliResp *))success failure:(void (^)(NSError *))failure
{
    sApiPath = @"pay/pay-api/make";
    [super requestWithParam:param responseClass:[PayAliResp class] success:success failure:failure];
}

+ (void)wxpayWithParam:(PayThirdParam *)param success:(void (^)(PayWechatResp *))success failure:(void (^)(NSError *))failure
{
    sApiPath = @"pay/pay-api/wxmake";
    [super requestWithParam:param responseClass:[PayWechatResp class] success:success failure:failure];
}
@end
