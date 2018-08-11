//
//  SetPasswordViewController.m
//  HWTou
//
//  Created by 赤 那 on 2017/3/21.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "SetPasswordViewController.h"

#import "PublicHeader.h"

#import "RegSuccessViewController.h"

@interface SetPasswordViewController ()<SetPwdViewDelegate>{

    OperationType g_OperationType;
    
}

@property (nonatomic, strong) NSString *m_Phone;
@property (nonatomic, strong) NSString *m_VerCode;

@property (nonatomic, strong) SetPwdView *m_SetPwdView;

@end

@implementation SetPasswordViewController
@synthesize m_Phone,m_VerCode;
@synthesize m_SetPwdView;

#pragma mark - 初始化
- (id)initWithOperationType:(OperationType)type withPhone:(NSString *)phone
                withVerCode:(NSString *)verCode{
    
    [self setM_Phone:phone];
    [self setM_VerCode:verCode];
    
    g_OperationType = type;
    
    self = [super init];
    
    if (self) {
        
        
        
    }
    
    return self;
    
    
}


- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        
        
        
    }
    
    return self;
    
}

#pragma mark - Life Cycle
- (void)viewDidLoad{
    
    [super viewDidLoad];
    
    [self setTitle:@"密码修改"];
    
    [self addSetPwdView];
    
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

- (void)addSetPwdView{

    SetPwdView *setPwdView = [[SetPwdView alloc] init];
    
    [setPwdView setM_Delegate:self];

    [setPwdView setOperationType:g_OperationType withPhone:m_Phone withVerCode:m_VerCode];
    
    [self setM_SetPwdView:setPwdView];
    [self.view addSubview:setPwdView];
    
    [setPwdView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.equalTo(self.view);
        
    }];
    
}

#pragma mark - SetPwdView Delegate Manager
- (void)onRegSuccessful{

    RegSuccessViewController *regSuccessVC = [[RegSuccessViewController alloc] init];
    
    [self.navigationController pushViewController:regSuccessVC animated:YES];
    
}

- (void)onChangePwdSuccessful{

    [self.navigationController popToRootViewControllerAnimated:YES];
    
}

@end
