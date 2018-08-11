//
//  MoneyInfoRequest.h
//  HWTou
//
//  Created by Reyna on 2018/2/2.
//  Copyright © 2018年 LieMi. All rights reserved.
//

#import "BaseRequest.h"
#import "SessionRequest.h"

@interface MoneyInfoRequest : SessionRequest


/** 查看用户账户 */
+ (void)getUserAccountWithUid:(NSInteger)uid success:(void (^)(NSDictionary *response))success failure:(void (^) (NSError *error))failure;

/** 获取某一用户资金流水 */
+ (void)getFinancialRecordsWithPage:(int)page pageSize:(int)pageSize flag:(int)flag success:(void (^)(NSDictionary *response))success failure:(void (^) (NSError *error))failure;

/** 记录资金流水(提现) */
+ (void)recordFinanceWithFinancialType:(int)financialType financialDesc:(NSString *)financialDesc money:(NSString *)money account:(NSString *)account channel:(int)channel success:(void (^)(NSDictionary *response))success failure:(void (^) (NSError *error))failure;

/** 增加支付宝账户 */
+ (void)addAlipayAccountWithAccount:(NSString *)account idCard:(NSString *)idCard realName:(NSString *)realname success:(void (^)(NSDictionary *response))success failure:(void (^) (NSError *error))failure;

/** 是否增加过支付宝账户 */
+ (void)isAlipayAccountWithSuccess:(void (^)(NSDictionary *response))success failure:(void (^) (NSError *error))failure;

/** 查看支付宝账户 */
+ (void)getAlipayAccountWithSuccess:(void (^)(NSDictionary *response))success failure:(void (^) (NSError *error))failure;

/** 打赏收益流水记录 */
+ (void)getAnchorTipsInfoWithPage:(int)page pageSize:(int)pageSize flag:(int)flag success:(void (^)(NSDictionary *response))success failure:(void (^) (NSError *error))failure;

@end
