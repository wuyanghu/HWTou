//
//  SetUpTradingPwdViewController.m
//  HWTou
//
//  Created by 赤 那 on 2017/3/23.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "SetUpTradingPwdViewController.h"

#import "SetUpTradingPwdView.h"

@interface SetUpTradingPwdViewController ()<SetUpTradingPwdViewDelegate>

@property (nonatomic, strong) SetUpTradingPwdView *m_SetUpTradingPwdView;

@end

@implementation SetUpTradingPwdViewController
@synthesize m_SetUpTradingPwdView;

#pragma mark - Life Cycle
- (void)viewDidLoad{
    
    [super viewDidLoad];
    
    [self setTitle:@"设置交易密码"];
    
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
    
    SetUpTradingPwdView *setUpTradingPwdView = [[SetUpTradingPwdView alloc]
                                                initWithFrame:self.view.bounds];
    
    [setUpTradingPwdView setM_Delegate:self];
    
    [self setM_SetUpTradingPwdView:setUpTradingPwdView];
    [self.view addSubview:setUpTradingPwdView];
    
}

#pragma mark - Public Functions
- (void)dataInitialization{
    
    
    
}

#pragma mark - Button Handlers

#pragma mark - BindingBankCardView Delegate Manager
- (void)onBindingSuccess{

    [self.navigationController popToRootViewControllerAnimated:YES];
    
}

@end
