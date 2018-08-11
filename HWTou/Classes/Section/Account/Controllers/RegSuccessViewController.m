//
//  RegSuccessViewController.m
//  HWTou
//
//  Created by 赤 那 on 2017/3/21.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "RealNameAutViewController.h"

#import "PublicHeader.h"

#import "RegSuccessView.h"
#import "MainTabBarController.h"
#import "RegSuccessViewController.h"

@interface RegSuccessViewController ()<RegSuccessViewDelegate>

@property (nonatomic, strong) RegSuccessView *m_RegSuccessView;

@end

@implementation RegSuccessViewController
@synthesize m_RegSuccessView;

#pragma mark - Life Cycle
- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self setTitle:@"注册成功"];
    
    [self dataInitialization];
    [self addMainView];
    
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    
}

#pragma mark - Add UI
- (void)addMainView {

    [self addRegSuccessView];
    
}

- (void)addRegSuccessView {

    RegSuccessView *regSuccessView = [[RegSuccessView alloc] init];
    
    [regSuccessView setM_Delegate:self];
    
    [self setM_RegSuccessView:regSuccessView];
    [self.view addSubview:regSuccessView];
    
    [regSuccessView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.equalTo(self.view);
        
    }];
}

#pragma mark - Public Functions
- (void)dataInitialization{
    
    
}

#pragma mark - Button Handlers
- (void)onClickNavigationBack {
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark - RegSuccessView Delegate Manager
- (void)onGoToShopping {
    
//    CustomTabBarController *tabBarController = [[CustomTabBarController alloc] init];
    MainTabBarController *tabBarController = [[MainTabBarController alloc] init];
    [[UIApplication sharedApplication].keyWindow setRootViewController:tabBarController];
}

- (void)onGoToRealNameAuthentication {

    RealNameAutViewController *realNameAutVC = [[RealNameAutViewController alloc] init];
    [self.navigationController pushViewController:realNameAutVC animated:YES];
}

@end
