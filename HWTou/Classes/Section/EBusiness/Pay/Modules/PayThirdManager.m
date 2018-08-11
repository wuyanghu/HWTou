//
//  PayThirdManager.m
//  HWTou
//
//  Created by 彭鹏 on 2017/4/5.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import <AlipaySDK/AlipaySDK.h>
#import <YYModel/YYModel.h>
#import "PayThirdManager.h"
#import "PayWechatDM.h"
#import "WXApi.h"

@interface PayWXManager : NSObject <WXApiDelegate>

+ (instancetype)shared;

@end

@implementation PayThirdManager

static PayCompletedBlock g_blockPayComplted;

static NSString* const kWXAppkey = @"wx000d002a0f2a15c4";

+ (void)registerThirdPay
{
    // 向微信注册
    [WXApi registerApp:kWXAppkey withDescription:@"HWTou"];
}

+ (BOOL)isWeixinInstalled
{
    return [WXApi isWXAppInstalled];
}

+ (void)aliPayWithOrder:(NSString *)orderStr completed:(PayCompletedBlock)completed
{
    g_blockPayComplted = completed;
    [[AlipaySDK defaultService] payOrder:orderStr fromScheme:@"HWTou" callback:^(NSDictionary *resultDic) {
        // 支付跳转H5页面进行支付，处理支付结果
        [self handleAliPayStatus:resultDic];
    }];
}

+ (void)wxPayWithParam:(PayWechatDM *)param completed:(PayCompletedBlock)completed
{
    g_blockPayComplted = completed;
    
    PayReq *payReq = [[PayReq alloc] init];
    payReq.partnerId = param.partnerid;
    payReq.prepayId = param.prepayid;
    payReq.nonceStr = param.noncestr;
    payReq.timeStamp = param.timestamp;
    payReq.package = param.package;
    payReq.openID = param.appid;
    payReq.sign = param.sign;
    
    [WXApi sendReq:payReq];
}

+ (void)handlePayResult:(NSURL *)resultUrl
{
    NSLog(@"%@", resultUrl);
    
    if ([resultUrl.host isEqualToString:@"safepay"]) {
        // 支付跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:resultUrl standbyCallback:^(NSDictionary *resultDic) {
            [self handleAliPayStatus:resultDic];
        }];
    } else {
        [WXApi handleOpenURL:resultUrl delegate:[PayWXManager shared]];
    }
}

+ (void)handleAliPayStatus:(NSDictionary *)resultDict
{
    NSNumber *code = [resultDict objectForKey:@"resultStatus"];
    NSString *msg = [resultDict objectForKey:@"memo"];
    
    BOOL success = NO;
    switch ([code integerValue]) {
        case 9000:  // 支付成功
            success = YES;
            break;
        case 4000:  // 支付失败
            msg = @"支付失败，请重试";
            break;
        case 5000:  // 重复请求
            msg = @"请勿重复支付";
            break;
        case 6001:  // 用户中途取消
            msg = @"无法完成支付，已被取消";
            break;
        case 6002:  // 网络连接出错
            msg = @"支付失败，请检查网络";
            break;
        default:
            break;
    }
    !g_blockPayComplted ?: g_blockPayComplted(success, msg);
    g_blockPayComplted = nil;
}
@end

@implementation PayWXManager

#pragma mark - LifeCycle
+ (instancetype)shared
{
    static dispatch_once_t onceToken;
    static PayWXManager *instance;
    dispatch_once(&onceToken, ^{
        instance = [[PayWXManager alloc] init];
    });
    return instance;
}

#pragma mark - WXApiDelegate
- (void)onResp:(BaseResp *)resp
{
    if ([resp isKindOfClass:[PayResp class]])
    {
        BOOL success = NO;
        NSString *msg;
        switch (resp.errCode) {
            case WXSuccess:  // 支付成功
                success = YES;
                msg = @"支付成功";
                break;
            case WXErrCodeUserCancel:  // 用户中途取消
                msg = @"无法完成支付，已被取消";
                break;
            case WXErrCodeUnsupport:  // 微信不支持
                msg = @"微信不支持，请升级微信后重试";
                break;
            default:
                msg = [NSString stringWithFormat:@"支付失败，请重试 [%d]", (int)resp.errCode];
                break;
        }
        !g_blockPayComplted ?: g_blockPayComplted(success, msg);
        g_blockPayComplted = nil;
    }
}

@end
