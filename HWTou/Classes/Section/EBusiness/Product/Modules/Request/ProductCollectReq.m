//
//  ProductCollectReq.m
//  HWTou
//
//  Created by 彭鹏 on 2017/3/30.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "ProductCollectReq.h"

#pragma mark - 请求参数
@implementation ProductCollectListParam

@end

@implementation ProductCollectParam

@end

#pragma mark - 请求响应 结果
@implementation CollectResult

+ (NSDictionary *)modelContainerPropertyGenericClass{
    
    return @{@"list" : [ProductCollectDM class]};
    
}

@end

#pragma mark - 请求响应
@implementation CollectResp

@end

#pragma mark - 请求执行
@implementation ProductCollectReq

static NSString *sRequestApiPath = nil;

+ (NSString *)requestApiPath{
    
    return sRequestApiPath;
    
}

+ (NSString *)requestServerHost{
    return kApiUserServerHost;
}

// 添加收藏
+ (void)addWithParam:(ProductCollectParam *)param success:(void (^)(BaseResponse *))success
             failure:(void (^)(NSError *))failure{
    
    sRequestApiPath = @"shop/collection-api/add";
    
    [super requestWithParam:param responseClass:[BaseResponse class] success:success failure:failure];
    
}

// 取消收藏
+ (void)cancelWithParam:(ProductCollectParam *)param success:(void (^)(BaseResponse *))success
                failure:(void (^)(NSError *))failure{
    
    sRequestApiPath = @"shop/collection-api/cancel";
    
    [super requestWithParam:param responseClass:[BaseResponse class] success:success failure:failure];
    
}

// 收藏列表
+ (void)listWithParam:(ProductCollectListParam *)param success:(void (^)(CollectResp *))success
              failure:(void (^)(NSError *))failure{
    
    sRequestApiPath = @"shop/collection-api/index";
    
    [super requestWithParam:param responseClass:[CollectResp class] success:success failure:failure];
    
}

@end
