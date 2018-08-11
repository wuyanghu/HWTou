//
//  MyCollectionColViewController.m
//  HWTou
//
//  Created by 赤 那 on 2017/4/9.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "MyCollectionColViewController.h"

#import "PublicHeader.h"

@interface MyCollectionColViewController ()<MyCollectionColViewDelegate>{

    CollectionColType g_CollectionColType;
    
}

@property (nonatomic, strong) MyCollectionColView *m_CollectionColView;

@end

@implementation MyCollectionColViewController
@synthesize m_Delegate;
@synthesize m_CollectionColView;

#pragma mark - 初始化
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
    
    MyCollectionColView *collectionColView = [[MyCollectionColView alloc] init];
    
    [collectionColView setM_Delegate:self];
    
    [self setM_CollectionColView:collectionColView];
    [self.view addSubview:collectionColView];
    
    [collectionColView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.edges.equalTo(self.view);
        
    }];
    
}

#pragma mark - Public Functions
- (void)dataInitialization{
    
    g_CollectionColType = CollectionColType_SpendMoney;
    
}

- (void)setMyCollectionColViewController:(CollectionColType)colType{
    
    g_CollectionColType = colType;
    
    [m_CollectionColView setMyCollectionColViewType:colType];
    
}

#pragma mark - Button Handlers

#pragma mark - CollectionColView Delegate Manager
- (void)onDidSelectItem:(NSObject *)model{

    if (m_Delegate && [m_Delegate respondsToSelector:@selector(onDidSelectItem:withCollectionType:)]) {
    
        [m_Delegate onDidSelectItem:model withCollectionType:g_CollectionColType];
        
    }
    
}

@end
