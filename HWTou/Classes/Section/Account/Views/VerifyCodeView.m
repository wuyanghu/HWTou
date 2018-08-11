//
//  VerifyCodeView.m
//  HWTou
//
//  Created by LeoSteve on 2017/3/6.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "VerifyCodeView.h"

#import "SecurityTool.h"
#import "PublicHeader.h"
#import "BindPhoneRequest.h"
#import "VerifyCodeRequest.h"
#import <SDWebImage/UIButton+WebCache.h>

#define KIntervalTime       60
#define verification_icon_mobile_phone @"zh_phone"

@interface VerifyCodeView ()<UITextFieldDelegate>{

    NSTimer *g_Timer;
    NSInteger g_Seconds;
    
    NSString *g_Phone;               // 接受验证码的手机号码
    VerifyCodeType g_VerifyCodeType;
    
}

@property (nonatomic, strong) UITextField *m_VerCodeTF;

@property (nonatomic, strong) UIButton *m_VerCodeBtn;
@property (nonatomic, strong) UIButton *m_NextStepBtn;

@end

@implementation VerifyCodeView
@synthesize m_Delegate;
@synthesize m_VerCodeTF;
@synthesize m_VerCodeBtn,m_NextStepBtn;

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
    
    UIImageView * iconImageView = [BasisUITool getImageViewWithImage:verification_icon_mobile_phone withIsUserInteraction:NO];
    [self addSubview:iconImageView];
    
    UITextField *verCodeTF = [BasisUITool getBoldTextFieldWithTextColor:[UIColor blackColor]
                                                               withSize:CLIENT_COMMON_FONT_INPUTBOX_SIZE
                                                        withPlaceholder:@""
                                                           withDelegate:self];
    [verCodeTF addTarget:self action:@selector(textFieldTextChange:) forControlEvents:UIControlEventEditingChanged];
    [verCodeTF setKeyboardType:UIKeyboardTypeNumberPad];
    [self setM_VerCodeTF:verCodeTF];
    [self addSubview:verCodeTF];
    
    UIView *lineView = [[UIView alloc] init];
    [lineView setBackgroundColor:UIColorFromHex(CLIENT_LINE_GRAY_BG)];
    [self addSubview:lineView];
    
    UIButton *verCodeBtn = [[UIButton alloc] init];
    [verCodeBtn addTarget:self action:@selector(obtainVerCodeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [verCodeBtn setRoundWithCorner:2.0f];
    [verCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    [verCodeBtn.titleLabel setFont:FontPFRegular(CLIENT_COMMON_FONT_CONTENT_SIZE)];
    [verCodeBtn setBackgroundImage:[UIImage imageWithColor:UIColorFromHex(CLIENT_BTN_RED_NORMAL_BG)]
                          forState:UIControlStateNormal];
    [verCodeBtn setBackgroundImage:[UIImage imageWithColor:UIColorFromHex(CLIENT_BTN_GRAY_DISABLED_BG)]
                          forState:UIControlStateDisabled];
    
    UIView *vLine1 = [[UIView alloc] init];
    [vLine1 setBackgroundColor:UIColorFromHex(CLIENT_LINE_GRAY_BG)];
    [self addSubview:vLine1];
    
    [self setM_VerCodeBtn:verCodeBtn];
    [self addSubview:verCodeBtn];
    
    /* ********** layout UI ********** */
    [iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(CGSizeMake(14, 20));
        make.left.equalTo(self).offset(44);
        make.top.equalTo(self).offset(88);
    }];
    
    [verCodeTF mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(iconImageView).offset(4);
        make.left.equalTo(iconImageView.right).offset(14);
        make.size.equalTo(CGSizeMake(142, 14));
        
    }];
    
    [verCodeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(83);
        make.right.equalTo(self).offset(-44);
        make.size.equalTo(CGSizeMake(100, 30));
    }];
    
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(verCodeBtn.mas_bottom).offset(10);
        make.left.equalTo(self).offset(42);
        make.right.equalTo(self).offset(-42);
        make.height.equalTo(1);
        
    }];
    
    /* ********** layout UI End ********** */
    
}

