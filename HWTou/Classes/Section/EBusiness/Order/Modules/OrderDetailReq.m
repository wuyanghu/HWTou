//
//  OrderDetailReq.m
//  HWTou
//
//  Created by 彭鹏 on 2017/3/30.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "OrderDetailReq.h"
#import "OrderDetailDM.h"

typedef NS_ENUM(NSInteger, OrderDetailType){
    
    OrderDetailList,        // 订单列表
    OrderDetailCommit,      // 订单提交
    OrderDetailDetail,      // 订单详情
    OrderDetailCancel,      // 订单取消
    OrderDetailAffirm,      // 订单回滚
    OrderDetailRollBack,    // 订单回滚
};

@implementation OrderCommitDM

@end

#pragma mark - Param
@implementation OrderListParam

@end

@implementation OrderCommitParam

+ (NSDictionary *)modelContainerPropertyGenericClass
{
    return @{@"list" : [OrderCommitDM class]};
}

@end

@implementation OrderComParam

@end

#pragma mark - Response

@implementation OrderListResp

@end

@implementation OrderListResult

+ (NSDictionary *)modelContainerPropertyGenericClass
{
    return @{@"list" : [OrderDetailDM class]};
}

@end
@implementation OrderCommitResult

@end

@implementation OrderCommitResp

@end

@implementation OrderDetailResp

@end

#pragma mark - Request

@implementation OrderDetailReq

static OrderDetailType kOrderType = OrderDetailList;

+ (NSString *)requestApiPath
{
    NSString *apiPath;
    switch (kOrderType) {
        case OrderDetailCommit:
            apiPath = @"order/postage-api/create";
            break;
        case OrderDetailRollBack:
            apiPath = @"order/postage-api/change-status";
            break;
        case OrderDetailDetail:
            apiPath = @"order/postage-api/view";
            break;
        case OrderDetailCancel:
            apiPath = @"order/postage-api/delete";
            break;
        case OrderDetailAffirm:
            apiPath = @"order/postage-api/affirm";
            break;
        default:
            apiPath = @"order/postage-api/index";
            break;
    }
    return apiPath;
}

+ (HttpRequestSerializerType)requestSerializerType
{
    return HttpRequestSerializerTypeJSON;
}

+ (void)rollBackWithParam:(OrderComParam *)param success:(void (^)(BaseResponse *))success failure:(void (^)(NSError *))failure
{
    kOrderType = OrderDetailRollBack;
    [super requestWithParam:param responseClass:[BaseResponse class] success:success failure:failure];
}

+ (void)commitWithParam:(OrderCommitParam *)param success:(void (^)(OrderCommitResp *))success failure:(void (^)(NSError *))failure
{
    kOrderType = OrderDetailCommit;
    [super requestWithParam:param responseClass:[OrderCommitResp class] success:success failure:failure];
}

+ (void)listWithParam:(OrderListParam *)param success:(void (^)(OrderListResp *))success failure:(void (^)(NSError *))failure
{
    kOrderType = OrderDetailList;
    [super requestWithParam:param responseClass:[OrderListResp class] success:success failure:failure];
}

+ (void)detailWithParam:(OrderListParam *)param success:(void (^)(OrderDetailResp *))success failure:(void (^)(NSError *))failure
{
    kOrderType = OrderDetailDetail;
    [super requestWithParam:param responseClass:[OrderDetailResp class] success:success failure:failure];
}

+ (void)cancelWithParam:(OrderComParam *)param success:(void (^)(BaseResponse *))success failure:(void (^)(NSError *))failure
{
    kOrderType = OrderDetailCancel;
    [super requestWithParam:param responseClass:[BaseResponse class] success:success failure:failure];
}

+ (void)confirmWithParam:(OrderComParam *)param success:(void (^)(BaseResponse *))success failure:(void (^)(NSError *))failure
{
    kOrderType = OrderDetailAffirm;
    [super requestWithParam:param responseClass:[BaseResponse class] success:success failure:failure];
}
@end
