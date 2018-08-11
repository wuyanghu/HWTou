//
//  VerifyPwdView.m
//  HWTou
//
//  Created by Alan Jiang on 2017/4/18.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "VerifyPwdView.h"

#import "PublicHeader.h"
#import "AccountManager.h"
#import "VerifyPwdRequest.h"

@interface VerifyPwdView ()<UITextFieldDelegate>

@property (nonatomic, strong) UILabel *m_AccLbl;
@property (nonatomic, strong) UITextField *m_PwdTF;
@property (nonatomic, strong) UIButton *m_CipherBtn;

@end

@implementation VerifyPwdView
@synthesize m_Delegate;
@synthesize m_AccLbl;
@synthesize m_PwdTF;
@synthesize m_CipherBtn;

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

    UILabel *accLbl = [BasisUITool getBoldLabelWithTextColor:[UIColor blackColor]
                                                        size:CLIENT_COMMON_FONT_TITLE_SIZE];
    
    [accLbl setText:[[AccountManager shared] account].userName];
    [accLbl setTextAlignment:NSTextAlignmentCenter];
    
    [self setM_AccLbl:accLbl];
    [self addSubview:accLbl];
    
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

    UIView *lineView = [[UIView alloc] init];
    
    [lineView setBackgroundColor:UIColorFromHex(CLIENT_LINE_GRAY_BG)];
    
    [self addSubview:lineView];
    
    UIButton *verifyBtn = [BasisUITool getBtnWithTarget:self action:@selector(verifyBtnClick:)];
    
    [verifyBtn setTitle:@"登录" forState:UIControlStateNormal];
    [verifyBtn setBackgroundImage:[UIImage imageWithColor:UIColorFromHex(CLIENT_BTN_RED_NORMAL_BG)]
                         forState:UIControlStateNormal];
    [verifyBtn setBackgroundImage:[UIImage imageWithColor:UIColorFromHex(CLIENT_BTN_GRAY_DISABLED_BG)]
                         forState:UIControlStateDisabled];
    
    [self addSubview:verifyBtn];
    
    /* ********** layout UI ********** */
    
    [accLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self).offset(26);
        make.leading.equalTo(self).offset(25);
        make.trailing.equalTo(self).offset(-25);
        
    }];
    
    [pwdTF mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(accLbl.mas_bottom).offset(27);
        make.leading.equalTo(self).offset(25);
        make.trailing.equalTo(cipherBtn.mas_leading).offset(-8);
        
    }];
    
    [cipherBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.equalTo(pwdTF);
        make.trailing.equalTo(lineView.trailing).offset(-8);
        make.size.equalTo(CGSizeMake(30, 30));
        
    }];
    
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(pwdTF.mas_bottom).offset(7);
        make.leading.trailing.equalTo(accLbl);
        make.height.equalTo(0.5);
        
    }];
    
    [verifyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(lineView).offset(29.5);
        make.leading.equalTo(self).offset(25);
        make.trailing.equalTo(self).offset(-25);
        make.height.equalTo(40);
        
    }];
    
    /* ********** layout UI End ********** */

}

#pragma mark - Public Functions
- (void)dataInitialization{
    
    // 当键盘弹起时，点击背景收起键盘
    [[IQKeyboardManager sharedManager] setShouldResignOnTouchOutside:YES];
    
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

- (void)verifyBtnClick:(id)sender{
    
    if (IsStrEmpty(m_PwdTF.text)) {
        
        [HUDProgressTool showOnlyText:@"请输入密码!"];
        
    }else{
    
        [self endEditing:YES];
        
        VerifyPwdParam *param = [[VerifyPwdParam alloc] init];
        
        [param setPassword:m_PwdTF.text];
        
        [self verifyPwdWithParam:param];
        
    }
    
}

#pragma mark - UITextField Delegate Methods
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    
    return YES;
    
}

#pragma mark - NetworkRequest Manager
- (void)verifyPwdWithParam:(VerifyPwdParam *)param{
    
    [HUDProgressTool showIndicatorWithText:ReqLoadingIn];
    
    [VerifyPwdRequest verifyPwdWithParam:param success:^(BaseResponse *response) {
        
        if (response.success) {

            [HUDProgressTool dismiss];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                if (m_Delegate && [m_Delegate respondsToSelector:@selector(onVerifyPwdSuccessful)]) {
                    
                    [m_Delegate onVerifyPwdSuccessful];
                    
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
