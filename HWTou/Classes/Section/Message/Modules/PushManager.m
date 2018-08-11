//
//  PushManager.m
//  HWTou
//
//  Created by Reyna on 2017/12/25.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "PushManager.h"
#import "AccountManager.h"
#import <JPush/JPUSHService.h>
#import <UserNotifications/UserNotifications.h>
#import "UIApplication+Extension.h"
#import "MessageViewController.h"
#import "PersonHomeReq.h"
#import "PushMessageModel.h"
#import "Navigation.h"
#import "PersonalHomePageViewController.h"
#import "AudioPlayerViewController.h"
#import "CustomNavigationController.h"
#import "MainTabBarControllerConfig.h"
#import "PlayerHistoryModel.h"

@interface PushManager () <JPUSHRegisterDelegate>

// 远程通知内容
@property (nonatomic, strong) NSDictionary  *userInfo;
@property (nonatomic, assign) BOOL          isLaunchedByNotification;

@end

@implementation PushManager

static NSString *appKey = @"fc2c4ed5bc90c7f62513d210";
static NSString *channel = @"App Store";
static BOOL isProduction = FALSE;

SingletonM();

- (void)registerPushServer:(NSDictionary *)launchOptions {
    [self registerPushNotification];
    
    //如不需要使用IDFA，advertisingIdentifier 可为nil
    [JPUSHService setupWithOption:launchOptions appKey:appKey
                          channel:channel
                 apsForProduction:isProduction
            advertisingIdentifier:nil];
    
    //2.1.9版本新增获取registration id block接口。
    [JPUSHService registrationIDCompletionHandler:^(int resCode, NSString *registrationID) {
        if(resCode == 0){
            NSLog(@"registrationID获取成功：%@",registrationID);
        }
        else{
            NSLog(@"registrationID获取失败，code：%d",resCode);
        }
    }];
    
}

- (void)setPushDeviceToken:(NSData *)deviceToken {
    NSString *token = [[[[deviceToken description] stringByReplacingOccurrencesOfString:@"<" withString:@""] stringByReplacingOccurrencesOfString:@">" withString:@""] stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSLog(@"获取DeviceToken：%@",token);
    [JPUSHService registerDeviceToken:deviceToken];
    
    
    if (![AccountManager isNeedToken]) {
        [JPUSHService getAlias:^(NSInteger iResCode, NSString *iAlias, NSInteger seq) {
            
            NSInteger aliasLong = [AccountManager shared].account.uid;
            NSLog(@"获取Alias：%@ ---已登入的uid：%ld",iAlias,aliasLong);
            NSString *aliasStr = [NSString stringWithFormat:@"%ld",aliasLong];
            if (![iAlias isEqualToString:aliasStr]) {
                [self setPushAlias:aliasLong];
            }
        } seq:1];
    }
}
    
- (void)registerPushNotification {
    JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
    entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound;
    
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        //可以添加自定义categories
        //    if ([[UIDevice currentDevice].systemVersion floatValue] >= 10.0) {
        //      NSSet<UNNotificationCategory *> *categories;
        //      entity.categories = categories;
        //    }
        //    else {
        //      NSSet<UIUserNotificationCategory *> *categories;
        //      entity.categories = categories;
        //    }
    }
    [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
}

- (void)setPushAlias:(long)alias {
//    NSSet *tags = [NSSet set];
    NSString *aliasString = @"";
    if (alias == 0) {
        // 账号退出时销毁
    }
    else {
        // 账号登录时注册
//        NSString *sex = [Sessions getSex] == nil ? @"1" : [Sessions getSex];
//        NSString *cityCode = [NSString stringWithFormat:@"%ld", (long)[Sessions getAdCode]];
//        NSArray *array = @[sex, cityCode];
//        tags = [NSSet setWithArray:array];
        aliasString = [NSString stringWithFormat:@"%ld",alias];
    }
    
    [JPUSHService setAlias:aliasString completion:^(NSInteger iResCode, NSString *iAlias, NSInteger seq) {
        if (iResCode == 0) {
            NSLog(@"the iAlias is %@", iAlias);
        }
    } seq:1];
    
//    [JPUSHService setTags:tags completion:^(NSInteger iResCode, NSSet *iTags, NSInteger seq) {
//
//    } seq:1];
}

- (void)resetApplicationBadge {
    NSInteger badge = [[[NSUserDefaults standardUserDefaults] objectForKey:@"badge"] integerValue];
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:badge];
    
    [JPUSHService setBadge:badge];
}

#pragma mark - UNUserNotificationCenterDelegate
// iOS 10新增 无论本地推送还是远程推送都会走这个回调
- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void(^)())completionHandler {
    NSLog(@"%s", __FUNCTION__);
    [[PushManager shared] remoteNotificationHandle:response.notification.request.content.userInfo];
    completionHandler();
}

