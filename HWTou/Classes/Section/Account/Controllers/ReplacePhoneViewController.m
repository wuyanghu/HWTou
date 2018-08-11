//
//  ReplacePhoneViewController.m
//  HWTou
//
//  Created by 赤 那 on 2017/4/25.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "ReplacePhoneViewController.h"

#import "PublicHeader.h"

#import "ReplacePhoneView.h"
#import "VerifyCodeViewController.h"

@interface ReplacePhoneViewController ()<ReplacePhoneViewDelegate>

@property (nonatomic, strong) ReplacePhoneView *m_ReplacePhoneView;

@end

@implementation ReplacePhoneViewController
@synthesize m_ReplacePhoneView;

#pragma mark - Life Cycle
- (void)viewDidLoad{
    
    [super viewDidLoad];
    
    [self setTitle:@"新的手机号码"];
    
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
    
    [self addAboutView];
    
}

- (void)addAboutView{
    
    ReplacePhoneView *replacePhoneView = [[ReplacePhoneView alloc] init];
    
    [replacePhoneView setM_Delegate:self];
    
    [self setM_ReplacePhoneView:replacePhoneView];
    [self.view addSubview:replacePhoneView];
    
    [replacePhoneView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.equalTo(self.view);
        
    }];
    
}

#pragma mark - Public Functions
- (void)dataInitialization{
    
    
    
}

#pragma mark - ReplacePhoneView Delegate Manager
- (void)onReplacePhone:(NSString *)phone{

    VerifyCodeViewController *verifyCodeVC = [[VerifyCodeViewController alloc]
                                              initWithVerifyCodeObtainType:VerifyCodeType_BindPhone
                                              withPhone:phone pwd:nil imgCode:nil];
    
    [self.navigationController pushViewController:verifyCodeVC animated:YES];
    
}

@end
