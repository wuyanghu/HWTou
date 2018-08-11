//
//  RegionRequest.m
//  HWTou
//
//  Created by 赤 那 on 2017/3/29.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "RegionRequest.h"

#pragma mark - 请求参数
@implementation RegionParam
@synthesize token;
@synthesize type,region_id;



@end

#pragma mark - 请求响应 结果
@implementation RegionResult
@synthesize id;
@synthesize name;



@end

#pragma mark - 请求响应
@implementation RegionResponse
@synthesize data;

+ (NSDictionary *)modelContainerPropertyGenericClass{
    
    return @{@"data" : [RegionResult class]};
    
}

@end

#pragma mark - 请求执行
@implementation RegionRequest

+ (NSString *)requestApiPath{

    return @"base/index/region-list";
    
}

+ (void)obtainRegionListWithParam:(RegionParam *)param
                          success:(void (^)(RegionResponse *response))success
                          failure:(void (^)(NSError *error))failure{

    [super requestWithParam:param responseClass:[RegionResponse class]
                    success:success failure:failure];
    
}

@end
