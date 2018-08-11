//
//  RegionViewController.m
//  HWTou
//
//  Created by 赤 那 on 2017/3/29.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "RegionViewController.h"

#import "PublicHeader.h"

#import "RegionView.h"
#import "ManageAddressViewController.h"

@interface RegionViewController ()<RegionViewDelegate>{

    NSDictionary *g_Dic;
    RegionType g_RegionType;
    
}

@property (nonatomic, strong) RegionView *m_RegionView;

@end

@implementation RegionViewController
@synthesize m_RegionView;

#pragma mark - 初始化
- (id)initWithType:(RegionType)regionType withDataSource:(NSDictionary *)dic{

    self = [super init];
    
    if(self){
        
        g_Dic = dic;
        g_RegionType = regionType;
        
        [self setTitle:@"新增地址"];
        
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
    
    [self addRegionView];
    
}

- (void)addRegionView{
    
    RegionView *regionView = [[RegionView alloc] init];
    
    [regionView setM_Delegate:self];
    [regionView accessDataSourceWithType:g_RegionType withDataSource:g_Dic];
    
    [self setM_RegionView:regionView];
    [self.view addSubview:regionView];
    
    [regionView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.equalTo(self.view);
        
    }];
    
}

#pragma mark - Public Functions
- (void)dataInitialization{
    
    
    
}

#pragma mark - Button Handlers

#pragma mark - RegionView Delegate Manager
- (void)onAreaSelection:(NSDictionary *)dic withType:(RegionType)type{

    if (type == RegionType_End) {
        
        UINavigationController *navigationVC = self.navigationController;
        
        NSMutableArray *vcArray = [NSMutableArray arrayWithCapacity:0];
        
        // 遍历导航控制器中的控制器
        for (UIViewController *vc in navigationVC.viewControllers) {
            
            [vcArray addObject:vc];
            
            if ([vc isKindOfClass:[ManageAddressViewController class]]) {
                
                ManageAddressViewController *manageAddressVC = (ManageAddressViewController *)vc;
                
                [manageAddressVC areaSelectionComplete:dic];
                
                break;
                
            }
            
        }
        
        // 把控制器重新添加到导航控制器
        [navigationVC setViewControllers:vcArray animated:YES];
        
    }else{
        
        RegionViewController *regionVC = [[RegionViewController alloc] initWithType:type
                                                                     withDataSource:dic];
        
        [self.navigationController pushViewController:regionVC animated:YES];
        
    }
    
}

@end
