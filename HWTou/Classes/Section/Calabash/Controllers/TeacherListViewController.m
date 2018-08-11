//
//  TeacherListViewController.m
//  HWTou
//
//  Created by 赤 那 on 2017/4/3.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "TeacherListViewController.h"

#import "PublicHeader.h"

#import "TeacherListView.h"

@interface TeacherListViewController ()<TeacherListViewDelegate>

@property (nonatomic, strong) TeacherListView *m_TeacherListView;

@end

@implementation TeacherListViewController
@synthesize m_TeacherListView;

#pragma mark - Life Cycle
- (void)viewDidLoad{
    
    [super viewDidLoad];
    
    [self setTitle:@"教师列表"];
    
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
    
    [self addTeacherListView];
    
}

- (void)addTeacherListView{
    
    TeacherListView *teacherListView = [[TeacherListView alloc] init];
    
    [teacherListView setM_Delegate:self];
    
    [self setM_TeacherListView:teacherListView];
    [self.view addSubview:teacherListView];
    
    [teacherListView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.equalTo(self.view);
        
    }];
    
}

#pragma mark - Public Functions
- (void)dataInitialization{
    
    
    
}

#pragma mark - TeacherListView Delegate Manager
- (void)onDidSelectItem:(TeacherModel *)model didSelectItemAtIndexPath:(NSIndexPath *)indexPath{

    
    
}

@end
