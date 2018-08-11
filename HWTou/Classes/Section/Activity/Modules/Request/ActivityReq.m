//
//  ActivityReq.m
//  HWTou
//
//  Created by 彭鹏 on 2017/4/6.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "ActivityReq.h"
#import "ActivityListDM.h"

#pragma mark - 请求参数
@implementation ActivityParam

@end

@implementation ActAppliedParam

@end

@implementation ActDetailParam

@end

#pragma mark - 请求响应 结果
@implementation ActivityList

+ (NSDictionary *)modelContainerPropertyGenericClass
{
    return @{@"list" : [ActivityListDM class]};
}

@end

#pragma mark - 请求响应
@implementation ActivityResp

@end

@implementation ActDetailResp

@end

#pragma mark - 请求执行
@implementation ActivityReq

static NSString *sApiPath = nil;

+ (NSString *)requestApiPath
{
    return sApiPath;
}

+ (void)listWithParam:(ActivityParam *)param
              success:(void (^)(ActivityResp *))success
              failure:(void (^)(NSError *))failure
{
    sApiPath = @"act/index/index";
    [super requestWithParam:param responseClass:[ActivityResp class] success:success failure:failure];
}

+ (void)listAppliedWithParam:(ActAppliedParam *)param success:(void (^)(ActivityResp *))success failure:(void (^)(NSError *))failure
{
    sApiPath = @"act/index/sign-list";
    [super requestWithParam:param responseClass:[ActivityResp class] success:success failure:failure];
}

+ (void)detailWithParam:(ActDetailParam *)param success:(void (^)(ActDetailResp *))success failure:(void (^)(NSError *))failure
{
    sApiPath = @"act/index/detail";
    [super requestWithParam:param responseClass:[ActDetailResp class] success:success failure:failure];
}

@end
