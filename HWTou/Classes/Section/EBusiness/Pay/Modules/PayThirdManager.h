//
//  PayThirdManager.h
//  HWTou
//
//  Created by 彭鹏 on 2017/4/5.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^PayCompletedBlock)(BOOL success, NSString *msg);

@class PayWechatDM;

@interface PayThirdManager : NSObject

/**
 注册第三方支付服务
 */
+ (void)registerThirdPay;

/*
 * 检查微信是否已被用户安装
 *
 * @return 微信已安装返回YES，未安装返回NO。
 */
+ (BOOL)isWeixinInstalled;

/**
 支付宝付款

 @param orderStr  订单签名
 @param completed 支付完成回调
 */
+ (void)aliPayWithOrder:(NSString *)orderStr
              completed:(PayCompletedBlock)completed;

/**
 微信付款

 @param param 微信支付参数
 @param completed 支付完成回调
 */
+ (void)wxPayWithParam:(PayWechatDM *)param
             completed:(PayCompletedBlock)completed;

/**
 处理支付宝结果

 @param resultUrl 回调地址
 */
+ (void)handlePayResult:(NSURL *)resultUrl;

@end
