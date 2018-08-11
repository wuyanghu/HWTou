//
//  RealNameAutView.m
//  HWTou
//
//  Created by 赤 那 on 2017/3/22.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "RealNameAutView.h"

#import "PublicHeader.h"
#import "RegularExTool.h"

@interface RealNameAutView()<UITextFieldDelegate>{

    UILabel *g_NameLbl;
    UILabel *g_IdCardLbl;
    
    UIView *g_OneLineView;
    UIView *g_TwoLineView;
    
    UITextField *g_NameTF;
    UITextField *g_IdCardTF;
    
    UIButton *g_RealNameAutBtn;
    
}

@end

@implementation RealNameAutView
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

    g_NameLbl = [BasisUITool getBoldLabelWithTextColor:[UIColor blackColor]
                                                  size:CLIENT_COMMON_FONT_CONTENT_SIZE];
    
    g_IdCardLbl = [BasisUITool getBoldLabelWithTextColor:[UIColor blackColor]
                                                    size:CLIENT_COMMON_FONT_CONTENT_SIZE];
    
    g_OneLineView = [[UIView alloc] init];
    
    g_TwoLineView = [[UIView alloc] init];
    
    g_NameTF = [BasisUITool getBoldTextFieldWithTextColor:[UIColor blackColor]
                                                 withSize:CLIENT_COMMON_FONT_INPUTBOX_SIZE
                                          withPlaceholder:@"请输入您的姓名"
                                             withDelegate:self];
    
    g_IdCardTF = [BasisUITool getBoldTextFieldWithTextColor:[UIColor blackColor]
                                                    withSize:CLIENT_COMMON_FONT_INPUTBOX_SIZE
                                             withPlaceholder:@"请输入您的身份证号码"
                                                withDelegate:self];
    
    g_RealNameAutBtn = [BasisUITool getBtnWithTarget:self action:@selector(realNameAutBtnClick:)];
    
    [self addSubview:g_NameLbl];
    [self addSubview:g_IdCardLbl];
    
    [self addSubview:g_OneLineView];
    [self addSubview:g_TwoLineView];
    
    [self addSubview:g_NameTF];
    [self addSubview:g_IdCardTF];
    
    [self addSubview:g_RealNameAutBtn];
    
}

#pragma mark - Public Functions
- (void)dataInitialization{
    
    // 当键盘弹起时，点击背景收起键盘
    [[IQKeyboardManager sharedManager] setShouldResignOnTouchOutside:YES];
    
}

- (void)layoutUI{
     
    NSString *nameStr = @"姓名 :";
    CGSize nameSize = [BasisUITool calculateSize:nameStr font:g_NameTF.font];

    [g_NameLbl setText:nameStr];
    [g_NameLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self).offset(25);
        make.width.equalTo(nameSize.width);
        make.top.equalTo(self).offset(25);
        
    }];
    
    [g_NameTF setClearsOnBeginEditing:NO];
    [g_NameTF mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(g_NameLbl.mas_right).offset(15);
        make.right.equalTo(self).offset(-25);
        make.top.equalTo(g_NameLbl);
        
    }];
    
    [g_OneLineView setBackgroundColor:UIColorFromHex(CLIENT_LINE_GRAY_BG)];
    [g_OneLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self).offset(25);
        make.right.equalTo(self).offset(-25);
        make.height.equalTo(0.5);
        make.top.equalTo(g_NameLbl.mas_bottom).offset(7);
        
    }];
    
    NSString *idCardStr = @"身份证 :";
    CGSize idCardSize = [BasisUITool calculateSize:idCardStr font:g_IdCardLbl.font];
    
    [g_IdCardLbl setText:idCardStr];
    [g_IdCardLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self).offset(25);
        make.width.equalTo(idCardSize.width);
        make.top.equalTo(g_OneLineView.mas_bottom).offset(CoordYSizeScale(20));
        
    }];
    
    [g_IdCardTF setClearsOnBeginEditing:NO];
    [g_IdCardTF mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(g_IdCardLbl.mas_right).offset(15);
        make.right.equalTo(self).offset(-25);
        make.top.equalTo(g_IdCardLbl);
        
    }];
    
    [g_TwoLineView setBackgroundColor:UIColorFromHex(CLIENT_LINE_GRAY_BG)];
    [g_TwoLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.and.right.equalTo(g_OneLineView);
        make.height.equalTo(0.5);
        make.top.equalTo(g_IdCardLbl.mas_bottom).offset(7);
        
    }];
    
    [g_RealNameAutBtn setEnabled:NO];
    [g_RealNameAutBtn setTitle:@"下一步" forState:UIControlStateNormal];
    [g_RealNameAutBtn setBackgroundImage:[UIImage imageWithColor:UIColorFromHex(CLIENT_BTN_RED_NORMAL_BG)]
                        forState:UIControlStateNormal];
    [g_RealNameAutBtn setBackgroundImage:[UIImage imageWithColor:UIColorFromHex(CLIENT_BTN_GRAY_DISABLED_BG)]
                        forState:UIControlStateDisabled];
    [g_RealNameAutBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self).offset(25);
        make.right.equalTo(self).offset(-25);
        make.height.equalTo(40);
        make.top.equalTo(g_TwoLineView.bottom).offset(29.5);
        
    }];
    
}

- (void)dataValidation{
    
    BOOL isEnabled = [g_NameTF.text length] > 0 && [g_IdCardTF.text length] > 0 ? YES : NO;
    
    [g_RealNameAutBtn setEnabled:isEnabled];
    
}

- (void)realNameAuthentication {

    if (m_Delegate && [m_Delegate respondsToSelector:@selector(onRealNameAutSuccessful)]) {
        
        [m_Delegate onRealNameAutSuccessful];
        
    }
}

- (BOOL)inputValidation:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range
      replacementString:(NSString *)string{
    
    NSInteger existedLength = textField.text.length;
    NSInteger selectedLength = range.length;
    NSInteger replaceLength = string.length;

    NSInteger length = existedLength - selectedLength + replaceLength;
    
    return length > 0 ? YES : NO;
    
}

#pragma mark - Button Handlers
- (void)realNameAutBtnClick:(id)sender{

    if ([RegularExTool validateIdentityCard:g_IdCardTF.text]) {// 身份证校验
        
        if (m_Delegate && [m_Delegate respondsToSelector:@selector(onShowAlertController)]) {
            
            [m_Delegate onShowAlertController];
            
        }
        
    }else{// 无效
        
         [HUDProgressTool showOnlyText:@"该身份证无效,请核对后重新输入!"];
        
    }
    
}

#pragma mark - UITextField Delegate Methods
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    
    return YES;
    
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    
    [self dataValidation];
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    
    [self dataValidation];
    
}

- (BOOL)textFieldShouldClear:(UITextField *)textField{
    
    [g_RealNameAutBtn setEnabled:NO];
    
    return YES;
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range
replacementString:(NSString *)string{
    
    BOOL isEnabled = NO;
    
    if ([textField isEqual:g_NameTF]) {
        
        if ([self inputValidation:textField shouldChangeCharactersInRange:range replacementString:string]
            && g_IdCardTF.text.length > 0) {
            
            isEnabled = YES;
            
        }
        
    }else if ([textField isEqual:g_IdCardTF]){
    
        if ([self inputValidation:textField shouldChangeCharactersInRange:range replacementString:string]
            && g_NameTF.text.length > 0) {
            
            isEnabled = YES;
            
        }
        
    }
    
    [g_RealNameAutBtn setEnabled:isEnabled];
    
    return YES;
    
}

#pragma mark - NetworkRequest Manager

@end
