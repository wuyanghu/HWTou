//
//  PersonalSetUpViewController.m
//  HWTou
//
//  Created by 赤 那 on 2017/3/24.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "PersonalSetUpViewController.h"

#import "PublicHeader.h"
#import "RongduManager.h"
#import "AccountManager.h"
#import "AboutViewController.h"
#import "PersonalSetUpView.h"
#import "AddressManageViewController.h"
#import "ModifyLoginPwdViewController.h"
#import "ComFloorEvent.h"
#import "PushManager.h"
#import "ShieldViewController.h"
#import "AddresseeListViewController.h"
#import "QuickRegistrationViewController.h"

@interface PersonalSetUpViewController ()<PersonalSetUpViewDelegate>

@property (nonatomic, strong) PersonalSetUpView *personalSetView;

@end

@implementation PersonalSetUpViewController

#pragma mark - Life Cycle
- (void)viewDidLoad{
    
    [super viewDidLoad];
    
    [self setTitle:@"个人设置"];
    
    [self dataInitialization];
    [self addNotifications];
    [self addMainView];
    
}

- (void)dealloc
{
    [self removeNotifications];
    NSLog(@"%s", __func__);
}

#pragma mark - Notifications
// 注册通知
- (void)addNotifications
{
    // 开始活跃通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleDidBecomeActiveNotification:)
                                                 name:UIApplicationDidBecomeActiveNotification
                                               object:nil];
}
// 移除通知
- (void)removeNotifications
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

// 处理开始活动通知
- (void)handleDidBecomeActiveNotification:(NSNotification *)notification
{
    [_personalSetView rrefreshPushState];
}

#pragma mark - Add UI
- (void)addMainView{
    
    [self addPersonalSetUpView];
    
}

- (void)addPersonalSetUpView{
    
    _personalSetView = [[PersonalSetUpView alloc]
                                             initWithFrame:self.view.bounds];
    
    [_personalSetView setM_Delegate:self];
    
    [self.view addSubview:_personalSetView];
    
}

#pragma mark - Public Functions
- (void)dataInitialization{
    
    
    
}

#pragma mark - Button Handlers
- (void)showAlertController{
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil
                                                                             message:@"确认清除缓存吗?"
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消"
                                                        style:UIAlertActionStyleCancel
                                                      handler:nil]];

    [alertController addAction:[UIAlertAction actionWithTitle:@"清除" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        // 清除所有 url 缓存
        [[NSURLCache sharedURLCache] removeAllCachedResponses];
        [[SDImageCache sharedImageCache] clearDiskOnCompletion:^{
            [HUDProgressTool showOnlyText:@"缓存清除完成"];
        }];
    }]];
    
    [self presentViewController:alertController animated:YES completion:nil];
    
}

#pragma mark - PersonalSetUpView Delegate Manager
- (void)onLogOut
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil
                                                                             message:@"确认退出登录?"
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消"
                                                        style:UIAlertActionStyleCancel
                                                      handler:nil]];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        // 清除所有 url 缓存
        [[NSURLCache sharedURLCache] removeAllCachedResponses];
        
        // 清空token & password
        [[AccountManager shared] account].passWord = nil;
        [[AccountManager shared] account].token = nil;
        [[AccountManager shared] account].isVisitorMode = NO;
        [[AccountManager shared] saveAccount];
        [[PushManager shared] setPushAlias:0];
        // 返回到首页
        [[UIApplication topViewController].navigationController popToRootViewControllerAnimated:NO];
        [UIApplication topViewController].tabBarController.selectedIndex = 0;
        
        [AccountManager showLoginView];
        
        [[RongduManager share] logout];
    }]];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)onCellEventProcessing:(PSFuncType)funcType{

    UIViewController *vc;
    
    switch (funcType) {
        case PSFuncType_ConsigneeAddress:{// 收货人地址
            
            if ([AccountManager isNeedLogin]) {
                [AccountManager showLoginView];
                return;
            }
            
            vc = [[AddressManageViewController alloc] init];
            
            break;}
        case PSFuncType_PwdManage:{// 密码管理
            
            if ([AccountManager isNeedLogin]) {
                [AccountManager showLoginView];
                return;
            }
            vc = [[ModifyLoginPwdViewController alloc] init];
            
            break;}
        case PSFuncType_ClearCache:{// 清除缓存
            
            [self showAlertController];
            
            break;}
        case PSFuncType_About:{// 关于
            
            FloorItemDM * itemDM = [FloorItemDM new];
            itemDM.type = FloorEventParam;
            itemDM.title = @"关于发耶";
            itemDM.param = kApiAboutH5UrlHost;
            [ComFloorEvent handleEventWithFloor:itemDM];
            break;}
        case PSFuncType_Shiled:{//屏蔽
            vc = [[ShieldViewController alloc] init];
        }
            break;
        case PSFuncType_Addressee:{
            vc = [[AddresseeListViewController alloc] init];
        }
            break;
        case PSFuncType_SetPayPswd:{
            QuickRegistrationViewController * pswdVC = [[QuickRegistrationViewController alloc] init];
            pswdVC.type = QuickRegistrationTypePayPswd;
            vc = pswdVC;
        }
            break;
        default:
            break;
    }
    
    if (!IsNilOrNull(vc)) [self.navigationController pushViewController:vc animated:YES];
    
}

@end
