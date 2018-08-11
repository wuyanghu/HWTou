//
//  RedPacketRequest.h
//  HWTou
//
//  Created by Reyna on 2018/3/7.
//  Copyright © 2018年 LieMi. All rights reserved.
//

#import "BaseRequest.h"
#import "SessionRequest.h"
#import "BaseParam.h"
#import "BaseResponse.h"

@interface GetTipsByTopTimeParam:BaseParam
@property (nonatomic,assign) NSInteger rtcId;//聊吧ID
@property (nonatomic,assign) NSInteger rtcUid;//主播ID
@property (nonatomic,assign) NSInteger flag;//标志：1：本场直播，2：贡献周榜，3：贡献总榜
@property (nonatomic,assign) NSInteger page;//页码
@property (nonatomic,assign) NSInteger pagesize;//每页显示条数
@end

@interface PayOrderParam:BaseParam
@property (nonatomic,copy) NSString * chargeId;//支付ID，支付类型为余额时传空
@property (nonatomic,assign) NSInteger chargeType;//支付类型，0：余额，1：支付宝，2：微信
@property (nonatomic,copy) NSString * orderIds;//订单编号ID集合 （（客户端需要把以下格式化好的数据转化成字符串传输给后台））
@end

@interface RefundOrderParam:BaseParam
@property (nonatomic,copy) NSString * orderId;//订单编号ID
@property (nonatomic,assign) NSInteger sellerId;//卖家ID
@property (nonatomic,assign) NSInteger goodsId;//商品ID
@end

@interface PayProveOrderParam:BaseParam
@property (nonatomic,copy) NSString * chargeId;//支付ID，支付类型为余额时传空
@property (nonatomic,assign) NSInteger chargeType;//支付类型，0：余额，1：支付宝，2：微信
@property (nonatomic,copy) NSString * proveOrderId;//保证金订单ID
@end

@interface ChargeProveMoneyParam:BaseParam
@property (nonatomic,assign) NSInteger chargeType;//支付类型：0：余额，1：支付宝，2：微信
@property (nonatomic,copy) NSString * ip;//客户端IP
@property (nonatomic,copy) NSString * proveOrderId;//保证金订单ID
@end

@interface ChargeSellerGoodsOrderParam:BaseParam
@property (nonatomic,copy) NSString * sellerGoodsOrderId;//拍卖品订单ID
@property (nonatomic,assign) NSInteger chargeType;//支付类型：0：余额，1：支付宝，2：微信
@property (nonatomic,copy) NSString * ip;//客户端IP
@end

@interface PaySellerGoodsOrderParam:BaseParam
@property (nonatomic,copy) NSString * chargeId;//支付ID，支付类型为余额时传空
@property (nonatomic,copy) NSString * sellerGoodsOrderId;//拍卖品订单ID
@property (nonatomic,assign) NSInteger chargeType;//支付类型，0：余额，1：支付宝，2：微信
@end

@interface ChargeOrderParam:BaseParam
@property (nonatomic,assign) NSInteger chargeType;//支付类型：0：余额，1：支付宝，2：微信
@property (nonatomic,copy) NSString * ip;//客户端IP
@property (nonatomic,copy) NSString * orderIds;//订单编号ID集合 （（客户端需要把以下格式化好的数据转化成字符串传输给后台））
@end

@interface RedPacketResponseDict:BaseResponse
@property (nonatomic,strong) NSDictionary * data;
@end

@interface RedPacketResponseArr:BaseResponse
@property (nonatomic,strong) NSArray * data;
@end

@interface RedPacketRequest : SessionRequest

/** 未过期未领完红包ID */
+ (void)getIsGetRedWithRtcId:(int)rtcId success:(void (^)(NSDictionary *response))success failure:(void (^) (NSError *error))failure;

/**
 * 发红包
 * @param redRId 红包ID(String)
 * @param chargeId 支付类型为余额时传空 Ping++支付ID (String)
 * @param chargeType 支付类型(0:余额 1:支付宝 2:微信)
 * @param token (String)
 */
+ (void)sendRedEnvelopeWithRedRId:(NSString *)redRId chargeId:(NSString *)chargeId chargeType:(int)chargeType success:(void (^)(NSDictionary *response))success failure:(void (^) (NSError *error))failure;

/**
 * 创建红包
 * @param text 红包文本(String)
 * @param fromTo 红包来源(0:普通用户来源 1:公司平台来源)
 * @param redType 红包类型(1:普通红包 2:拼手气红包)
 * @param redMoney 红包金额 (int_分)
 * @param redNum 红包个数 (int)
 * @param rtcId 话题、广播、聊吧ID(int)
 * @param flag (1:广播 2:话题 3:聊吧)
 * @param token (String)
 */
+ (void)createRedEnvelopeWithText:(NSString *)text fromTo:(int)fromTo redType:(int)redType redMoney:(int)redMoney redNum:(int)redNum rtcId:(int)rtcId flag:(int)flag success:(void (^)(NSDictionary *response))success failure:(void (^) (NSError *error))failure;

