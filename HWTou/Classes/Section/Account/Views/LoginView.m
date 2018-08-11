//
//  LoginView.m
//  HWTou
//
//  Created by 赤 那 on 2017/3/20.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "LoginView.h"

#import "PublicHeader.h"
#import "RegularExTool.h"
#import "RongduManager.h"
#import "AccountManager.h"
#import "QuickRegistrationViewController.h"

#define Sign_in_icon_Password @"Sign_in_icon_Password"
#define Sign_in_icon_phone_number @"Sign_in_icon_phone_number"

@interface LoginView ()<UITextFieldDelegate>{
    
    LoginMode g_LoginMode;
    
}

@property (nonatomic, strong) UILabel *m_AccLbl;

@property (nonatomic, strong) UIView *m_AccLineView;

@property (nonatomic, strong) UITextField *m_AccTF;
@property (nonatomic, strong) UITextField *m_PwdTF;

@property (nonatomic, strong) UIButton *m_CipherBtn;

@end

@implementation LoginView
@synthesize m_Delegate;
@synthesize m_AccLbl;
@synthesize m_AccLineView;
@synthesize m_AccTF,m_PwdTF;
@synthesize m_CipherBtn;

#pragma mark - Life Cycle
- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]){
        
        [self dataInitialization];
        [self addViews];
        
    }
    
    return self;
    
}

