//
//  VerifyCodeViewController.m
//  HWTou
//
//  Created by LeoSteve on 2017/3/7.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "VerifyCodeViewController.h"
#import "PublicHeader.h"
#import "RegisterInfoFillViewController.h"
#import "SetPasswordViewController.h"
#import "ModifyPhoneSuccessViewController.h"
#import "SetPayPswdViewController.h"

@interface VerifyCodeViewController ()<VerifyCodeViewDelegate>{

    NSString *g_Phone;
    NSString * g_pwd;
    NSString * g_imgCode;
    VerifyCodeType g_VerifyCodeType;
    
}

@property (nonatomic, strong) VerifyCodeView *m_VerifyCodeView;

@end

@implementation VerifyCodeViewController
@synthesize m_VerifyCodeView;

#pragma mark - 初始化
- (id)initWithVerifyCodeObtainType:(VerifyCodeType)type withPhone:(NSString *)phone pwd:(NSString *)pwd imgCode:(NSString *)imgCode{
    self = [super init];
    if (self) {
        g_Phone = phone;
        g_pwd = pwd;
        g_VerifyCodeType = type;
        g_imgCode = imgCode;
    }
    return self;
}


- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:@"输入验证码"];
 
    VerifyCodeView *verifyCodeView = [[VerifyCodeView alloc] init];
    [verifyCodeView setM_Delegate:self];
    [verifyCodeView setVerifyCodeObtainType:g_Phone withVerifyCodeType:g_VerifyCodeType];
    [self setM_VerifyCodeView:verifyCodeView];
    [self.view addSubview:verifyCodeView];
    
    [verifyCodeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning{
    if (!IsNilOrNull(m_VerifyCodeView)) [m_VerifyCodeView closeTimer];
    [super didReceiveMemoryWarning];
}

#pragma mark - VerifyCodeView Delegate Manager
- (void)onModifyPhoneSuccessful{
    ModifyPhoneSuccessViewController *vc = [[ModifyPhoneSuccessViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)onNextStepWithVerCode:(NSString *)verCode withVerifyCodeType:(VerifyCodeType)type{
    
    switch (type) {
        case VerifyCodeType_Register:{// 发送注册短信验证码
            
            RegisterInfoFillViewController * registerInfoFillViewController = [[RegisterInfoFillViewController alloc]
                                                   init];
            registerInfoFillViewController.registerInfoFillView.phone = g_Phone;
            registerInfoFillViewController.registerInfoFillView.pwd = g_pwd;
            registerInfoFillViewController.registerInfoFillView.imgCode = g_imgCode;
            registerInfoFillViewController.registerInfoFillView.smsCode = [verCode intValue];
            
            [self.navigationController pushViewController:registerInfoFillViewController animated:YES];
            
            break;}
        case VerifyCodeType_Forget:{// 发送找回密码短信验证码
            
            SetPasswordViewController *setPwdVC = [[SetPasswordViewController alloc]
                                                   initWithOperationType:OperationType_Change
                                                   withPhone:g_Phone withVerCode:verCode];
            
            [self.navigationController pushViewController:setPwdVC animated:YES];
            
            break;}
        case VerifyCodeType_BindPhone:{// 发送绑定手机短信验证码

            break;}
        case VerifyCodeType_PayPswd:{
            SetPayPswdViewController * setPayVC = [[SetPayPswdViewController alloc] init];
            [self.navigationController pushViewController:setPayVC animated:YES];
        }
            break;
        default:
            break;
    }
    
}

@end
