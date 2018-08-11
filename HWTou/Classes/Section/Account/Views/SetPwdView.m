//
//  SetPwdView.m
//  HWTou
//
//  Created by 赤 那 on 2017/3/21.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "SetPwdView.h"
#import "PublicHeader.h"
#import "RegularExTool.h"
#import "SignupRequest.h"
#import "AccountManager.h"
#import "ModifyPWRequest.h"
#import "RongduManager.h"

#define password_modification_icon_guess_the_input_again @"password_modification_icon_guess_the_input_again"
#define password_modification_icon_set_new_password @"password_modification_icon_set_new_password"

@interface SetPwdView ()<UITextFieldDelegate>{

    NSString *g_Phone;
    NSString *g_VerCode;
    OperationType g_OperationType;
    
}

@property (nonatomic, strong) UIButton *m_SubmitBtn;

@property (nonatomic, strong) UIView *m_AccLineView;

@property (nonatomic, strong) UITextField *m_AccTF;//设置新密码
@property (nonatomic, strong) UITextField *m_PwdTF;//请再次输入密码

@property (nonatomic, strong) UIButton *m_CipherBtn;
@end

@implementation SetPwdView
@synthesize m_Delegate;
@synthesize m_CipherBtn,m_SubmitBtn;

#pragma mark - Life Cycle
- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]){
        
        [self dataInitialization];
        [self addMainView];
        
    }
    
    return self;
    
}

#pragma mark - Add UI
- (void)addMainView{
    
    [self addViews];
    
}

- (void)addViews{
    //账号icon
    UIImageView * accIconImageView = [BasisUITool getImageViewWithImage:password_modification_icon_set_new_password withIsUserInteraction:NO];
    [self addSubview:accIconImageView];

    
    UITextField *accTF = [BasisUITool getBoldTextFieldWithTextColor:[UIColor blackColor]
                                                           withSize:CLIENT_COMMON_FONT_INPUTBOX_SIZE
                                                    withPlaceholder:@"设置新密码"
                                                       withDelegate:self];
    [self setM_AccTF:accTF];
    [self addSubview:accTF];
    
    UIView *accLineView = [[UIView alloc] init];
    [accLineView setBackgroundColor:UIColorFromHex(CLIENT_LINE_GRAY_BG)];
    [self setM_AccLineView:accLineView];
    [self addSubview:accLineView];
    
    UIImageView * pwdIconImageView = [BasisUITool getImageViewWithImage:password_modification_icon_guess_the_input_again withIsUserInteraction:NO];
    [self addSubview:pwdIconImageView];
    
    UITextField * pwdTF = [BasisUITool getBoldTextFieldWithTextColor:[UIColor blackColor]
                                                            withSize:CLIENT_COMMON_FONT_INPUTBOX_SIZE
                                                     withPlaceholder:@"请再次输入密码"
                                                        withDelegate:self];
    
//    [pwdTF setSecureTextEntry:YES];
    
    [self setM_PwdTF:pwdTF];
    [self addSubview:pwdTF];
    
    UIView *pwdLineView = [[UIView alloc] init];
    [pwdLineView setBackgroundColor:UIColorFromHex(CLIENT_LINE_GRAY_BG)];
    [self addSubview:pwdLineView];
    
    UIButton *loginBtn = [BasisUITool getBtnWithTarget:self action:@selector(submitBtnClick:)];
    
    [loginBtn setTitle:@"提交" forState:UIControlStateNormal];
    [loginBtn setBackgroundImage:[UIImage imageWithColor:UIColorFromHex(CLIENT_BTN_RED_NORMAL_BG)]
                        forState:UIControlStateNormal];
    [loginBtn setBackgroundImage:[UIImage imageWithColor:UIColorFromHex(CLIENT_BTN_GRAY_DISABLED_BG)]
                        forState:UIControlStateDisabled];
    
    [self addSubview:loginBtn];
    
    /* ********** layout UI ********** */
    
    [accIconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(100);
        make.left.mas_equalTo(41.5);
        make.size.equalTo(CGSizeMake(21.5, 21));
    }];
    
    [accTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.height.equalTo(accIconImageView);
        make.left.equalTo(accIconImageView.right).offset(10);
        make.right.equalTo(self).offset(-41.5);
    }];
    
    [accLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(accTF.mas_bottom).offset(13);
        make.left.equalTo(accIconImageView);
        make.right.equalTo(accTF);
        make.height.mas_equalTo(0.5);
    }];
    
    [pwdIconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(accIconImageView);
        make.size.equalTo(accIconImageView);
        make.top.equalTo(accLineView.mas_bottom).offset(15);
    }];
    
    [pwdTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(accTF);
        make.size.equalTo(accTF);
        make.top.equalTo(pwdIconImageView);
    }];
    
    [pwdLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(pwdTF.mas_bottom).offset(13);
        make.left.equalTo(accLineView);
        make.width.equalTo(accLineView);
        make.height.mas_equalTo(accLineView);
    }];
    
    [loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(pwdLineView).offset(29.5);
        make.left.equalTo(self).offset(42);
        make.right.equalTo(self).offset(-42);
        make.height.equalTo(40);
    }];
    
    /* ********** layout UI End ********** */
    
}

