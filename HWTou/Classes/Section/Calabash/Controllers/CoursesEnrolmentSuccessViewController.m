//
//  CoursesEnrolmentSuccessViewController.m
//  HWTou
//
//  Created by 赤 那 on 2017/4/4.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "CoursesEnrolmentSuccessViewController.h"

#import "PublicHeader.h"
#import "CalabashViewController.h"
#import "CoursesEnrolmentSuccessView.h"

@interface CoursesEnrolmentSuccessViewController ()

@property (nonatomic, strong) CoursesEnrolmentSuccessView *m_SuccessView;

@end

@implementation CoursesEnrolmentSuccessViewController
@synthesize m_SuccessView;

#pragma mark - 初始化
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        
        [self setTitle:@"报名成功"];
        
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
    
    [self addMomentsView];
    
}

- (void)addMomentsView{
    
    CoursesEnrolmentSuccessView *successView = [[CoursesEnrolmentSuccessView alloc] init];
    
    [self setM_SuccessView:successView];
    [self.view addSubview:successView];
    
    [successView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.equalTo(self.view);
        
    }];
    
}

#pragma mark - Public Functions
- (void)dataInitialization{
    
    
    
}

- (void)setEnrolmentSuccessViewControllerDataSource:(CourseModel *)courseModel
                                    withAddressInfo:(CoursesAddressModel *)coursesAddressModel{

    [m_SuccessView setSuccessViewDataSource:courseModel
                            withAddressInfo:coursesAddressModel];
    
}

- (void)setEnrolmentSuccessViewControllerDataSource:(CourseModel *)courseModel
                                     withEnlistInfo:(EnlistModel *)enlistModel{
    
    [self setTitle:@"课程报名信息"];
    
    [m_SuccessView setSuccessViewDataSource:courseModel
                            withEnlistInfo:enlistModel];
    
}

#pragma mark - Button Handlers
- (void)onClickNavigationBack{
    
    UINavigationController *navigationVC = self.navigationController;
    
    NSMutableArray *vcArray = [NSMutableArray arrayWithCapacity:0];
    
    // 遍历导航控制器中的控制器
    for (UIViewController *vc in navigationVC.viewControllers) {
        
        [vcArray addObject:vc];
        
        if ([vc isKindOfClass:[CalabashViewController class]]) {
            
            break;
            
        }
        
    }
    
    // 把控制器重新添加到导航控制器
    [navigationVC setViewControllers:vcArray animated:YES];
    
}

@end
