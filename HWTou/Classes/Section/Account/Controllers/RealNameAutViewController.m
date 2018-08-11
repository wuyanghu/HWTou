//
//  RealNameAutViewController.m
//  HWTou
//
//  Created by 赤 那 on 2017/3/21.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "RealNameAutViewController.h"

#import "PublicHeader.h"

#import "RealNameAutView.h"
#import "RealNameAutSuccessViewController.h"

@interface RealNameAutViewController ()<RealNameAutViewDelegate>

@property (nonatomic, strong) RealNameAutView *m_RealNameAutView;

@end

@implementation RealNameAutViewController
@synthesize m_RealNameAutView;

#pragma mark - Life Cycle
- (void)viewDidLoad{
    
    [super viewDidLoad];
    
    [self setTitle:@"实名认证"];
    
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
    
    RealNameAutView *realNameAutView = [[RealNameAutView alloc] init];
    
    [realNameAutView setM_Delegate:self];
    
    [self setM_RealNameAutView:realNameAutView];
    [self.view addSubview:realNameAutView];
    
    [realNameAutView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.equalTo(self.view);
        
    }];
    
}

#pragma mark - Public Functions
- (void)dataInitialization{
    
    
    
}

- (void)showAlertController{

    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil
                                                                             message:@"请仔细核对实名认证信息"
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消"
                                                        style:UIAlertActionStyleCancel
                                                      handler:nil]];

    [alertController addAction:[UIAlertAction actionWithTitle:@"已核对" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [m_RealNameAutView realNameAuthentication];
        
        
    }]];

    [self presentViewController:alertController animated:YES completion:nil];
    
}

#pragma mark - Button Handlers

#pragma mark - RealNameAutView Delegate Manager
- (void)onShowAlertController{

    [self showAlertController];
    
}

- (void)onRealNameAutSuccessful{
    
    RealNameAutSuccessViewController *realNameAutSuccessVC = [[RealNameAutSuccessViewController alloc] init];
    
    [self.navigationController pushViewController:realNameAutSuccessVC animated:YES];
    
}

@end
