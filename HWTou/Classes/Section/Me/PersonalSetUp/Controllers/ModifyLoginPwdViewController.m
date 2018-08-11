//
//  ModifyLoginPwdViewController.m
//  HWTou
//
//  Created by 赤 那 on 2017/3/26.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "ModifyLoginPwdViewController.h"

#import "PublicHeader.h"
#import "ModifyLoginPwdView.h"

@interface ModifyLoginPwdViewController ()<ModifyLoginPwdViewDelegate>

@property (nonatomic, strong) ModifyLoginPwdView *m_ModifyLoginPwdView;

@end

@implementation ModifyLoginPwdViewController
@synthesize m_ModifyLoginPwdView;

#pragma mark - Life Cycle
- (void)viewDidLoad{
    
    [super viewDidLoad];
    
    [self setTitle:@"修改登录密码"];
    
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
    
    [self addModifyLoginPwdView];
    
}

- (void)addModifyLoginPwdView{
    
    ModifyLoginPwdView *modifyLoginPwdView = [[ModifyLoginPwdView alloc] init];
    
    [modifyLoginPwdView setM_Delegate:self];
    
    [self setM_ModifyLoginPwdView:modifyLoginPwdView];
    [self.view addSubview:modifyLoginPwdView];
    
    [modifyLoginPwdView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.equalTo(self.view);
        
    }];
    
}

#pragma mark - Public Functions
- (void)dataInitialization{
    
    
    
}

#pragma mark - Button Handlers

#pragma mark - ModifyLoginPwdView Delegate Manager
- (void)onModifyPwdSuccess{

    [self.navigationController popViewControllerAnimated:YES];
    
}

@end