/**
 * 抢红包
 * @param redRId 红包ID(String)
 * @param rtcId 话题、广播、聊吧ID(int)
 * @param token (String)
 */
+ (void)consumeRedEnvelopesWithRedRId:(NSString *)redRId rtcId:(int)rtcId success:(void (^)(NSDictionary *response))success failure:(void (^) (NSError *error))failure;

/**
 * 微信支付宝支付发红包
 * @param redRId 红包ID(String)
 * @param chargeType 支付渠道(1:支付宝 2:微信)
 * @param ip 客户端ip地址(String)
 * @param token (String)
 */
+ (void)chargeRedMoneyWithRedRId:(NSString *)redRId chargeType:(int)chargeType ip:(NSString *)ip success:(void (^)(NSDictionary *response))success failure:(void (^) (NSError *error))failure;

/**
 * 创建打赏订单
 * @param rtcId 话题ID(int)
 * @param rtcUid 发布话题的用户ID(int)
 * @param flag 标志(1:广播 2:话题 3:聊吧)
 * @param tipMoney 打赏金额(int_分)
 * @param token (String)
 */
+ (void)createTipRTCWithRtcId:(int)rtcId rtcUid:(int)rtcUid flag:(int)flag tipMoney:(int)tipMoney success:(void (^)(NSDictionary *response))success failure:(void (^) (NSError *error))failure;

/**
 * 打赏支出
 * @param chargeId 支付ID，支付类型为余额时传空(String)
 * @param tipRId 打赏记录ID(String)
 * @param chargeType 支付类型(0:余额 1:支付宝 2:微信)
 * @param token (String)
 */
+ (void)sendTipRTCWithChargeId:(NSString *)chargeId tipRId:(NSString *)tipRId chargeType:(int)chargeType success:(void (^)(NSDictionary *response))success failure:(void (^) (NSError *error))failure;

/**
 * 微信支付宝支付打赏
 * @param tipRId 打赏记录ID(String)
 * @param chargeType 支付类型(0:余额 1:支付宝 2:微信)
 * @param ip 客户端ip(String)
 * @param token (String)
 */
+ (void)chargeTipMoneyWithTipRId:(NSString *)tipRId chargeType:(int)chargeType ip:(NSString *)ip success:(void (^)(NSDictionary *response))success failure:(void (^) (NSError *error))failure;

#pragma mark - 爆料奖励
//创建爆料奖励订单
+ (void)createRewardRTC:(int)rtcId toUid:(int)toUid flag:(int)flag rewardMoney:(int)rewardMoney success:(void (^)(NSDictionary *))success failure:(void (^)(NSError *))failure;
//微信支付宝支付奖励
+ (void)chargeRewardMoney:(NSString *)rewardRId chargeType:(int)chargeType ip:(NSString *)ip success:(void (^)(NSDictionary *))success failure:(void (^)(NSError *))failure;
//奖励支出
+ (void)sendRewardRTC:(NSString *)chargeId rewardRId:(NSString *)rewardRId chargeType:(int)chargeType success:(void (^)(NSDictionary *))success failure:(void (^)(NSError *))failure;
#pragma mark - 主播打赏排行榜
+ (void)getTipsByTopTime:(GetTipsByTopTimeParam *)param success:(void (^)(RedPacketResponseArr *))success failure:(void (^)(NSError *))failure ;

#pragma mark - 订单支付模块
//商品订单支出
+ (void)payOrder:(PayOrderParam *)param success:(void (^)(RedPacketResponseDict *))success failure:(void (^)(NSError *))failure;
//微信支付宝支付商品订单
+ (void)chargeOrder:(ChargeOrderParam *)param success:(void (^)(RedPacketResponseDict *))success failure:(void (^)(NSError *))failure;
//未发货订单用户端退款 (加密接口)
+ (void)refundOrder:(RefundOrderParam *)param
            Success:(void (^)(RedPacketResponseDict *response))success
            failure:(void (^) (NSError *error))failure;
//保证金订单支出
+ (void)payProveOrder:(PayProveOrderParam *)param
              Success:(void (^)(RedPacketResponseDict *response))success
              failure:(void (^) (NSError *error))failure;
//微信支付宝支付保证金
+ (void)chargeProveMoney:(ChargeProveMoneyParam *)param
                 Success:(void (^)(RedPacketResponseDict *response))success
                 failure:(void (^) (NSError *error))failure;
//微信支付宝支付已拍中商品
+ (void)chargeSellerGoodsOrder:(ChargeSellerGoodsOrderParam *)param
                       Success:(void (^)(RedPacketResponseDict *response))success
                       failure:(void (^) (NSError *error))failure;
//拍卖品订单金额支出
+ (void)paySellerGoodsOrder:(PaySellerGoodsOrderParam *)param
                    Success:(void (^)(RedPacketResponseDict *response))success
                    failure:(void (^) (NSError *error))failure;
@end
