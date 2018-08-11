//
//  BannerAdReq.m
//  HWTou
//
//  Created by 彭鹏 on 2017/3/21.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "BannerAdReq.h"
#import "BannerAdDM.h"

@implementation BannerAdParam

@end

@implementation BannerAdList

+ (NSDictionary *)modelContainerPropertyGenericClass
{
    return @{@"list" : [BannerAdDM class]};
}

@end

@implementation BannerAdResp

@end

@implementation BannerAdReq

+ (NSString *)requestServerHost{
    return kApiServerHost;
}

+ (NSString *)requestApiPath
{
    return @"adv/index/index";
}

+ (void)bannerWithParam:(BannerAdParam *)param
                success:(void (^)(BannerAdResp *))success
                failure:(void (^)(NSError *))failure
{
    [super requestWithParam:param responseClass:[BannerAdResp class] success:success failure:failure];
}
@end
