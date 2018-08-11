//
//  ProductCategoryViewController.m
//  HWTou
//
//  Created by 彭鹏 on 2017/3/19.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "ProductCategoryViewController.h"
#import "ProductSearchViewController.h"
#import "CustomNavigationController.h"
#import "ProductCartViewController.h"
#import "UINavigationItem+Margin.h"
#import "PYSearchViewController.h"
#import "ProductCategoryView.h"
#import "ProductCategoryDM.h"
#import "ProductCartReq.h"
#import "WZLBadgeImport.h"
#import "PublicHeader.h"

@interface ProductCategoryViewController ()

@property (nonatomic, strong) PYSearchViewController *searchVC;
@property (nonatomic, strong) ProductCategoryView *vCategory;
@property (nonatomic, strong) UIButton   *btnCart;

@end

@implementation ProductCategoryViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self createUI];
    [self addSearchBar];
}

- (void)createUI
{
    self.title = @"商品分类";
    self.vCategory = [[ProductCategoryView alloc] init];
    self.vCategory.listData = self.categorys;
    [self.view addSubview:self.vCategory];
    [self.vCategory makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    self.btnCart = [[UIButton alloc] init];
    [self.btnCart setImage:[UIImage imageNamed:@"com_float_cart"] forState:UIControlStateNormal];
    [self.btnCart addTarget:self action:@selector(actionCart) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.btnCart];
    
    [self.btnCart makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self.view).offset(-20);
        make.bottom.equalTo(self.view).offset(-20);
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self loadCartNumber];
}

- (void)actionCart
{
    if ([AccountManager isNeedLogin]) {
        [AccountManager showLoginView];
        return;
    }
    ProductCartViewController *cartVC = [[ProductCartViewController alloc] init];
    [self.navigationController pushViewController:cartVC animated:YES];
}

- (void)loadCartNumber
{
    if ([AccountManager isNeedLogin]) {
        return;
    }
    [ProductCartReq listCartsSuccess:^(CartListResp *response) {
        [self setCartNumber:response.data.count];
    } failure:^(NSError *error) {
        
    }];
}

- (void)setCartNumber:(NSInteger)num
{
    if (num > 0) {
        [self.btnCart setBadgeBgColor:UIColorFromHex(0xb4292d)];
        [self.btnCart setBadgeCenterOffset:CGPointMake(-10, 10)];
        [self.btnCart showBadgeWithStyle:WBadgeStyleNumber value:num animationType:WBadgeAnimTypeNone];
    } else {
        [self.btnCart clearBadge];
    }
}

- (void)addSearchBar
{
    UIButton *btnSeach = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth * 0.8, 32)];
    [btnSeach setRoundWithCorner:6.0f];
    btnSeach.titleLabel.font = FontPFRegular(12.0f);
    [btnSeach setTitle:@"搜索您想要的商品" forState:UIControlStateNormal];
    [btnSeach setTitleColor:UIColorFromHex(0x7f7f7f) forState:UIControlStateNormal];
    [btnSeach setImage:[UIImage imageNamed:NAVIGATION_IMG_SEARCH_ICO] forState:UIControlStateNormal];
    [btnSeach setBackgroundColor:UIColorFromHex(NAVIGATION_SEARCHBAR_GRAY_BG)];
    [btnSeach addTarget:self action:@selector(actionSearch:) forControlEvents:UIControlEventTouchUpInside];
    
    btnSeach.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 6);
    
    // 把UIButton包装成UIBarButtonItem，解决按钮点击范围过大的问题
    UIView *containView = [[UIView alloc] initWithFrame:btnSeach.bounds];
    [containView addSubview:btnSeach];
    
    UIBarButtonItem *itemSearch = [[UIBarButtonItem alloc] initWithCustomView:containView];
    [self.navigationItem setRightBarButtonItem:itemSearch fixedSpace:-2];
    self.navigationItem.titleView = [UIView new];
}

- (void)actionSearch:(UIButton *)button
{
    CustomNavigationController *nav = [[CustomNavigationController alloc] initWithRootViewController:self.searchVC];
    [self presentViewController:nav animated:YES completion:nil];
}

- (PYSearchViewController *)searchVC
{
    if (!_searchVC) {
        _searchVC = [PYSearchViewController searchViewControllerWithHotSearches:nil searchBarPlaceholder:@"输入商品关键字" didSearchBlock:^(PYSearchViewController *searchViewController, UISearchBar *searchBar, NSString *searchText) {
            ProductSearchViewController *searchVC = [[ProductSearchViewController alloc] init];
            searchVC.keywords = searchText;
            [searchViewController.navigationController pushViewController:searchVC animated:YES];
        }];
        // 3.设置风格
        [_searchVC setHotSearchStyle:PYHotSearchStyleDefault]; // 热门搜索风格为默认
        [_searchVC setSearchHistoryStyle:PYSearchHistoryStyleDefault]; // 搜索历史风格根据选择
    }
    return _searchVC;
}
@end
