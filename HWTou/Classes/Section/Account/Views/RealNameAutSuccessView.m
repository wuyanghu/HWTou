//
//  RealNameAutSuccessView.m
//  HWTou
//
//  Created by 赤 那 on 2017/3/22.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "RealNameAutSuccessView.h"

#import "PublicHeader.h"

@interface RealNameAutSuccessView(){

    UIImageView *g_SuccessImgView;
    
    UILabel *g_PromptLbl;
    
    UIButton *g_ShoppingBtn;
    UIButton *g_BindingBankCardBtn;
    
}

@end

@implementation RealNameAutSuccessView
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
    
    g_SuccessImgView = [BasisUITool getImageViewWithImage:PUBLIC_IMG_SUCCESS_ICON
                                    withIsUserInteraction:NO];
    
    g_PromptLbl = [BasisUITool getBoldLabelWithTextColor:[UIColor blackColor]
                                                    size:CLIENT_COMMON_FONT_TITLE_INCREASE_SIZE];
    
    g_ShoppingBtn = [BasisUITool getBtnWithTarget:self action:@selector(shoppingBtnClick:)];
    g_BindingBankCardBtn = [BasisUITool getBtnWithTarget:self action:@selector(bindingBankCardBtnClick:)];
    
    [self addSubview:g_SuccessImgView];
    [self addSubview:g_PromptLbl];
    [self addSubview:g_ShoppingBtn];
    [self addSubview:g_BindingBankCardBtn];
    
}

#pragma mark - Public Functions
- (void)dataInitialization{
    
    
    
}

- (void)layoutUI{
    
    [g_SuccessImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        CGFloat offset = g_SuccessImgView.frame.size.width / 2;
        
        make.top.equalTo(self).offset(54);
        make.left.equalTo(self.centerX).offset(-offset);
        
    }];
    
    [g_PromptLbl setText:@"恭喜您已实名认证成功!"];
    [g_PromptLbl setTextAlignment:NSTextAlignmentCenter];
    [g_PromptLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self).offset(25);
        make.right.equalTo(self).offset(-25);
        make.top.equalTo(g_SuccessImgView.mas_bottom).offset(10);
        
    }];
    
    [g_BindingBankCardBtn setTitle:@"去绑定银行卡" forState:UIControlStateNormal];
    [g_BindingBankCardBtn setBackgroundImage:[UIImage imageWithColor:UIColorFromHex(CLIENT_BTN_RED_NORMAL_BG)]
                                forState:UIControlStateNormal];
    [g_BindingBankCardBtn setBackgroundImage:[UIImage imageWithColor:UIColorFromHex(CLIENT_BTN_GRAY_DISABLED_BG)]
                                forState:UIControlStateDisabled];
    [g_BindingBankCardBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self).offset(25);
        make.right.equalTo(self).offset(-25);
        make.height.equalTo(40);
        make.top.equalTo(g_PromptLbl.mas_bottom).offset(15);
        
    }];
    
    [g_ShoppingBtn setTitle:@"先逛逛" forState:UIControlStateNormal];
    [g_ShoppingBtn setTitleColor:UIColorFromHex(CLIENT_FONT_GRAY_COLOR) forState:UIControlStateNormal];
    [g_ShoppingBtn.layer setBorderWidth:0.5];
    [g_ShoppingBtn.layer setBorderColor:UIColorFromHex(CLIENT_LINE_GRAY_BG).CGColor];
    [g_ShoppingBtn setBackgroundImage:[UIImage imageWithColor:UIColorFromHex(CLIENT_BTN_WHITE_NORMAL_BG)]
                             forState:UIControlStateNormal];
    [g_ShoppingBtn setBackgroundImage:[UIImage imageWithColor:UIColorFromHex(CLIENT_BTN_GRAY_DISABLED_BG)]
                             forState:UIControlStateDisabled];
    [g_ShoppingBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(g_BindingBankCardBtn);
        make.right.equalTo(g_BindingBankCardBtn);
        make.height.equalTo(g_BindingBankCardBtn);
        make.top.equalTo(g_BindingBankCardBtn.mas_bottom).offset(15);
        
    }];
}

#pragma mark - Button Handlers
- (void)shoppingBtnClick:(id)sender{
    
    if (m_Delegate && [m_Delegate respondsToSelector:@selector(onGoToShopping)]) {
        
        [m_Delegate onGoToShopping];
    }
}

- (void)bindingBankCardBtnClick:(id)sender{
    
    if (m_Delegate && [m_Delegate respondsToSelector:@selector(onGoToBindingBankCard)]) {
        
        [m_Delegate onGoToBindingBankCard];
    }
}

@end
