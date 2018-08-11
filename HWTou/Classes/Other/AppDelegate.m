//
//  AppDelegate.m
//  HWTou
//
//  Created by 彭鹏 on 17/3/4.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import <UMMobClick/MobClick.h>
#import "QuickRegistrationViewController.h"
#import "CustomNavigationController.h"
#import "NSNotificationCenterMacro.h"
#import "UIApplication+Extension.h"
#import "MainTabBarControllerConfig.h"
#import "SocialThirdController.h"
#import "LoginViewController.h"
#import "VersionUpdateTool.h"
//#import "IQKeyboardManager.h"
#import "NSURL+Parameters.h"
#import "LaunchAdManager.h"
#import "PayThirdManager.h"
#import "DeviceInfoTool.h"
#import "RongduManager.h"
#import "ComFloorEvent.h"
#import "AppDelegate.h"
#import "InvestReq.h"
#import <AVFoundation/AVFAudio.h>
#import "AccountManager.h"
#import "LaunchIntroductionView.h"
#import "XHLaunchAd.h"
#import "RotRequest.h"
#import "HomeBannerListModel.h"
#import "PublicHeader.h"
#import "PushManager.h"
#import <AMapFoundationKit/AMapFoundationKit.h>
#import "RadioRequest.h"
#import "HighInfoPlayInstance.h"
#import "IFlyMSC/IFlyMSC.h"
#import "PlayerHistoryManager.h"
#import "AccountModel.h"
#import "NTESService.h"
#import "NTESAttachDecoder.h"
#import "NTESNetDetectManger.h"
#import <Pingpp/Pingpp.h>

#define APPID_VALUE           @"5a65847b"
NSString *NTESNotificationLogout = @"NTESNotificationLogout";

@interface AppDelegate ()<UITabBarControllerDelegate, CYLTabBarControllerDelegate>

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [self setupTabBarController];
    [self dataInitialization];
    [AMapServices sharedServices].apiKey = @"bbde77420a20166ac0f94ec5b6d9e2e0";
    
    [[PushManager shared] registerPushServer:launchOptions];

    return YES;
}

#pragma mark - URL拦截处理
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    [SocialThirdController handleOpenURL:url];
//    [PayThirdManager handlePayResult:url];
    [self handleOpenUrl:url];
    [Pingpp handleOpenURL:url withCompletion:nil];
    
    return YES;
}

// NOTE: 9.0以后使用新API接口
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options {
    
    [SocialThirdController handleOpenURL:url];
//    [PayThirdManager handlePayResult:url];
    [self handleOpenUrl:url];
    [Pingpp handleOpenURL:url withCompletion:nil];
    
    return YES;
}

- (void)handleOpenUrl:(NSURL *)url {
    if ([url.scheme isEqualToString:@"HWTou"] || [url.scheme isEqualToString:@"hwtou"]) {
        if ([url.host isEqualToString:@"www.hangwt.com"]) {
            NSDictionary *dict = [url getParameters];
            FloorItemDM *dmItem = [FloorItemDM new];
            dmItem.type = [[dict objectForKey:@"type"] integerValue];;
            dmItem.param = [dict objectForKey:@"param"];
            [ComFloorEvent handleEventWithFloor:dmItem];
        }
    }
}

#pragma mark - XHLaunchAd delegate
/**
 广告点击事件回调
 */
-(void)xhLaunchAd:(XHLaunchAd *)launchAd clickAndOpenModel:(id)openModel clickPoint:(CGPoint)clickPoint{
    NSDictionary * dict = (NSDictionary *)openModel;
    HomeBannerListModel * bannerModel = [HomeBannerListModel new];
    [bannerModel setValuesForKeysWithDictionary:dict];
    [Navigation showBanner:self.window.rootViewController bannerModel:bannerModel];
}

#pragma mark - RemoteNotifications 消息推送处理
// 获取deviceToken
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    NSLog(@"%s: %@", __FUNCTION__, deviceToken);
    [[PushManager shared] setPushDeviceToken:deviceToken];
}

