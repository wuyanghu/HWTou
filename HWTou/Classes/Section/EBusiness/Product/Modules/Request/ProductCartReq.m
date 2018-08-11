//
//  ProductCartReq.m
//  HWTou
//
//  Created by 彭鹏 on 2017/3/29.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "ProductCartReq.h"
#import "ProductCartDM.h"
#import "BaseParam.h"

@implementation CartDeleteParam

@end

@implementation CartAddParam

@end

@implementation CartListResp

+ (NSDictionary *)modelContainerPropertyGenericClass
{
    return @{@"data" : [ProductCartDM class]};
}

@end

@implementation ProductCartReq

static NSString *sRequestApiPath = nil;

+ (NSString *)requestServerHost{
    return kHomeServerHost;
}

+ (NSString *)requestApiPath
{
    return sRequestApiPath;
}

+ (void)listCartsSuccess:(void (^)(CartListResp *))success failure:(void (^)(NSError *))failure
{
    sRequestApiPath = @"shop/cart-api/index";
    [super requestWithParam:[BaseParam new] responseClass:[CartListResp class] success:success failure:failure];
}

+ (void)addCartsWithParam:(CartAddParam *)param success:(void (^)(BaseResponse *))success failure:(void (^)(NSError *))failure
{
    sRequestApiPath = @"shop/cart-api/add";
    [super requestWithParam:param responseClass:[BaseResponse class] success:success failure:failure];
}

+ (void)deleteCartsWithParam:(CartDeleteParam *)param success:(void (^)(BaseResponse *))success failure:(void (^)(NSError *))failure
{
    sRequestApiPath = @"shop/cart-api/batch-delete";
    [super requestWithParam:param responseClass:[BaseResponse class] success:success failure:failure];
}
@end
