//
//  CouponRequest.m
//  HWTou
//
//  Created by 赤 那 on 2017/4/6.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "CouponRequest.h"

#pragma mark - 请求参数
@implementation CouponParam
@synthesize type;
@synthesize flag;

@end

@implementation CouponProductParam

@end

#pragma mark - 请求响应 结果
@implementation CouponResult

@end

#pragma mark - 请求响应
@implementation CouponResponse
@synthesize data;

+ (NSDictionary *)modelContainerPropertyGenericClass{
    
    return @{@"data" : [CouponModel class]};
    
}

@end

#pragma mark - 请求执行
@implementation CouponRequest

+ (NSString *)requestApiPath{
    
    return @"coupon/coupon-api/index";
    
}

+ (void)obtainCouponListWithParam:(CouponParam *)param
                          success:(void (^)(CouponResponse *response))success
                          failure:(void (^)(NSError *error))failure{

    [super requestWithParam:param responseClass:[CouponResponse class]
                    success:success failure:failure];
    
}

+ (void)couponProductWithParam:(CouponProductParam *)param
                       success:(void (^)(CouponResponse *))success
                       failure:(void (^)(NSError *))failure
{
    [super requestWithParam:param responseClass:[CouponResponse class]
                    success:success failure:failure];
    
}
@end
