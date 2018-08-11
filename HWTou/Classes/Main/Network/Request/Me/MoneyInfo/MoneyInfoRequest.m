//
//  MoneyInfoRequest.m
//  HWTou
//
//  Created by Reyna on 2018/2/2.
//  Copyright © 2018年 LieMi. All rights reserved.
//

#import "MoneyInfoRequest.h"
#import "AccountManager.h"

@implementation MoneyInfoRequest

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

#pragma mark - 查看用户账户
+ (void)getUserAccountWithUid:(NSInteger)uid success:(void (^)(NSDictionary *))success failure:(void (^)(NSError *))failure {
    sApiPath = @"balance/getUserAccount";
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:@(uid) forKey:@"uid"];
    [self requestWithParam:dic responseClass:nil success:success failure:failure];
}

#pragma mark - 获取某一用户资金流水
+ (void)getFinancialRecordsWithPage:(int)page pageSize:(int)pageSize flag:(int)flag success:(void (^)(NSDictionary *))success failure:(void (^)(NSError *))failure {
    sApiPath = @"finance/getFinancialRecords";
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    NSString * token = [[AccountManager shared] account].token;
    [dic setObject:token!=nil?token:@"" forKey:@"token"];
    [dic setValue:@(page) forKey:@"page"];
    [dic setValue:@(pageSize) forKey:@"pagesize"];
    [dic setValue:@(flag) forKey:@"flag"];
    [self requestWithParam:dic responseClass:nil success:success failure:failure];
}

#pragma mark - 记录资金流水(提现)
+ (void)recordFinanceWithFinancialType:(int)financialType financialDesc:(NSString *)financialDesc money:(NSString *)money account:(NSString *)account channel:(int)channel success:(void (^)(NSDictionary *))success failure:(void (^)(NSError *))failure {
    
    sApiPath = @"finance/recordFinance";
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    NSString * token = [[AccountManager shared] account].token;
    [dic setObject:token!=nil?token:@"" forKey:@"token"];
    [dic setValue:@(financialType) forKey:@"financialType"];
    [dic setObject:financialDesc forKey:@"financialDesc"];
    [dic setObject:money forKey:@"money"];
    [dic setObject:account forKey:@"account"];
    [dic setValue:@(channel) forKey:@"channel"];
    
    [self requestWithParam:dic responseClass:nil success:success failure:failure];
}

#pragma mark - 增加支付宝账户
+ (void)addAlipayAccountWithAccount:(NSString *)account idCard:(NSString *)idCard realName:(NSString *)realname success:(void (^)(NSDictionary *))success failure:(void (^)(NSError *))failure {
    
    sApiPath = @"alipay/addAlipayAccount";
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    NSString * token = [[AccountManager shared] account].token;
    [dic setObject:token!=nil?token:@"" forKey:@"token"];
    [dic setObject:account forKey:@"account"];
    [dic setObject:idCard forKey:@"idCard"];
    [dic setObject:realname forKey:@"realname"];
    
    [self requestWithParam:dic responseClass:nil success:success failure:failure];
}

#pragma mark - 是否增加过支付宝账户
+ (void)isAlipayAccountWithSuccess:(void (^)(NSDictionary *))success failure:(void (^)(NSError *))failure {
    
    sApiPath = @"alipay/isAlipayAccount";
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    NSString * token = [[AccountManager shared] account].token;
    [dic setObject:token!=nil?token:@"" forKey:@"token"];
    
    [self requestWithParam:dic responseClass:nil success:success failure:failure];
}

#pragma mark - 查看支付宝账户
+ (void)getAlipayAccountWithSuccess:(void (^)(NSDictionary *))success failure:(void (^)(NSError *))failure {
    
    sApiPath = @"alipay/getAlipayAccount";
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    NSString * token = [[AccountManager shared] account].token;
    [dic setObject:token!=nil?token:@"" forKey:@"token"];
    
    [self requestWithParam:dic responseClass:nil success:success failure:failure];
}

#pragma mark - 打赏收益流水记录
+ (void)getAnchorTipsInfoWithPage:(int)page pageSize:(int)pageSize flag:(int)flag success:(void (^)(NSDictionary *))success failure:(void (^)(NSError *))failure {
    
    sApiPath = @"tipRecord/getAnchorTipsInfo";
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    NSString * token = [[AccountManager shared] account].token;
    [dic setObject:token!=nil?token:@"" forKey:@"token"];
    [dic setValue:@(page) forKey:@"page"];
    [dic setValue:@(pageSize) forKey:@"pagesize"];
    [dic setValue:@(flag) forKey:@"flag"];
    [self requestWithParam:dic responseClass:nil success:success failure:failure];
}

@end
