//
//  AddressManageViewController.m
//  HWTou
//
//  Created by 赤 那 on 2017/3/26.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "AddressManageViewController.h"
#import "UIBarButtonItem+Extension.h"

#import "PublicHeader.h"

#import "AddressManageView.h"
#import "ManageAddressViewController.h"

@interface AddressManageViewController ()<AddressManageViewDelegate>

@property (nonatomic, strong) AddressManageView *m_AddressManageView;

@end

@implementation AddressManageViewController
@synthesize m_AddressManageView;

#pragma mark - Life Cycle
- (void)viewDidLoad{
    
    [super viewDidLoad];
    
    [self setTitle:@"地址管理"];
    
    [self dataInitialization];
    [self addMainView];
    
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    if (!IsNilOrNull(m_AddressManageView))[m_AddressManageView accessDataSource];
    
}

- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    
}

- (void)didReceiveMemoryWarning{
    
    [super didReceiveMemoryWarning];
    
}

#pragma mark - Add UI
- (void)addMainView{

    [self addNaviRightBtn];
    [self addAddressManageView];
    
}

- (void)addNaviRightBtn{
    
    UIBarButtonItem *item = [UIBarButtonItem itemWithTitle:@"新增"
                                                 withColor:UIColorFromHex(NAVIGATION_FONT_RED_COLOR)
                                                    target:self
                                                    action:@selector(onNavigationCustomRightBtnClick:)];
    
    [self.navigationItem setRightBarButtonItem:item];
    
}

- (void)addAddressManageView{

    AddressManageView *addressManageView = [[AddressManageView alloc] init];
    
    [addressManageView setM_Delegate:self];
    
    [self setM_AddressManageView:addressManageView];
    [self.view addSubview:addressManageView];
    
    [addressManageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.equalTo(self.view);
        
    }];
    
}

#pragma mark - Public Functions
- (void)dataInitialization{

    
    
}

#pragma mark - Button Handlers
- (void)onNavigationCustomRightBtnClick:(id)sender{

    ManageAddressViewController *manageAddressVC = [[ManageAddressViewController alloc] init];

    [self.navigationController pushViewController:manageAddressVC animated:YES];
    
}

#pragma mark - AddressManageView Delegate Manager
- (void)onEditor:(AddressGoodsDM *)model{

    ManageAddressViewController *manageAddressVC = [[ManageAddressViewController alloc] init];
    
    [manageAddressVC setEditAddressDataSource:model];
    manageAddressVC.modifyAddress = self.modifyAddress;
    
    [self.navigationController pushViewController:manageAddressVC animated:YES];
    
}

- (void)didSelectItem:(AddressGoodsDM *)model {
    
    if (self.blockAddress) {
        
        self.blockAddress(model);
        
        [self.navigationController popViewControllerAnimated:YES];
        
    }
}

- (void)deleteAddress:(AddressGoodsDM *)model
{
    !self.deleteAddress ?: self.deleteAddress(model);
}

@end