#pragma mark - Public Functions
- (void)dataInitialization{
    
    g_Phone = nil;
    g_Seconds = KIntervalTime;
    
    // 当键盘弹起时，点击背景收起键盘
    [[IQKeyboardManager sharedManager] setShouldResignOnTouchOutside:YES];
    
}

- (void)closeTimer{

    if (!IsNilOrNull(g_Timer)) [g_Timer invalidate];
    
}

- (void)setVerifyCodeObtainType:(NSString *)phone withVerifyCodeType:(VerifyCodeType)type{

    g_Phone = phone;
    g_VerifyCodeType = type;
    [self obtainVerCode:phone withVerifyCodeType:type];
    
}

- (void)obtainVerCode:(NSString *)phone withVerifyCodeType:(VerifyCodeType)type{

    SMSCodeParam *param = [[SMSCodeParam alloc] init];
    [param setPhone:phone];
    
    switch (type) {
        case VerifyCodeType_Register:{// 发送注册短信验证码
            
            [self obtainRegVerifyCode:param];
            
            break;}
        case VerifyCodeType_Forget:{// 发送注册短信验证码
            [self obtainRegVerifyCode:param];
            
            break;}
        case VerifyCodeType_PayPswd:{
            [self obtainRegVerifyCode:param];
        }
            break;
        case VerifyCodeType_BindPhone:{// 发送绑定手机短信验证码
            
            [self bindingPhoneWithParam:param];
            
            break;}
        default:
            break;
    }
    
}

// 倒计时方法验证码实现倒计时60秒，60 秒后按钮变换开始的样子
- (void)timerMethod:(NSTimer *)theTimer{
    
    UIButton *btn = m_VerCodeBtn;
    
    if (g_Seconds == 0) {
        
        [theTimer invalidate];
        
        g_Seconds = KIntervalTime;
        
        [btn setEnabled:YES];
        [btn setTitle:@"获取验证码" forState: UIControlStateNormal];

    }else{
        
        g_Seconds--;
        
        NSString *title = [NSString stringWithFormat:@"%zds",g_Seconds];
        
        [btn setEnabled:NO];
        [btn setTitle:title forState:UIControlStateNormal];
        
    }
    
}

#pragma mark - Button Handlers
- (void)obtainVerCodeBtnClick:(id)sender{
    [self obtainVerCode:g_Phone withVerifyCodeType:g_VerifyCodeType];
}
//获取验证码
- (void)nextStepBtnClick{
    [self endEditing:YES];
    NSString *verCode = m_VerCodeTF.text;
    // 验证手机验证码
    VerifyPhoneCodeParam *param = [[VerifyPhoneCodeParam alloc] init];
    [param setPhone:g_Phone];
    [param setSmsCode:verCode];
    [self verifyPhoneCodeWithParam:param];
}

#pragma mark - UITextField Delegate Methods

- (void)textFieldTextChange:(UITextField *)textField{
    if (textField.text.length == 4) {
        //长度为4位自动验证请求
        [self nextStepBtnClick];
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range
replacementString:(NSString *)string{
    
    if ([textField isEqual:m_VerCodeTF]){
        if (string.length == 0) {
            return YES;
        }
        
        NSInteger existedLength = textField.text.length;
        NSInteger selectedLength = range.length;
        NSInteger replaceLength = string.length;
        
        NSInteger length = existedLength - selectedLength + replaceLength;
        
        if (length > 4) {
            return NO;
        }else{

        }
    }
    
    return YES;
    
}

#pragma mark - NetworkRequest Manager
// 发送短信验证码
- (void)obtainRegVerifyCode:(SMSCodeParam *)param{
    
    [HUDProgressTool showIndicatorWithText:ReqVerifyCode];
    
    [VerifyCodeRequest singupWithParam:param success:^(BaseResponse *response) {
        if (response.status == 200) {
            [HUDProgressTool showSuccessWithText:ReqVerifyCodeHasBeenSent];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [HUDProgressTool showSuccessWithText:ReqVerifyCodeRetry];
            });
            g_Timer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                                       target:self
                                                     selector:@selector(timerMethod:)
                                                     userInfo:nil
                                                      repeats:YES];
        }else{
            [HUDProgressTool showErrorWithText:response.msg];
        }
    } failure:^(NSError *error) {
        [HUDProgressTool showErrorWithText:ReqErrCode_Custom_ErrorInfo];
    }];
    
}

