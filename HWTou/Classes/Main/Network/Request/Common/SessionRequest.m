//
//  SessionRequest.m
//
//  Created by PP on 15/11/4.
//  Copyright (c) 2015年 LieMi. All rights reserved.
//

#import "CustomNavigationController.h"
#import "LoginViewController.h"
#import "HUDProgressTool.h"
#import "AccountManager.h"
#import "SessionRequest.h"
#import "BusinessConst.h"
#import "BaseResponse.h"
#import "BaseParam.h"
#import "PushManager.h"

@implementation SessionRequest

static NSInteger nTokenExpireCount = 0;

+ (NSURLSessionTask *)requestWithParam:(id)param
                         responseClass:(Class)response
                               success:(RequestSuccessBlock)success
                               failure:(RequestFailureBlock)failure
{
    NSURLSessionTask *session = nil;
    session =
    [super requestWithParam:param responseClass:response success:^(id result) {
        
        BOOL bSucceed = YES;
        if ([result isKindOfClass:[BaseResponse class]])
        {
            BaseResponse *baseResult = (BaseResponse *)result;
            if (baseResult.status == kHttpCodeTokenExpire)
            {
                bSucceed = NO;
                if (nTokenExpireCount >= 2) {   // 重试2次失败后直接进登录页面
                    nTokenExpireCount = 0;
                    [self jumpLoginWithHint:@"登录失败，请手动重试"];
                } else {
                    nTokenExpireCount++;
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(nTokenExpireCount * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [self tokenExpireWithParam:param resultClass:response success:success failure:failure];
                    });
                }
            } else {
                nTokenExpireCount = 0;
            }
        }
        
        if (bSucceed && success) {
            success(result);
        }
        
    } failure:failure];
    return session;
}

/**
 *  @brief token过期(自动登录后再重新请求)
 *
 *  @param param         过期请求参数
 *  @param resultClass   过期过期请求结果
 *  @param success       过期请求完成block
 *  @param failure       过期请求失败block
 */
+ (void)tokenExpireWithParam:(id)param
                 resultClass:(Class)resultClass
                     success:(RequestSuccessBlock)success
                     failure:(RequestFailureBlock)failure
{
    AccountModel *account = [[AccountManager shared] account];
    [AccountManager loginWithUserName:account.userName password:account.passWord complete:^(NSInteger code, NSString *msg, NSInteger uid) {
        
        if (code == kHttpCodeOperateSucceed) {
            // 需要更新param中过期的token
            BaseParam *baseParam = param;
            baseParam.token = [[AccountManager shared] account].token;
            
            [self requestWithParam:param responseClass:resultClass success:success failure:failure];
        } else if (code == 1200) {
            [self jumpLoginWithHint:@"已自动登出，请重新登录"];
        } else {
            [self jumpLoginWithHint:@"登录失败，请重新登录"];
        }
        
    } failure:failure];
}

+ (void)jumpLoginWithHint:(NSString *)text
{
    [AccountManager showLoginView];
    [AccountManager shared].account.token = nil;
    [AccountManager shared].account.isVisitorMode = NO;
    [[AccountManager shared] saveAccount];
    [[PushManager shared] setPushAlias:0];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [HUDProgressTool showOnlyText:text];
    });
    
}
@end
