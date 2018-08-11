//
//  RongduManager.h
//  HWTou
//
//  Created by 彭鹏 on 2017/7/5.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RongduManager : NSObject

+ (instancetype)share;

/**
 初始化融都SDK
 */
- (void)initRongduSDK;

/**
 登录融都账号
 */
- (void)autoLogin;

/**
 退出融都账号
 */
- (void)logout;

/**
 获取理财列表(发耶后台)
 */
- (void)getInvestList;


/**
 解绑融都账号
 */
- (void)unbindAccount;

/**
 获取理财记录
 */
- (void)getInvestRecord;


/**
 获取融都账号用户ID

 @return 用户id
 */
- (NSInteger)getRdUserId;

@end
