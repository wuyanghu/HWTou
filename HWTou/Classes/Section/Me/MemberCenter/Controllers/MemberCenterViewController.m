//
//  MemberCenterViewController.m
//  HWTou
//
//  Created by 赤 那 on 2017/3/24.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "MemberCenterViewController.h"

#import "PublicHeader.h"
#import "MemberCenterView.h"
#import "MemberLvDescViewController.h"

@interface MemberCenterViewController ()<MemberCenterViewDelegate>

@property (nonatomic, strong)  MemberCenterView *m_MemberCenterView;

@end

@implementation MemberCenterViewController
@synthesize m_MemberCenterView;

#pragma mark - 初始化
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        
        [self setTitle:@"会员中心"];
        
        [self dataInitialization];
        [self addMainView];
        
    }
    
    return self;
    
}

#pragma mark - Life Cycle
- (void)viewDidLoad{
    
    [super viewDidLoad];
    
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
    
    [self addMemberCenterView];
    
}

- (void)addMemberCenterView{
    
    MemberCenterView *memberCenterView = [[MemberCenterView alloc] init];
    
    [memberCenterView setM_Delegate:self];
    
    [self setM_MemberCenterView:memberCenterView];
    [self.view addSubview:memberCenterView];
    
    [memberCenterView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.equalTo(self.view);
        
    }];
    
}

#pragma mark - Public Functions
- (void)dataInitialization{
    
    
    
}

- (void)setMemberInfo:(PersonalInfoDM *)model{

    [m_MemberCenterView setMemberInfo:model];
    
}

#pragma mark - Button Handlers

#pragma mark - MemberCenterView Delegate Manager
- (void)onDidLevelDescription{

    MemberLvDescViewController *lvDescVC = [[MemberLvDescViewController alloc] init];
    
    [self.navigationController pushViewController:lvDescVC animated:YES];
    
}

- (void)onDidSelTask:(TaskModel *)model{

    switch (model.m_TaskType) {
        case TaskType_Investment:{// 投资
            
            NSLog(@"投资任务");
            
            break;}
        case TaskType_Shopping:{// 购物
            
            NSLog(@"购物任务");
            
            break;}
        case TaskType_Evaluation:{// 评价
            
            NSLog(@"评价任务");
            
            break;}
        case TaskType_Activity:{// 参加活动
            
            NSLog(@"参加活动任务");
            
            break;}
        case TaskType_EvaluationActivity:{// 评价活动
            
            NSLog(@"评价活动任务");
            
            break;}
        default:
            break;
    }
    
}

@end
