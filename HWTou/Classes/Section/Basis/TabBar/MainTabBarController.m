//
//  MainTabBarController.m
//  HWTou
//
//  Created by Reyna on 2017/12/5.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import <HWTSDK/HWTAPI.h>
#import <HWTSDK/CustomNavigationVC.h>
#import "CustomNavigationController.h"
#import "MainTabBarController.h"
#import "ActivityViewController.h"
#import "InvestViewController.h"
#import "HomePageViewController.h"
#import "AudioPlayerViewController.h"
#import "ShopViewController.h"
#import "VersionUpdateTool.h"
#import "MeViewController.h"
#import "AccountManager.h"
#import "AppConfigMacro.h"
#import "RongduManager.h"
#import "PublicHeader.h"

@interface MainTabBarController () <UITabBarControllerDelegate>

@property (nonatomic, strong) UIViewController *selectVC;

@end

@implementation MainTabBarController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.delegate = self;
    [self setupTabBarController];
}

- (void)dealloc
{
    NSLog(@"%s", __FUNCTION__);
}

#pragma mark - 控制屏幕旋转方向
- (BOOL)shouldAutorotate
{
    return [self.selectedViewController shouldAutorotate];
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return [self.selectedViewController supportedInterfaceOrientations];
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return [self.selectedViewController preferredInterfaceOrientationForPresentation];
}

- (void)setupTabBarController
{
    self.view.backgroundColor = [UIColor whiteColor];
    self.tabBar.barTintColor = [UIColor colorWithWhite:0.98 alpha:1];
    
    HomePageViewController *homeVC = [[HomePageViewController alloc] init];
    [self addChlildViewContoller:homeVC controllerTitle:@"听说" tarBarImage:@"tab_btn_hear" selectImage:@"tab_btn_hear_click"];
    
    //    if ([VersionUpdateTool shared].showInvest == YES) { // 用于审核的时候隐藏
//    InvestViewController *investVC = [[InvestViewController alloc] init];
//    [self addChlildViewContoller:investVC controllerTitle:@"钱潮" tarBarImage:@"tab_btn_cft" selectImage:@"tab_btn_cft_click"];
    //    }
    
//    AudioPlayerViewController *playerVC = [[AudioPlayerViewController alloc] init];
//    [self addChlildViewContoller:playerVC controllerTitle:nil tarBarImage:nil selectImage:nil];
    
//    ShopViewController *shopVC = [[ShopViewController alloc] init];
//    [self addChlildViewContoller:shopVC controllerTitle:@"好选" tarBarImage:@"tab_btn_Online retailers" selectImage:@"tab_btn_Online retailers_click"];
    
    //    ActivityViewController *activityVC = [[ActivityViewController alloc] init];
    //    [self addChlildViewContoller:activityVC controllerTitle:@"美好生活" tarBarImage:@"tabbar_activity_nor" selectImage:@"tabbar_activity_sel"];
    
    MeViewController *meVC = [[MeViewController alloc] init];
    [self addChlildViewContoller:meVC controllerTitle:@"我的" tarBarImage:@"tab_btn_MY" selectImage:@"tab_btn_MY_click"];
    
//    self.tab
    
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(kMainScreenWidth / 2.0 - 49 / 2.0 - 5 , -10, 59, 59);
    [btn setBackgroundImage:[UIImage imageNamed:@"tabbar_np_normal"] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@"tabbar_np_playnon"] forState:UIControlStateNormal];
    btn.imageEdgeInsets = UIEdgeInsetsMake(-7, 0, 7, 0);
    btn.userInteractionEnabled = NO;
//    [btn addTarget:self action:@selector(playerBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.tabBar addSubview:btn];
}

/**
 *  @brief 添加子控制器到TabBar
 *
 *  @param childVC      子控制器
 *  @param title        选项卡标题
 *  @param image        选项卡图片
 *  @param selectImage  选项卡选中图片
 */
- (void)addChlildViewContoller:(UIViewController *)childVC
               controllerTitle:(NSString *)title
                   tarBarImage:(NSString *)image
                   selectImage:(NSString *)selectImage
{
    // 声明图片渲染模式（按原图不要渲染）
    UIImage *imgNormal = [[UIImage imageNamed:image] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImage *imgSelect = [[UIImage imageNamed:selectImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    if (title) {
        childVC.title = title;
        // 设置tabBarItem的普通文字大小
        NSMutableDictionary *dictTextAttrs = [NSMutableDictionary dictionary];
        [dictTextAttrs setObject:FontPFMedium(11.0f) forKey:NSFontAttributeName];
        [dictTextAttrs setObject:[UIColor colorWithWhite:0.498 alpha:1] forKey:NSForegroundColorAttributeName];
        [childVC.tabBarItem setTitleTextAttributes:dictTextAttrs forState:UIControlStateNormal];
        
        // 设置选项卡文字选中的文字颜色
        NSMutableDictionary *dictSelectText = [[NSMutableDictionary alloc] init];
        [dictSelectText setObject:[UIColor colorWithRed:0.706 green:0.157 blue:0.176 alpha:1] forKey:NSForegroundColorAttributeName];
        [childVC.tabBarItem setTitleTextAttributes:dictSelectText forState:UIControlStateSelected];
    } else {
        childVC.tabBarItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0);
    }
    
    childVC.tabBarItem.image = imgNormal;
    childVC.tabBarItem.title = title;
    childVC.tabBarItem.selectedImage = imgSelect;
    
    UIViewController *viewController = nil;
    if ([childVC isKindOfClass:[UINavigationController class]]) {
        viewController = childVC;
    } else {
        viewController = [[CustomNavigationController alloc] initWithRootViewController:childVC];
    }
    
    [self addChildViewController:viewController];
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    if (self.selectVC != viewController) {
        if ([self.selectVC isKindOfClass:[InvestViewController class]]) {
            // 退出赚铜钱模块
            [[RongduManager share] getInvestRecord];
        }
        if ([viewController isKindOfClass:[CustomNavigationVC class]]) {
            // 点击赚铜钱模块
            [[RongduManager share] getInvestList];
        }

        self.selectVC = viewController;
    }
}

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
{
    if ([AccountManager isNeedLogin]) {
        // 拦截点击“我的”事件，判断是否需要登录
        if ([viewController isKindOfClass:[UINavigationController class]]) {
            UINavigationController *naviContrller = (UINavigationController *)viewController;
            if ([naviContrller.topViewController isKindOfClass:[MeViewController class]] ||
                [naviContrller.topViewController isKindOfClass:[InvestViewController class]]) {
                [AccountManager showLoginView];
                return NO;
            }
        }
    }
    return YES;
}

@end
