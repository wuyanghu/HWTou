//
//  QuickRegView.m
//  HWTou
//
//  Created by 赤 那 on 2017/3/20.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "QuickRegView.h"

#import "PublicHeader.h"
#import "RegularExTool.h"
#import "PhoneVerRequest.h"

@interface QuickRegView ()<UITextFieldDelegate>{

    UIImageView *g_LogoImgView;
    
    UILabel *g_TitleLbl;
    
    UITextField *g_PhoneTF;
    
    UIView *g_LineView;
    
    UIButton *g_NextStepBtn;
    UIButton *g_ToLogInBtn;
    
}

@end

@implementation QuickRegView
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

    g_LogoImgView = [BasisUITool getImageViewWithImage:PUBLIC_IMG_LOGO withIsUserInteraction:NO];
    
    g_TitleLbl = [BasisUITool getBoldLabelWithTextColor:[UIColor blackColor]
                                                   size:CLIENT_COMMON_FONT_CONTENT_SIZE];
    
    g_PhoneTF = [BasisUITool getBoldTextFieldWithTextColor:[UIColor blackColor]
                                                  withSize:CLIENT_COMMON_FONT_INPUTBOX_SIZE
                                           withPlaceholder:@"请输入手机号"
                                              withDelegate:self];
    
    g_LineView = [[UIView alloc] init];
    
    g_NextStepBtn = [BasisUITool getBtnWithTarget:self action:@selector(nextStepBtnClick:)];
    g_ToLogInBtn = [BasisUITool getBtnWithTarget:self action:@selector(toLogInBtnClick:)];
    
    [self addSubview:g_LogoImgView];
    [self addSubview:g_TitleLbl];
    [self addSubview:g_PhoneTF];
    [self addSubview:g_LineView];
    [self addSubview:g_NextStepBtn];
    [self addSubview:g_ToLogInBtn];
    
}

#pragma mark - Public Functions
- (void)dataInitialization{
    
    // 当键盘弹起时，点击背景收起键盘
    [[IQKeyboardManager sharedManager] setShouldResignOnTouchOutside:YES];
    
}

- (void)layoutUI{
    
    [g_LogoImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        CGFloat offset = g_LogoImgView.frame.size.width / 2;

        make.top.equalTo(self).offset(30);
        make.left.equalTo(self.mas_centerX).offset(-offset);
        
    }];
    
    [g_TitleLbl setText:@"手机号"];
    [g_TitleLbl setTextAlignment:NSTextAlignmentCenter];
    [g_TitleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self).offset(25);
        make.width.equalTo(50);
        make.top.equalTo(g_LogoImgView.mas_bottom).offset(60);
        
    }];
    
    [g_PhoneTF setKeyboardType:UIKeyboardTypeNumberPad];
    [g_PhoneTF mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(g_TitleLbl.mas_right).offset(15);
        make.right.equalTo(self).offset(-25);
        make.top.equalTo(g_TitleLbl);
        
    }];
    
    [g_LineView setBackgroundColor:UIColorFromHex(CLIENT_LINE_GRAY_BG)];
    [g_LineView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self).offset(25);
        make.right.equalTo(self).offset(-25);
        make.height.equalTo(0.5);
        make.top.equalTo(g_PhoneTF.mas_bottom).offset(7);
        
    }];
    
    [g_NextStepBtn setEnabled:NO];
    [g_NextStepBtn setTitle:@"下一步" forState:UIControlStateNormal];
    [g_NextStepBtn setBackgroundImage:[UIImage imageWithColor:UIColorFromHex(CLIENT_BTN_RED_NORMAL_BG)]
                          forState:UIControlStateNormal];
    [g_NextStepBtn setBackgroundImage:[UIImage imageWithColor:UIColorFromHex(CLIENT_BTN_GRAY_DISABLED_BG)]
                          forState:UIControlStateDisabled];
    [g_NextStepBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.equalTo(g_LineView);
        make.height.equalTo(40);
        make.top.equalTo(g_LineView.mas_bottom).offset(29.5);
        
    }];
    
    [g_ToLogInBtn setTitle:@"已有账号，去登录" forState:UIControlStateNormal];
    [g_ToLogInBtn setTitleColor:UIColorFromHex(CLIENT_FONT_RED_COLOR)
                       forState:UIControlStateNormal];

    [g_ToLogInBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(g_NextStepBtn.mas_bottom).offset(20);
        make.centerX.equalTo(self.mas_centerX);
        make.width.greaterThanOrEqualTo(140);
        make.height.equalTo(40);
        
    }];
    
}

#pragma mark - Button Handlers
- (void)nextStepBtnClick:(id)sender{
    
    NSString *phone = g_PhoneTF.text;
    
    if ([RegularExTool validateMobile:phone]) {
        
        PhoneVerParam *model = [[PhoneVerParam alloc] init];
        
        [model setPhone:phone];
        
        [self phoneVerification:model];
        
    }else{
        
        [HUDProgressTool showOnlyText:@"请输入一个有效的手机号码!"];
        
    }
    
}

- (void)toLogInBtnClick:(id)sender{
    
    if (m_Delegate && [m_Delegate respondsToSelector:@selector(onToLogIn)]) {
        
        [m_Delegate onToLogIn];
        
    }
    
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

#pragma mark - NetworkRequest Manager
- (void)phoneVerification:(PhoneVerParam *)param{
    
    [HUDProgressTool showIndicatorWithText:ReqLoadingIn];
    
    [PhoneVerRequest phoneVerWithParam:param success:^(PhoneVerResponse *response) {
        
        if (self.isForget) {
            if (response.data.status == 0) {
                [HUDProgressTool showOnlyText:@"该手机号码没有注册!"];
                return;
            }
        } else {
            if (response.data.status == 1) {
                [HUDProgressTool showOnlyText:@"该手机号码已注册!"];
                return;
            }
        }
        
        if (m_Delegate && [m_Delegate respondsToSelector:@selector(onNextStepWithRegPhone:)]) {
            [m_Delegate onNextStepWithRegPhone:g_PhoneTF.text];
        }
    } failure:^(NSError *error) {
        
        [HUDProgressTool showErrorWithText:ReqErrCode_Custom_ErrorInfo];
        
    }];
    
}

@end
