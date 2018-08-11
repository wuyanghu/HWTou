//
//  CustomerAndFeedbackViewController.m
//  HWTou
//
//  Created by 赤 那 on 2017/3/24.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "CustomerAndFeedbackViewController.h"

#import "CustomerAndFeedbackView.h"

@interface CustomerAndFeedbackViewController ()<CustomerAndFeedbackViewDelegate>

@property (nonatomic, strong) CustomerAndFeedbackView *m_CustomerAndFeedbackView;

@end

@implementation CustomerAndFeedbackViewController
@synthesize m_CustomerAndFeedbackView;

#pragma mark - Life Cycle
- (void)viewDidLoad{
    
    [super viewDidLoad];
    
    [self setTitle:@"客服与反馈"];
    
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
    
    [self addCustomerAndFeedbackView];
    
}

- (void)addCustomerAndFeedbackView{
    
    CustomerAndFeedbackView *customerAndFeedbackView = [[CustomerAndFeedbackView alloc]
                                                  initWithFrame:self.view.bounds];
    
    [customerAndFeedbackView setM_Delegate:self];
    
    [self setM_CustomerAndFeedbackView:customerAndFeedbackView];
    [self.view addSubview:customerAndFeedbackView];

}

#pragma mark - Public Functions
- (void)dataInitialization{
    
    
    
}

#pragma mark - Button Handlers

#pragma mark - CustomerAndFeedbackView Delegate Manager

@end
