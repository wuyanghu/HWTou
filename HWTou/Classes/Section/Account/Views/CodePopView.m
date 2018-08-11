//
//  CodePopView.m
//  HWTou
//
//  Created by robinson on 2017/11/10.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "CodePopView.h"
#import "BasisUITool.h"
#import "PublicHeader.h"
#import "HUDProgressTool.h"
#import "InterfaceDefine.h"
#import "VerifyCodeRequest.h"

#define Popup_icon_Picture_verification @"Popup_icon_Picture_verification"

@interface CodePopView()
{
    UIImageView * pwdIconImageView;//验证码
    UIView * bgView;
    NSString * imageText;
}

@end

@implementation CodePopView

- (instancetype)init{
    self = [super init];
    if (self) {
        [self addView];
        
        //注册键盘弹出通知
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWillShow:)
                                                     name:UIKeyboardWillShowNotification
                                                   object:nil];
        //注册键盘隐藏通知
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWillHide:)
                                                     name:UIKeyboardWillHideNotification
                                                   object:nil];
    }
    return self;
}

- (void)codePopView{
    
}

- (void)drawRect:(CGRect)rect {

}

- (void)addView{
    
    bgView = [[UIView alloc] init];
    bgView.backgroundColor = [UIColor whiteColor];
    bgView.layer.cornerRadius = 10.0f;
    [bgView.layer setMasksToBounds:YES];
    [self addSubview:bgView];
    
    UIButton * closeBtn = [BasisUITool getBtnWithTarget:self action:@selector(buttonClick:)];
    closeBtn.tag = closeButtonClickTag;
    [closeBtn setBackgroundImage:[UIImage imageNamed:@"navi_close_btn"] forState:UIControlStateNormal];
    [bgView addSubview:closeBtn];
    
    UILabel * codeLabel = [BasisUITool getLabelWithTextColor:UIColorFromHex(0x2B2B2B) size:18];
    codeLabel.text = @"验证码";
    [bgView addSubview:codeLabel];
    
    UIImageView * accIconImageView = [BasisUITool getImageViewWithImage:Popup_icon_Picture_verification withIsUserInteraction:NO];
    [bgView addSubview:accIconImageView];
    
    UILabel *accLbl = [BasisUITool getBoldLabelWithTextColor:[UIColor blackColor]
                                                        size:CLIENT_COMMON_FONT_TITLE_SIZE];
    
    [accLbl setHidden:YES];
    [accLbl setTextAlignment:NSTextAlignmentCenter];
    
    [bgView addSubview:accLbl];
    
    UITextField *accTF = [BasisUITool getBoldTextFieldWithTextColor:UIColorFromHex(0xB8B8B8)
                                                           withSize:CLIENT_COMMON_FONT_INPUTBOX_SIZE
                                                    withPlaceholder:@"请输入图片验证码"
                                                       withDelegate:self];
    
    [self setAccTF:accTF];
    [bgView addSubview:accTF];
    
    UIView *accLineView = [[UIView alloc] init];
    [accLineView setBackgroundColor:UIColorFromHex(CLIENT_LINE_GRAY_BG)];
    [bgView addSubview:accLineView];
    
    pwdIconImageView = [BasisUITool getImageViewWithImage:@"navi_close_btn" withIsUserInteraction:NO];
    [bgView addSubview:pwdIconImageView];
    
    UIButton * cipherBtn = [BasisUITool getBtnWithTarget:self action:@selector(buttonClick:)];
    cipherBtn.tag = switchButtonClickTag;
    [cipherBtn setTitle:@"换一张" forState:UIControlStateNormal];
    [cipherBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [cipherBtn.layer setBorderWidth:1.0];
    cipherBtn.layer.borderColor = UIColorFromHex(0XBABABA).CGColor;
    [bgView addSubview:cipherBtn];
    
    UIView *pwdLineView = [[UIView alloc] init];
    [pwdLineView setBackgroundColor:UIColorFromHex(CLIENT_LINE_GRAY_BG)];
    [bgView addSubview:pwdLineView];
    
    UIButton *loginBtn = [BasisUITool getBtnWithTarget:self action:@selector(buttonClick:)];
    loginBtn.tag = sureButtonClickTag;
    [loginBtn.titleLabel setFont:FontPFRegular(17)];
    [loginBtn setTitle:@"确定" forState:UIControlStateNormal];
    [loginBtn setTitleColor:UIColorFromHex(0XAD0021) forState:UIControlStateNormal];
    [bgView addSubview:loginBtn];
    
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(25);
        make.right.equalTo(self).offset(-25);
        make.top.equalTo(self).offset(153);
        make.height.equalTo(220);
    }];
    
    [closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.and.height.equalTo(17);
        make.left.top.equalTo(bgView).offset(10);
    }];
    
    [codeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(17.5);
        make.centerX.equalTo(bgView);
        make.top.equalTo(bgView).offset(44.5);
    }];
    
    [accIconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bgView).offset(87);
        make.left.mas_equalTo(41.5);
        make.size.equalTo(CGSizeMake(26, 20.5));
    }];
    
    [accLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(accIconImageView);
        make.left.equalTo(accIconImageView.mas_right).offset(10.5);
        make.right.mas_equalTo(bgView).offset(-46);
        make.height.equalTo(25);
    }];
    
    [accTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.trailing.equalTo(accLbl);
    }];
    
    [accLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(accTF.mas_bottom).offset(13);
        make.left.equalTo(accIconImageView);
        make.right.equalTo(bgView).offset(-17);
        make.height.equalTo(0.5);
    }];
    
    [pwdIconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(accTF);
        make.size.equalTo(CGSizeMake(120.5, 25));
        make.top.equalTo(accLineView.mas_bottom).offset(10);
    }];
    
    [cipherBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(bgView).offset(-18.5);
        make.top.equalTo(accLineView.mas_bottom).offset(7);
        make.size.equalTo(CGSizeMake(99, 30));
    }];
    
    [pwdLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(cipherBtn.mas_bottom).offset(7);
        make.left.equalTo(accLineView);
        make.width.equalTo(accLineView);
        make.height.mas_equalTo(1);
    }];
    
    [loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(bgView);
        make.bottom.equalTo(bgView).offset(-18);
        make.height.equalTo(16);
    }];
    
}

