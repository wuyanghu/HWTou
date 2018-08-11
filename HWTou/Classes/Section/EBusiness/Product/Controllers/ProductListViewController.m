//
//  ProductListViewController.m
//  HWTou
//
//  Created by 彭鹏 on 2017/3/19.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "ProductSearchViewController.h"
#import "CustomNavigationController.h"
#import "ProductListViewController.h"
#import "ProductCartViewController.h"
#import "PYSearchViewController.h"
#import "ProductCategoryDM.h"
#import "ProductListView.h"
#import "ProductListReq.h"
#import "ProductCartReq.h"
#import "WZLBadgeImport.h"
#import "PublicHeader.h"
#import "VTMagic.h"

@interface ProductListContentVC : UIViewController

@property (nonatomic, strong) ProductListView *vProductList;
@property (nonatomic, strong) ProductCategoryDM *category;

@end

@implementation ProductListContentVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self createUI];
}

- (void)createUI
{
    self.vProductList = [[ProductListView alloc] init];
    [self.view addSubview:self.vProductList];
    
    [self.vProductList makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    WeakObj(self);
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [selfWeak loadListData:YES];
    }];
    
    header.lastUpdatedTimeLabel.hidden = YES;
    self.vProductList.collectionView.mj_header = header;
    [self.vProductList.collectionView.mj_header beginRefreshing];
}

- (void)setCategory:(ProductCategoryDM *)category
{
    _category = category;
    self.vProductList.listData = nil;
    [self loadListData:YES];
}

- (void)loadListData:(BOOL)refresh
{
    ProductListParam *param = [[ProductListParam alloc] init];
    param.mcid = self.category.mcid;
    param.start_page = refresh ? 0 : self.vProductList.listData.count;
    param.pages = 20;
    
    [ProductListReq productWithParam:param success:^(ProductListResp *response) {
        if (refresh) {
            self.vProductList.listData = response.data.list;
        } else {
            NSMutableArray *tempData = [NSMutableArray arrayWithArray:self.vProductList.listData];
            [tempData addObjectsFromArray:response.data.list];
            self.vProductList.listData = tempData;
        }
        
        BOOL isMore = self.vProductList.listData.count < response.data.total_pages ? YES : NO;
        [self setLoadMore:isMore];
        [self handleLoadCompleted];
        
    } failure:^(NSError *error) {
        [self handleLoadCompleted];
        [HUDProgressTool showOnlyText:[error urlErrorCodeDescribe]];
    }];
}

- (void)setLoadMore:(BOOL)isMore
{
    if (isMore) {
        WeakObj(self);
        self.vProductList.collectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            [selfWeak loadListData:NO];
        }];
    } else {
        self.vProductList.collectionView.mj_footer = nil;
    }
}

// 更新视图状态显示
- (void)handleLoadCompleted
{
    [self.vProductList.collectionView.mj_header endRefreshing];
    [self.vProductList.collectionView.mj_footer endRefreshing];
}

@end

@interface ProductListViewController () <VTMagicViewDataSource, VTMagicViewDelegate>

@property (nonatomic, strong) PYSearchViewController *searchVC;
@property (nonatomic, strong) VTMagicController *magicController;
@property (nonatomic, strong) UIButton   *btnCart;

@end

@implementation ProductListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = self.category.name;
    [self.view addSubview:self.magicController.magicView];
    [self.magicController.magicView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [self.magicController.magicView reloadData];
    [self.magicController switchToPage:self.currentPage animated:NO];
    
    self.btnCart = [[UIButton alloc] init];
    [self.btnCart setImage:[UIImage imageNamed:@"com_float_cart"] forState:UIControlStateNormal];
    [self.btnCart addTarget:self action:@selector(actionCart) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.btnCart];
    
    UIBarButtonItem *itemSearch = [UIBarButtonItem itemWithImageName:@"navi_search_nor" hltImageName:nil target:self action:@selector(actionSearch)];
    self.navigationItem.rightBarButtonItem = itemSearch;
    
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

- (void)actionSearch
{
    CustomNavigationController *nav = [[CustomNavigationController alloc] initWithRootViewController:self.searchVC];
    [self presentViewController:nav animated:YES completion:nil];
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
    } failure:nil];
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

- (VTMagicController *)magicController
{
    if (!_magicController) {
        _magicController = [[VTMagicController alloc] init];
        _magicController.magicView.dataSource = self;
        _magicController.magicView.delegate = self;
        _magicController.magicView.sliderHeight = 2.5;
        _magicController.magicView.sliderExtension = 8;
        _magicController.magicView.navigationHeight = 32;
        _magicController.magicView.layoutStyle = VTLayoutStyleCenter;
        _magicController.magicView.navigationColor = UIColorFromHex(0xfafafa);
        _magicController.magicView.sliderColor = UIColorFromHex(0xb4292d);
    }
    return _magicController;
}

- (NSArray<NSString *> *)menuTitlesForMagicView:(VTMagicView *)magicView
{
    if (self.category.children.count == 0) {
        return [NSArray arrayWithObjects:self.category.name, nil];
    }
    NSMutableArray *arrTitle = [NSMutableArray arrayWithCapacity:self.category.children.count];
    [self.category.children enumerateObjectsUsingBlock:^(ProductCategoryDM *obj, NSUInteger idx, BOOL *stop) {
        [arrTitle addObject:obj.name];
    }];
    return arrTitle;
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
    ProductListContentVC *viewController = [magicView dequeueReusablePageWithIdentifier:recomId];
    if (!viewController) {
        viewController = [[ProductListContentVC alloc] init];
    }
    
    if (self.category.children.count == 0) {
        viewController.category = self.category;
    } else {
        viewController.category = self.category.children[pageIndex];
    }
    return viewController;
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
