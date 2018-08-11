//
//  ManageAddressViewController.m
//  HWTou
//
//  Created by 赤 那 on 2017/3/28.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "ManageAddressViewController.h"

#import "PublicHeader.h"
#import "ManageAddressView.h"
#import "RegionViewController.h"

@interface ManageAddressViewController ()<ManageAddressViewDelegate>

@property (nonatomic, strong) ManageAddressView *m_ManageAddressView;

@end

@implementation ManageAddressViewController
@synthesize m_ManageAddressView;

#pragma mark - 初始化
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        
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
    
    [self addManageAddressView];
    
}

- (void)addManageAddressView{
    
    ManageAddressView *manageAddressView = [[ManageAddressView alloc] init];
    
    [manageAddressView setM_Delegate:self];
    
    [self setM_ManageAddressView:manageAddressView];
    [self.view addSubview:manageAddressView];
    
    [manageAddressView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.equalTo(self.view);
        
    }];
    
}

#pragma mark - Public Functions
- (void)dataInitialization{
    
    
    
}

- (void)setEditAddressDataSource:(AddressGoodsDM *)model{
    
    [m_ManageAddressView setAddressData:model];
    
}

- (void)areaSelectionComplete:(NSDictionary *)dic{

    [m_ManageAddressView updateSelectionArea:dic];
    
}

#pragma mark - Button Handlers

#pragma mark - NewAddressView Delegate Manager
- (void)onSelectedRegion{

    RegionViewController *regionVC = [[RegionViewController alloc] initWithType:RegionType_Province
                                                                 withDataSource:nil];
    
    [self.navigationController pushViewController:regionVC animated:YES];
    
}

- (void)onAddAddressSuccess:(AddressGoodsDM *)address {

    if (self.blockAddress) {
        self.blockAddress(address);
    }
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)onModifyAddressSuccess:(AddressGoodsDM *)address {
    if (self.modifyAddress) {
        self.modifyAddress(address);
    }
    [self.navigationController popViewControllerAnimated:YES];
    
}

@end
