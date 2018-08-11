//
//  ActivityNewsCollectReq.m
//  HWTou
//
//  Created by 赤 那 on 2017/4/9.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "ActivityNewsCollectReq.h"

#pragma mark - 请求参数
@implementation ActivityNewsCollectListParam

@end

@implementation ActivityNewsCollectParam

@end

#pragma mark - 请求响应 结果
@implementation ActivityNewsCollectResult

+ (NSDictionary *)modelContainerPropertyGenericClass{
    
    return @{@"list" : [ActivityNewsCollectDM class]};
    
}

@end

#pragma mark - 请求响应
@implementation ActivityNewsCollectResp



@end

#pragma mark - 请求执行
@implementation ActivityNewsCollectReq

static NSString *sApiPath = nil;

+ (NSString *)requestServerHost{
    return kApiUserServerHost;
}

+ (NSString *)requestApiPath{
    
    return sApiPath;
    
}

// 添加收藏
+ (void)addActivityNewsCollectWithParam:(ActivityNewsCollectParam *)param
                                success:(void (^)(BaseResponse *response))success
                                failure:(void (^) (NSError *error))failure{
    
    sApiPath = @"info/collection-api/add";
    
    [super requestWithParam:param responseClass:[BaseResponse class] success:success failure:failure];
    
}

// 取消收藏
+ (void)cancelActivityNewsCollectWithParam:(ActivityNewsCollectParam *)param
                                   success:(void (^)(BaseResponse *response))success
                                   failure:(void (^) (NSError *error))failure{
    
    sApiPath = @"/info/collection-api/cancel";
    
    [super requestWithParam:param responseClass:[BaseResponse class] success:success failure:failure];
    
}

// 收藏列表
+ (void)obtainActivityNewsCollectListWithParam:(ActivityNewsCollectListParam *)param
                                       success:(void (^)(ActivityNewsCollectResp *response))success
                                       failure:(void (^) (NSError *error))failure{
    
    sApiPath = @"info/collection-api/index";
    
    [super requestWithParam:param responseClass:[ActivityNewsCollectResp class]
                    success:success failure:failure];
    
}

@end
