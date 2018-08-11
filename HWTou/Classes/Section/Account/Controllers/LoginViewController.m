//
//  LoginViewController.m
//  HWTou
//
//  Created by 彭鹏 on 2017/3/5.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "LoginViewController.h"

#import "PublicHeader.h"

#import "LoginView.h"
#import "RongduManager.h"
#import "AccountManager.h"
#import "VerifyCodeViewController.h"
#import "QuickRegistrationViewController.h"

@interface LoginViewController ()<LoginViewDelegate>{
  
    LoginMode g_LoginMode;
    
}

@property (nonatomic, strong) LoginView *m_LoginView;

@end

@implementation LoginViewController
@synthesize m_LoginView;

#pragma mark - Life Cycle
- (void)viewDidLoad{
    
    [super viewDidLoad];
    
    [self setTitle:@"登录"];
    
    [self dataInitialization];
    [self addMainView];
    
    
    [[RongduManager share] logout];
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
}

- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    
    [self.view endEditing:YES];
    
}

- (void)didReceiveMemoryWarning{
    
    [super didReceiveMemoryWarning];
    
}

#pragma mark - Add UI
- (void)addMainView{
    
    [self addLoginView];
    
    [self addNaviRightBtn];
}

- (void)addNaviRightBtn {
    
    if (g_LoginMode == LoginMode_ExistingAcc) {
        UIBarButtonItem *leftItem = [UIBarButtonItem itemWithTitle:@"切换账号"
                                                         withColor:UIColorFromHex(NAVIGATION_FONT_RED_COLOR)
                                                            target:self
                                                            action:@selector(onNavigationCustomRightBtnClick:)];
        [self.navigationItem setLeftBarButtonItem:leftItem];
    }
    
    if ([[AccountManager shared] account].isVisitorMode) {
        UIBarButtonItem *rightItem = [UIBarButtonItem itemWithTitle:@"取消"
                                                          withColor:UIColorFromHex(NAVIGATION_FONT_RED_COLOR)
                                                             target:self
                                                             action:@selector(cancelAction:)];
        [self.navigationItem setRightBarButtonItem:rightItem];
    }
    else {
        UIBarButtonItem *rightItem = [UIBarButtonItem itemWithTitle:@"游客登录"
                                                          withColor:UIColorFromHex(NAVIGATION_FONT_RED_COLOR)
                                                             target:self
                                                             action:@selector(loginByVisitor:)];
        [self.navigationItem setRightBarButtonItem:rightItem];
    }
}

- (void)addLoginView{

    LoginView *loginView = [[LoginView alloc] init];
    
    [loginView setM_Delegate:self];
    [loginView setLoginWay:g_LoginMode];
    
    [self setM_LoginView:loginView];
    [self.view addSubview:loginView];
    
    [loginView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.equalTo(self.view);
        
    }];
    
}

#pragma mark - Public Functions
- (void)dataInitialization{
    
    AccountModel *accModel = [[AccountManager shared] account];
    
    g_LoginMode = IsStrEmpty(accModel.userName) ?  LoginMode_Default : LoginMode_ExistingAcc;
    
}

#pragma mark - Button Handlers
- (void)cancelAction:(id)sender {
    
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)loginByVisitor:(id)sender {
    
    [AccountManager loginByVisitorWithComplete:^(NSInteger code, NSString *msg, NSInteger uid) {
        if (code == kHttpCodeOperateSucceed) {
            
            [HUDProgressTool showSuccessWithText:@"登录成功!"];
            // 延迟执行
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                if (self.loginSuccess) {
                    self.loginSuccess();
                } else {
                    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIF_LOGINSUCCESS
                                                                        object:nil];
                }
            });
        } else {
            [HUDProgressTool showErrorWithText:msg];
        }
    } failure:^(NSError *error) {
        [HUDProgressTool showErrorWithText:ReqErrCode_Custom_ErrorInfo];
    }];
}

- (void)onNavigationCustomRightBtnClick:(id)sender{
    
    if (g_LoginMode == LoginMode_Default) {
        g_LoginMode = LoginMode_ExistingAcc;
    }else{
        g_LoginMode = LoginMode_Default;
    }
    
    [m_LoginView setLoginWay:g_LoginMode];
    
}

#pragma mark - LoginView Delegate Manager
- (void)onToRegister{
    
    NSArray *viewcontrollers = self.navigationController.viewControllers;
    
    if (viewcontrollers.count > 1 ) {
        
        [self.navigationController popViewControllerAnimated:YES];
        
    }else{
        
        QuickRegistrationViewController *quickRegVC = [[QuickRegistrationViewController alloc] init];
        quickRegVC.type = QuickRegistrationTypeRegister;
        [self.navigationController pushViewController:quickRegVC animated:YES];
        
    }
    
}

- (void)onLoginSuccessful{
    
    if (self.loginSuccess) {
        self.loginSuccess();
    } else {
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIF_LOGINSUCCESS
                                                            object:nil];
    }
}

- (void)onForgetPassword:(NSString *)phone{
    
    VerifyCodeViewController *verifyCodeVC = [[VerifyCodeViewController alloc]
                                              initWithVerifyCodeObtainType:VerifyCodeType_Forget
                                              withPhone:phone pwd:nil imgCode:nil];
    
    [self.navigationController pushViewController:verifyCodeVC animated:YES];
    
}

@end