#pragma mark - Public Functions
- (void)dataInitialization{
    
    g_Phone = nil;
    g_VerCode = nil;
    
    // 当键盘弹起时，点击背景收起键盘
    [[IQKeyboardManager sharedManager] setShouldResignOnTouchOutside:YES];
    
}

- (void)setOperationType:(OperationType)type withPhone:(NSString *)phone
             withVerCode:(NSString *)verCode{

    g_Phone = phone;
    g_VerCode = verCode;
    g_OperationType = type;
}

#pragma mark - Button Handlers
- (void)cipherSwitchBtnClick:(id)sender{

    NSString *norStr;
    NSString *selStr;
    
    BOOL isVisible;
    
    if ([_m_PwdTF isSecureTextEntry]) {// 不可见
        
        isVisible = NO;
        norStr = PUBLIC_IMG_VISIBLE_NOR;
        selStr = PUBLIC_IMG_VISIBLE_SEL;
        
    }else{
        
        isVisible = YES;
        norStr = PUBLIC_IMG_INVISIBLE_NOR;
        selStr = PUBLIC_IMG_INVISIBLE_SEL;
        
    }
    
    [_m_PwdTF setSecureTextEntry:isVisible];
    [m_CipherBtn setImage:ImageNamed(norStr) forState:UIControlStateNormal];
    [m_CipherBtn setImage:ImageNamed(selStr) forState:UIControlStateDisabled];
    
}

- (void)submitBtnClick:(id)sender{
    [_m_AccTF resignFirstResponder];
    [_m_PwdTF resignFirstResponder];
    NSString *pwdStr = _m_PwdTF.text;
    
    if (![_m_AccTF.text isEqualToString:_m_PwdTF.text]) {
        [HUDProgressTool showOnlyText:@"密码不一致"];
        return;
    }
    
    if ([RegularExTool validatePassWord:pwdStr]) {
        
        switch (g_OperationType) {
            case OperationType_Reg:{
                
                SignupParam *param = [[SignupParam alloc] init];
                
                [param setPhone:g_Phone];
                [param setPassword:pwdStr];
                [param setCode:g_VerCode];
                [param setPhoneType:[AccountManager getDevicePlatForm]];
                [param setPhoneDevice:[AccountManager getIFDVCode]];
                
                [self userRegistration:param];
                
                break;}
            case OperationType_Change:{
                
                ModifyPWParam *param = [[ModifyPWParam alloc] init];
                
                [param setPhone:g_Phone];
                [param setNPassword:pwdStr];
                [param setSmsCode:g_VerCode];
                
                [self changePasswordWithParam:param];
                
                break;}
            default:
                break;
        }
        
    }else{
        
        [HUDProgressTool showOnlyText:@"为了您的账号安全，密码应由6位以上的数字和字母组成"];
        
    }
    
}

