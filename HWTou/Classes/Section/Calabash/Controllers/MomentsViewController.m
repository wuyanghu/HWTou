//
//  MomentsViewController.m
//  HWTou
//
//  Created by 赤 那 on 2017/4/3.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "MomentsViewController.h"

#import "PublicHeader.h"

#import "MomentsView.h"
#import "ShareMomentsViewController.h"

@interface MomentsViewController ()<MomentsViewDelegate>

@property (nonatomic, strong) MomentsView *m_MomentsView;

@end

@implementation MomentsViewController
@synthesize m_MomentsView;

#pragma mark - Life Cycle
- (void)viewDidLoad{
    
    [super viewDidLoad];
    
    [self setTitle:@"圈子"];
    
    [self dataInitialization];
    [self addMainView];
    
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    if (!IsNilOrNull(m_MomentsView)) {
        
        [m_MomentsView accessDataSourceWithLoadDataType:LoadDataType_New
                                               withPage:Request_Page
                                           withpageSize:Request_PageSize];
        
    }
    
}

- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    
}

- (void)didReceiveMemoryWarning{
    
    [super didReceiveMemoryWarning];
    
}

#pragma mark - Add UI
- (void)addMainView{
    
    [self addMomentsView];
    
}

- (void)addMomentsView{
    
    MomentsView *momentsView = [[MomentsView alloc] init];
    
    [momentsView setM_Delegate:self];
    
    [self setM_MomentsView:momentsView];
    [self.view addSubview:momentsView];
    
    [momentsView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.equalTo(self.view);
        
    }];
    
}

#pragma mark - Public Functions
- (void)dataInitialization{
    
    
    
}

#pragma mark - MomentsView Delegate Manager
- (void)onShareMoments{

    ShareMomentsViewController *shareMomentsVC = [[ShareMomentsViewController alloc] init];
    
    [self.navigationController pushViewController:shareMomentsVC animated:YES];
    
}

@end