// 注册远程推送服务失败
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"%s:%@", __FUNCTION__, error);
}

// 收到远程通知的回调
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    NSLog(@"%s", __FUNCTION__);
    [[PushManager shared] remoteNotificationHandle:userInfo];
}

#pragma mark - Public Functions
- (void)setupTabBarController {
    if ([AccountManager isNeedLogin]) {
        [self showQuickRegView];
    }else{
        [self initTabBarController];
    }
}

- (void)dataInitialization {
    [self setupNIMSDK];//网易直播sdk
    // 注册第三方支付服务
//    [PayThirdManager registerThirdPay];
    
    [SocialThirdController registerThird];
    
    // 键盘监控
    [[IQKeyboardManager sharedManager] setEnable:YES];
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:NO];
    
//    LaunchIntroductionView * launchView = [[LaunchIntroductionView alloc] init];
    if ([LaunchIntroductionView isFirstLauch]) {
        //配置导航页
        [LaunchIntroductionView sharedWithImages:@[@"guide1.png"]];
    }else{
        //配置广告数据
        [self setLaunchAdvert];
    }
    // 配置友盟统计
    [MobClick setAppVersion:[DeviceInfoTool getApplicationVersion]];
    UMConfigInstance.appKey = @"58f97c8ba40fa30bed00005d";
    [MobClick startWithConfigure:UMConfigInstance];
    
    // 科大讯飞 Set APPID
    NSString *initString = [[NSString alloc] initWithFormat:@"appid=%@",APPID_VALUE];
    [IFlySpeechUtility createUtility:initString];
    
    // 登录成功通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onLoginRespone:)
                                                 name:NOTIF_LOGINSUCCESS
                                               object:nil];
    // 显示登录界面通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onShowLoginRespone:)
                                                 name:NOTIF_SHOWLOGINVIEW
                                               object:nil];
    
    // 显示快速注册界面通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onShowQuickRegView:)
                                                 name:NOTIF_SHOWQUICKREGVIEW
                                               object:nil];
    
}

- (void)showLoginView
{
    LoginViewController *loginVC = [[LoginViewController alloc] init];
    
    CustomNavigationController *navCtl = [[CustomNavigationController alloc] initWithRootViewController:loginVC];
    
    [[UIApplication topViewController] presentViewController:navCtl animated:YES completion:nil];
    
}

- (void)showQuickRegView
{
    QuickRegistrationViewController *quickRegVC = [[QuickRegistrationViewController alloc] init];
    quickRegVC.type = QuickRegistrationTypeRegister;
    CustomNavigationController *navCtl = [[CustomNavigationController alloc]
                                          initWithRootViewController:quickRegVC];
    
    [self.window setRootViewController:navCtl];
    [self.window makeKeyAndVisible];
}

- (void)initTabBarController
{
    MainTabBarControllerConfig *tabBarControllerConfig = [[MainTabBarControllerConfig alloc] init];
    CYLTabBarController *mainTabBarController = tabBarControllerConfig.tabBarController;
    [self.window setRootViewController:mainTabBarController];
    mainTabBarController.delegate = self;
    [self.window makeKeyAndVisible];
}
//广告页
- (void)setLaunchAdvert{
    [RotRequest getAdvert:nil Success:^(DictResponse *response) {
        if (response.status != 200) {
            return ;
        }
        NSDictionary * dataDict = response.data;
        
        long long startTime = [dataDict[@"startTime"] longLongValue];
        long long endTime = [dataDict[@"endTime"] longLongValue];
        
        NSDate *datenow = [NSDate date];
        long long currentTime = (long long)[datenow timeIntervalSince1970]*1000;
        if (currentTime < startTime || currentTime>endTime) {
            return ;
        }
        //设置你工程的启动页使用的是:LaunchImage 还是 LaunchScreen.storyboard(不设置默认:LaunchImage)
        [XHLaunchAd setLaunchSourceType:SourceTypeLaunchScreen];
        
        XHLaunchImageAdConfiguration *imageAdconfiguration = [XHLaunchImageAdConfiguration defaultConfiguration];
        //广告图片URLString/或本地图片名(.jpg/.gif请带上后缀)
        imageAdconfiguration.imageNameOrURLString = dataDict[@"url"];
        //广告点击打开页面参数(openModel可为NSString,模型,字典等任意类型)
        imageAdconfiguration.openModel = dataDict;
        //网络图片缓存机制(只对网络图片有效)
        imageAdconfiguration.imageOption = XHLaunchAdImageRefreshCached;
        //图片填充模式
        imageAdconfiguration.contentMode = UIViewContentModeScaleToFill;
        //广告停留时间
        imageAdconfiguration.duration = [dataDict[@"time"] intValue];
        //后台返回时,是否显示广告
        imageAdconfiguration.showEnterForeground = NO;
        //显示图片开屏广告
        [XHLaunchAd imageAdWithImageAdConfiguration:imageAdconfiguration delegate:self];
        
    } failure:^(NSError *error) {

    }];
}

