//
//  SocialThirdController.m
//
//  Created by pengpeng on 16/10/25.
//  Copyright © 2016年 LieMi. All rights reserved.
//

#import "UIApplication+Extension.h"
#import "SocialThirdController.h"
#import "WXUserInfoRequest.h"
#import "SocialShareView.h"
#import "OpenShareHeader.h"
#import "WXTokenRequest.h"
#import "WeiboUserReq.h"
#import "MMShareView.h"

enum WXErrCode {
    WXSuccess           = 0,    /**< 成功    */
    WXErrCodeCommon     = -1,   /**< 普通错误类型    */
    WXErrCodeUserCancel = -2,   /**< 用户点击取消并返回    */
    WXErrCodeSentFail   = -3,   /**< 发送失败    */
    WXErrCodeAuthDeny   = -4,   /**< 授权失败    */
    WXErrCodeUnsupport  = -5,   /**< 微信不支持    */
};

typedef NS_ENUM(NSInteger, WeiboSDKResponseStatusCode)
{
    WeiboSDKCodeSuccess               = 0,//成功
    WeiboSDKCodeUserCancel            = -1,//用户取消发送
    WeiboSDKCodeSentFail              = -2,//发送失败
    WeiboSDKCodeAuthDeny              = -3,//授权失败
    WeiboSDKCodeUserCancelInstall     = -4,//用户取消安装微博客户端
    WeiboSDKCodeShareInSDKFailed      = -8,//分享失败 详情见response UserInfo
    WeiboSDKCodeUnsupport             = -99,//不支持的请求
};

@implementation SocialThirdController

static NSString * const kWeChatSecret = @"01f4f293eff0f8c45d8d8fc0c6043f90";
static NSString * const kWeChatAppId  = @"wx000d002a0f2a15c4";
static NSString * const kWeiboAppId   = @"2405115422";
static NSString * const kQQAppId      = @"1106111056";

static NSString * const kWXAuthScope  = @"snsapi_userinfo";

+ (void)registerThird
{
    [OpenShare connectQQWithAppId:kQQAppId];
    [OpenShare connectWeiboWithAppKey:kWeiboAppId];
    [OpenShare connectWeixinWithAppId:kWeChatAppId];
}

+ (BOOL)handleOpenURL:(NSURL *)url
{
    return [OpenShare handleOpenURL:url];
}

+ (BOOL)isQQInstalled
{
    return [OpenShare isQQInstalled];
}
+ (BOOL)isWeiboInstalled
{
    return [OpenShare isWeiboInstalled];
}
+ (BOOL)isWeixinInstalled
{
    return [OpenShare isWeixinInstalled];
}

#pragma mark - 第三方登录
+ (void)authWechatSuccess:(AuthSuccessBlock)success failure:(AuthFailureBlock)failure
{
    [OpenShare WeixinAuth:kWXAuthScope Success:^(NSDictionary *message) {
        NSString *code = [message objectForKey:@"code"];
        if (code.length == 0) {
            code = [message objectForKey:@"access_token"];
        }
        [self wxUserInfoWithCode:code success:success failure:failure];
        NSLog(@"微信登录成功:\n%@",message);
    } Fail:^(NSDictionary *message, NSError *error) {
        !failure ?: failure([self wechatErrorCode:error.code]);
        NSLog(@"微信登录失败:\n%@\n%@", message, error);
    }];
}

+ (void)authWeiboSuccess:(AuthSuccessBlock)success failure:(AuthFailureBlock)failure
{
    [OpenShare WeiboAuth:@"all" redirectURI:@"http://universe-home.palcomm.com.cn" Success:^(NSDictionary *message) {
        NSLog(@"微博登录成功:\n%@", message);
        NSString *token = [message objectForKey:@"token"];
        NSString *uid = [message objectForKey:@"userID"];
        [self wbUserInfoWithToken:token userID:uid success:success failure:failure];
    } Fail:^(NSDictionary *message, NSError *error) {
        !failure ?: failure([self weiboErrorCode:error.code]);
        NSLog(@"微博登录失败:\n%@\n%@", message, error);
    }];
}

+ (void)authQQSuccess:(AuthSuccessBlock)success failure:(AuthFailureBlock)failure
{
    [OpenShare QQAuth:@"get_user_info" Success:^(NSDictionary *message) {
        NSLog(@"QQ登录成功:\n%@", message);
        NSString *openId = [message objectForKey:@"openid"];
        !success ?: success(openId);
        
    } Fail:^(NSDictionary *message, NSError *error) {
        !failure ?: failure([self QQErrorCode:error.code]);
        NSLog(@"QQ登录失败:\n%@\n%@", error, message);
    }];
}

#pragma mark - 处理方法

