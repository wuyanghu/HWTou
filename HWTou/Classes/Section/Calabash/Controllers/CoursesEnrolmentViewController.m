//
//  CoursesEnrolmentViewController.m
//  HWTou
//
//  Created by 赤 那 on 2017/4/3.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "CoursesEnrolmentViewController.h"

#import "PublicHeader.h"
#import "CoursesEnrolmentView.h"
#import "CoursesEnrolmentSuccessViewController.h"

@interface CoursesEnrolmentViewController ()<CoursesEnrolmentViewDelegate>

@property (nonatomic, strong) CoursesEnrolmentView *m_CoursesEnrolmentView;

@end

@implementation CoursesEnrolmentViewController
@synthesize m_CoursesEnrolmentView;

#pragma mark - 初始化
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        
        [self setTitle:@"选择课程地址"];
        
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
    
    [self.view endEditing:YES];
    
}

- (void)didReceiveMemoryWarning{
    
    [super didReceiveMemoryWarning];
    
}

#pragma mark - Add UI
- (void)addMainView{
    
    [self addCoursesEnrolmentView];
    
}

- (void)addCoursesEnrolmentView{
    
    CoursesEnrolmentView *cursesEnrolmentView = [[CoursesEnrolmentView alloc] init];
    
    [cursesEnrolmentView setM_Delegate:self];
    
    [self setM_CoursesEnrolmentView:cursesEnrolmentView];
    [self.view addSubview:cursesEnrolmentView];
    
    [cursesEnrolmentView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.equalTo(self.view);
        
    }];
    
}

#pragma mark - Public Functions
- (void)dataInitialization{
    
    
    
}

- (void)setCoursesEnrolmentViewControllerDataSource:(CourseModel *)model{
    
    [m_CoursesEnrolmentView setCoursesEnrolmentViewDataSource:model];
    
}

#pragma mark - Button Handlers

#pragma mark - CoursesEnrolmentView Delegate Manager
- (void)onEnrolmentSuccess:(CourseModel *)courseModel withAddressInfo:(CoursesAddressModel *)coursesAddressModel{

    CoursesEnrolmentSuccessViewController *successVC = [[CoursesEnrolmentSuccessViewController alloc] init];
    
    [successVC setEnrolmentSuccessViewControllerDataSource:courseModel
                                           withAddressInfo:coursesAddressModel];
    
    [self.navigationController pushViewController:successVC animated:YES];
    
}

@end
