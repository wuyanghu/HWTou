//
//  AccountManager.h
//  HWTou
//
//  Created by LeoSteve on 16/8/14.
//  Copyright © 2016年 LieMi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SingletonMacro.h"
#import "AccountModel.h"

@class WXUserInfo;

@interface AccountManager : NSObject

SingletonH();

/**
 *  @brief 游客登录
 */
+ (void)loginByVisitorWithComplete:(void (^)(NSInteger code, NSString *msg, NSInteger))complete failure:(void (^)(NSError *error))failure;

/**
 *  @brief 登录授权
 *
 *  @param userName 用户名
 *  @param password 密码
 *  @param complete 请求完成回调
 *  @param failure  请求失败回调
 */
+ (void)loginWithUserName:(NSString *)userName password:(NSString *)password
                 complete:(void (^)(NSInteger code, NSString *msg, NSInteger))complete
                  failure:(void (^)(NSError *error))failure;
/**
 *  @brief 将原密码按一定的规则加密
 *
 *  @param password 密码
 *
 *  @return 加密后的密码
 */
+ (NSString *)passwordEncrypt:(NSString *)password;

/**
 *  @brief  保存账户
 *
 *  @return 成功或失败
 */
- (BOOL)saveAccount;

/**
 *  @brief  删除账号信息
 *
 *  @return 成功或失败
 */
- (BOOL)deleteAccount;

/**
 *  @brief  获取账号信息
 *
 *  @return 账号信息
 */
- (AccountModel *)account;

/**
 是否需要Token
 
 @return YES:需要Token NO:已经有Token
 */
+ (BOOL)isNeedToken;

/**
 是否需要登录
 
 @return YES:需要登录 NO:已经登录
 */
+ (BOOL)isNeedLogin;

/**
 显示登录页面
 */
+ (void)showLoginView;

/**
 获取设备信息
 */
+ (NSString *)getDevicePlatForm;

/**
 获取设备标示
 */
+ (NSString *)getIFDVCode;
    
@end