- (void)buttonClick:(UIButton *)button{
    if (button.tag == switchButtonClickTag) {
        [self actionImageCode];
    }
    if ([_m_codePopViewDelegate respondsToSelector:@selector(buttonClick:)]) {
        [_m_codePopViewDelegate buttonClick:button.tag];
    }
}
//弹出框
- (void)showCodePopView{
    [self actionImageCode];//刷新验证码
    _accTF.text = @"";
}

//关闭框
- (void)colseCodePopView{
    [self removeFromSuperview];
}

//获取验证码
- (void)actionImageCode
{
    [HUDProgressTool showIndicatorWithText:nil inView:pwdIconImageView];
    [CodeValidImageRequest getCodeValidImageWithParam:^(CodeValidImageParam *response) {
        [HUDProgressTool dismissFormView:pwdIconImageView animated:YES];
        pwdIconImageView.image = [UIImage imageWithData:response.imageData];
        imageText = response.codeImage;
    }failure:^(NSError *error) {
        [HUDProgressTool showOnlyText:@"图片获取失败"];
        pwdIconImageView.image = [UIImage imageNamed:@"navi_close_btn"];
        imageText = nil;
    }];
}

- (BOOL)isCodeVaild{
    return [[self.accTF.text lowercaseString] isEqualToString:[imageText lowercaseString]];
}

#pragma mark - UITextFieldDelegate
//键盘弹出后将视图向上移动
-(void)keyboardWillShow:(NSNotification *)note
{
    NSTimeInterval animationDuration = 0.50f;
    [UIView beginAnimations:@"ResizeView" context:nil];
    [UIView setAnimationDuration:animationDuration];
    [bgView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(100);
    }];
    [self layoutIfNeeded];
    [UIView commitAnimations];
}

//键盘隐藏后将视图恢复到原始状态
-(void)keyboardWillHide:(NSNotification *)note
{
    NSTimeInterval animationDuration = 0.50f;
    [UIView beginAnimations:@"ResizeView" context:nil];
    [UIView setAnimationDuration:animationDuration];
    [bgView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(153);
    }];
    
    [self layoutIfNeeded];
    [UIView commitAnimations];
}

@end
