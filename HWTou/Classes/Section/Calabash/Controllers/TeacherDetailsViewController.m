//
//  TeacherDetailsViewController.m
//  HWTou
//
//  Created by 赤 那 on 2017/4/3.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "TeacherDetailsViewController.h"

#import "PublicHeader.h"

#import "TeacherDetailsView.h"

@interface TeacherDetailsViewController ()

@property (nonatomic, strong) TeacherDetailsView *m_TeacherDetailsView;

@end

@implementation TeacherDetailsViewController
@synthesize m_TeacherDetailsView;

#pragma mark - Life Cycle
- (void)viewDidLoad{
    
    [super viewDidLoad];
    
    [self setTitle:@"教师详情"];
    
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
    
    [self addTeacherDetailsView];
    
}

- (void)addTeacherDetailsView{
    
    TeacherDetailsView *teacherDetailsView = [[TeacherDetailsView alloc] init];
    
    [self setM_TeacherDetailsView:teacherDetailsView];
    [self.view addSubview:teacherDetailsView];
    
    [teacherDetailsView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.equalTo(self.view);
        
    }];
    
}

#pragma mark - Public Functions
- (void)dataInitialization{
    
    
    
}

- (void)setTeacherDetailsDataSource:(TeacherModel *)model{

    
    
}

#pragma mark - Button Handlers

@end
