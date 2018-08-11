//
//  HomeViewController.m
//  HWTou
//
//  Created by pengpeng on 17/3/7.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "HomeViewController.h"
#import "ComFloorEvent.h"
#import "HomeConfigReq.h"
#import "HomeNoticeReq.h"
#import "FloorListReq.h"
#import "HomeConfigDM.h"
#import "PublicHeader.h"
#import "BannerAdReq.h"
#import "MessageReq.h"
#import "HomeView.h"
#import "ActivityContentController.h"
#import "ActivityListViewController.h"

#import "ActivityContentSearchVC.h"
#import "PYSearchViewController.h"
#import "MessageViewController.h"
#import "CustomNavigationController.h"
#import "UINavigationItem+Margin.h"
#import "VTMagic.h"
#import "HomeSubFactory.h"

@interface HomeViewController () <VTMagicViewDataSource, VTMagicViewDelegate, PYSearchViewControllerDelegate>

@property (nonatomic, strong) PYSearchViewController *searchVC;
@property (nonatomic, strong) UIBarButtonItem   *itemMessage;
@property (nonatomic, strong) VTMagicController *magicController;

@end

@implementation HomeViewController

#define kNaviBarScrollOffset   180.0f

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self addSearchBar];
    
    [self.view addSubview:self.magicController.magicView];
    [self.magicController.magicView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [self.magicController.magicView reloadData];
}

- (void)addSearchBar
{
    self.itemMessage = [UIBarButtonItem itemWithImageName:@"nav_icon_news" hltImageName:nil target:self action:@selector(actionMessage)];
    [self.navigationItem setLeftBarButtonItem:self.itemMessage fixedSpace:-6];
    
    UIButton *btnSeach = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth * 0.65, 32)];
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
    self.navigationItem.titleView = containView;
    
    UIBarButtonItem * rightBtnItem = [UIBarButtonItem itemWithImageName:@"nav_icon_history" hltImageName:nil target:self action:@selector(actionMessage)];
    [self.navigationItem setRightBarButtonItem:rightBtnItem fixedSpace:-2];
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
        _magicController.magicView.itemWidth = kMainScreenWidth/self.listTitle.count;
        _magicController.magicView.navigationColor = UIColorFromHex(0xfafafa);
        _magicController.magicView.sliderColor = UIColorFromHex(0xb4292d);
    }
    return _magicController;
}

- (NSArray *)listTitle
{
    return @[@"聊吧", @"热门",@"分类", @"主播",@"电台"];
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
    UIViewController * contentVC = [HomeSubFactory subFindControllerWithIdentifier:self.listTitle[pageIndex]];
    return contentVC;
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
        _searchVC.showSearchHistory = YES;
//        [_searchVC setHotSearchStyle:PYHotSearchStyleDefault]; // 热门搜索风格为默认
        [_searchVC setSearchHistoryStyle:PYSearchHistoryStyleDefault]; // 搜索历史风格根据选择
        
        // 4. 设置代理
        [_searchVC setDelegate:self];
    }
    return _searchVC;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
