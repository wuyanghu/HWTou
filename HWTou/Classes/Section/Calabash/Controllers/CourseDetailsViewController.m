//
//  CourseDetailsViewController.m
//  HWTou
//
//  Created by 赤 那 on 2017/4/3.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "CourseDetailsViewController.h"

#import "PublicHeader.h"
#import "CourseDetailsView.h"
#import "CoursesEnrolmentViewController.h"
#import "CoursesEnrolmentSuccessViewController.h"

@interface CourseDetailsViewController ()<CourseDetailsViewDelegate>

@property (nonatomic, strong) CourseDetailsView *m_CourseDetailsView;

@end

@implementation CourseDetailsViewController
@synthesize m_CourseDetailsView;

#pragma mark - 初始化
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        
        [self setTitle:@"课程详情"];
        
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
    
    [self addCourseDetailsView];
    
}

- (void)addCourseDetailsView{
    
    CourseDetailsView *courseDetailsView = [[CourseDetailsView alloc] init];
    
    [courseDetailsView setM_Delegate:self];
    
    [self setM_CourseDetailsView:courseDetailsView];
    [self.view addSubview:courseDetailsView];
    
    [courseDetailsView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.equalTo(self.view);
        
    }];
    
}

#pragma mark - Public Functions
- (void)dataInitialization{
    
    
    
}

- (void)setCourseDetailsViewControllerDataSource:(CourseModel *)model{

    [m_CourseDetailsView setCourseDetailsViewDataSource:model];
    
}

#pragma mark - Button Handlers

#pragma mark - CourseDetailsView Delegate Manager
- (void)onCoursesEnrolment:(CourseModel *)model{

    CoursesEnrolmentViewController *coursesEnrolmentVC = [[CoursesEnrolmentViewController alloc] init];
    
    [coursesEnrolmentVC setCoursesEnrolmentViewControllerDataSource:model];
    
    [self.navigationController pushViewController:coursesEnrolmentVC animated:YES];
    
}

- (void)onCoursesEnrolmentInfo:(CourseModel *)model{

    CoursesEnrolmentSuccessViewController *successVC = [[CoursesEnrolmentSuccessViewController alloc] init];
    
    [successVC setEnrolmentSuccessViewControllerDataSource:model withEnlistInfo:model.enlist];
    
    [self.navigationController pushViewController:successVC animated:YES];
    
}

@end
