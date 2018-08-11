//
//  BindingBankCardView.m
//  HWTou
//
//  Created by 赤 那 on 2017/3/23.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "BindingBankCardView.h"

#import "PublicHeader.h"
#import "RegularExTool.h"

@interface BindingBankCardView()<UITextFieldDelegate>{

    UILabel *g_BankNameLbl;
    UILabel *g_CardNumberLbl;
    
    UIView *g_OneLineView;
    UIView *g_TwoLineView;
    
    UITextField *g_BankNameTF;
    UITextField *g_BankCardNumberTF;
    
    UIButton *g_NextStepBtn;
    
}

@end

@implementation BindingBankCardView
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
    
    g_BankNameLbl = [BasisUITool getBoldLabelWithTextColor:[UIColor blackColor]
                                                      size:CLIENT_COMMON_FONT_CONTENT_SIZE];
    
    g_CardNumberLbl = [BasisUITool getBoldLabelWithTextColor:[UIColor blackColor]
                                                        size:CLIENT_COMMON_FONT_CONTENT_SIZE];
    
    g_OneLineView = [[UIView alloc] init];
    
    g_TwoLineView = [[UIView alloc] init];
    
    g_BankNameTF = [BasisUITool getBoldTextFieldWithTextColor:[UIColor blackColor]
                                                     withSize:CLIENT_COMMON_FONT_INPUTBOX_SIZE
                                              withPlaceholder:@"请输入银行名称"
                                                 withDelegate:self];
    
    g_BankCardNumberTF = [BasisUITool getBoldTextFieldWithTextColor:[UIColor blackColor]
                                                           withSize:CLIENT_COMMON_FONT_INPUTBOX_SIZE
                                                    withPlaceholder:@"请输入您的银行卡号"
                                                       withDelegate:self];
    
    g_NextStepBtn = [BasisUITool getBtnWithTarget:self action:@selector(nextStepBtnClick:)];
    
    [self addSubview:g_BankNameLbl];
    [self addSubview:g_CardNumberLbl];
    
    [self addSubview:g_OneLineView];
    [self addSubview:g_TwoLineView];
    
    [self addSubview:g_BankNameTF];
    [self addSubview:g_BankCardNumberTF];
    
    [self addSubview:g_NextStepBtn];
    
}

#pragma mark - Public Functions
- (void)dataInitialization{
    
    // 当键盘弹起时，点击背景收起键盘
    [[IQKeyboardManager sharedManager] setShouldResignOnTouchOutside:YES];
    
}

- (void)layoutUI{
    
    NSString *nameStr = @"银行名称 :";
    CGSize nameSize = [BasisUITool calculateSize:nameStr font:g_BankNameTF.font];
    
    [g_BankNameLbl setText:nameStr];
    [g_BankNameLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self).offset(25);
        make.width.equalTo(nameSize.width);
        make.top.equalTo(self).offset(25);
        
    }];
    
    [g_BankNameTF setClearsOnBeginEditing:NO];
    [g_BankNameTF mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(g_BankNameLbl.mas_right).offset(15);
        make.right.equalTo(self).offset(-25);
        make.top.equalTo(g_BankNameLbl);
        
    }];
    
    [g_OneLineView setBackgroundColor:UIColorFromHex(CLIENT_LINE_GRAY_BG)];
    [g_OneLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self).offset(25);
        make.right.equalTo(self).offset(-25);
        make.height.equalTo(0.5);
        make.top.equalTo(g_BankNameLbl.bottom).offset(7);
        
    }];
    
    NSString *idCardStr = @"银行卡号 :";
    CGSize idCardSize = [BasisUITool calculateSize:idCardStr font:g_CardNumberLbl.font];
    
    [g_CardNumberLbl setText:idCardStr];
    [g_CardNumberLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self).offset(25);
        make.width.equalTo(idCardSize.width);
        make.top.equalTo(g_OneLineView.bottom).offset(20);
        
    }];
    
    [g_BankCardNumberTF setClearsOnBeginEditing:NO];
    [g_BankCardNumberTF setKeyboardType:UIKeyboardTypeNumberPad];
    [g_BankCardNumberTF mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(g_CardNumberLbl.mas_right).offset(15);
        make.right.equalTo(self).offset(-25);
        make.top.equalTo(g_CardNumberLbl);
        
    }];
    
    [g_TwoLineView setBackgroundColor:UIColorFromHex(CLIENT_LINE_GRAY_BG)];
    [g_TwoLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.and.right.equalTo(g_OneLineView);
        make.height.equalTo(0.5);
        make.top.equalTo(g_CardNumberLbl.bottom).offset(7);
        
    }];
    
    [g_NextStepBtn setEnabled:NO];
    [g_NextStepBtn setTitle:@"下一步" forState:UIControlStateNormal];
    [g_NextStepBtn setBackgroundImage:[UIImage imageWithColor:UIColorFromHex(CLIENT_BTN_RED_NORMAL_BG)]
                                forState:UIControlStateNormal];
    [g_NextStepBtn setBackgroundImage:[UIImage imageWithColor:UIColorFromHex(CLIENT_BTN_GRAY_DISABLED_BG)]
                                forState:UIControlStateDisabled];
    [g_NextStepBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self).offset(25);
        make.right.equalTo(self).offset(-25);
        make.height.equalTo(40);
        make.top.equalTo(g_TwoLineView.bottom).offset(29.5);
        
    }];
    
}

- (void)dataValidation{
    
    BOOL isEnabled = [g_BankNameTF.text length] > 0 && [g_BankCardNumberTF.text length] > 0 ? YES : NO;
    
    [g_NextStepBtn setEnabled:isEnabled];
    
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
- (void)nextStepBtnClick:(id)sender{
    
    if (m_Delegate && [m_Delegate respondsToSelector:@selector(onNextStepWithBankName:withBankCardNumber:)]) {
        
        [m_Delegate onNextStepWithBankName:g_BankNameTF.text
                        withBankCardNumber:g_BankCardNumberTF.text];
        
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
    
    [g_NextStepBtn setEnabled:NO];
    
    return YES;
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range
replacementString:(NSString *)string{
    
    BOOL isEnabled = NO;
    
    if ([textField isEqual:g_BankNameTF]) {
        
        if ([self inputValidation:textField shouldChangeCharactersInRange:range replacementString:string]
            && g_BankCardNumberTF.text.length > 0) {
            
            isEnabled = YES;
            
        }
        
    }else if ([textField isEqual:g_BankCardNumberTF]){
        
        if ([self inputValidation:textField shouldChangeCharactersInRange:range replacementString:string]
            && g_BankNameTF.text.length > 0) {
            
            isEnabled = YES;
            
        }
        
    }
    
    [g_NextStepBtn setEnabled:isEnabled];
    
    return YES;
    
}

#pragma mark - NetworkRequest Manager

@end
