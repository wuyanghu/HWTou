//
//  SetUpTradingPwdView.m
//  HWTou
//
//  Created by 赤 那 on 2017/3/23.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "SetUpTradingPwdView.h"

#import "PublicHeader.h"
#import "SLPasswordInputView.h"

@interface SetUpTradingPwdView()<SLPasswordInputViewDelegate>{

    UILabel *g_SafetyTipsLbl;
    UILabel *g_PwdRequiredLbl;
    UILabel *g_ConsultingLbl;
    
    UIButton *g_ConfirmBtn;
    
    SLPasswordInputView *g_TradingPwdView;
    
}

@end

@implementation SetUpTradingPwdView
@synthesize m_Delegate;

#pragma mark - Life Cycle
- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]){
        
        [self dataInitialization];
        [self addMainView];
        [self layoutUI];
        
    }
    
    return self;
    
}

#pragma mark - Add UI
- (void)addMainView{
    
    [self addViews];
    
}

- (void)addViews{

    g_SafetyTipsLbl = [BasisUITool getBoldLabelWithTextColor:[UIColor blackColor]
                                                        size:CLIENT_COMMON_FONT_CONTENT_SIZE];
    
    g_TradingPwdView = [[SLPasswordInputView alloc] init];
    
    g_PwdRequiredLbl = [BasisUITool getBoldLabelWithTextColor:UIColorFromHex(CLIENT_FONT_GRAY_COLOR)
                                                         size:CLIENT_COMMON_FONT_CONTENT_SIZE];
    
    g_ConsultingLbl = [BasisUITool getBoldLabelWithTextColor:[UIColor blackColor]
                                                        size:CLIENT_COMMON_FONT_CONTENT_SIZE];
    
    g_ConfirmBtn = [BasisUITool getBtnWithTarget:self action:@selector(confirmBtnClick:)];
    
    [self addSubview:g_SafetyTipsLbl];
    [self addSubview:g_PwdRequiredLbl];
    [self addSubview:g_ConsultingLbl];
    
    [self addSubview:g_ConfirmBtn];
    [self addSubview:g_TradingPwdView];
    
}

#pragma mark - Public Functions
- (void)dataInitialization{

    
    
}

- (void)layoutUI{

    [g_SafetyTipsLbl setTextAlignment:NSTextAlignmentCenter];
    [g_SafetyTipsLbl setText:@"为保障您的资金安全,请设置数字交易密码"];
    [g_SafetyTipsLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self).offset(25);
        make.right.equalTo(self).offset(-25);
        make.top.equalTo(self).offset(25);
        
    }];
    
    [g_TradingPwdView setDelegate:self];
    [g_TradingPwdView setPasswordLength:6];
    [g_TradingPwdView setBorderWidth:1.5];
    [g_TradingPwdView setBorderColor:UIColorFromHex(CLIENT_LINE_GRAY_BG)];
    [g_TradingPwdView setBackgroundColor:[UIColor whiteColor]];
    [g_TradingPwdView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self).offset(50);
        make.right.equalTo(self).offset(-50);
        make.height.equalTo(32);
        make.top.equalTo(g_SafetyTipsLbl.mas_bottom).offset(17);
        
    }];
    
    [g_PwdRequiredLbl setTextAlignment:NSTextAlignmentCenter];
    [g_PwdRequiredLbl setText:@"密码要求6位数字"];
    [g_PwdRequiredLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self).offset(25);
        make.right.equalTo(self).offset(-25);
        make.top.equalTo(g_TradingPwdView.mas_bottom).offset(14);
        
    }];
    
    [g_ConsultingLbl setTextAlignment:NSTextAlignmentCenter];
    [g_ConsultingLbl setText:@"如有疑问请咨询: 0571-87689328"];
    [g_ConsultingLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self).offset(25);
        make.right.equalTo(self).offset(-25);
        make.top.equalTo(g_PwdRequiredLbl.mas_bottom).offset(15);
        
    }];
    
    [g_ConfirmBtn setEnabled:NO];
    [g_ConfirmBtn setTitle:@"确认" forState:UIControlStateNormal];
    [g_ConfirmBtn setBackgroundImage:[UIImage imageWithColor:UIColorFromHex(CLIENT_BTN_RED_NORMAL_BG)]
                                    forState:UIControlStateNormal];
    [g_ConfirmBtn setBackgroundImage:[UIImage imageWithColor:UIColorFromHex(CLIENT_BTN_GRAY_DISABLED_BG)]
                                    forState:UIControlStateDisabled];
    [g_ConfirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self).offset(25);
        make.right.equalTo(self).offset(-25);
        make.height.equalTo(40);
        make.top.equalTo(g_ConsultingLbl.bottom).offset(15);
        
    }];
    
}

#pragma mark - Button Handlers
- (void)confirmBtnClick:(id)sender{

    if (m_Delegate && [m_Delegate respondsToSelector:@selector(onBindingSuccess)]) {
        
        [m_Delegate onBindingSuccess];
        
    }
    
}

#pragma mark - SLPasswordInputView Delegate Manager
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [self endEditing:YES];
    
}

- (void)passwordInputView:(SLPasswordInputView *)inputView didChangeInputWithPassword:(NSString *)password{
    
    if (password.length < inputView.passwordLength) {
        
        if (g_ConfirmBtn.isEnabled) [g_ConfirmBtn setEnabled:NO];
        
    }
    
}

- (void)passwordInputView:(SLPasswordInputView *)inputView didFinishInputWithPassword:(NSString *)password{
    
    [g_ConfirmBtn setEnabled:YES];
    
}

#pragma mark - NetworkRequest Manager

@end
