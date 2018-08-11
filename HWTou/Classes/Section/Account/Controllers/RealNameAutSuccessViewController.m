//
//  RealNameAutSuccessViewController.m
//  HWTou
//
//  Created by 赤 那 on 2017/3/22.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "RealNameAutSuccessViewController.h"

#import "PublicHeader.h"

#import "RealNameAutSuccessView.h"
#import "BindingBankCardViewController.h"

@interface RealNameAutSuccessViewController ()<RealNameAutSuccessViewDelegate>

@property (nonatomic, strong) RealNameAutSuccessView *m_AutSuccessView;

@end

@implementation RealNameAutSuccessViewController
@synthesize m_AutSuccessView;

#pragma mark - Life Cycle
- (void)viewDidLoad{
    
    [super viewDidLoad];
    
    [self setTitle:@"实名认证成功"];
    
    [self dataInitialization];
    [self addMainView];
    
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
}

- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    
}

- (void)didReceiveMemoryWarning{
    
    [super didReceiveMemoryWarning];
    
}

#pragma mark - Add UI
- (void)addMainView{
    
    [self addAutSuccessView];
    
}

- (void)addAutSuccessView{
    
    RealNameAutSuccessView *autSuccessView = [[RealNameAutSuccessView alloc] init];
    
    [autSuccessView setM_Delegate:self];
    
    [self setM_AutSuccessView:autSuccessView];
    [self.view addSubview:autSuccessView];
    
    [autSuccessView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.equalTo(self.view);
        
    }];
    
}

#pragma mark - Public Functions
- (void)dataInitialization{
    
    
    
}

#pragma mark - Button Handlers
- (void)onClickNavigationBack{
    
    [self.navigationController popToRootViewControllerAnimated:YES];
    
}

#pragma mark - RealNameAutSuccessView Delegate Manager
- (void)onGoToShopping{
    
    [self.navigationController popToRootViewControllerAnimated:YES];
    
}

- (void)onGoToBindingBankCard{
    
    BindingBankCardViewController *bindingBankCardVC = [[BindingBankCardViewController alloc] init];
    
    [self.navigationController pushViewController:bindingBankCardVC animated:YES];
    
}

@end
