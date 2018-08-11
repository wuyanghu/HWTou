//
//  ProductListReq.m
//  HWTou
//
//  Created by pengpeng on 17/3/24.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "ProductDetailDM.h"
#import "ProductListReq.h"

@implementation ProductListParam

@end

@implementation ProductSearchParam

@end

@implementation ProductListResult

+ (NSDictionary *)modelContainerPropertyGenericClass
{
    return @{@"list" : [ProductDetailDM class]};
}

@end

@implementation ProductListResp

@end

@implementation ProductListReq

static NSString * kApiPath = nil;

+ (NSString *)requestServerHost{
    return kHomeServerHost;
}

+ (NSString *)requestApiPath
{
    return kApiPath;
}

+ (void)productWithParam:(ProductListParam *)param success:(void (^)(ProductListResp *))success failure:(void (^)(NSError *))failure
{
    kApiPath = @"shop/index/index";
    [super requestWithParam:param responseClass:[ProductListResp class] success:success failure:failure];
}

+ (void)searchWithParam:(ProductSearchParam *)param success:(void (^)(ProductListResp *))success failure:(void (^)(NSError *))failure
{
    kApiPath = @"shop/index/search";
    [super requestWithParam:param responseClass:[ProductListResp class] success:success failure:failure];
}
@end
