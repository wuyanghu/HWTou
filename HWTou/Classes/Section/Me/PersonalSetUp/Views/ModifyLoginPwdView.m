//
//  ModifyLoginPwdView.m
//  HWTou
//
//  Created by 赤 那 on 2017/3/26.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "ModifyLoginPwdView.h"

#import "PublicHeader.h"
#import "RegularExTool.h"

#import "AccountManager.h"
#import "ResetPWRequest.h"

#define kTextFieldTag       99

@interface ModifyLoginPwdView()<UITextFieldDelegate>

@property (nonatomic, strong) UITextField *m_OldPwdTF;
@property (nonatomic, strong) UITextField *m_NewPwdTF;
@property (nonatomic, strong) UITextField *m_RepeatPwdTF;

@end

@implementation ModifyLoginPwdView
@synthesize m_Delegate;
@synthesize m_OldPwdTF,m_NewPwdTF,m_RepeatPwdTF;

#pragma mark - Life Cycle
- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]){
        
        [self dataInitialization];
        [self addMainView];
        
        [self setBackgroundColor:UIColorFromHex(ME_BG_COLOR)];
        
    }
    
    return self;
    
}

#pragma mark - Add UI
- (void)addMainView{
    
    [self addViews];
    
}

- (void)addViews{

    UIView *oldPwdView = [self createInputView:CGRectZero withTitle:@"原登录密码:" withIsShowLine:YES];
    
    [self setM_OldPwdTF:[oldPwdView viewWithTag:kTextFieldTag]];
    
    UIView *newPwdView = [self createInputView:CGRectZero withTitle:@"设置新密码:" withIsShowLine:YES];
    
    [self setM_NewPwdTF:[newPwdView viewWithTag:kTextFieldTag]];
    
    UIView *repeatPwdView = [self createInputView:CGRectZero withTitle:@"重复新密码:" withIsShowLine:NO];
    
    [self setM_RepeatPwdTF:[repeatPwdView viewWithTag:kTextFieldTag]];
    
    UIButton *confirmBtn = [BasisUITool getBtnWithTarget:self action:@selector(confirmBtnBtnClick:)];
    
    [confirmBtn setTitle:@"确认" forState:UIControlStateNormal];
    [confirmBtn setBackgroundImage:[UIImage imageWithColor:UIColorFromHex(CLIENT_BTN_RED_NORMAL_BG)]
                          forState:UIControlStateNormal];
    [confirmBtn setBackgroundImage:[UIImage imageWithColor:UIColorFromHex(CLIENT_BTN_GRAY_DISABLED_BG)]
                          forState:UIControlStateDisabled];
    
    [self addSubview:oldPwdView];
    [self addSubview:newPwdView];
    [self addSubview:repeatPwdView];
    [self addSubview:confirmBtn];
    
    [oldPwdView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self);
        make.left.and.right.equalTo(self);
        make.size.equalTo(CGSizeMake(kMainScreenWidth, 40));
        
    }];
    
    [newPwdView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(oldPwdView.mas_bottom);
        make.left.and.right.equalTo(oldPwdView);
        make.size.equalTo(oldPwdView);
        
    }];
    
    [repeatPwdView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(newPwdView.mas_bottom);
        make.left.and.right.equalTo(oldPwdView);
        make.size.equalTo(oldPwdView);
        
    }];
    
    [confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(repeatPwdView.mas_bottom).offset(37);
        make.left.equalTo(self).offset(25);
        make.right.equalTo(self).offset(-25);
        make.height.equalTo(40);
        
    }];
    
}

#pragma mark - Public Functions
- (void)dataInitialization{
    
    // 当键盘弹起时，点击背景收起键盘
    [[IQKeyboardManager sharedManager] setShouldResignOnTouchOutside:YES];
    
}

