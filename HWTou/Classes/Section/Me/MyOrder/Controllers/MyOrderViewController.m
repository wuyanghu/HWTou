//
//  MyOrderViewController.m
//  HWTou
//
//  Created by 赤 那 on 2017/3/24.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "CustomNavigationController.h"
#import "OrderListViewController.h"
#import "PYSearchViewController.h"
#import "MyOrderViewController.h"
#import "PublicHeader.h"
#import "VTMagic.h"

@interface MyOrderViewController () <VTMagicViewDataSource, VTMagicViewDelegate>

@property (nonatomic, strong) PYSearchViewController *searchVC;
@property (nonatomic, strong) VTMagicController *magicController;
@property (nonatomic, copy) NSArray *listStatus;
@property (nonatomic, copy) NSArray *listTitle;

@end

@implementation MyOrderViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"我的订单";
    
    UIBarButtonItem *itemSearch = [UIBarButtonItem itemWithImageName:@"navi_search_nor" hltImageName:nil target:self action:@selector(actionSearch)];
    self.navigationItem.rightBarButtonItem = itemSearch;
    
    [self.view addSubview:self.magicController.magicView];
    [self.magicController.magicView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [self.magicController.magicView reloadData];
}

- (void)actionSearch
{
    CustomNavigationController *nav = [[CustomNavigationController alloc] initWithRootViewController:self.searchVC];
    [self presentViewController:nav animated:YES completion:nil];
}

- (VTMagicController *)magicController
{
    if (!_magicController) {
        _magicController = [[VTMagicController alloc] init];
        _magicController.magicView.dataSource = self;
        _magicController.magicView.delegate = self;
        _magicController.magicView.sliderHeight = 2.5;
        _magicController.magicView.sliderExtension = 8;
        _magicController.magicView.navigationHeight = 32;
        _magicController.magicView.itemWidth = kMainScreenWidth/5;
        _magicController.magicView.navigationColor = UIColorFromHex(0xfafafa);
        _magicController.magicView.sliderColor = UIColorFromHex(0xb4292d);
    }
    return _magicController;
}

- (NSArray *)listStatus
{
    if (_listStatus == nil) {
        _listStatus = @[@(OrderStatusAll), @(OrderStatusWaitPay), @(OrderStatusReapGoods), @(OrderStatusWaitComment), @(OrderStatusReturnProce)];
    }
    return _listStatus;
}

- (NSArray *)listTitle
{
    if (_listTitle == nil) {
        _listTitle = @[@"全部", @"待付款", @"待收货", @"待评价", @"退款退货"];
    }
    return _listTitle;
}

- (NSArray<NSString *> *)menuTitlesForMagicView:(VTMagicView *)magicView
{
    return self.listTitle;
}

- (UIButton *)magicView:(VTMagicView *)magicView menuItemAtIndex:(NSUInteger)itemIndex
{
    static NSString *itemIdentifier = @"itemIdentifier";
    UIButton *menuItem = [magicView dequeueReusableItemWithIdentifier:itemIdentifier];
    if (!menuItem) {
        menuItem = [UIButton buttonWithType:UIButtonTypeCustom];
        [menuItem setTitleColor:UIColorFromHex(0x333333) forState:UIControlStateNormal];
        [menuItem setTitleColor:UIColorFromHex(0xb4292d) forState:UIControlStateSelected];
        menuItem.titleLabel.font = FontPFRegular(14.0f);
    }
    return menuItem;
}

- (UIViewController *)magicView:(VTMagicView *)magicView viewControllerAtPage:(NSUInteger)pageIndex
{
    static NSString *recomId = @"recom.identifier";
    OrderListViewController *vc = [magicView dequeueReusablePageWithIdentifier:recomId];
    if (!vc) {
        vc = [[OrderListViewController alloc] init];
    }
    return vc;
}

- (void)magicView:(VTMagicView *)magicView viewDidAppear:(UIViewController *)viewController atPage:(NSUInteger)pageIndex
{
    NSNumber *status = self.listStatus[pageIndex];
    OrderListViewController *vc = (OrderListViewController *)viewController;
    vc.status = [status integerValue];
}

- (PYSearchViewController *)searchVC
{
    if (!_searchVC) {
        _searchVC = [PYSearchViewController searchViewControllerWithHotSearches:nil searchBarPlaceholder:@"输入订单关键字" didSearchBlock:^(PYSearchViewController *searchViewController, UISearchBar *searchBar, NSString *searchText) {
            OrderListViewController *searchVC = [[OrderListViewController alloc] init];
            searchVC.title = @"订单搜索";
            searchVC.keywords = searchText;
            searchVC.status = OrderStatusAll;
            [searchViewController.navigationController pushViewController:searchVC animated:YES];
        }];
        // 3.设置风格
        _searchVC.showSearchHistory = NO;
    }
    return _searchVC;
}
@end
