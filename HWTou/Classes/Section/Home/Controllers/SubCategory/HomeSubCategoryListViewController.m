//
//  HomeSubCategoryListViewController.m
//  HWTou
//
//  Created by robinson on 2018/1/4.
//  Copyright © 2018年 LieMi. All rights reserved.
//

#import "HomeSubCategoryListViewController.h"
#import "VTMagicController.h"
#import "PublicHeader.h"
#import "HomeSubCategoryDetailViewController.h"
#import "PYSearch.h"
#import "SearchViewController.h"
#import "CustomNavigationController.h"
#import "UINavigationItem+Margin.h"
#import "GuessULikeModel.h"
#import "GetChatInfoModel.h"

//#import "NTESAnchorLiveViewController.h"
//#import "NTESDemoService.h"
#import "SVProgressHUD.h"
#import "UIView+Toast.h"
//#import "NTESLiveManager.h"
//#import "NSDictionary+NTESJson.h"
//#import "NTESCustomKeyDefine.h"
//#import "NTESLiveUtil.h"
#import "RotRequest.h"

//#import "NTESBundleSetting.h"
//#import "NTESChatroomManager.h"
//#import "NTESLiveViewController.h"
//#import "NTESAudienceLiveViewController.h"
#import "AccountManager.h"
#import "SaveRoomInfoModel.h"

@interface HomeSubCategoryListViewController ()<VTMagicViewDataSource, VTMagicViewDelegate>
@property (nonatomic, strong) VTMagicController *magicController;
@property (nonatomic,strong) NSMutableArray * listTitle;
@end

@implementation HomeSubCategoryListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"聊吧";
    [self addNavBarView];
    
    if (_chatScrollStyle) {
        // Do any additional setup after loading the view.
        [self.view addSubview:self.magicController.magicView];
        [self.magicController.magicView makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
        [self.magicController.magicView reloadData];
        [self.magicController.magicView switchToPage:_row animated:YES];
    }else{
        HomeSubCategoryDetailViewController * contentVC = [[HomeSubCategoryDetailViewController alloc] init];
        contentVC.detailBlock = ^(GuessULikeModel *model) {
            [Navigation showAudioPlayerViewController:self radioModel:model];
        };
        contentVC.classId = [_classModel classId];
        
        [self.view addSubview:contentVC.view];
        [contentVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)addNavBarView{
    UIBarButtonItem *leftItem = [UIBarButtonItem itemWithImageName:@"hfzk_btn_back" hltImageName:nil target:self action:@selector(popViewControll)];
    [self.navigationItem setLeftBarButtonItem:leftItem fixedSpace:0];
    
    UIView * bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth - 24, 32)];
    
    UILabel *labNavTitle = [BasisUITool getLabelWithTextColor:UIColorFromHex(0x333333)
                                                         size:NAVIGATION_FONT_TITLE_SIZE];
    labNavTitle.textAlignment = NSTextAlignmentCenter;
    [labNavTitle setText:_classModel.className];
    labNavTitle.frame = CGRectMake(0, 0, 20*labNavTitle.text.length, 32);
    [bgView addSubview:labNavTitle];
    
    UIButton *btnSeach = [[UIButton alloc] initWithFrame:CGRectMake(labNavTitle.frame.origin.x+labNavTitle.frame.size.width+5, 0, bgView.frame.size.width - (labNavTitle.frame.origin.x+labNavTitle.frame.size.width+30), 32)];
    [btnSeach setRoundWithCorner:6.0f];
    btnSeach.titleLabel.font = FontPFRegular(14.0f);
    [btnSeach setTitle:@"搜索您感兴趣的内容" forState:UIControlStateNormal];
    [btnSeach setTitleColor:UIColorFromHex(0x7f7f7f) forState:UIControlStateNormal];
    [btnSeach setImage:[UIImage imageNamed:NAVIGATION_IMG_SEARCH_ICO] forState:UIControlStateNormal];
    [btnSeach setBackgroundColor:UIColorFromHex(NAVIGATION_SEARCHBAR_GRAY_BG)];
    [btnSeach addTarget:self action:@selector(searchAction) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:btnSeach];

    [self.navigationItem setTitleView:bgView];
}

