//
//  RegSuccessView.m
//  HWTou
//
//  Created by 赤 那 on 2017/3/21.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "RegSuccessView.h"

#import "PublicHeader.h"

@interface RegSuccessView(){

    UIImageView *g_SuccessImgView;
    
    UILabel *g_PromptLbl;
    
    UIButton *g_ShoppingBtn;
    UIButton *g_RealNameAutBtn;
    
}

@end

@implementation RegSuccessView
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
    g_RealNameAutBtn = [BasisUITool getBtnWithTarget:self action:@selector(realNameAutBtnClick:)];
    
    [self addSubview:g_SuccessImgView];
    [self addSubview:g_PromptLbl];
    [self addSubview:g_ShoppingBtn];
    [self addSubview:g_RealNameAutBtn];
    
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
    
    [g_PromptLbl setText:@"恭喜您已注册成功!"];
    [g_PromptLbl setTextAlignment:NSTextAlignmentCenter];
    [g_PromptLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self).offset(25);
        make.right.equalTo(self).offset(-25);
        make.top.equalTo(g_SuccessImgView.mas_bottom).offset(10);
        
    }];
    
    /*
    [g_RealNameAutBtn setTitle:@"去实名认证" forState:UIControlStateNormal];
    [g_RealNameAutBtn setBackgroundImage:[UIImage imageWithColor:UIColorFromHex(CLIENT_BTN_RED_NORMAL_BG)]
                             forState:UIControlStateNormal];
    [g_RealNameAutBtn setBackgroundImage:[UIImage imageWithColor:UIColorFromHex(CLIENT_BTN_GRAY_DISABLED_BG)]
                             forState:UIControlStateDisabled];
    [g_RealNameAutBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self).offset(25);
        make.right.equalTo(self).offset(-25);
        make.height.equalTo(40);
        make.top.equalTo(g_PromptLbl.mas_bottom).offset(15);
        
    }];
    */
    
    [g_ShoppingBtn setTitle:@"去逛逛" forState:UIControlStateNormal];
    [g_ShoppingBtn setTitleColor:UIColorFromHex(CLIENT_FONT_GRAY_COLOR) forState:UIControlStateNormal];
    [g_ShoppingBtn.layer setBorderWidth:0.5];
    [g_ShoppingBtn.layer setBorderColor:UIColorFromHex(CLIENT_LINE_GRAY_BG).CGColor];
    [g_ShoppingBtn setBackgroundImage:[UIImage imageWithColor:UIColorFromHex(CLIENT_BTN_WHITE_NORMAL_BG)]
                                forState:UIControlStateNormal];
    [g_ShoppingBtn setBackgroundImage:[UIImage imageWithColor:UIColorFromHex(CLIENT_BTN_GRAY_DISABLED_BG)]
                                forState:UIControlStateDisabled];
    [g_ShoppingBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
//        make.left.equalTo(g_RealNameAutBtn);
//        make.right.equalTo(g_RealNameAutBtn);
//        make.height.equalTo(g_RealNameAutBtn);
//        make.top.equalTo(g_RealNameAutBtn.mas_bottom).offset(15);
        
        make.left.equalTo(self).offset(25);
        make.right.equalTo(self).offset(-25);
        make.height.equalTo(40);
        make.top.equalTo(g_PromptLbl.mas_bottom).offset(15);

    }];
}

#pragma mark - Button Handlers
- (void)shoppingBtnClick:(id)sender{
    
    if (m_Delegate && [m_Delegate respondsToSelector:@selector(onGoToShopping)]) {
        
        [m_Delegate onGoToShopping];
        
    }
    
}

- (void)realNameAutBtnClick:(id)sender{
    
    if (m_Delegate && [m_Delegate respondsToSelector:@selector(onGoToRealNameAuthentication)]) {
        
        [m_Delegate onGoToRealNameAuthentication];
        
    }
    
}

@end
