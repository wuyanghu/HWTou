//
//  ActivityCollectReq.m
//  HWTou
//
//  Created by 赤 那 on 2017/4/9.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "ActivityCollectReq.h"

#pragma mark - 请求参数
@implementation ActivityCollectListParam



@end

@implementation ActivityCollectParam



@end

#pragma mark - 请求响应 结果
@implementation ActivityCollectResult

+ (NSDictionary *)modelContainerPropertyGenericClass{
    
    return @{@"list" : [ActivityCollectDM class]};
    
}

@end

#pragma mark - 请求响应
@implementation ActivityCollectResp



@end

#pragma mark - 请求执行
@implementation ActivityCollectReq

static NSString *sApiPath = nil;

+ (NSString *)requestApiPath{
    
    return sApiPath;
    
}

+ (NSString *)requestServerHost{
    return kApiUserServerHost;
}

// 收藏活动
+ (void)addActivityCollectWithParam:(ActivityCollectParam *)param
                            success:(void (^)(BaseResponse *response))success
                            failure:(void (^) (NSError *error))failure{

    sApiPath = @"act/collection-api/add";
    
    [super requestWithParam:param responseClass:[BaseResponse class] success:success failure:failure];
    
}

// 取消收藏活动
+ (void)cancelActivityCollectWithParam:(ActivityCollectParam *)param
                               success:(void (^)(BaseResponse *response))success
                               failure:(void (^) (NSError *error))failure{

    sApiPath = @"act/collection-api/cancel";
    
    [super requestWithParam:param responseClass:[BaseResponse class] success:success failure:failure];
    
}

// 用户收藏活动列表
+ (void)obtainActivityCollectListWithParam:(ActivityCollectListParam *)param
                                   success:(void (^)(ActivityCollectResp *response))success
                                   failure:(void (^) (NSError *error))failure{

    sApiPath = @"act/collection-api/index";
    
    [super requestWithParam:param responseClass:[ActivityCollectResp class] success:success failure:failure];
    
}

@end
