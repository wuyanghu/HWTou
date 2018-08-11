//
//  RedPacketRequest.m
//  HWTou
//
//  Created by Reyna on 2018/3/7.
//  Copyright © 2018年 LieMi. All rights reserved.
//

#import "RedPacketRequest.h"
#import "AccountManager.h"
#import "YYModel.h"
#import "SecurityTool.h"

@implementation RedPacketRequest

static NSString *sApiPath = nil;

+ (NSString *)requestServerHost {
    return kApiMoneyServerHost;
}

+ (NSString *)requestApiPath
{
    return sApiPath;
}

+ (HttpRequestMethod)requestMethod{
    
    return HttpRequestMethodPost;
    
}

#pragma mark - 未过期未领完红包ID
+ (void)getIsGetRedWithRtcId:(int)rtcId success:(void (^)(NSDictionary *))success failure:(void (^)(NSError *))failure {
    
    sApiPath = @"redEnvelopes/getIsGetRed";
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    int userId = (int)[[AccountManager shared] account].uid;
    [dic setValue:@(userId) forKey:@"userId"];
    [dic setValue:@(rtcId) forKey:@"rtcId"];
    
    NSDictionary *dataDic = [SecurityTool getAesDict:dic];
    [self requestWithParam:dataDic responseClass:nil success:success failure:failure];
}

#pragma mark - 发红包
+ (void)sendRedEnvelopeWithRedRId:(NSString *)redRId chargeId:(NSString *)chargeId chargeType:(int)chargeType success:(void (^)(NSDictionary *))success failure:(void (^)(NSError *))failure {
    
    sApiPath = @"redEnvelopes/sendRedEnvelope";
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    NSString * token = [[AccountManager shared] account].token;
    [dic setObject:token!=nil?token:@"" forKey:@"token"];
    [dic setObject:redRId forKey:@"redRId"];
    [dic setObject:chargeId forKey:@"chargeId"];
    [dic setValue:@(chargeType) forKey:@"chargeType"];
    
    NSDictionary *dataDic = [SecurityTool getAesDict:dic];
    [self requestWithParam:dataDic responseClass:nil success:success failure:failure];
}

#pragma mark - 创建红包
+ (void)createRedEnvelopeWithText:(NSString *)text fromTo:(int)fromTo redType:(int)redType redMoney:(int)redMoney redNum:(int)redNum rtcId:(int)rtcId flag:(int)flag success:(void (^)(NSDictionary *))success failure:(void (^)(NSError *))failure {
    
    sApiPath = @"redEnvelopes/createRedEnvelope";
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    NSString * token = [[AccountManager shared] account].token;
    [dic setObject:token!=nil?token:@"" forKey:@"token"];
    [dic setObject:text forKey:@"text"];
    [dic setValue:@(fromTo) forKey:@"fromTo"];
    [dic setValue:@(redType) forKey:@"redType"];
    [dic setValue:@(redMoney) forKey:@"redMoney"];
    [dic setValue:@(redNum) forKey:@"redNum"];
    [dic setValue:@(rtcId) forKey:@"rtcId"];
    [dic setValue:@(flag) forKey:@"flag"];
    
    NSDictionary *dataDic = [SecurityTool getAesDict:dic];
    [self requestWithParam:dataDic responseClass:nil success:success failure:failure];
}

#pragma mark - 抢红包
+ (void)consumeRedEnvelopesWithRedRId:(NSString *)redRId rtcId:(int)rtcId success:(void (^)(NSDictionary *))success failure:(void (^)(NSError *))failure {
    
    sApiPath = @"redEnvelopes/consumeRedEnvelopes";
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    NSString * token = [[AccountManager shared] account].token;
    [dic setObject:token!=nil?token:@"" forKey:@"token"];
    [dic setObject:redRId forKey:@"redRId"];
    [dic setValue:@(rtcId) forKey:@"rtcId"];
    
    NSDictionary *dataDic = [SecurityTool getAesDict:dic];
    [self requestWithParam:dataDic responseClass:nil success:success failure:failure];
}

#pragma mark - 微信支付宝发红包
+ (void)chargeRedMoneyWithRedRId:(NSString *)redRId chargeType:(int)chargeType ip:(NSString *)ip success:(void (^)(NSDictionary *))success failure:(void (^)(NSError *))failure {
    
    sApiPath = @"redEnvelopes/chargeRedMoney";
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    NSString * token = [[AccountManager shared] account].token;
    [dic setObject:token!=nil?token:@"" forKey:@"token"];
    [dic setObject:ip forKey:@"ip"];
    [dic setObject:redRId forKey:@"redRId"];
    [dic setValue:@(chargeType) forKey:@"chargeType"];
    
    NSDictionary *dataDic = [SecurityTool getAesDict:dic];
    [self requestWithParam:dataDic responseClass:nil success:success failure:failure];
}

