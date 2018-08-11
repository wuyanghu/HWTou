//
//  CouponColViewController.m
//  HWTou
//
//  Created by 赤 那 on 2017/4/6.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "CouponColViewController.h"

#import "PublicHeader.h"
#import "CouponColView.h"

@interface CouponColViewController ()<CouponColViewDelegate>{

    CouponType g_CouponType;
    
}

@property (nonatomic, strong) CouponColView *m_CouponColView;

@end

@implementation CouponColViewController
@synthesize m_Delegate;

@synthesize m_CouponColView;

#pragma mark - 初始化
- (id)initWithFrame:(CGRect)frame{
    
    self = [super init];
    
    if (self) {
        
        [self.view setFrame:frame];
        [self dataInitialization];
        [self addMainView];
        
    }
    
    return self;
    
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        
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
    
    [self addCouponColView];
    
}

- (void)addCouponColView{
    
    CouponColView *calabashColView = [[CouponColView alloc] init];
    
    [calabashColView setM_Delegate:self];
    
    [self setM_CouponColView:calabashColView];
    [self.view addSubview:calabashColView];
    
    [calabashColView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.equalTo(self.view);
        
    }];
    
}

#pragma mark - Public Functions
- (void)dataInitialization{
    
}

- (void)setCouponColViewControllerType:(CouponType)colType{
    
    g_CouponType = colType;
    
    [m_CouponColView setCouponColViewType:colType];
    
}

#pragma mark - Button Handlers

#pragma mark - CouponColView Delegate Manager
- (void)onDidSelectItem:(CouponModel *)model{
    
    if (m_Delegate && [m_Delegate respondsToSelector:@selector(onDidSelectItem:withCouponType:)]) {
        
        [m_Delegate onDidSelectItem:model withCouponType:g_CouponType];
        
    }
    
}

@end
