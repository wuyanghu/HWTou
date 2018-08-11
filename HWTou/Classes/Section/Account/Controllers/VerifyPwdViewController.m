//
//  VerifyPwdViewController.m
//  HWTou
//
//  Created by Alan Jiang on 2017/4/18.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "VerifyPwdViewController.h"

#import "PublicHeader.h"

#import "VerifyPwdView.h"
#import "AccountManager.h"
#import "ReplacePhoneViewController.h"

@interface VerifyPwdViewController ()<VerifyPwdViewDelegate>

@property (nonatomic, strong) VerifyPwdView *m_VerifyPwdView;

@end

@implementation VerifyPwdViewController
@synthesize m_VerifyPwdView;

#pragma mark - Life Cycle
- (void)viewDidLoad{
    
    [super viewDidLoad];
    
    [self setTitle:@"修改手机号"];
    
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
    
    [self addVerifyPwdView];
    
}

- (void)addVerifyPwdView{

    VerifyPwdView *verifyPwdView = [[VerifyPwdView alloc] init];
    
    [verifyPwdView setM_Delegate:self];
    
    [self setM_VerifyPwdView:verifyPwdView];
    [self.view addSubview:verifyPwdView];
    
    [verifyPwdView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.equalTo(self.view);
        
    }];
    
}

#pragma mark - Public Functions
- (void)dataInitialization{

    
    
}

#pragma mark - VerifyPwdView Delegate Manager
- (void)onVerifyPwdSuccessful{

    ReplacePhoneViewController *replacePhoneVC = [[ReplacePhoneViewController alloc] init];
    
    [self.navigationController pushViewController:replacePhoneVC animated:YES];
    
}

@end
