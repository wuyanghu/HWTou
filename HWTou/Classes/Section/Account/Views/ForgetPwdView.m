//
//  QuickRegView.m
//  HWTou
//
//  Created by 赤 那 on 2017/3/20.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "ForgetPwdView.h"

#import "PublicHeader.h"
#import "RegularExTool.h"
#import "PhoneVerRequest.h"
#import "VerifyCodeRequest.h"
#import "CodePopView.h"

@interface ForgetPwdView ()<UITextFieldDelegate,CodePopViewDelegate>{
    
    UIImageView * phoneIconImageView;
    
    UITextField *g_PhoneTF;
    
    UIView *g_LineView;
    
    UIButton *g_NextStepBtn;
    UIButton *g_ToLogInBtn;
    
}

@property (nonatomic,strong) CodePopView * codePopView;

@end

@implementation ForgetPwdView
@synthesize m_Delegate;

#pragma mark - Life Cycle
- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]){
        
        [self dataInitialization];
        [self addMainView];
        [self layoutUI];
        [[IQKeyboardManager sharedManager] setShouldResignOnTouchOutside:YES];
    }
    
    return self;
    
}

#pragma mark - Add UI
- (void)addMainView{
    [self addViews];
}

- (void)addViews{
    
    phoneIconImageView = [BasisUITool getImageViewWithImage:@"zh_icon_dx" withIsUserInteraction:NO];
    
    g_PhoneTF = [BasisUITool getBoldTextFieldWithTextColor:[UIColor blackColor]
                                                  withSize:CLIENT_COMMON_FONT_INPUTBOX_SIZE
                                           withPlaceholder:@"请输入手机号"
                                              withDelegate:self];
    
    g_LineView = [[UIView alloc] init];
    
    g_NextStepBtn = [BasisUITool getBtnWithTarget:self action:@selector(nextStepBtnClick:)];
    
    [self addSubview:phoneIconImageView];
    [self addSubview:g_PhoneTF];
    [self addSubview:g_LineView];
    [self addSubview:g_NextStepBtn];
}

#pragma mark - Public Functions
- (void)dataInitialization{
    
    // 当键盘弹起时，点击背景收起键盘
    [[IQKeyboardManager sharedManager] setShouldResignOnTouchOutside:YES];
    
}

- (void)layoutUI{
    
    [phoneIconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self).offset(25);
        make.size.equalTo(CGSizeMake(21, 21));
        make.top.equalTo(self).offset(155);
        
    }];
    
    [g_PhoneTF setKeyboardType:UIKeyboardTypeNumberPad];
    [g_PhoneTF mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(phoneIconImageView.mas_right).offset(15);
        make.right.equalTo(self).offset(-25);
        make.top.equalTo(phoneIconImageView);
        
    }];
    
    [g_LineView setBackgroundColor:UIColorFromHex(CLIENT_LINE_GRAY_BG)];
    [g_LineView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self).offset(25);
        make.right.equalTo(self).offset(-25);
        make.height.equalTo(0.5);
        make.top.equalTo(g_PhoneTF.mas_bottom).offset(7);
        
    }];
    
    [g_NextStepBtn setEnabled:NO];
    [g_NextStepBtn setTitle:@"获取短信验证码" forState:UIControlStateNormal];
    [g_NextStepBtn setBackgroundImage:[UIImage imageWithColor:UIColorFromHex(CLIENT_BTN_RED_NORMAL_BG)]
                          forState:UIControlStateNormal];
    [g_NextStepBtn setBackgroundImage:[UIImage imageWithColor:UIColorFromHex(CLIENT_BTN_GRAY_DISABLED_BG)]
                          forState:UIControlStateDisabled];
    [g_NextStepBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.equalTo(g_LineView);
        make.height.equalTo(40);
        make.top.equalTo(g_LineView.mas_bottom).offset(29.5);
        
    }];
}

#pragma mark - Button Handlers
- (void)nextStepBtnClick:(id)sender{
    NSString *phone = g_PhoneTF.text;
    if ([RegularExTool validateMobile:phone]) {
        [self showCodePopView];
    }else{
        [HUDProgressTool showOnlyText:@"请输入一个有效的手机号码!"];
    }
    
}

- (void)toLogInBtnClick:(id)sender{
    
    if (m_Delegate && [m_Delegate respondsToSelector:@selector(onToLogIn)]) {
        
        [m_Delegate onToLogIn];
        
    }
    
}