#pragma mark - UITextField Delegate Methods
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    
    return YES;
    
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    
    if ([textField isEqual:_m_PwdTF]) {// 获得焦点
        
        BOOL isEnabled = textField.text.length > 6 ? YES : NO;
        
        [m_SubmitBtn setEnabled:isEnabled];
        
    }
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    
    if ([textField isEqual:_m_PwdTF]){// 失去焦点操作
        
        BOOL isEnabled = textField.text.length > 6 ? YES : NO;
        
        [m_SubmitBtn setEnabled:isEnabled];
        
    }
    
}

- (BOOL)textFieldShouldClear:(UITextField *)textField{
    
    if ([textField isEqual:_m_PwdTF]){// 清除按钮
        
        [m_SubmitBtn setEnabled:NO];
        
    }
    
    return YES;
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range
replacementString:(NSString *)string{
    
    if ([textField isEqual:_m_PwdTF]){
        
        NSInteger existedLength = textField.text.length;
        NSInteger selectedLength = range.length;
        NSInteger replaceLength = string.length;
        
        NSInteger length = existedLength - selectedLength + replaceLength;
        
        if (string.length == 0 && length <= 6) {
            
            [m_SubmitBtn setEnabled:NO];
            
            return YES;
            
        }
        
        BOOL isEnabled = length >= 6 ? YES : NO;
        
        [m_SubmitBtn setEnabled:isEnabled];
        
    }
    
    return YES;
    
}

#pragma mark - NetworkRequest Manager
- (void)userRegistration:(SignupParam *)model{
    
    [HUDProgressTool showIndicatorWithText:ReqLoadingIn];
    
    [SignupRequest signupWithParam:model success:^(SignupResponse *response) {
        
        if (response.status == 200) {// 注册成功后自动登录 （只登陆一次无论成功与否都跳转到注册成功界面 PS：和安卓处理一致）
            
            [HUDProgressTool dismiss];
            
            [self loginWithUserName:model.phone password:model.password];
            
            
        }else{
            
            [HUDProgressTool showErrorWithText:response.msg];
            
        }
        
    } failure:^(NSError *error) {
        
        [HUDProgressTool showErrorWithText:ReqErrCode_Custom_ErrorInfo];
        
    }];
    
}

- (void)changePasswordWithParam:(ModifyPWParam *)param{
    
    [HUDProgressTool showIndicatorWithText:ReqLoadingIn];
    
    [ModifyPWRequest modifyPWWithParam:param success:^(ModifyPWResponse *response) {
        
        if (response.status == 200) {
            [HUDProgressTool showSuccessWithText:ReqSuccessful];
            [self loginWithUserName:g_Phone password:_m_PwdTF.text];
        }else{
            [HUDProgressTool showErrorWithText:response.msg];
        }
        
    } failure:^(NSError *error) {
       
        [HUDProgressTool showErrorWithText:ReqErrCode_Custom_ErrorInfo];
        
    }];
    
}

- (void)loginWithUserName:(NSString *)acc password:(NSString *)pwd{
    
    [HUDProgressTool showIndicatorWithText:ReqLoadingIn];
    
    [AccountManager loginWithUserName:acc password:pwd complete:^(NSInteger code, NSString *msg, NSInteger uid) {
        
        if (code == kHttpCodeOperateSucceed) {
            [[RongduManager share] autoLogin]; // 登录融都账号
            // 延迟执行
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                [[NSNotificationCenter defaultCenter] postNotificationName:NOTIF_LOGINSUCCESS
                                                                    object:nil];//调到首页
            });
        } else {
            [HUDProgressTool showErrorWithText:msg];
        }
        
    } failure:^(NSError *error) {
        
        [HUDProgressTool showErrorWithText:ReqErrCode_Custom_ErrorInfo];
        
    }];
    
}

@end
