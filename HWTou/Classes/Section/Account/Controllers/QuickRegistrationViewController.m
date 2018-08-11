//
//  QuickRegistrationViewController.m
//  HWTou
//
//  Created by 赤 那 on 2017/3/20.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "QuickRegistrationViewController.h"

#import "PublicHeader.h"
#import "RegisterView.h"
#import "ForgetPwdView.h"
#import "LoginViewController.h"
#import "VerifyCodeViewController.h"
#import "AccountManager.h"

@interface QuickRegistrationViewController ()<ForgetPwdViewDelegate,RegisterViewDelegate>

@end

@implementation QuickRegistrationViewController

#pragma mark - Life Cycle
- (void)viewDidLoad{
    [super viewDidLoad];
    if (_type == QuickRegistrationTypeRegister) {
        self.navigationItem.title = @"注册";
    }else if (_type == QuickRegistrationTypeForgetPswd){
        self.navigationItem.title = @"找回密码";
    }else if (_type == QuickRegistrationTypePayPswd){
        self.navigationItem.title = @"支付密码设置";
    }
    [self addQuickRegView];
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    [[IQKeyboardManager sharedManager] setShouldResignOnTouchOutside:YES];
}

- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    
    [self.view endEditing:YES];
    
}

- (void)didReceiveMemoryWarning{
    
    [super didReceiveMemoryWarning];
    
}

#pragma mark - Add UI

- (void)addQuickRegView{
    
    if (_type == QuickRegistrationTypeForgetPswd || _type == QuickRegistrationTypePayPswd) {
        self.m_QuickRegView.type = _type;
        [self setM_QuickRegView:self.m_QuickRegView];
        [self.view addSubview:self.m_QuickRegView];
        
        [self.m_QuickRegView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
    }else if(_type == QuickRegistrationTypeRegister){
        [self.view addSubview:self.m_RegisterView];
        [self.m_RegisterView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
    }
}

#pragma mark - QuickRegView Delegate Manager
- (void)onToLogIn{
    
    NSArray *viewcontrollers = self.navigationController.viewControllers;
    
    if (viewcontrollers.count > 1 ) {
        
        [self.navigationController popViewControllerAnimated:YES];
        
    }else{
    
        LoginViewController *loginVC = [[LoginViewController alloc] init];
        
        [self.navigationController pushViewController:loginVC animated:YES];
        
    }

}

- (void)onNextStepWithRegPhone:(NSString *)regPhone pwd:(NSString *)pwd imgCode:(NSString *)imgCode{

    VerifyCodeType type;
    if (_type == QuickRegistrationTypeRegister) {
        type = VerifyCodeType_Register;
    }else if (_type == QuickRegistrationTypeForgetPswd){
        type = VerifyCodeType_Forget;
    }else{
        type = VerifyCodeType_PayPswd;
    }
    
    VerifyCodeViewController *verifyCodeVC = [[VerifyCodeViewController alloc]
                                              initWithVerifyCodeObtainType:type
                                              withPhone:regPhone pwd:pwd imgCode:imgCode];
    
    [self.navigationController pushViewController:verifyCodeVC animated:YES];
    
}

- (void)visitorLoginMode {
    
    [AccountManager loginByVisitorWithComplete:^(NSInteger code, NSString *msg, NSInteger uid) {
        if (code == kHttpCodeOperateSucceed) {
            
            [HUDProgressTool showSuccessWithText:@"登录成功!"];
            // 延迟执行
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                [[NSNotificationCenter defaultCenter] postNotificationName:NOTIF_LOGINSUCCESS
                                                                    object:nil];
            });
        } else {
            [HUDProgressTool showErrorWithText:msg];
        }
    } failure:^(NSError *error) {
        [HUDProgressTool showErrorWithText:ReqErrCode_Custom_ErrorInfo];
    }];
}

#pragma mark - getter
- (RegisterView *)m_RegisterView{
    if (!_m_RegisterView) {
        _m_RegisterView = [[RegisterView alloc] init];
        [_m_RegisterView setM_Delegate:self];
    }
    return _m_RegisterView;
}

-(ForgetPwdView *)m_QuickRegView{
    if (!_m_QuickRegView) {
        _m_QuickRegView = [[ForgetPwdView alloc] init];
        [_m_QuickRegView setM_Delegate:self];
    }
    return _m_QuickRegView;
}

@end