- (void)setupNIMSDK{
    NSString * loginPath = [[NIMSDK sharedSDK] currentLogFilepath];
    
    NSString *appKey        = @"bf2db8e50ad06648b5281099bbc69c97";
        
    NIMSDKOption *option    = [NIMSDKOption optionWithAppKey:appKey];
    option.apnsCername      = @"faye";
    option.pkCername        = @"";
    [[NIMSDK sharedSDK] registerWithOption:option];
    [NIMCustomObject registerCustomDecoder:[NTESAttachDecoder new]];
    [[NTESNetDetectManger sharedmanager]startNetDetect];
    
    AccountModel * accountModel = [[AccountManager shared] account];
    if (accountModel.imToken == nil) {
        NSLog(@"登出操作");
        [AccountManager showLoginView];
    }else{
        if (accountModel) {
            [[[NIMSDK sharedSDK] loginManager] login:[NSString stringWithFormat:@"%ld",accountModel.uid]
                                               token:accountModel.imToken
                                          completion:^(NSError *error) {
                                              if (error) {
                                                  NSLog(@"登录失败");
                                                  [AccountManager showLoginView];
                                              }else{
                                                  NSLog(@"登录成功");
                                                  [[NTESServiceManager sharedManager] start];
                                              }
                                          }];
            
        }
    }
}

#pragma mark - TabBarDelegate

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
    [[self cyl_tabBarController] updateSelectionStatusIfNeededForTabBarController:tabBarController shouldSelectViewController:viewController];
    return YES;
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectControl:(UIControl *)control {
    UIView *animationView;
    
    if ([control cyl_isTabButton]) {
        animationView = [control cyl_tabImageView];
    }
    // 即使 PlusButton 也添加了点击事件，点击 PlusButton 后也会触发该代理方法。
    if ([control cyl_isPlusButton]) {
        UIButton *button = CYLExternPlusButton;
        animationView = button.imageView;
    }
    NSLog(@"___%ld",[self cyl_tabBarController].selectedIndex);
    
    [self addScaleAnimationOnView:animationView repeatCount:1];
    
//    if ([self cyl_tabBarController].selectedIndex % 2 == 0) {
//        [self addScaleAnimationOnView:animationView repeatCount:1];
//    } else {
//        [self addRotateAnimationOnView:animationView];
//    }
    
}

//缩放动画
- (void)addScaleAnimationOnView:(UIView *)animationView repeatCount:(float)repeatCount {
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animation];
    animation.keyPath = @"transform.scale";
    animation.values = @[@1.0,@1.3,@0.9,@1.15,@0.95,@1.02,@1.0];
    animation.duration = 1;
    animation.repeatCount = repeatCount;
    animation.calculationMode = kCAAnimationCubic;
    [animationView.layer addAnimation:animation forKey:nil];
}

