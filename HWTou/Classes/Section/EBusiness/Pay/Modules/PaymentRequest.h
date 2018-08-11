//
//  PaymentRequest.h
//  HWTou
//
//  Created by 彭鹏 on 2017/3/31.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import <CoreGraphics/CoreGraphics.h>
#import "SessionRequest.h"
#import "BaseResponse.h"
#import "BaseParam.h"

typedef NS_OPTIONS(NSUInteger, PaymentWay) {
    PaymentWayNone      = 0,
    PaymentWayProfit    = 1 << 0,   // 提前花
    PaymentWayAliPay    = 1 << 1,   // 支付宝
    PaymentWayWXPay     = 1 << 2,   // 微信支付
    PaymentWayCard      = 1 << 3,   // 银行卡
};

@class PayWechatDM;

@interface PaymentParam : BaseParam

@property (nonatomic, assign) NSInteger mpid;
@property (nonatomic, assign) PaymentWay type;
@property (nonatomic, assign) CGFloat gold_expense;
@property (nonatomic, assign) CGFloat union_expense;

@end

@interface PayThirdParam : BaseParam

@property (nonatomic, assign) NSInteger mpid;

@end

@interface PayAliResult : NSObject

@property (nonatomic, assign) NSInteger type;
@property (nonatomic, copy) NSString *order_string;

@end

@interface PayAliResp : BaseResponse

@property (nonatomic, strong) PayAliResult *data;

@end

@interface PayWechatResp : BaseResponse

@property (nonatomic, strong) PayWechatDM *data;

@end


@interface PaymentRequest : SessionRequest

/**
 统一支付接口
 */
+ (void)paymentWithParam:(PaymentParam *)param
                 success:(void (^)(BaseResponse *response))success
                 failure:(void (^) (NSError *error))failure;
/**
 支付宝支付接口
 */
+ (void)alipayWithParam:(PayThirdParam *)param
                success:(void (^)(PayAliResp *response))success
                failure:(void (^) (NSError *error))failure;
/**
 微信支付接口
 */
+ (void)wxpayWithParam:(PayThirdParam *)param
               success:(void (^)(PayWechatResp *response))success
               failure:(void (^) (NSError *error))failure;
@end
