//
//  ModifyPhoneSuccessViewController.m
//  HWTou
//
//  Created by 赤 那 on 2017/4/15.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "ModifyPhoneSuccessViewController.h"

#import "PublicHeader.h"

#import "SuccessView.h"

@interface ModifyPhoneSuccessViewController ()

@property (nonatomic, strong) SuccessView *m_SuccessView;

@end

@implementation ModifyPhoneSuccessViewController
@synthesize m_SuccessView;
#pragma mark - Life Cycle
- (void)viewDidLoad{
    
    [super viewDidLoad];
    
    [self setTitle:@"修改成功"];
    
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
    
    [self addRegSuccessView];
    
}

- (void)addRegSuccessView{
    
    SuccessView *successView = [[SuccessView alloc] init];
    
    [self setM_SuccessView:successView];
    [self.view addSubview:successView];
 
    [successView mas_makeConstraints:^(MASConstraintMaker *make) {
        
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

@end
