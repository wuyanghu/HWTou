//
//  SocialThirdController.h
//
//  Created by pengpeng on 16/10/25.
//  Copyright © 2016年 LieMi. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  @brief 分享完成回调
 *
 *  @param success  是否分享成功
 *  @param errMsg   错误描述
 */
typedef void (^ShareCompleted)(BOOL success, NSString *errMsg);

/**
 *  @brief 授权成功回调
 *
 *  @param response 响应结果
 */
typedef void (^AuthSuccessBlock)(id response);

/**
 *  @brief 授权失败回调
 *
 *  @param describe 错误描述
 */
typedef void (^AuthFailureBlock)(NSString *describe);

@interface SocialThirdController : NSObject

/**
 *  @brief 注册第三方开放平台
 */
+ (void)registerThird;

/**
 *  @brief 处理第三方通过URL启动App时传递的数据
 *
 *  @param url 第三方启动第三方应用时传递过来的URL
 */
+ (BOOL)handleOpenURL:(NSURL *)url;

/**
 *  @brief  检测应用是否安装(QQ/微博/微信)
 *
 *  @return YES:已安装 NO:未安装
 */
+ (BOOL)isQQInstalled;
+ (BOOL)isWeiboInstalled;
+ (BOOL)isWeixinInstalled;

/**
 *  @brief 微信登录授权
 */
+ (void)authWechatSuccess:(AuthSuccessBlock)success
                  failure:(AuthFailureBlock)failure;
/**
 *  @brief QQ登录授权
 */
+ (void)authQQSuccess:(AuthSuccessBlock)success
              failure:(AuthFailureBlock)failure;
/**
 *  @brief 微博登录授权
 */
+ (void)authWeiboSuccess:(AuthSuccessBlock)success
                 failure:(AuthFailureBlock)failure;

/**
 *  @brief 分享web页类型
 *
 *  @param url       链接地址
 *  @param title     标题
 *  @param thum      缩略图
 *  @param completed 完成时回调
 */
+ (void)shareWebLink:(NSString *)url
               title:(NSString *)title
             content:(NSString *)content
           thumbnail:(UIImage *)thum
           completed:(ShareCompleted)completed;

@end