+ (NSString *)filterHTML:(NSString *)html {
    
    NSScanner *scanner = [NSScanner scannerWithString:html];
    NSString *text = nil;
    while([scanner isAtEnd] == NO) {
        [scanner scanUpToString:@"<" intoString:nil];
        [scanner scanUpToString:@">" intoString:&text];
        html = [html stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@>",text] withString:@""];
    }
    return html;
}

#pragma mark - 第三方分享处理
+ (void)shareWebLink:(NSString *)url title:(NSString *)title content:(NSString *)content thumbnail:(UIImage *)thum completed:(ShareCompleted)completed
{
    MMShareView *share = [[MMShareView alloc] init];
    share.shareOperate = ^(SocialShareType shareType){
        OSMessage *msg = [OSMessage new];
        msg.title = title;
        msg.desc = [self filterHTML:content];
        msg.link = url;
        // 必须设置，不然微信出现“应用消息错误”
        msg.image = thum ?: [UIImage new];
        
        switch (shareType) {
            case SocialShareWXFriend:
                [self shareWXFriend:msg completed:completed];
                break;
            case SocialShareWXTimeline:
                [self shareWXTimeline:msg completed:completed];
                break;
            case SocialShareQQFriend:
                [self shareQQFriend:msg completed:completed];
                break;
            case SocialShareQQZone:
                [self shareQQZone:msg completed:completed];
                break;
            case SocialShareWeibo:
            {
                msg.title = [NSString stringWithFormat:@"分享了一个发耶app上的<<%@>>，邀请你一起来听！关注@发耶app，了解更多美好动态，全能小编等你来撩~%@",title,[NSURL URLWithString:url]];
                msg.desc = content;
                msg.link = nil;
                [self shareWeibo:msg completed:completed];
            }
                break;
            default:
                break;
        }
    };
    [share show];
}

+ (void)shareWXFriend:(OSMessage *)msg completed:(ShareCompleted)completed
{
    [OpenShare shareToWeixinSession:msg Success:^(OSMessage *message) {
        !completed ?: completed(YES, nil);
    } Fail:^(OSMessage *message, NSError *error) {
        !completed ?: completed(NO, [self wechatErrorCode:error.code]);
    }];
}

+ (void)shareWXTimeline:(OSMessage *)msg completed:(ShareCompleted)completed
{
    [OpenShare shareToWeixinTimeline:msg Success:^(OSMessage *message) {
        !completed ?: completed(YES, nil);
    } Fail:^(OSMessage *message, NSError *error) {
        !completed ?: completed(NO, [self wechatErrorCode:error.code]);
    }];
}

+ (void)shareQQFriend:(OSMessage *)msg completed:(ShareCompleted)completed
{
    [OpenShare shareToQQFriends:msg Success:^(OSMessage *message) {
        !completed ?: completed(YES, nil);
    } Fail:^(OSMessage *message, NSError *error) {
        !completed ?: completed(NO, [self QQErrorCode:error.code]);
    }];
}

+ (void)shareQQZone:(OSMessage *)msg completed:(ShareCompleted)completed
{
    [OpenShare shareToQQZone:msg Success:^(OSMessage *message) {
        !completed ?: completed(YES, nil);
    } Fail:^(OSMessage *message, NSError *error) {
        !completed ?: completed(NO, [self QQErrorCode:error.code]);
    }];
}

+ (void)shareWeibo:(OSMessage *)msg completed:(ShareCompleted)completed
{
    [OpenShare shareToWeibo:msg Success:^(OSMessage *message) {
        !completed ?: completed(YES, nil);
    } Fail:^(OSMessage *message, NSError *error) {
        !completed ?: completed(NO, [self weiboErrorCode:error.code]);
    }];
}

#pragma mark - Private Method

+ (void)wxUserInfoWithCode:(NSString *)codeAuth
                   success:(AuthSuccessBlock)success
                   failure:(AuthFailureBlock)failure
{
    WXTokenParam *param = [WXTokenParam new];
    param.grant_type = @"authorization_code";
    param.secret = kWeChatSecret;
    param.appid = kWeChatAppId;
    param.code = codeAuth;
    
    [WXTokenRequest accessTokenWithParam:param success:^(WXTokenResponse *response) {
        
        WXUserInfoParam *param = [WXUserInfoParam new];
        param.access_token = response.access_token;
        param.openid = response.openid;
        
        [WXUserInfoRequest userInfoWithParam:param success:^(WXUserInfo *response) {
            !success ?: success(response);
        } failure:^(NSError *error) {
            !failure ?: failure(@"网络不给力，请稍后重试");
        }];
    } failure:^(NSError *error) {
        !failure ?: failure(@"网络不给力，请稍后重试");
    }];
}

+ (void)wbUserInfoWithToken:(NSString *)token
                     userID:(NSString *)userID
                   success:(AuthSuccessBlock)success
                   failure:(AuthFailureBlock)failure
{
    WeiboUserParam *param = [WeiboUserParam new];
    param.access_token = token;
    param.uid = userID;
    
    [WeiboUserReq userInfoWithParam:param success:^(WeiboUserInfo *response) {
        !success ?: success(response.screen_name);
    } failure:^(NSError *error) {
        !failure ?: failure(@"网络不给力，请稍后重试");
    }];
}

+ (NSString *)wechatErrorCode:(NSInteger)errCode
{
    NSString *describe = nil;
    switch (errCode) {
        case WXErrCodeUserCancel:
            describe = @"您已取消操作";
            break;
        case WXErrCodeSentFail:
            describe = @"发送失败";
            break;
        case WXErrCodeAuthDeny:
            describe = @"微信授权失败";
            break;
        case WXErrCodeUnsupport:
            describe = @"微信不支持";
            break;
        default:
            describe = @"未知错误";
            break;
    }
    return describe;
}

+ (NSString *)QQErrorCode:(NSInteger)errCode
{
    NSString *describe = nil;
    switch (errCode) {
        case -4:
        case -1:
            describe = @"您已取消操作";
            break;
        default:
            describe = @"操作失败";
            break;
    }
    return describe;
}

+ (NSString *)weiboErrorCode:(NSInteger)errCode
{
    NSString *describe = nil;
    switch (errCode) {
        case WeiboSDKCodeUserCancel:
            describe = @"您已取消操作";
            break;
        case WeiboSDKCodeSentFail:
            describe = @"发送失败";
            break;
        case WeiboSDKCodeAuthDeny:
            describe = @"微博授权失败";
            break;
        case WeiboSDKCodeShareInSDKFailed:
            describe = @"微博分享失败";
            break;
        default:
            describe = @"未知错误";
            break;
    }
    return describe;
}
@end