#pragma mark - Add UI
- (void)addViews{
    //账号icon
    UIImageView * accIconImageView = [BasisUITool getImageViewWithImage:Sign_in_icon_phone_number withIsUserInteraction:NO];
    [self addSubview:accIconImageView];
    
    //账号
    UILabel *accLbl = [BasisUITool getBoldLabelWithTextColor:[UIColor blackColor]
                                                        size:CLIENT_COMMON_FONT_TITLE_SIZE];
    
    [accLbl setHidden:YES];
    [accLbl setTextAlignment:NSTextAlignmentCenter];
    
    [self setM_AccLbl:accLbl];
    [self addSubview:accLbl];
    
    UITextField *accTF = [BasisUITool getBoldTextFieldWithTextColor:[UIColor blackColor]
                                                           withSize:CLIENT_COMMON_FONT_INPUTBOX_SIZE
                                                    withPlaceholder:@"请输入手机号"
                                                       withDelegate:self];
    
    [accTF setKeyboardType:UIKeyboardTypeNumberPad];
    
    [self setM_AccTF:accTF];
    [self addSubview:accTF];
    
    UIView *accLineView = [[UIView alloc] init];
    [accLineView setBackgroundColor:UIColorFromHex(CLIENT_LINE_GRAY_BG)];
    [self setM_AccLineView:accLineView];
    [self addSubview:accLineView];
    
    UIImageView * pwdIconImageView = [BasisUITool getImageViewWithImage:Sign_in_icon_Password withIsUserInteraction:NO];
    [self addSubview:pwdIconImageView];
    
    UITextField * pwdTF = [BasisUITool getBoldTextFieldWithTextColor:[UIColor blackColor]
                                                            withSize:CLIENT_COMMON_FONT_INPUTBOX_SIZE
                                                     withPlaceholder:@"请输入密码"
                                                        withDelegate:self];
    
    [pwdTF setSecureTextEntry:YES];
    
    [self setM_PwdTF:pwdTF];
    [self addSubview:pwdTF];
    
    UIButton *cipherBtn = [BasisUITool getBtnWithTarget:self action:@selector(cipherSwitchBtnClick:)];
    
    [cipherBtn setImage:ImageNamed(PUBLIC_IMG_INVISIBLE_NOR) forState:UIControlStateNormal];
    [cipherBtn setImage:ImageNamed(PUBLIC_IMG_INVISIBLE_SEL) forState:UIControlStateDisabled];
    
    [self setM_CipherBtn:cipherBtn];
    [self addSubview:cipherBtn];
    
    UIView *pwdLineView = [[UIView alloc] init];
    [pwdLineView setBackgroundColor:UIColorFromHex(CLIENT_LINE_GRAY_BG)];
    [self addSubview:pwdLineView];
    
    UIButton *loginBtn = [BasisUITool getBtnWithTarget:self action:@selector(loginBtnClick:)];
    
    [loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    [loginBtn setBackgroundImage:[UIImage imageWithColor:UIColorFromHex(CLIENT_BTN_RED_NORMAL_BG)]
                        forState:UIControlStateNormal];
    [loginBtn setBackgroundImage:[UIImage imageWithColor:UIColorFromHex(CLIENT_BTN_GRAY_DISABLED_BG)]
                        forState:UIControlStateDisabled];
    
    [self addSubview:loginBtn];
    
    UIButton *forgetPwdBtn  = [BasisUITool getBtnWithTarget:self action:@selector(forgetPwdBtnClick:)];
    [forgetPwdBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [forgetPwdBtn setTitle:@"忘记密码?" forState:UIControlStateNormal];
    [forgetPwdBtn setTitleColor:UIColorFromHex(CLIENT_FONT_RED_COLOR) forState:UIControlStateNormal];
    [self addSubview:forgetPwdBtn];
    
    UIButton *regBtn = [BasisUITool getBtnWithTarget:self action:@selector(regBtnClick:)];
    [regBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    [regBtn setTitle:@"注册账号" forState:UIControlStateNormal];
    [regBtn setTitleColor:UIColorFromHex(CLIENT_FONT_RED_COLOR) forState:UIControlStateNormal];
    [self addSubview:regBtn];
    
    
    
    /* ********** layout UI ********** */
    
    [accIconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(100);
        make.left.mas_equalTo(41.5);
        make.size.equalTo(CGSizeMake(21.5, 21));
    }];
    
    [accLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(accIconImageView);
        make.left.equalTo(accIconImageView.mas_right).offset(10.5);
        make.right.mas_equalTo(self).offset(-46);
        make.height.equalTo(25);
    }];
    
    [accTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.trailing.equalTo(accLbl);
    }];
    
    [accLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(accTF.mas_bottom).offset(13);
        make.left.equalTo(accIconImageView);
        make.right.equalTo(accLbl);
        make.height.mas_equalTo(0.5);
    }];
    
    [pwdIconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(accIconImageView);
        make.size.equalTo(accIconImageView);
        make.top.equalTo(accLineView.mas_bottom).offset(15);
    }];
    
    [pwdTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(accTF);
        make.height.equalTo(accTF);
        make.right.equalTo(cipherBtn.mas_left).offset(-5);
        make.top.equalTo(pwdIconImageView);
    }];
    
    [cipherBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(pwdTF);
        make.trailing.equalTo(accLineView.trailing).offset(-8);
        make.size.equalTo(CGSizeMake(30, 30));
    }];
    
    [pwdLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(pwdTF.mas_bottom).offset(13);
        make.left.equalTo(accLineView);
        make.width.equalTo(accLineView);
        make.height.mas_equalTo(1);
    }];
    
    [loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(pwdLineView).offset(29.5);
        make.left.equalTo(self).offset(42);
        make.right.equalTo(self).offset(-42);
        make.height.equalTo(40);
    }];
    
    [forgetPwdBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(loginBtn.mas_bottom).offset(14.5);
        make.left.equalTo(loginBtn);
        make.width.equalTo(100);
        make.height.equalTo(40);
    }];
    
    [regBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(forgetPwdBtn);
        make.right.equalTo(loginBtn);
        make.width.equalTo(100);
        make.height.equalTo(40);
    }];
    
    
    
    /* ********** layout UI End ********** */
    
}

#pragma mark - Public Functions
- (void)dataInitialization{
    
    // 当键盘弹起时，点击背景收起键盘
    [[IQKeyboardManager sharedManager] setShouldResignOnTouchOutside:YES];
    
}

- (BOOL)dataValidation{
    
    NSString *accStr = m_AccTF.text;
    
//    if (g_LoginMode == LoginMode_Default) {
//
//        accStr = m_AccTF.text;
//
//    }else{
//
//        accStr = m_AccLbl.text;
//
//    }
    
    if (IsStrEmpty(accStr)) {
        
         [HUDProgressTool showOnlyText:@"请输入手机号!"];
        
        return NO;
        
    }
    
    if (IsStrEmpty(m_PwdTF.text)) {
        
        [HUDProgressTool showOnlyText:@"请输入密码!"];
        
        return NO;
        
    }
    
    return YES;
    
}

