//
//  MemberLvDescViewController.m
//  HWTou
//
//  Created by 赤 那 on 2017/4/13.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "MemberLvDescViewController.h"

#import "PublicHeader.h"
#import "MemberLvDescView.h"

@interface MemberLvDescViewController ()

@property (nonatomic, strong) MemberLvDescView *m_LvDescView;

@end

@implementation MemberLvDescViewController

#pragma mark - Life Cycle
- (void)viewDidLoad{
    
    [super viewDidLoad];
    
    [self setTitle:@"发耶积分、会员等级规则"];
    
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
    
    [self addLvDescView];
    
}

- (void)addLvDescView{
    
    MemberLvDescView *lvDescView = [[MemberLvDescView alloc] init];
    
    [self setM_LvDescView:lvDescView];
    [self.view addSubview:lvDescView];
    
    [lvDescView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.equalTo(self.view);
        
    }];
    
}

#pragma mark - Public Functions
- (void)dataInitialization{
    
    
    
}

#pragma mark - Button Handlers

@end
