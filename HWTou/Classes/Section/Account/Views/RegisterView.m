//
//  QuickRegView.m
//  HWTou
//
//  Created by 赤 那 on 2017/3/20.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "RegisterView.h"

#import "PublicHeader.h"
#import "RegularExTool.h"
#import "PhoneVerRequest.h"
#import "VerifyCodeRequest.h"
#import "CodePopView.h"
#import <VerifyCode/NTESVerifyCodeManager.h>


#define Sign_in_icon_Password @"Sign_in_icon_Password"
#define Sign_in_icon_phone_number @"Sign_in_icon_phone_number"

@interface RegisterView ()<UITextFieldDelegate,CodePopViewDelegate,NTESVerifyCodeManagerDelegate>

@property (nonatomic, strong) UILabel *m_AccLbl;
@property (nonatomic, strong) UIView *m_AccLineView;

@property (nonatomic, strong) UITextField *m_AccTF;//用户名
@property (nonatomic, strong) UITextField *m_PwdTF;//密码

@property (nonatomic, strong) UIButton *m_CipherBtn;
@property (nonatomic, strong) UIButton * m_getCodeBtn;

@property (nonatomic,strong) CodePopView * codePopView;

@property (nonatomic, strong) NTESVerifyCodeManager *manager;
@end

@implementation RegisterView
@synthesize m_Delegate;

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
                                                    withPlaceholder:@"请输入您的手机号"
                                                       withDelegate:self];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldChanged:) name:UITextFieldTextDidChangeNotification object:accTF];
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
                                                     withPlaceholder:@"请设置8-16位数字字母组合密码"
                                                        withDelegate:self];
    
    [pwdTF setSecureTextEntry:YES];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldChanged:) name:UITextFieldTextDidChangeNotification object:pwdTF];
    [self setM_PwdTF:pwdTF];
    [self addSubview:pwdTF];
    
    UIButton *cipherBtn = [BasisUITool getBtnWithTarget:self action:@selector(registerBtnClick:)];
    cipherBtn.tag = RegistercipherBtnTag;
    [cipherBtn setImage:ImageNamed(PUBLIC_IMG_INVISIBLE_NOR) forState:UIControlStateNormal];
    [cipherBtn setImage:ImageNamed(PUBLIC_IMG_VISIBLE_NOR) forState:UIControlStateSelected];
    
    [self setM_CipherBtn:cipherBtn];
    [self addSubview:cipherBtn];
    
    UIView *pwdLineView = [[UIView alloc] init];
    [pwdLineView setBackgroundColor:UIColorFromHex(CLIENT_LINE_GRAY_BG)];
    [self addSubview:pwdLineView];
    
    UIButton * getCodeBtn = [BasisUITool getBtnWithTarget:self action:@selector(registerBtnClick:)];
    getCodeBtn.tag = RegisterGetCodeBtnTag;
    [getCodeBtn setEnabled:NO];
    [getCodeBtn setTitle:@"获取短信验证码" forState:UIControlStateNormal];
    [getCodeBtn setBackgroundImage:[UIImage imageWithColor:UIColorFromHex(CLIENT_BTN_RED_NORMAL_BG)]
                          forState:UIControlStateNormal];
    [getCodeBtn setBackgroundImage:[UIImage imageWithColor:UIColorFromHex(CLIENT_BTN_GRAY_DISABLED_BG)]
                          forState:UIControlStateDisabled];
    [self setM_getCodeBtn:getCodeBtn];
    [self addSubview:getCodeBtn];
    
    UIButton * goLoginBtn  = [BasisUITool getBtnWithTarget:self action:@selector(registerBtnClick:)];
    goLoginBtn.tag = RegisterGoLoginBtnTag;
    [goLoginBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [goLoginBtn setTitle:@"已有账号去登录" forState:UIControlStateNormal];
    [goLoginBtn setTitleColor:UIColorFromHex(CLIENT_FONT_RED_COLOR) forState:UIControlStateNormal];
    [self addSubview:goLoginBtn];
    
    UIButton * visitorLoginBtn = [BasisUITool getBtnWithTarget:self action:@selector(visitorLoginBtnClick:)];
//    [visitorLoginBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [visitorLoginBtn setTitle:@"游客登录" forState:UIControlStateNormal];
    [visitorLoginBtn setTitleColor:UIColorFromHex(CLIENT_FONT_RED_COLOR) forState:UIControlStateNormal];
    [self addSubview:visitorLoginBtn];
    
    /* ********** layout UI ********** */
    
    [accIconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(36);
        make.left.mas_equalTo(40);
        make.size.equalTo(CGSizeMake(20, 20));
    }];
    
    [accLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(accIconImageView).offset(4);
        make.left.equalTo(accIconImageView.mas_right).offset(10);
        make.right.mas_equalTo(self).offset(-46);
        make.height.equalTo(12);
    }];
    
    [accTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.trailing.equalTo(accLbl);
    }];
    
    [accLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(accTF.mas_bottom).offset(15);
        make.left.equalTo(accIconImageView);
        make.right.equalTo(self).offset(-40);
        make.height.mas_equalTo(1);
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
        make.top.equalTo(pwdTF.mas_bottom).offset(15);
        make.left.equalTo(accLineView);
        make.width.equalTo(accLineView);
        make.height.mas_equalTo(1);
    }];
    
    [getCodeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(pwdLineView).offset(94);
        make.left.equalTo(self).offset(42);
        make.right.equalTo(self).offset(-42);
        make.height.equalTo(40);
    }];
    
    [goLoginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(getCodeBtn.mas_bottom).offset(20);
        make.centerX.equalTo(getCodeBtn);
        make.size.mas_equalTo(CGSizeMake(100, 14));
    }];
    
    [visitorLoginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(goLoginBtn.mas_bottom).offset(20);
        make.centerX.equalTo(goLoginBtn);
        make.size.mas_equalTo(CGSizeMake(100, 14));
    }];
}