#pragma mark - 创建打赏订单
+ (void)createTipRTCWithRtcId:(int)rtcId rtcUid:(int)rtcUid flag:(int)flag tipMoney:(int)tipMoney success:(void (^)(NSDictionary *))success failure:(void (^)(NSError *))failure {
    
    sApiPath = @"tipRecord/createTipRTC";
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    NSString * token = [[AccountManager shared] account].token;
    [dic setObject:token!=nil?token:@"" forKey:@"token"];
    [dic setValue:@(rtcId) forKey:@"rtcId"];
    [dic setValue:@(rtcUid) forKey:@"rtcUid"];
    [dic setValue:@(flag) forKey:@"flag"];
    [dic setValue:@(tipMoney) forKey:@"tipMoney"];
    
    NSDictionary *dataDic = [SecurityTool getAesDict:dic];
    [self requestWithParam:dataDic responseClass:nil success:success failure:failure];
}

#pragma mark - 爆料奖励
//创建爆料奖励订单
+ (void)createRewardRTC:(int)rtcId toUid:(int)toUid flag:(int)flag rewardMoney:(int)rewardMoney success:(void (^)(NSDictionary *))success failure:(void (^)(NSError *))failure {
    
    sApiPath = @"rewardRecord/createRewardRTC";
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    NSString * token = [[AccountManager shared] account].token;
    [dic setObject:token!=nil?token:@"" forKey:@"token"];
    [dic setValue:@(rtcId) forKey:@"rtcId"];
    [dic setValue:@(toUid) forKey:@"toUid"];
    [dic setValue:@(flag) forKey:@"flag"];
    [dic setValue:@(rewardMoney) forKey:@"rewardMoney"];
    
    NSDictionary *dataDic = [SecurityTool getAesDict:dic];
    [self requestWithParam:dataDic responseClass:nil success:success failure:failure];
}

//微信支付宝支付奖励
+ (void)chargeRewardMoney:(NSString *)rewardRId chargeType:(int)chargeType ip:(NSString *)ip success:(void (^)(NSDictionary *))success failure:(void (^)(NSError *))failure {
    
    sApiPath = @"rewardRecord/chargeRewardMoney";
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    NSString * token = [[AccountManager shared] account].token;
    [dic setObject:token!=nil?token:@"" forKey:@"token"];
    [dic setObject:ip forKey:@"ip"];
    [dic setObject:rewardRId forKey:@"rewardRId"];
    [dic setValue:@(chargeType) forKey:@"chargeType"];
    
    NSDictionary *dataDic = [SecurityTool getAesDict:dic];
    [self requestWithParam:dataDic responseClass:nil success:success failure:failure];
}

//奖励支出
+ (void)sendRewardRTC:(NSString *)chargeId rewardRId:(NSString *)rewardRId chargeType:(int)chargeType success:(void (^)(NSDictionary *))success failure:(void (^)(NSError *))failure {
    
    sApiPath = @"rewardRecord/sendRewardRTC";
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    NSString * token = [[AccountManager shared] account].token;
    [dic setObject:token!=nil?token:@"" forKey:@"token"];
    [dic setObject:chargeId forKey:@"chargeId"];
    [dic setObject:rewardRId forKey:@"rewardRId"];
    [dic setValue:@(chargeType) forKey:@"chargeType"];
    
    NSDictionary *dataDic = [SecurityTool getAesDict:dic];
    [self requestWithParam:dataDic responseClass:nil success:success failure:failure];
}

#pragma mark - 打赏支出
+ (void)sendTipRTCWithChargeId:(NSString *)chargeId tipRId:(NSString *)tipRId chargeType:(int)chargeType success:(void (^)(NSDictionary *))success failure:(void (^)(NSError *))failure {
   
    sApiPath = @"tipRecord/sendTipRTC";
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    NSString * token = [[AccountManager shared] account].token;
    [dic setObject:token!=nil?token:@"" forKey:@"token"];
    [dic setObject:chargeId forKey:@"chargeId"];
    [dic setObject:tipRId forKey:@"tipRId"];
    [dic setValue:@(chargeType) forKey:@"chargeType"];
    
    NSDictionary *dataDic = [SecurityTool getAesDict:dic];
    [self requestWithParam:dataDic responseClass:nil success:success failure:failure];
}
#pragma mark - 微信支付宝打赏
+ (void)chargeTipMoneyWithTipRId:(NSString *)tipRId chargeType:(int)chargeType ip:(NSString *)ip success:(void (^)(NSDictionary *))success failure:(void (^)(NSError *))failure {
   
    sApiPath = @"tipRecord/chargeTipMoney";
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    NSString * token = [[AccountManager shared] account].token;
    [dic setObject:token!=nil?token:@"" forKey:@"token"];
    [dic setObject:tipRId forKey:@"tipRId"];
    [dic setValue:@(chargeType) forKey:@"chargeType"];
    [dic setObject:ip forKey:@"ip"];
    
    NSDictionary *dataDic = [SecurityTool getAesDict:dic];
    [self requestWithParam:dataDic responseClass:nil success:success failure:failure];
}



