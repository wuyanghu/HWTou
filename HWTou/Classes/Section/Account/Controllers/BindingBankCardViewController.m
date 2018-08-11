//
//  BindingBankCardViewController.m
//  HWTou
//
//  Created by 赤 那 on 2017/3/23.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "BindingBankCardViewController.h"

#import "PublicHeader.h"
#import "BindingBankCardView.h"
#import "SetUpTradingPwdViewController.h"

@interface BindingBankCardViewController ()<BindingBankCardViewDelegate>

@property (nonatomic, strong) BindingBankCardView *m_BindingBankCardView;

@end

@implementation BindingBankCardViewController
@synthesize m_BindingBankCardView;

#pragma mark - Life Cycle
- (void)viewDidLoad{
    
    [super viewDidLoad];
    
    [self setTitle:@"绑定银行卡"];
    
    [self dataInitialization];
    [self addMainView];
    
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
}

- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    
    [self.view endEditing:YES];
    
}

- (void)didReceiveMemoryWarning{
    
    [super didReceiveMemoryWarning];
    
}

#pragma mark - Add UI
- (void)addMainView{
    
    [self addRealNameAutView];
    
}

- (void)addRealNameAutView{
    
    BindingBankCardView *bindingBankCardView = [[BindingBankCardView alloc] init];
    
    [bindingBankCardView setM_Delegate:self];
    
    [self setM_BindingBankCardView:bindingBankCardView];
    [self.view addSubview:bindingBankCardView];
    
    [bindingBankCardView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.edges.equalTo(self.view);
        
    }];
    
}

#pragma mark - Public Functions
- (void)dataInitialization{
    
    
    
}

#pragma mark - Button Handlers

#pragma mark - BindingBankCardView Delegate Manager
- (void)onNextStepWithBankName:(NSString *)name withBankCardNumber:(NSString *)cardNumber{
    
    SetUpTradingPwdViewController *setUpTradingPwdVC = [[SetUpTradingPwdViewController alloc] init];
    
    [self.navigationController pushViewController:setUpTradingPwdVC animated:YES];
    
}

@end
