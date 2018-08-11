//
//  LaunchViewController.m
//
//  Created by pengpeng on 15/9/9.
//  Copyright (c) 2015年 PP. All rights reserved.
//

#import "CustomNavigationController.h"
#import "MainTabBarController.h"
#import "LaunchViewController.h"
#import "LoginViewController.h"
#import "AccountManager.h"
#import "DataStoreTool.h"
#import "PublicHeader.h"

@interface LaunchViewController ()

@property (nonatomic, strong) UIImageView   *imgvBackgroup;
@property (nonatomic, assign) BOOL          isShowAdComplete; // 展示广告完成
@property (nonatomic, assign) BOOL          isLoginComplete;  // 是否已经登录

@end

@implementation LaunchViewController

static NSString *startPicDir              = @"food.default";
static NSString *startPicName             = @"app_launch_ad.jpg";
static NSTimeInterval const kShowAdSecond = 0;

+ (UIViewController *)chooseRootViewController
{
    AccountModel *account = [AccountManager shared].account;
    if (account.token.length > 0) {
        
//        return [[CustomTabBarController alloc] init];
        return [[MainTabBarController alloc] init];
    } else {
        LoginViewController *loginVC = [[LoginViewController alloc] init];
        UIViewController *viewController = [[CustomNavigationController alloc]
                                            initWithRootViewController:loginVC];
        
        return viewController;
    }
}

#pragma mark - Life Cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    AccountModel *account = [AccountManager shared].account;
    self.isLoginComplete  = (account.token.length > 0) ? YES : NO;
    self.isShowAdComplete = YES;
    
    [self createUI];
    [self setupLaunchImage];
    [self startAnimations];
    [self getLaunchAdFromServer];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self performSelector:@selector(launchAdShowCompleted) withObject:nil afterDelay:kShowAdSecond];
}

- (void)dealloc
{
    NSLog(@"%s", __FUNCTION__);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)createUI
{
    self.view.backgroundColor = [UIColor whiteColor];
    self.imgvBackgroup = [[UIImageView alloc] init];
    self.imgvBackgroup.frame = self.view.frame;
    [self.view addSubview:self.imgvBackgroup];
}

- (void)startAnimations
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationRepeatAutoreverses:YES];
    [UIView setAnimationRepeatCount:CGFLOAT_MAX];
    [UIView setAnimationDuration:2.0f];
    
    self.imgvBackgroup.transform = CGAffineTransformMakeScale(1.12, 1.12);
    
    [UIView commitAnimations];
}

- (void)launchAdShowCompleted
{
    self.isShowAdComplete = YES;
    [self jumpViewControllerHandle];
}

#pragma mark - 屏幕旋转控制
- (BOOL)shouldAutorotate
{
    return NO;
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

#pragma mark - 配置启动图片
- (void)setupLaunchImage
{
    UIImage *imgLaunch = nil;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *startPicPath = [self getLaunchAdImagePath];
    if ([fileManager fileExistsAtPath:startPicPath])
    {
        imgLaunch = [UIImage imageWithContentsOfFile:startPicPath];
    }
    
    if (imgLaunch == nil)
    {
        imgLaunch = [self loadLaunchImage];
    }
    
    self.imgvBackgroup.image = imgLaunch;
}

#pragma mark - 读取启动画面的图片
- (UIImage *)loadLaunchImage
{
    if (kMainScreenHeight == 480) {
        return [UIImage imageNamed:@"LaunchImage-700"];
    } else if (kMainScreenHeight == 568) {
        return [UIImage imageNamed:@"LaunchImage-700-568h"];
    } else if (kMainScreenHeight == 667) {
        return [UIImage imageNamed:@"LaunchImage-800-667h"];
    } else if (kMainScreenHeight == 736) {
        return [UIImage imageNamed:@"LaunchImage-800-Portrait-736h"];
    } else {
        return [UIImage imageNamed:@"LaunchImage-800-667h"];
    }
}

#pragma mark - 从服务器获取启动页广告
- (void)getLaunchAdFromServer
{
    
}

- (void)downloadImageWithUrl:(NSString *)urlPath
{
    if (urlPath == nil) {
        return;
    }
    
    NSURL *url = [NSURL URLWithString:urlPath];
    SDWebImageDownloader *downloader = [SDWebImageDownloader sharedDownloader];
    [downloader downloadImageWithURL:url options:SDWebImageDownloaderUseNSURLCache progress:nil
                           completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
                               if (finished && data)
                               {
                                   [data writeToFile:[self getLaunchAdImagePath] atomically:YES];
                               }
                           }];
}

- (NSString *)getLaunchAdImagePath
{
    NSString *dirPath = [DataStoreTool currentDirAppendDir:[DataStoreTool getCachesDirectory]
                                                 appendDir:startPicDir];
    return [dirPath stringByAppendingPathComponent:startPicName];
}

#pragma mark - 页面跳转逻辑
- (void)jumpViewControllerHandle
{
    if (self.isShowAdComplete)
    {
        if (self.isLoginComplete) {
            [LaunchViewController jumpMainViewController];
        } else {
            [LaunchViewController jumpLoginViewController];
        }
    }
}

+ (void)jumpMainViewController
{
//    UIViewController *viewController = [[CustomTabBarController alloc] init];
    MainTabBarController *viewController = [[MainTabBarController alloc] init];
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window setRootViewController:viewController];
}

+ (void)jumpLoginViewController{
    
    UIViewController *viewController = [[LoginViewController alloc] init];
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    
    [window setRootViewController:viewController];
    
}

@end
