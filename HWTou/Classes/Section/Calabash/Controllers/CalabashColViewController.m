//
//  CalabashColViewController.m
//  HWTou
//
//  Created by 赤 那 on 2017/4/1.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "CalabashColViewController.h"

#import "PublicHeader.h"
#import "CalabashColView.h"

@interface CalabashColViewController ()<CalabashColViewDelegate>

@property (nonatomic, strong) CalabashColView *m_CalabashColView;

@end

@implementation CalabashColViewController
@synthesize m_Delegate;
@synthesize m_CalabashColView;

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
    
    [self addCalabashColView];
    
}

- (void)addCalabashColView{
    
    CalabashColView *calabashColView = [[CalabashColView alloc] init];
    
    [calabashColView setM_Delegate:self];
    
    [self setM_CalabashColView:calabashColView];
    [self.view addSubview:calabashColView];
    
    [calabashColView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.equalTo(self.view);
        
    }];
    
}

#pragma mark - Public Functions
- (void)dataInitialization{
    
    
    
}

- (void)setCalabashColViewType:(CalabashColType)colType{

    [m_CalabashColView setCalabashColViewType:colType];
    
}

#pragma mark - Button Handlers

#pragma mark - CalabashColView Delegate Manager
- (void)onSelCalabashColViewWithColType:(CalabashColType)colType withDataSource:(NSObject *)object{

    if (m_Delegate && [m_Delegate respondsToSelector:
                       @selector(onViewSelectedInformationWithColType:withDataSource:)]) {
        
        [m_Delegate onViewSelectedInformationWithColType:colType withDataSource:object];
        
    }
    
}

@end
