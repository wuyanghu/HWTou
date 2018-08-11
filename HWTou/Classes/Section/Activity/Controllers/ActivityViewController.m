//
//  ActivityViewController.m
//  HWTou
//
//  Created by pengpeng on 17/3/7.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "CustomNavigationController.h"
#import "ActivityListViewController.h"
#import "ActivityContentController.h"
#import "ActivityContentSearchVC.h"
#import "UINavigationItem+Margin.h"
#import "PYSearchViewController.h"
#import "ActivityViewController.h"
#import "MessageViewController.h"
#import "WZLBadgeImport.h"
#import "PublicHeader.h"
#import "MessageReq.h"
#import "VTMagic.h"

@interface ActivityViewController () <VTMagicViewDataSource, VTMagicViewDelegate, PYSearchViewControllerDelegate>

@property (nonatomic, strong) PYSearchViewController *searchVC;
@property (nonatomic, strong) UIBarButtonItem   *itemMessage;
@property (nonatomic, strong) VTMagicController *magicController;

@end

@implementation ActivityViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self createUI];
    [self addSearchBar];
    
    [self.view addSubview:self.magicController.magicView];
    [self.magicController.magicView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [self.magicController.magicView reloadData];
}

- (void)createUI
{
    self.itemMessage = [UIBarButtonItem itemWithImageName:@"navi_msg_nor" hltImageName:nil target:self action:@selector(actionMessage)];
    [self.navigationItem setLeftBarButtonItem:self.itemMessage fixedSpace:-6];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self loadBadgeNumber];
}

- (void)loadBadgeNumber
{
    if ([AccountManager isNeedLogin]) {
        return;
    }
    
    MessageNumParam *param = [MessageNumParam new];
    param.type = 0;
    [MessageReq numberWithParam:param success:^(MessageNumResp *response) {
        [self setMsgNumber:response.data.number];
    } failure:nil];
}

- (void)setMsgNumber:(NSInteger)num
{
    if (num > 0) {
        [self.itemMessage setBadgeCenterOffset:CGPointMake(-5, 5)];
        [self.itemMessage setBadgeBgColor:UIColorFromHex(0xb4292d)];
        [self.itemMessage showBadgeWithStyle:WBadgeStyleNumber value:num animationType:WBadgeAnimTypeNone];
    } else {
        [self.itemMessage clearBadge];
    }
}

- (void)actionMessage
{
    if ([AccountManager isNeedLogin]) {
        [AccountManager showLoginView];
        return;
    }
    MessageViewController *msgVC = [[MessageViewController alloc] init];
    [self.navigationController pushViewController:msgVC animated:YES];
}

- (void)actionSearch:(UIButton *)button
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
        _magicController.magicView.sliderExtension = CoordXSizeScale(30);
        _magicController.magicView.navigationHeight = 32;
        _magicController.magicView.itemWidth = kMainScreenWidth/2;
        _magicController.magicView.navigationColor = UIColorFromHex(0xfafafa);
        _magicController.magicView.sliderColor = UIColorFromHex(0xb4292d);
    }
    return _magicController;
}

- (NSArray *)listTitle
{
    return @[@"内容", @"社群"];
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
    static NSString *idContent = @"idContent";
    static NSString *idActivity = @"idActivity";
    
    UIViewController *contentVC = nil;
    if (pageIndex == 0) {
        contentVC = [magicView dequeueReusablePageWithIdentifier:idContent];
        if (!contentVC) {
            contentVC = [[ActivityContentController alloc] init];
        }
    } else {
        contentVC = [magicView dequeueReusablePageWithIdentifier:idActivity];
        if (!contentVC) {
            contentVC = [[ActivityListViewController alloc] init];
        }
    }
    
    return contentVC;
}

- (void)addSearchBar
{
    UIButton *btnSeach = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth * 0.8, 32)];
    [btnSeach setRoundWithCorner:6.0f];
    btnSeach.titleLabel.font = FontPFRegular(12.0f);
    [btnSeach setTitle:@"搜索您感兴趣的内容" forState:UIControlStateNormal];
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

- (PYSearchViewController *)searchVC
{
    if (!_searchVC) {
        _searchVC = [PYSearchViewController searchViewControllerWithHotSearches:nil searchBarPlaceholder:@"搜索您感兴趣的内容" didSearchBlock:^(PYSearchViewController *searchViewController, UISearchBar *searchBar, NSString *searchText) {
            
            if ([self.magicController.currentViewController isKindOfClass:[ActivityListViewController class]]) {
                ActivityListViewController *searchVC = [[ActivityListViewController alloc] init];
                searchVC.keywords = searchText;
                searchVC.title = @"社群";
                [searchViewController.navigationController pushViewController:searchVC animated:YES];
            } else {
                ActivityContentSearchVC *searchVC = [[ActivityContentSearchVC alloc] init];
                searchVC.keywords = searchText;
                [searchViewController.navigationController pushViewController:searchVC animated:YES];
            }
        }];
        // 3.设置风格
        _searchVC.showSearchHistory = NO;
        [_searchVC setHotSearchStyle:PYHotSearchStyleDefault]; // 热门搜索风格为默认
        [_searchVC setSearchHistoryStyle:PYSearchHistoryStyleDefault]; // 搜索历史风格根据选择
        
        // 4. 设置代理
        [_searchVC setDelegate:self];
    }
    return _searchVC;
}
@end