//旋转动画
- (void)addRotateAnimationOnView:(UIView *)animationView {
    animationView.layer.zPosition = 65.f / 2;
    [UIView animateWithDuration:0.32 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        animationView.layer.transform = CATransform3DMakeRotation(M_PI, 0, 1, 0);
    } completion:nil];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.70 delay:0 usingSpringWithDamping:1 initialSpringVelocity:0.2 options:UIViewAnimationOptionCurveEaseOut animations:^{
            animationView.layer.transform = CATransform3DMakeRotation(2 * M_PI, 0, 1, 0);
        } completion:nil];
    });
}

#pragma mark - NSNotification

- (void)onLoginRespone:(NSNotification *)notif{
    
    [self initTabBarController];
    
}

- (void)onShowLoginRespone:(NSNotification *)notif{
    
    [self showLoginView];
    
}

- (void)onShowQuickRegView:(NSNotification *)notif{

    [self showQuickRegView];
    
}

#pragma mark - 后台处理
- (void)requestRecordUserIsOnline:(BOOL)isEnterForeground{
    PlayerHistoryModel *newestPHModel = [[PlayerHistoryManager sharedInstance] readNewestPlayerHistoryModel];
    if (newestPHModel.flag != 3) {//如果不是聊吧，不发送消息
        return;
    }
    
    RecordUserIsOnlineParam * onlineParam = [RecordUserIsOnlineParam new];
    onlineParam.userPhone = [[AccountManager shared] account].userName;
    onlineParam.chatId = [HighInfoPlayInstance sharedInstance].chatId;
    if(isEnterForeground){//进前台
        NSLog(@"进前台");
        onlineParam.flag = 0;
    }else{//进后台
        NSLog(@"进后台");
        onlineParam.flag = 1;
    }
    //用户没有登录或退出登录
    if (onlineParam.userPhone == nil || [onlineParam.userPhone isEqualToString:@""]) {
        return;
    }
    //用户没有进入聊吧
    if (onlineParam.chatId <=0 ) {
        return;
    }
    
    [RadioRequest recordUserIsOnline:onlineParam success:^(NSDictionary * dict) {
        
    } failure:^(NSError * error) {
        
    }];
}

#pragma mark - Sup

//+(UIBackgroundTaskIdentifier)backgroundPlayerID:(UIBackgroundTaskIdentifier)backTaskId
//{
//    //设置并激活音频会话类别
//    AVAudioSession *session = [AVAudioSession sharedInstance];
//    [session setCategory:AVAudioSessionCategoryPlayback error:nil];
//    [session setActive:YES error:nil];
//    //允许应用程序接收远程控制
//    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
//    //设置后台任务ID
//    UIBackgroundTaskIdentifier newTaskId=UIBackgroundTaskInvalid;
//    newTaskId=[[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:nil];
//    if(newTaskId!=UIBackgroundTaskInvalid&&backTaskId!=UIBackgroundTaskInvalid)
//    {
//        [[UIApplication sharedApplication] endBackgroundTask:backTaskId];
//    }
//    return newTaskId;
//}

#pragma mark - AppDelegate

- (void)applicationWillResignActive:(UIApplication *)application {
//    [self requestRecordUserIsOnline:NO];
//    //开启后台处理多媒体事件
//    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
//    AVAudioSession *session = [AVAudioSession sharedInstance];
//    [session setActive:YES error:nil];
//    //后台播放
//    [session setCategory:AVAudioSessionCategoryPlayback error:nil];
    //这样做，可以在按home键进入后台后 ，播放一段时间，几分钟吧。但是不能持续播放网络歌曲，若需要持续播放网络歌曲，还需要申请后台任务id，具体做法是：
//    _bgTaskId=[AppDelegate backgroundPlayerID:_bgTaskId];
    //其中的_bgTaskId是后台任务UIBackgroundTaskIdentifier _bgTaskId;
    
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    [self requestRecordUserIsOnline:YES];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    
    [[PushManager shared] resetApplicationBadge];
}

- (void)applicationWillTerminate:(UIApplication *)application {
}

@end
