//
//  PushManager.h
//  HWTou
//
//  Created by Reyna on 2017/12/25.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SingletonMacro.h"

@interface PushManager : NSObject

SingletonH();

/**
 *  @brief 注册推送服务
 *
 *  @param launchOptions App启动时系统提供的参数
 */
- (void)registerPushServer:(NSDictionary *)launchOptions;

/**
 *  @brief 设置推送设备token
 *
 *  @param deveiceToken 设备唯一标示
 */
- (void)setPushDeviceToken:(NSData *)deviceToken;

/**
 * @alias 绑定账号Uid到Alias
 */
- (void)setPushAlias:(long)alias;

/**
 *  @brief 远程通知数据处理
 *
 *  @param userInfo 用户数据
 */
- (void)remoteNotificationHandle:(NSDictionary *)userInfo;

/*
 * 清空app角标信息
 */
- (void)resetApplicationBadge;

@end