- (void)registerBtnClick:(UIButton *)button{

    switch (button.tag) {
        case RegisterGetCodeBtnTag:
        {
            if (![RegularExTool validateMobile:self.m_AccTF.text]) {
                [HUDProgressTool showOnlyText:@"请输入一个有效的手机号码!"];
            }else if(![RegularExTool validatePassWord:self.m_PwdTF.text]){
                [HUDProgressTool showOnlyText:@"密码过于简单!"];
            }else{
                PhoneVerParam *model = [[PhoneVerParam alloc] init];
                [model setPhone:self.m_AccTF.text];
                [self phoneVerification:model];
            }
        }
            break;
        case RegisterGoLoginBtnTag:{
            if ([m_Delegate respondsToSelector:@selector(onToLogIn)]) {
                [m_Delegate onToLogIn];
            }
        }
            break;
        case RegistercipherBtnTag:{
            self.m_PwdTF.secureTextEntry = !self.m_PwdTF.secureTextEntry;
            button.selected = !button.selected;
        }
            break;
        default:
            break;
    }
}

- (void)visitorLoginBtnClick:(UIButton *)button {
    if ([m_Delegate respondsToSelector:@selector(visitorLoginMode)]) {
        [m_Delegate visitorLoginMode];
    }
}

    
#pragma mark - OpenView
    
- (void)openView {
    
    self.manager = [NTESVerifyCodeManager sharedInstance];
    if (self.manager) {
        
        // 如果需要了解组件的执行情况,则实现回调
        self.manager.delegate = self;
        // captchaid的值是每个产品从后台生成的,比如 @"a05f036b70ab447b87cc788af9a60974"
        NSString *captchaid = @"a05f036b70ab447b87cc788af9a60974";
        [self.manager configureVerifyCode:captchaid timeout:10.0];
        
        // 设置透明度
        self.manager.alpha = 0.7;
        // 设置frame
        self.manager.frame = CGRectNull;
        // 显示验证码
        [self.manager openVerifyCodeView:nil];
    }
}
    
#pragma mark - NTESVerifyCodeManagerDelegate
    
    /**
     * 验证码组件初始化完成
     */