// 发送找回密码短信验证码
- (void)obtainForgetVerifyCode:(SMSCodeParam *)param{

    [HUDProgressTool showIndicatorWithText:ReqVerifyCode];
    
    [VerifyCodeRequest forgetPWWithParam:param success:^(BaseResponse *response) {
        if (response.status == 200) {
            [HUDProgressTool showSuccessWithText:ReqVerifyCodeHasBeenSent];
            g_Timer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                                       target:self
                                                     selector:@selector(timerMethod:)
                                                     userInfo:nil
                                                      repeats:YES];
        }else{
            [HUDProgressTool showErrorWithText:response.msg];
        }
    } failure:^(NSError *error) {
        [HUDProgressTool showErrorWithText:ReqErrCode_Custom_ErrorInfo];
    }];
    
}

// 发送绑定手机短信验证码
- (void)bindingPhoneWithParam:(SMSCodeParam *)param{

    [HUDProgressTool showIndicatorWithText:ReqVerifyCode];
    
    [VerifyCodeRequest bindingPhoneWithParam:param success:^(BaseResponse *response) {
        
        if (response.success) {
            
            [HUDProgressTool showSuccessWithText:ReqVerifyCodeHasBeenSent];
            
            g_Timer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                                       target:self
                                                     selector:@selector(timerMethod:)
                                                     userInfo:nil
                                                      repeats:YES];
            
        }else{
            
            [HUDProgressTool showErrorWithText:response.msg];
            
        }
        
    } failure:^(NSError *error) {
        
        [HUDProgressTool showErrorWithText:ReqErrCode_Custom_ErrorInfo];
        
    }];
    
}

// 验证手机短信验证码
- (void)verifyPhoneCodeWithParam:(VerifyPhoneCodeParam *)vcParam{
    
    [HUDProgressTool showIndicatorWithText:ReqLoadingIn];
    
    [VerifyCodeRequest verifyPhoneCodeWithParam:vcParam success:^(BaseResponse *response) {
        if (response.status == 200) {
            [HUDProgressTool dismiss];
            if (g_VerifyCodeType == VerifyCodeType_BindPhone) {
                BindPhoneParam *param = [[BindPhoneParam alloc] init];
                
                [param setPhone:vcParam.phone];
                [param setCode:vcParam.smsCode];
                
                [self updateBindPhoneWithParam:param];
                
            }else{
                
                // 延迟执行 跳传页面
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    if (m_Delegate && [m_Delegate respondsToSelector:@selector(onNextStepWithVerCode:withVerifyCodeType:)]) {
                        [m_Delegate onNextStepWithVerCode:vcParam.smsCode withVerifyCodeType:g_VerifyCodeType];
                    }
                });
            }
            
        }else{
            [HUDProgressTool showErrorWithText:response.msg];
        }
        
    } failure:^(NSError *error) {
        
        [HUDProgressTool showErrorWithText:ReqErrCode_Custom_ErrorInfo];
        
    }];
    
}

- (void)updateBindPhoneWithParam:(BindPhoneParam *)param{

    [HUDProgressTool showIndicatorWithText:ReqLoadingIn];
    
    [BindPhoneRequest updateBindPhoneWithParam:param success:^(BaseResponse *response) {
        
        if (response.success) {
            
            [HUDProgressTool showSuccessWithText:ReqSuccessful];
            
            // 延迟执行
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                if (m_Delegate && [m_Delegate respondsToSelector:@selector(onModifyPhoneSuccessful)]) {
                    
                    [m_Delegate onModifyPhoneSuccessful];
                    
                }
                
            });
            
        }else{
            
            [HUDProgressTool showErrorWithText:response.msg];
            
        }
        
    } failure:^(NSError *error) {
        
        [HUDProgressTool showErrorWithText:ReqErrCode_Custom_ErrorInfo];
        
    }];
    
}

@end