// App 在前台弹通知需要调用这个接口
- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions options))completionHandler {
    
    NSLog(@"%s", __FUNCTION__);
    //    completionHandler(UNNotificationPresentationOptionBadge | UNNotificationPresentationOptionSound | UNNotificationPresentationOptionAlert);
    
    [[PushManager shared] remoteNotificationHandle:notification.request.content.userInfo];
}

- (void)launchCompletedHandle {
    
    if (self.isLaunchedByNotification)
    {
        [self remoteNotificationHandle:self.userInfo];
        self.isLaunchedByNotification = NO;
        self.userInfo = nil;
    }
}

#pragma mark - 通知处理
- (void)remoteNotificationHandle:(NSDictionary *)userInfo {

    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
}

- (void)handleMessageNotifiy:(NSDictionary *)data {
    
    UIViewController *topViewController = [UIApplication topViewController];
    
    if ([topViewController isKindOfClass:[UIAlertController class]]) {
        [topViewController dismissViewControllerAnimated:NO completion:^{
            [self jumpMessageVC];
        }];
    } else {
        [self jumpMessageVC];
    }
}

- (void)jumpMessageVC {
    
    UIViewController *topViewController = [UIApplication topViewController];
    if ([topViewController isKindOfClass:[MessageViewController class]]) {
        
        MessageViewController *messageVC = (MessageViewController *)topViewController;
        if ([messageVC respondsToSelector:@selector(refreshListData)]) {
            [messageVC refreshListData];
        }
    } else {
        UINavigationController *topNaviController = topViewController.navigationController;
        MessageViewController *vcReach = [[MessageViewController alloc] init];
        [topNaviController pushViewController:vcReach animated:YES];
    }
}

- (void)showAlertViewWithMsg:(NSString *)msg {
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"发耶" message:msg delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alertView show];
}

#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#pragma mark- JPUSHRegisterDelegate
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
    NSDictionary * userInfo = notification.request.content.userInfo;
    
    UNNotificationRequest *request = notification.request; // 收到推送的请求
    UNNotificationContent *content = request.content; // 收到推送的消息内容
    
    NSNumber *badge = content.badge;  // 推送消息的角标
    NSString *body = content.body;    // 推送消息体
    UNNotificationSound *sound = content.sound;  // 推送消息的声音
    NSString *subtitle = content.subtitle;  // 推送消息的副标题
    NSString *title = content.title;  // 推送消息的标题
    
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
        NSLog(@"iOS10 前台收到远程通知:%@", [self logDic:userInfo]);
        
//        [rootViewController addNotificationCount];
    }
    else {
        // 判断为本地通知
        NSLog(@"iOS10 前台收到本地通知:{\nbody:%@，\ntitle:%@,\nsubtitle:%@,\nbadge：%@，\nsound：%@，\nuserInfo：%@\n}",body,title,subtitle,badge,sound,userInfo);
    }
    completionHandler(UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionSound|UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以设置
}

- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    UNNotificationRequest *request = response.notification.request; // 收到推送的请求
    UNNotificationContent *content = request.content; // 收到推送的消息内容
    
    NSNumber *badge = content.badge;  // 推送消息的角标
    NSString *body = content.body;    // 推送消息体
    UNNotificationSound *sound = content.sound;  // 推送消息的声音
    NSString *subtitle = content.subtitle;  // 推送消息的副标题
    NSString *title = content.title;  // 推送消息的标题
    
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
        NSLog(@"iOS10 收到远程通知:%@", [self logDic:userInfo]);
        
        
        
        PushMessageModel *pushModel = [PushMessageModel bindMessageDic:userInfo];
        if ([pushModel.tag isEqualToString:@"2"]) {
            if (pushModel.type == 2) {
                //跳转到链接
                [self PresentWebViewWithLinkURL:pushModel.msg_link];
            }
            else if (pushModel.type == 3) {
                //话题详情
                [self PresentPlayerDetailWithFlag:2 msg_link:pushModel.msg_link];
            }
            else if (pushModel.type == 4) {
                //聊吧详情
                [self PresentPlayerDetailWithFlag:3 msg_link:pushModel.msg_link];
            }
            else if (pushModel.type == 5) {
                //广播详情
                [self PresentPlayerDetailWithFlag:1 msg_link:pushModel.msg_link];
            }
        }
        else if ([pushModel.tag isEqualToString:@"1"]) {
            if (pushModel.type == 1) {
                //话题详情
                [self PresentPlayerDetailWithFlag:2 msg_link:pushModel.msg_link];
            }
            else if (pushModel.type == 2) {
                //广播详情
                [self PresentPlayerDetailWithFlag:1 msg_link:pushModel.msg_link];
            }
            else if (pushModel.type == 3) {
                //话题详情
                [self PresentPlayerDetailWithFlag:2 msg_link:pushModel.msg_link];
            }
            else if (pushModel.type == 4) {
                //聊吧详情
                [self PresentPlayerDetailWithFlag:3 msg_link:pushModel.msg_link];
            }
            else if (pushModel.type == 5) {
                //用户详情
                [self PresentUserInfoWithUid:pushModel.msg_link];
            }
            else if (pushModel.type == 6) {
                //话题详情
                [self PresentPlayerDetailWithFlag:2 msg_link:pushModel.msg_link];
            }
            else if (pushModel.type == 7) {
                //广播详情
                [self PresentPlayerDetailWithFlag:1 msg_link:pushModel.msg_link];
            }
            else if (pushModel.type == 8) {
                //话题详情
                [self PresentPlayerDetailWithFlag:2 msg_link:pushModel.msg_link];
            }
            else if (pushModel.type == 9) {
                //聊吧详情
                [self PresentPlayerDetailWithFlag:3 msg_link:pushModel.msg_link];
            }
        }
    }
    else {
        // 判断为本地通知
        NSLog(@"iOS10 收到本地通知:{\nbody:%@，\ntitle:%@,\nsubtitle:%@,\nbadge：%@，\nsound：%@，\nuserInfo：%@\n}",body,title,subtitle,badge,sound,userInfo);
    }

    completionHandler();  // 系统要求执行这个方法
}
#endif

// log NSSet with UTF8
// if not ,log will be \Uxxx
- (NSString *)logDic:(NSDictionary *)dic {
    if (![dic count]) {
        return nil;
    }
    NSString *tempStr1 =
    [[dic description] stringByReplacingOccurrencesOfString:@"\\u"
                                                 withString:@"\\U"];
    NSString *tempStr2 =
    [tempStr1 stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    NSString *tempStr3 =
    [[@"\"" stringByAppendingString:tempStr2] stringByAppendingString:@"\""];
    NSData *tempData = [tempStr3 dataUsingEncoding:NSUTF8StringEncoding];
    NSString *str =
    [NSPropertyListSerialization propertyListFromData:tempData
                                     mutabilityOption:NSPropertyListImmutable
                                               format:NULL
                                     errorDescription:NULL];
    return str;
}

#pragma mark - PresentViewController

//跳转到播放详情页
- (void)PresentPlayerDetailWithFlag:(int)flag msg_link:(NSString *)msg_link {
    
    PlayerHistoryModel *m = [[PlayerHistoryModel alloc] init];
    m.flag = flag;
    m.rtcId = [msg_link intValue];
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    CYLTabBarController *tabBarController = (CYLTabBarController *)window.rootViewController;
    CustomNavigationController *nav = (CustomNavigationController *)tabBarController.selectedViewController;
    UIViewController * baseVC = (UIViewController *)nav.visibleViewController;
    if([baseVC isKindOfClass:[AudioPlayerViewController class]]) {
        AudioPlayerViewController *vc = (AudioPlayerViewController *)baseVC;
        [vc reloadDataWithHistoryModel:m];
        return;
    }
    [Navigation showAudioPlayerViewController:nav radioModel:m];
}

//跳转到web页
- (void)PresentWebViewWithLinkURL:(NSString *)msg_link {
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    CYLTabBarController *tabBarController = (CYLTabBarController *)window.rootViewController;
    CustomNavigationController *nav = (CustomNavigationController *)tabBarController.selectedViewController;
    
     [Navigation showWebViewController:nav webLink:msg_link];
}

//跳转到用户详情页
- (void)PresentUserInfoWithUid:(NSString *)uid {
    
    NSInteger userID = [AccountManager shared].account.uid;
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    CYLTabBarController *tabBarController = (CYLTabBarController *)window.rootViewController;
    CustomNavigationController *nav = (CustomNavigationController *)tabBarController.selectedViewController;
    UIViewController * baseVC = (UIViewController *)nav.visibleViewController;
    if([baseVC isKindOfClass:[PersonalHomePageViewController class]]) {
        PersonalHomePageViewController *vc = (PersonalHomePageViewController *)baseVC;
        vc.buttonType = userID == [uid integerValue] ? editDataButtonType : dynamicButtonType;
        vc.uid = [uid integerValue];
        [vc refreshView];
        return;
    }
    
    [Navigation showPersonalHomePageViewController:baseVC attendType:userID == [uid integerValue] ? editDataButtonType : dynamicButtonType uid:[uid integerValue]];
}

@end