- (void)setLoginWay:(LoginMode)mode{
    
    switch (mode) {
        case LoginMode_Default:{
            
//            [m_AccLbl setHidden:YES];
//            [m_AccTF setHidden:NO];
//            [m_AccLineView setHidden:NO];
            
//            [m_AccLbl setText:nil];
            m_AccTF.text = @"";
            g_LoginMode = LoginMode_Default;
            
            break;}
        case LoginMode_ExistingAcc:{
            
//            [m_AccLbl setHidden:NO];
//            [m_AccTF setHidden:YES];
//            [m_AccLineView setHidden:YES];
            m_AccTF.text = [[AccountManager shared] account].userName;
//            [m_AccTF setText:[[AccountManager shared] account].userName];
            
            g_LoginMode = LoginMode_ExistingAcc;
            
            break;
        }
        default:
            break;
    }

    [m_PwdTF setText:nil];
    
}

#pragma mark - Button Handlers
- (void)cipherSwitchBtnClick:(id)sender{
    
    NSString *norStr;
    NSString *selStr;

    BOOL isVisible;
    
    if ([m_PwdTF isSecureTextEntry]) {// 不可见
        
        isVisible = NO;
        norStr = PUBLIC_IMG_VISIBLE_NOR;
        selStr = PUBLIC_IMG_VISIBLE_SEL;
 
    }else{
        
        isVisible = YES;
        norStr = PUBLIC_IMG_INVISIBLE_NOR;
        selStr = PUBLIC_IMG_INVISIBLE_SEL;
        
    }
    
    [m_PwdTF setSecureTextEntry:isVisible];
    [m_CipherBtn setImage:ImageNamed(norStr) forState:UIControlStateNormal];
    [m_CipherBtn setImage:ImageNamed(selStr) forState:UIControlStateDisabled];

}

- (void)loginBtnClick:(id)sender{

    if ([self dataValidation]) {
        
        NSString * accStr = m_AccTF.text;
        
//        if (g_LoginMode == LoginMode_Default) {
//
//            accStr = m_AccTF.text;
//
//        }else{
//
//            accStr = m_AccLbl.text;
//
//        }
        
        [self endEditing:YES];
        [self loginWithUserName:accStr password:m_PwdTF.text];
        
    }
    
}
//注册
- (void)regBtnClick:(id)sender{
    if (m_Delegate && [m_Delegate respondsToSelector:@selector(onToRegister)]) {
        [m_Delegate onToRegister];
    }
}

- (void)forgetPwdBtnClick:(id)sender{
    
    NSString *phone = m_AccTF.text;
    
    QuickRegistrationViewController *quickRegVC = [[QuickRegistrationViewController alloc] init];
    quickRegVC.type = QuickRegistrationTypeForgetPswd;
    
    [quickRegVC.m_QuickRegView setPhone:phone];
    [self.viewController.navigationController pushViewController:quickRegVC animated:YES];
}

#pragma mark - UITextField Delegate Methods
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    
    return YES;
    
}

#pragma mark - NetworkRequest Manager
- (void)loginWithUserName:(NSString *)acc password:(NSString *)pwd{
    
    [HUDProgressTool showIndicatorWithText:ReqLoadingIn];
    
    [AccountManager loginWithUserName:acc password:pwd complete:^(NSInteger code, NSString *msg, NSInteger uid) {
        
        if (code == kHttpCodeOperateSucceed) {
            
            [HUDProgressTool showSuccessWithText:@"登录成功!"];
            [[RongduManager share] autoLogin]; // 登录融都账号
            
            
            // 延迟执行
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                if (m_Delegate && [m_Delegate respondsToSelector:@selector(onLoginSuccessful)]) {
                    [m_Delegate onLoginSuccessful];
                }
            });
        } else {
            [HUDProgressTool showErrorWithText:msg];
        }
        
    } failure:^(NSError *error) {
        
        [HUDProgressTool showErrorWithText:ReqErrCode_Custom_ErrorInfo];
        
    }];
    
}

@end
