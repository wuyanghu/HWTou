//
//  OrderDetailReq.h
//  HWTou
//
//  Created by 彭鹏 on 2017/3/30.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import <CoreGraphics/CoreGraphics.h>
#import "SessionRequest.h"
#import "BaseResponse.h"
#import "BaseParam.h"

@class OrderDetailDM;

// 订单提交模型
@interface OrderCommitDM : NSObject

@property (nonatomic, assign) NSInteger cart_id;
@property (nonatomic, assign) NSInteger item_id;
@property (nonatomic, assign) NSInteger num;
@property (nonatomic, assign) NSInteger mivid;

@end

#pragma mark - Param
// 订单提交参数
@interface OrderCommitParam : BaseParam

@property (nonatomic, assign) NSInteger maid;
@property (nonatomic, assign) CGFloat   price_total;
@property (nonatomic, assign) CGFloat   postage;
@property (nonatomic, copy)   NSArray   *cuids;
@property (nonatomic, copy)   NSArray   *list;

@end

// 订单列表参数
@interface OrderListParam : BaseParam

@property (nonatomic, assign) NSInteger     start_page;
@property (nonatomic, assign) NSInteger     pages;
@property (nonatomic, assign) NSInteger     status;
@property (nonatomic, copy)   NSString      *order_nos;

@end

// 订单回滚参数
@interface OrderComParam : BaseParam

@property (nonatomic, assign) NSInteger     mpid;

@end

#pragma mark - Response
// 订单提交响应结果
@interface OrderCommitResult : NSObject

@property (nonatomic, assign) NSInteger mpid;

@end

// 订单列表响应结果
@interface OrderListResult : NSObject

@property (nonatomic, assign) NSInteger total_pages;
@property (nonatomic, copy)   NSArray   *list;

@end

// 订单提交响应
@interface OrderCommitResp : BaseResponse

@property (nonatomic, strong) OrderCommitResult *data;

@end

// 订单列表响应
@interface OrderListResp : BaseResponse

@property (nonatomic, strong) OrderListResult *data;

@end

// 订单详情响应
@interface OrderDetailResp : BaseResponse

@property (nonatomic, strong) OrderDetailDM *data;

@end

#pragma mark - Request

@interface OrderDetailReq : SessionRequest

// 提交订单请求
+ (void)commitWithParam:(OrderCommitParam *)param
                success:(void (^)(OrderCommitResp *response))success
                failure:(void (^) (NSError *error))failure;

// 订单回滚请求
+ (void)rollBackWithParam:(OrderComParam *)param
                  success:(void (^)(BaseResponse *response))success
                  failure:(void (^) (NSError *error))failure;

// 订单列表请求
+ (void)listWithParam:(OrderListParam *)param
              success:(void (^)(OrderListResp *response))success
              failure:(void (^) (NSError *error))failure;

// 订单详情请求
+ (void)detailWithParam:(OrderComParam *)param
                success:(void (^)(OrderDetailResp *response))success
                failure:(void (^) (NSError *error))failure;

// 订单详情请求
+ (void)cancelWithParam:(OrderComParam *)param
                success:(void (^)(BaseResponse *response))success
                failure:(void (^) (NSError *error))failure;

// 确认收货请求
+ (void)confirmWithParam:(OrderComParam *)param
                 success:(void (^)(BaseResponse *response))success
                 failure:(void (^) (NSError *error))failure;

@end
