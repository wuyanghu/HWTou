//
//  ProductCollectReq.h
//  HWTou
//
//  Created by 彭鹏 on 2017/3/30.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "BaseParam.h"
#import "BaseResponse.h"
#import "SessionRequest.h"

#import "ProductCollectDM.h"

#pragma mark - 请求参数
@interface ProductCollectListParam : BaseParam

@property (nonatomic, assign) NSInteger start_page;
@property (nonatomic, assign) NSInteger pages;

@end

@interface ProductCollectParam : BaseParam

@property (nonatomic, assign) NSInteger item_id;

@end

#pragma mark - 请求响应 结果
@interface CollectResult : NSObject

@property (nonatomic, assign) NSInteger total_pages;
@property (nonatomic, strong) NSArray *list;

@end

#pragma mark - 请求响应
@interface CollectResp : BaseResponse

@property (nonatomic, strong) CollectResult *data;

@end

#pragma mark - 请求执行
@interface ProductCollectReq : SessionRequest

/**
 *  @brief 收藏商品
 *
 */
+ (void)addWithParam:(ProductCollectParam *)param
             success:(void (^)(BaseResponse *response))success
             failure:(void (^) (NSError *error))failure;

/**
 *  @brief 取消收藏的商品
 *
 */
+ (void)cancelWithParam:(ProductCollectParam *)param
                success:(void (^)(BaseResponse *response))success
                failure:(void (^) (NSError *error))failure;

/**
 *  @brief 用户收藏的商品列表
 *
 */
+ (void)listWithParam:(ProductCollectListParam *)param
              success:(void (^)(CollectResp *response))success
              failure:(void (^) (NSError *error))failure;

@end
