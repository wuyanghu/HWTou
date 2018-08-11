//
//  ProductCategoryReq.m
//  HWTou
//
//  Created by pengpeng on 17/3/23.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "ProductCategoryReq.h"
#import "ProductCategoryDM.h"
#import "BaseParam.h"

@implementation CategoryChildParam

@end

@implementation ProductCategoryResp

+ (NSDictionary *)modelContainerPropertyGenericClass
{
    return @{@"data" : [ProductCategoryList class]};
}

@end

@implementation CategoryChildResp

@end


@implementation ProductCategoryReq

static NSString * kApiPath = nil;

+ (NSString *)requestServerHost{
    return kApiServerHost;
}

+ (NSString *)requestApiPath
{
    return kApiPath;
}

+ (void)categorySuccess:(void (^)(ProductCategoryResp *))success failure:(void (^)(NSError *))failure
{
    kApiPath = @"shop/index/category";
    [super requestWithParam:[BaseParam new] responseClass:[ProductCategoryResp class] success:success failure:failure];
}

+ (void)childCategoryWithParam:(CategoryChildParam *)param success:(void (^)(CategoryChildResp *))success failure:(void (^)(NSError *))failure
{
    kApiPath = @"shop/index/category-children";
    [super requestWithParam:param responseClass:[CategoryChildResp class] success:success failure:failure];
}
@end