#pragma mark - 主播打赏排行榜
+ (void)getTipsByTopTime:(GetTipsByTopTimeParam *)param success:(void (^)(RedPacketResponseArr *))success failure:(void (^)(NSError *))failure {
    
    sApiPath = @"tipRecord/getTipsByTopTime";
    
    [self requestWithParam:param responseClass:[RedPacketResponseArr class] success:success failure:failure];
}

#pragma mark - 订单支付模块
//商品订单支出
+ (void)payOrder:(PayOrderParam *)param success:(void (^)(RedPacketResponseDict *))success failure:(void (^)(NSError *))failure {
    
    sApiPath = @"orderRecord/payOrder";
    
    NSDictionary *paramDict = [param yy_modelToJSONObject];
    paramDict = [SecurityTool getAesDict:paramDict];
    
    [self requestWithParam:paramDict responseClass:[RedPacketResponseDict class] success:success failure:failure];
}

//微信支付宝支付商品订单
+ (void)chargeOrder:(ChargeOrderParam *)param success:(void (^)(RedPacketResponseDict *))success failure:(void (^)(NSError *))failure {
    
    sApiPath = @"orderRecord/chargeOrder";
    
    NSDictionary *paramDict = [param yy_modelToJSONObject];
    paramDict = [SecurityTool getAesDict:paramDict];
    
    [self requestWithParam:paramDict responseClass:[RedPacketResponseDict class] success:success failure:failure];
}

//未发货订单用户端退款 (加密接口)
+ (void)refundOrder:(RefundOrderParam *)param
            Success:(void (^)(RedPacketResponseDict *response))success
            failure:(void (^) (NSError *error))failure{
    NSDictionary *paramDict = [param yy_modelToJSONObject];
    paramDict = [SecurityTool getAesDict:paramDict];
    
    sApiPath = @"orderRecord/refundOrder";
    [super requestWithParam:paramDict responseClass:[RedPacketResponseDict class] success:success failure:failure];
}

//保证金订单支出
+ (void)payProveOrder:(PayProveOrderParam *)param
            Success:(void (^)(RedPacketResponseDict *response))success
            failure:(void (^) (NSError *error))failure{
    NSDictionary *paramDict = [param yy_modelToJSONObject];
    paramDict = [SecurityTool getAesDict:paramDict];
    
    sApiPath = @"orderRecord/payProveOrder";
    [super requestWithParam:paramDict responseClass:[RedPacketResponseDict class] success:success failure:failure];
}

//微信支付宝支付保证金
+ (void)chargeProveMoney:(ChargeProveMoneyParam *)param
              Success:(void (^)(RedPacketResponseDict *response))success
              failure:(void (^) (NSError *error))failure{
    NSDictionary *paramDict = [param yy_modelToJSONObject];
    paramDict = [SecurityTool getAesDict:paramDict];
    
    sApiPath = @"orderRecord/chargeProveMoney";
    [super requestWithParam:paramDict responseClass:[RedPacketResponseDict class] success:success failure:failure];
}

//微信支付宝支付已拍中商品
+ (void)chargeSellerGoodsOrder:(ChargeSellerGoodsOrderParam *)param
                 Success:(void (^)(RedPacketResponseDict *response))success
                 failure:(void (^) (NSError *error))failure{
    NSDictionary *paramDict = [param yy_modelToJSONObject];
    paramDict = [SecurityTool getAesDict:paramDict];
    
    sApiPath = @"orderRecord/chargeSellerGoodsOrder";
    [super requestWithParam:paramDict responseClass:[RedPacketResponseDict class] success:success failure:failure];
}

//拍卖品订单金额支出
+ (void)paySellerGoodsOrder:(PaySellerGoodsOrderParam *)param
                       Success:(void (^)(RedPacketResponseDict *response))success
                       failure:(void (^) (NSError *error))failure{
    NSDictionary *paramDict = [param yy_modelToJSONObject];
    paramDict = [SecurityTool getAesDict:paramDict];
    
    sApiPath = @"orderRecord/paySellerGoodsOrder";
    [super requestWithParam:paramDict responseClass:[RedPacketResponseDict class] success:success failure:failure];
}

@end

@implementation GetTipsByTopTimeParam

@end

@implementation RedPacketResponseDict
@end

@implementation RedPacketResponseArr

@end

@implementation PayOrderParam

@end

@implementation ChargeOrderParam

@end

@implementation RefundOrderParam
@end

@implementation PayProveOrderParam
@end

@implementation ChargeProveMoneyParam
@end

@implementation ChargeSellerGoodsOrderParam
@end

@implementation PaySellerGoodsOrderParam
@end