#pragma mark - Action

- (void)searchAction{
    PYSearchViewController * pySearchVC = [PYSearchViewController searchViewControllerWithHotSearches:nil searchBarPlaceholder:@"搜索您感兴趣的内容" didSearchBlock:^(PYSearchViewController *searchViewController, UISearchBar *searchBar, NSString *searchText) {
        
        SearchViewController *searchVC = [[SearchViewController alloc] init];
        searchVC.keywords = searchText;
        searchViewController.searchResultController = searchVC;
    }];
    UIButton * cancelBtn = (UIButton *)pySearchVC.navigationItem.rightBarButtonItem.customView;
    [cancelBtn setTitleColor:UIColorFromHex(0x2b2b2b) forState:UIControlStateNormal];
    // 3.设置风格
    //        [_searchVC setHotSearchStyle:PYHotSearchStyleDefault]; // 热门搜索风格为默认
    [pySearchVC setSearchHistoryStyle:PYSearchHistoryStyleDefault]; // 搜索历史风格根据选择
    pySearchVC.searchResultShowMode = PYSearchResultShowModeEmbed;
//    pySearchVC.dataSource = self;
//    // 4. 设置代理
//    [pySearchVC setDelegate:self];
    
    CustomNavigationController *nav = [[CustomNavigationController alloc] initWithRootViewController:pySearchVC];
    [self presentViewController:nav animated:YES completion:nil];
}

- (void)popViewControll{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - VTMagicView

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
        menuItem.titleLabel.font = FontPFRegular(16.0f);
    }
    return menuItem;
}

- (UIViewController *)magicView:(VTMagicView *)magicView viewControllerAtPage:(NSUInteger)pageIndex
{
    static NSString * recomId;
    recomId = [NSString stringWithFormat:@"recom.identifier%ld",pageIndex];
    HomeSubCategoryDetailViewController * contentVC = [magicView dequeueReusablePageWithIdentifier:recomId];

    if (!contentVC) {
        contentVC = [[HomeSubCategoryDetailViewController alloc] init];
        contentVC.detailBlock = ^(GuessULikeModel *model) {
            [Navigation lookLiveRoom:self model:model];
        };
    }
    
    contentVC.classId = [_classModel.chatClassSecsArr[pageIndex] classIdSec];
    return contentVC;
}

#pragma mark - getter
- (VTMagicController *)magicController
{
    if (!_magicController) {
        _magicController = [[VTMagicController alloc] init];
        _magicController.magicView.dataSource = self;
        _magicController.magicView.delegate = self;
        _magicController.magicView.sliderHeight = 2.5;
        _magicController.magicView.sliderExtension = CoordXSizeScale(30);
        _magicController.magicView.navigationHeight = 44;
        CGFloat itemWidth = self.listTitle.count>5?kMainScreenWidth/5:kMainScreenWidth/self.listTitle.count;
        _magicController.magicView.itemWidth = itemWidth;
        _magicController.magicView.navigationColor = UIColorFromHex(0xfafafa);
        _magicController.magicView.sliderColor = UIColorFromHex(0xb4292d);
    }
    return _magicController;
}

- (NSMutableArray *)listTitle
{
    if (!_listTitle) {
        _listTitle = [NSMutableArray array];
        for (int i = 0;i<_classModel.chatClassSecsArr.count;i++) {
            ChatClassSecsModel * secsModel = _classModel.chatClassSecsArr[i];
            if (secsModel.classIdSec != -1) {
                [_listTitle addObject:secsModel.classNameSec];
            }
            if (secsModel.classIdSec == _secsModel.classIdSec) {
                _row = i;
            }
        };
    }
    return _listTitle;
}

@end