- (void)loginBtnClick:(UIButton *)button{
    
}
//弹出验证码
- (void)showCodePopView{
    //添加验证码
    [self addSubview:self.codePopView];
    [self.codePopView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    [self.codePopView showCodePopView];//刷新验证码
    
    [UIView animateWithDuration:0.5 animations:^{
        self.codePopView.alpha = 1.0f;
        self.alpha = 0.5;
        self.backgroundColor = [UIColor blackColor];
    }];
}
//关闭验证码
- (void)colseCodePopView{
    [self.codePopView colseCodePopView];
    [UIView animateWithDuration:0.5 animations:^{
        self.backgroundColor = [UIColor whiteColor];
        self.alpha = 1.0f;
    }];
}

- (void)buttonClick:(ButtonClickTag)tag{
    switch (tag) {
            case closeButtonClickTag:
        {
            [self colseCodePopView];
        }
            break;
            case sureButtonClickTag:
        {
            if ([self.codePopView isCodeVaild]) {
                [self colseCodePopView];
                
                SMSCodeParam *param = [[SMSCodeParam alloc] init];
                [param setPhone:g_PhoneTF.text];
                [self obtainRegVerifyCode:param];
            }else{
                [HUDProgressTool showErrorWithText:@"验证码不正确"];
            }
        }
            break;
        default:
            break;
    }
}

#pragma mark - network
// 发送注册短信验证码
- (void)obtainRegVerifyCode:(SMSCodeParam *)param{
    
    [HUDProgressTool showIndicatorWithText:ReqVerifyCode];
    
    [VerifyCodeRequest singupWithParam:param success:^(BaseResponse *response) {
        if (response.status == 200) {
            [HUDProgressTool showSuccessWithText:ReqVerifyCodeHasBeenSent];
            
            if (m_Delegate && [m_Delegate respondsToSelector:@selector(onNextStepWithRegPhone:pwd:imgCode:)]) {
                [m_Delegate onNextStepWithRegPhone:g_PhoneTF.text pwd:nil imgCode:self.codePopView.accTF.text];
            }
        }else{
            [HUDProgressTool showErrorWithText:response.msg];
        }
    } failure:^(NSError *error) {
        [HUDProgressTool showErrorWithText:ReqErrCode_Custom_ErrorInfo];
    }];
    
}

#pragma mark - UITextField Delegate Methods
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    
    if ([textField isEqual:g_PhoneTF]) {// 获得焦点
        
        BOOL isEnabled = textField.text.length >= 11 ? YES : NO;
        
        [g_NextStepBtn setEnabled:isEnabled];
        
    }
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    
    if ([textField isEqual:g_PhoneTF]){// 失去焦点操作
        
        BOOL isEnabled = textField.text.length >= 11 ? YES : NO;
        
        [g_NextStepBtn setEnabled:isEnabled];
        
    }
    
}

- (BOOL)textFieldShouldClear:(UITextField *)textField{
    
    if ([textField isEqual:g_PhoneTF]){// 清除按钮
        
        [g_NextStepBtn setEnabled:NO];
        
    }
    
    return YES;
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range
replacementString:(NSString *)string{
    
    if ([textField isEqual:g_PhoneTF]){
        
        if (string.length == 0) {
            
            [g_NextStepBtn setEnabled:NO];
            
            return YES;
            
        }
        
        NSInteger existedLength = textField.text.length;
        NSInteger selectedLength = range.length;
        NSInteger replaceLength = string.length;
        
        NSInteger length = existedLength - selectedLength + replaceLength;
        
        if (length > 11) {
            
            [g_NextStepBtn setEnabled:YES];
            
            return NO;
            
        }else{
            
            BOOL isEnabled = length >= 11 ? YES : NO;
            
            [g_NextStepBtn setEnabled:isEnabled];
            
        }
        
    }
    
    return YES;
    
}

#pragma mark - getter

- (void)setType:(QuickRegistrationType)type{
    _type = type;
    if (_type == QuickRegistrationTypePayPswd) {
        g_PhoneTF.text = [[AccountManager shared] account].userName;
        g_PhoneTF.placeholder = [NSString stringWithFormat:@"手机号 %@",_phone];
        [g_PhoneTF setEnabled:NO];
        g_NextStepBtn.enabled = YES;
    }
}

- (void)setPhone:(NSString *)phone{
    g_PhoneTF.text = phone;
    g_NextStepBtn.enabled = YES;
}

- (CodePopView *)codePopView{
    if (!_codePopView) {
        _codePopView = [[CodePopView alloc] init];
        _codePopView.alpha = 0;
        [_codePopView setM_codePopViewDelegate:self];
    }
    return _codePopView;
}


@end
