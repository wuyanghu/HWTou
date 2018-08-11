//
//  ProductDetailReq.m
//  HWTou
//
//  Created by 彭鹏 on 2017/4/7.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "ProductDetailReq.h"

@implementation ProductDetailParam

@end

@implementation ProductDetailResp

@end

@implementation ProductDetailReq

+ (NSString *)requestServerHost{
    return kHomeServerHost;
}

+ (NSString *)requestApiPath
{
    return @"shop/index/detail";
}

+ (void)detailWithParam:(ProductDetailParam *)param success:(void (^)(ProductDetailResp *))success failure:(void (^)(NSError *))failure
{
    [super requestWithParam:param responseClass:[ProductDetailResp class] success:success failure:failure];
}

@end
