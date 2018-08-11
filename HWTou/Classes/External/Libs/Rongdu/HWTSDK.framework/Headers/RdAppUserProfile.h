//
//  RdAppUserProfile.h
//  RdP2PApp
//
//  Created by Yosef Lin on 10/21/15.
//  Copyright © 2015 Yosef Lin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RdAppUserProfile : NSObject


@property(nonatomic,copy)NSString*              bindingId;
/**
 *  用户id
 */

@property(nonatomic,copy)NSString*              userId;
/**
 *  用户名
 */
@property(nonatomic,copy)NSString*              userName;
/**
 *  登录认证信息
 */
@property(nonatomic,copy)NSString*              oauthToken;
/**
 *  刷新token
 */
@property(nonatomic,copy)NSString*              refresh_token;
/**
 *  生命周期
 */
@property(nonatomic,strong)NSString*              tokenExpiredTime;
/**
 *  手机号码
 */
@property(nonatomic,copy)NSString*              phoneNumber;
/**
 *  邮箱地址
 */
@property(nonatomic,copy)NSString*              emailAddress;
/**
 *  其他数据
 */
@property(nonatomic,strong)NSMutableDictionary* customAttributes;
/**
 *  是否登录
 */
@property(nonatomic,readonly)BOOL               isLogon;

/**
 *  HWT是否登录
 */
@property(nonatomic,readonly)BOOL               isHWTLogon;
/**
 *  密码
 */
@property(nonatomic,copy)NSString*              pwd;

/**
 *  手机号码
 */
@property(nonatomic,copy)NSString*              phoneFromHWT;
/**
 *  手机号码
 */
@property(nonatomic,copy)NSString*              pwdFromHWT;


+(RdAppUserProfile*)sharedInstance;

-(void)cleanUp;
-(BOOL)save;
-(BOOL)load;
-(void)updateTokenExpiredTime:(NSTimeInterval)life;

@end