- (void)verifyCodeInitFinish{
    NSLog(@"收到初始化完成的回调");
}
    
    /**
     * 验证码组件初始化出错
     *
     * @param message 错误信息
     */
- (void)verifyCodeInitFailed:(NSString *)message{
    NSLog(@"收到初始化失败的回调:%@",message);
}
    
    /**
     * 完成验证之后的回调
     *
     * @param result 验证结果 BOOL:YES/NO
     * @param validate 二次校验数据，如果验证结果为false，validate返回空
     * @param message 结果描述信息
     *
     */
- (void)verifyCodeValidateFinish:(BOOL)result validate:(NSString *)validate message:(NSString *)message{
    NSLog(@"收到验证结果的回调:(%d,%@,%@)", result, validate, message);
    
    if (result) {
        if (m_Delegate && [m_Delegate respondsToSelector:@selector(onNextStepWithRegPhone:pwd:imgCode:)]) {
            [m_Delegate onNextStepWithRegPhone:self.m_AccTF.text pwd:self.m_PwdTF.text imgCode:self.codePopView.accTF.text];
        }
    }
}
    
    /**
     * 关闭验证码窗口后的回调
     */
- (void)verifyCodeCloseWindow{
    //用户关闭验证后执行的方法
    NSLog(@"收到关闭验证码视图的回调");
}
    
    /**
     * 网络错误
     *
     * @param error 网络错误信息
     */
- (void)verifyCodeNetError:(NSError *)error{
    //用户关闭验证后执行的方法
    NSLog(@"收到网络错误的回调:%@(%ld)", [error localizedDescription], (long)error.code);
}

#pragma mark - Public Functions
- (void)dataInitialization{
    
    // 当键盘弹起时，点击背景收起键盘
    [[IQKeyboardManager sharedManager] setShouldResignOnTouchOutside:YES];
    
}

//弹出验证码
- (void)showCodePopView{
    //添加验证码
    [self addSubview:self.codePopView];
    [self.codePopView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    [self.codePopView showCodePopView];
    
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
        self.codePopView.alpha = 0;
        self.alpha = 1.0f;
        self.backgroundColor = [UIColor whiteColor];
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
                if (m_Delegate && [m_Delegate respondsToSelector:@selector(onNextStepWithRegPhone:pwd:imgCode:)]) {
                    [m_Delegate onNextStepWithRegPhone:self.m_AccTF.text pwd:self.m_PwdTF.text imgCode:self.codePopView.accTF.text];
                }
            }else{
                [HUDProgressTool showErrorWithText:@"验证码不正确"];
            }
        }
            break;
        default:
            break;
    }
}
//判断用户名是否是11位，密码是否合法
- (BOOL)isInputLegal{
    return self.m_AccTF.text.length >= 11 && self.m_PwdTF.text.length>=8;
}

- (void)setPhone:(NSString *)phone{
//    self.m_AccTF.text = phone;
}

#pragma mark - getter
- (CodePopView *)codePopView{
    if (!_codePopView) {
        _codePopView = [[CodePopView alloc] init];
        _codePopView.alpha = 0;
        _codePopView.m_codePopViewDelegate = self;
    }
    return _codePopView;
}

#pragma mark - UITextField Delegate Methods
- (void)textFieldChanged:(UITextField *)textField{
    BOOL isEnabled = [self isInputLegal];
    [self.m_getCodeBtn setEnabled:isEnabled];
}
#pragma mark - NetworkRequest Manager
- (void)phoneVerification:(PhoneVerParam *)param{
    [HUDProgressTool showIndicatorWithText:ReqLoadingIn];
    [PhoneVerRequest phoneVerWithParam:param success:^(PhoneVerResponse *response) {
        if (response.status != 200) {
            [HUDProgressTool showOnlyText:response.msg];
            return;
        }
        [self showCodePopView];
//        [self openView];
    } failure:^(NSError *error) {
        [HUDProgressTool showErrorWithText:ReqErrCode_Custom_ErrorInfo];
    }];
    
}

@end