- (UIView *)createInputView:(CGRect)frame withTitle:(NSString *)title withIsShowLine:(BOOL)isShow{

    UIView *bgView = [[UIView alloc] initWithFrame:frame];
    
    [bgView setBackgroundColor:[UIColor whiteColor]];
    
    UILabel *lbl = [BasisUITool getBoldLabelWithTextColor:[UIColor blackColor]
                                                     size:CLIENT_COMMON_FONT_CONTENT_SIZE];
    
    [lbl setText:title];
    
    [bgView addSubview:lbl];
    
    UITextField *tf = [BasisUITool getBoldTextFieldWithTextColor:[UIColor blackColor]
                                                        withSize:CLIENT_COMMON_FONT_INPUTBOX_SIZE
                                                 withPlaceholder:nil
                                                    withDelegate:self];
    
    [tf setSecureTextEntry:YES];
    
    [tf setTag:kTextFieldTag];
    
    [bgView addSubview:tf];
    
    UIView *lineView = [[UIView alloc] init];
    
    [lineView setBackgroundColor:UIColorFromHex(CLIENT_LINE_GRAY_BG)];
    
    [bgView addSubview:lineView];

    [lbl mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.centerY.equalTo(bgView.mas_centerY);
        make.left.equalTo(bgView).offset(12);
        make.right.equalTo(tf.mas_left).offset(-10);
        
    }];
    
    [tf mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.equalTo(lbl);
        make.left.equalTo(lbl.mas_right).offset(10);
        make.right.equalTo(bgView).offset(-12);
        make.width.greaterThanOrEqualTo(80);
        
    }];
    
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.and.right.equalTo(bgView);
        make.bottom.equalTo(bgView);
        make.height.equalTo(0.5);
        
    }];
    
    return bgView;
    
}

#pragma mark - Button Handlers
- (void)confirmBtnBtnClick:(id)sender{
    
    NSString *oldStr = m_OldPwdTF.text;
    NSString *newStr = m_NewPwdTF.text;
    NSString *repeatStr = m_RepeatPwdTF.text;
    
    NSString *errorStr = nil;
    
    if (IsStrEmpty(oldStr)) {
        
        errorStr = @"请输入原登录密码!";
        
    }else if (IsStrEmpty(newStr)){
    
        errorStr = @"请输入新密码!";
        
    }else if (IsStrEmpty(repeatStr)){
    
        errorStr = @"请再次输入新密码!";
        
    }else{
        
        if ([newStr isEqualToString:repeatStr]) {
            
            if ([RegularExTool validatePassWord:m_NewPwdTF.text]) {
                
                ResetPWParam *param = [[ResetPWParam alloc] init];
                
                [param setOldPassword:m_OldPwdTF.text];
                [param setNPassword:m_NewPwdTF.text];
                
                [self resetPwdWithParam:param];
                
            }else{
                
                errorStr = @"为了您的账号安全，密码应由6位以上的数字和字母组成!";
            }
            
        }else{
            
            errorStr = @"设置的新密码不一致!";
            
        }

    }
    
    if (!IsStrEmpty(errorStr)) [HUDProgressTool showOnlyText:errorStr];
    
}

#pragma mark - UITextField Delegate Methods
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    
    return YES;
    
}

#pragma mark - NetworkRequest Manager
- (void)resetPwdWithParam:(ResetPWParam *)param{
    
    [HUDProgressTool showIndicatorWithText:ReqLoadingIn];
    
    [ResetPWRequest resetPWWithParam:param success:^(ResetPWResponse *response) {
        
        if (response.status == 200) {
        
            [HUDProgressTool showSuccessWithText:ReqSuccessful];
            
            // 延迟执行
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                [AccountManager shared].account.passWord = param.nPassword;
                [[AccountManager shared] saveAccount];
                if (m_Delegate && [m_Delegate respondsToSelector:@selector(onModifyPwdSuccess)]) {
                    
                    [m_Delegate onModifyPwdSuccess];
                    
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
