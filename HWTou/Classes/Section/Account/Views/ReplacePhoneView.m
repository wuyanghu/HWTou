//
//  ReplacePhoneView.m
//  HWTou
//
//  Created by 赤 那 on 2017/4/25.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "ReplacePhoneView.h"

#import "PublicHeader.h"
#import "RegularExTool.h"

@interface ReplacePhoneView()

@property (nonatomic, strong) UITextField *m_PhoneTF;
@property (nonatomic, strong) UIButton *m_NextStepBtn;

@end

@implementation ReplacePhoneView
@synthesize m_Delegate;

@synthesize m_PhoneTF;
@synthesize m_NextStepBtn;

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
    
    UILabel *promptLbl = [BasisUITool getBoldLabelWithTextColor:[UIColor blackColor]
                                                           size:CLIENT_COMMON_FONT_CONTENT_SIZE];
    
    [promptLbl setText:@"手机号"];
    
    [self addSubview:promptLbl];
    
    UIView *lineView = [[UIView alloc] init];
    
    [lineView setBackgroundColor:UIColorFromHex(CLIENT_LINE_GRAY_BG)];
    
    [self addSubview:lineView];
    
    UITextField *phoneTF = [BasisUITool getBoldTextFieldWithTextColor:[UIColor blackColor]
                                                             withSize:CLIENT_COMMON_FONT_INPUTBOX_SIZE withPlaceholder:@"请输入新的手机号"
                                                         withDelegate:self];
    
    [self setM_PhoneTF:phoneTF];
    [self addSubview:phoneTF];
    
    UIButton *nextStepBtn = [BasisUITool getBtnWithTarget:self action:@selector(nextStepBtnClick:)];
    
    [nextStepBtn setTitle:@"下一步" forState:UIControlStateNormal];
    [nextStepBtn setBackgroundImage:[UIImage imageWithColor:UIColorFromHex(CLIENT_BTN_RED_NORMAL_BG)]
                           forState:UIControlStateNormal];
    [nextStepBtn setBackgroundImage:[UIImage imageWithColor:UIColorFromHex(CLIENT_BTN_GRAY_DISABLED_BG)]
                           forState:UIControlStateDisabled];
    
    
    [self setM_NextStepBtn:nextStepBtn];
    [self addSubview:nextStepBtn];
    
    /* ********** layout UI ********** */
    
    [promptLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        CGSize size = [BasisUITool calculateSize:promptLbl.text font:promptLbl.font];
        
        make.top.equalTo(self).offset(26);
        make.leading.equalTo(self).offset(25);
        make.width.equalTo(size);
        
    }];
    
    [phoneTF mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.equalTo(promptLbl.mas_centerY);
        make.leading.equalTo(promptLbl.mas_trailing).offset(15);
        make.trailing.equalTo(self).offset(-25);
        
    }];
    
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(promptLbl.mas_bottom).offset(7);
        make.leading.equalTo(promptLbl);
        make.trailing.equalTo(phoneTF);
        make.height.equalTo(0.5);
        
    }];
    
    [nextStepBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(lineView.mas_bottom).offset(29.5);
        make.leading.trailing.equalTo(lineView);
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
- (void)nextStepBtnClick:(id)sender{
    
    NSString *phone = m_PhoneTF.text;
    
    if ([RegularExTool validateMobile:phone]) {
        
        if (m_Delegate && [m_Delegate respondsToSelector:@selector(onReplacePhone:)]) {
            
            [m_Delegate onReplacePhone:phone];
            
        }
        
    }else{
        
        [HUDProgressTool showOnlyText:@"请输入一个有效的手机号码!"];
        
    }
    
}

#pragma mark - UITextField Delegate Methods
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    
    return YES;
    
}

@end
