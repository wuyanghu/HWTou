//
//  CouponRequest.h
//  HWTou
//
//  Created by 赤 那 on 2017/4/6.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "BaseParam.h"
#import "BaseResponse.h"
#import "SessionRequest.h"

#import "CouponModel.h"

#pragma mark - 请求参数
@interface CouponParam : BaseParam

@property (nonatomic, assign) NSInteger type;           // 1:商城代金券,2:加息券,3:体验券
@property (nonatomic, assign) NSInteger flag;           // 可选（0：全部优惠券,1：过滤出有效优惠券

@end

#pragma mark - 请求参数
@interface CouponProductParam : CouponParam

@property (nonatomic, copy) NSArray *item_ids;

@end

#pragma mark - 请求响应 结果
@interface CouponResult : NSObject



@end

#pragma mark - 请求响应
@interface CouponResponse : BaseResponse

@property (nonatomic, strong) NSArray <CouponModel *> *data;

@end

#pragma mark - 请求执行
@interface CouponRequest : SessionRequest

/**
 *  @brief 获取优惠劵列表
 *
 *  @param param    CouponParam
 *  @param success  请求成功回调的block
 *  @param failure  请求失败回调的block
 *
 */
+ (void)obtainCouponListWithParam:(CouponParam *)param
                          success:(void (^)(CouponResponse *response))success
                          failure:(void (^)(NSError *error))failure;

/**
 获取商品优惠券
 */
+ (void)couponProductWithParam:(CouponProductParam *)param
                       success:(void (^)(CouponResponse *response))success
                       failure:(void (^)(NSError *error))failure;

@end
