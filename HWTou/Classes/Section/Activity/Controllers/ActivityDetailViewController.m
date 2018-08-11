//
//  ActivityDetailViewController.m
//  HWTou
//
//  Created by 彭鹏 on 2017/4/11.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "ActivityDetailViewController.h"
#import "ProductDetailViewController.h"
#import "CustomNavigationController.h"
#import "UIBarButtonItem+Extension.h"
#import "UINavigationItem+Margin.h"
#import "ActivityNewsCollectReq.h"
#import "SocialThirdController.h"
#import "LoginViewController.h"
#import "ActivityCollectReq.h"
#import "ProductDetailDM.h"
#import "InterfaceDefine.h"
#import "ActivityNewsDM.h"
#import "AccountManager.h"
#import "PublicHeader.h"

@interface ActivityDetailViewController ()

@property (nonatomic, strong) UIButton *btnCollect;

@end

@implementation ActivityDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupMainUI];
    [self setupJSToOCEvent];
    [self loadWebWithUrl:[self getWebLink:YES]];
}

- (void)setupMainUI
{
    if (self.type == ActivityDetailNews) {
        [self setCustomTitle:self.dmNews.title];
    } else {
        [self setCustomTitle:self.dmActivity.title];
    }
    
    UIBarButtonItem *itemSeperator = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    [self.navigationItem addLeftBarButtonItem:itemSeperator fixedSpace:10];
}

- (void)setCustomTitle:(NSString *)title
{
    UILabel *labTitle = [BasisUITool getLabelWithTextColor:UIColorFromHex(0x333333) size:14.0f];
    labTitle.text = title;
    labTitle.textAlignment = NSTextAlignmentCenter;
    labTitle.frame = CGRectMake(0, 0, kMainScreenWidth, 44);
    [self.navigationItem setTitleView:labTitle];
}

- (void)setupJSToOCEvent
{
    static NSString *getSureToken = @"getSureToken";
    [self addScriptMethod:getSureToken];
    
    WeakObj(self);
    self.handleScript = ^(NSString *method, id param) {
        if ([method isEqualToString:getSureToken]) {
            // 旧版本刷新token方法，直接拼接URL并刷新
            [selfWeak refreshAccessToken];
        }
    };
}

// 刷新token方法
- (void)refreshAccessToken
{
    AccountModel *account = [[AccountManager shared] account];
    if (!IsStrEmpty(account.userName) && !IsStrEmpty(account.passWord)) {
        // 登录过，token过期处理
        [AccountManager loginWithUserName:account.userName
                                 password:account.passWord complete:^(NSInteger code, NSString *msg, NSInteger uid) {
            
            if (code == kHttpCodeOperateSucceed) {
                [self reloadWebWithUrl:[self getWebLink:YES]];
            } else {
                [HUDProgressTool showOnlyText:msg];
                [self jumpLoginVC];
            }
            
        } failure:^(NSError *error) {
            [HUDProgressTool showOnlyText:[error urlErrorCodeDescribe]];
        }];
    } else {
        [self jumpLoginVC];
    }
}

- (void)jumpLoginVC
{
    LoginViewController *loginVC = [[LoginViewController alloc] init];
    
    WeakObj(loginVC);
    loginVC.loginSuccess = ^{
        [loginVCWeak dismissViewControllerAnimated:YES completion:nil];
        [self reloadWebWithUrl:[self getWebLink:YES]];
    };
    
    CustomNavigationController *navCtl = [[CustomNavigationController alloc] initWithRootViewController:loginVC];
    [self presentViewController:navCtl animated:YES completion:nil];
}

- (NSString *)getWebLink:(BOOL)needToken
{
    NSString *link;
    NSString *token;
    if (needToken) {
        token = [[AccountManager shared] account].token;
    }
    
    if (IsStrEmpty(token)) {
        token = @"1"; // 用于H5内部区分
    }
    
    if (self.type == ActivityDetailNews) {
        link = self.dmNews.link;
        if (self.dmNews.type == 1) { // 内部模板
            link = [NSString stringWithFormat:@"%@/%@?id=%ld&access_token=%@", kHomeServerHost, kApiNewsDetail, (long)self.dmNews.news_id, token];
        }
    } else {
        link = [NSString stringWithFormat:@"%@/%@?id=%ld&access_token=%@", kHomeServerHost, kApiActiDetail, (long)self.dmActivity.act_id, token];
    }
    return link;
}
@end
