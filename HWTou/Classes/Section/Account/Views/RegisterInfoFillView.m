//
//  RegisterInfoFillView.m
//  HWTou
//
//  Created by robinson on 2017/11/13.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "RegisterInfoFillView.h"
#import "PublicHeader.h"
#import "SignupRequest.h"
#import "AccountManager.h"
#import "RongduManager.h"
#import "RegularExTool.h"

#define information_filling_icon_Invitation_code @"information_filling_icon_Invitation_code"
#define information_filling_icon_nickname @"information_filling_icon_nickname"

@interface RegisterInfoFillView()

@property (nonatomic, strong) UILabel *m_AccLbl;

@property (nonatomic, strong) UIView *m_AccLineView;

@property (nonatomic, strong) UITextField *m_AccTF;//昵称
@property (nonatomic, strong) UITextField *m_PwdTF;//邀请码

@property (nonatomic, strong) UIButton *m_CipherBtn;

@end

@implementation RegisterInfoFillView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self addViews];
    }
    return self;
}

- (void)addViews{
    //账号icon
    UIImageView * accIconImageView = [BasisUITool getImageViewWithImage:information_filling_icon_nickname withIsUserInteraction:NO];
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
                                                    withPlaceholder:@"请输入昵称"
                                                       withDelegate:self];
    
    [self setM_AccTF:accTF];
    [self addSubview:accTF];
    
    UIView *accLineView = [[UIView alloc] init];
    [accLineView setBackgroundColor:UIColorFromHex(CLIENT_LINE_GRAY_BG)];
    [self setM_AccLineView:accLineView];
    [self addSubview:accLineView];
    
    UIImageView * pwdIconImageView = [BasisUITool getImageViewWithImage:information_filling_icon_Invitation_code withIsUserInteraction:NO];
    [self addSubview:pwdIconImageView];
    
    UITextField * pwdTF = [BasisUITool getBoldTextFieldWithTextColor:[UIColor blackColor]
                                                            withSize:CLIENT_COMMON_FONT_INPUTBOX_SIZE
                                                     withPlaceholder:@"请输入邀请码(选填)"
                                                        withDelegate:self];
    
    [self setM_PwdTF:pwdTF];
    [self addSubview:pwdTF];
    
    UIView *pwdLineView = [[UIView alloc] init];
    [pwdLineView setBackgroundColor:UIColorFromHex(CLIENT_LINE_GRAY_BG)];
    [self addSubview:pwdLineView];
    
    UIButton *loginBtn = [BasisUITool getBtnWithTarget:self action:@selector(loginBtnClick:)];
    
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
        make.size.equalTo(accTF);
        make.top.equalTo(pwdIconImageView);
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
    
    /* ********** layout UI End ********** */
    
}

- (void)loginBtnClick:(UIButton *)button{
    [self.m_AccTF resignFirstResponder];
    [self.m_PwdTF resignFirstResponder];
    
    SignupParam *param = [[SignupParam alloc] init];
    
    [param setPhone:self.phone];
    [param setPassword:self.pwd];
    [param setNickname:self.m_AccTF.text];
    [param setCode:self.m_PwdTF.text];
    [param setPhoneType:[AccountManager getDevicePlatForm]];
    [param setPhoneDevice:[AccountManager getIFDVCode]];
    [param setImgCode:_imgCode];
    [param setSmsCode:_smsCode];
    
    if (![RegularExTool validateNickName:self.m_AccTF.text]) {
        NSLog(@"不合法");
        [HUDProgressTool showErrorWithText:HINTNickName];
        return;
    }
    
    //检测昵称是否合法
    [PersonHomeRequest checkNickname:param.nickname Success:^(BaseResponse *response) {
        [HUDProgressTool dismiss];
        if (response.status == 200) {
            [self userRegistration:param];
        }else{
            [HUDProgressTool showErrorWithText:response.msg];
        }
    } failure:^(NSError *error) {
        [HUDProgressTool showErrorWithText:ReqErrCode_Custom_ErrorInfo];
    }];
    
}

//用户进行注册，成功后
//用户昵称设置成功后，点击‘提交’自动登录用户，且跳转到‘听说-热门’主页面
- (void)userRegistration:(SignupParam *)model{
    [HUDProgressTool showIndicatorWithText:ReqLoadingIn];
    [SignupRequest signupWithParam:model success:^(SignupResponse *response) {
        if (response.status == 200) {// 注册成功后自动登录 （只登陆一次无论成功与否都跳转到注册成功界面 PS：和安卓处理一致）
            [HUDProgressTool dismiss];
            [HUDProgressTool showSuccessWithText:@"注册成功!"];
            [self loginWithUserName:model.phone password:model.password];
            
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

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
