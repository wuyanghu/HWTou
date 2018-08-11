//
//  HomePageViewController.m
//  HWTou
//
//  Created by Reyna on 2017/11/21.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "HomePageViewController.h"
#import "PublicHeader.h"
#import "UINavigationItem+Margin.h"
#import "PlayerHistoryViewController.h"
#import "PYSearchViewController.h"
#import "CustomNavigationController.h"
#import "SearchViewController.h"
#import "RadioRequest.h"
#import "PlayerHistoryModel.h"
#import "HomeSubRadioController.h"
#import <AMapLocationKit/AMapLocationKit.h>
#import "HomeBannerListModel.h"
#import "HomeBanerListViewModel.h"
#import "AnswerLsRequest.h"
#import "AnswerlrViewModel.h"
#import "HeaderRollCollectionCell.h"
#import "HomeInteractCollectionViewCell.h"
#import "AnswerLsCollectionViewCell.h"
#import "BaseCollectionReusableView.h"
#import "SubCategateCollectionReusableView.h"
#import "GuessULikeModel.h"
#import "SubYiXingViewController.h"

#define kCarouselCellIdentify @"kCarouselCellIdentify"

@interface HomePageViewController ()<PYSearchViewControllerDataSource, PYSearchViewControllerDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, HeaderRollCollectionCellDelegate, AnswerLsCollectionViewCellDelegate>
{
    AMapLocationManager *_locationManager;
    NSString *_cityCode;
}

@property (nonatomic, strong) UICollectionView  *collectionView;
@property (nonatomic, strong) HomeBanerListViewModel *bannerListViewModel;
@property (nonatomic, strong) GuessULikeModel *lbModel;
@property (nonatomic, strong) AnswerlrViewModel *answerlrViewModel;

@end

@implementation HomePageViewController

- (void)viewDidLoad {
    [super viewDidLoad];

//    [self addNaviBar];
    [self configSubViews];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (!self.navigationController.navigationBarHidden) {
        [self.navigationController setNavigationBarHidden:YES animated:YES];
    }
    [self requestGetBannerList];
    [self requestGetHomeChatID];
    [self requestGetSpecList];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    // 如果当前VC是self则不需要隐藏，如TabBar切换的过程
    if (self.navigationController.topViewController != self) {
        [self.navigationController setNavigationBarHidden:NO animated:YES];
    }
}

- (void)addNaviBar {
    
    UIBarButtonItem *leftItem = [UIBarButtonItem itemWithImageName:@"ss_fayelogo" hltImageName:nil target:self action:@selector(messageAction)];
    [self.navigationItem setLeftBarButtonItem:leftItem fixedSpace:0];
    
    UIBarButtonItem *rightItem = [UIBarButtonItem itemWithImageName:@"nav_icon_history" hltImageName:nil target:self action:@selector(historyAction)];
    [self.navigationItem setRightBarButtonItem:rightItem fixedSpace:6];
    
    UIView * bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth - 124, 32)];
    
    UIButton *btnSeach = [[UIButton alloc] initWithFrame:CGRectMake(10, 0, kMainScreenWidth - 134, 32)];
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

- (void)configSubViews {
    
    [self.view addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}
    
#pragma mark - request
//banner列表
- (void)requestGetBannerList{
    BannerListParam * bannerListParam = self.bannerListViewModel.bannerListParam;
    bannerListParam.flag = 1;
    [RotRequest getBannerList:bannerListParam Success:^(ArrayResponse *response) {
        if (response.status == 200) {
            [self.bannerListViewModel bindWithDic:response.data];
            [self.collectionView reloadSections:[NSIndexSet indexSetWithIndex:0]];
        }
    } failure:^(NSError *error) {
        
    }];
}
    
- (void)requestGetHomeChatID {
    
    [RotRequest getHomeChatIDDetailWithSuccess:^(DictResponse *response) {
        if (response.status == 200) {
            self.lbModel.rtcId = [[response.data objectForKey:@"rtcId"] integerValue];
            self.lbModel.roomId = [[response.data objectForKey:@"croomId"] integerValue];
        }
    } failure:^(NSError *error) {
        
    }];
}

- (void)requestGetSpecList {
    GetActivityParam * activityParam = [GetActivityParam new];
    activityParam.specId = 0;
    [AnswerLsRequest getSpecList:activityParam Success:^(AnswerLsArray *response) {
        if (response.status == 200) {
            [self.answerlrViewModel bindGetSpecList:response.data];
//            [self.collectionView reloadData];
            [self.collectionView reloadSections:[NSIndexSet indexSetWithIndex:2]];
        }
        [self.collectionView.mj_header endRefreshing];

    } failure:^(NSError *error) {
        
        [HUDProgressTool showErrorWithText:ReqErrCode_Custom_ErrorInfo];
        [self.collectionView.mj_header endRefreshing];
    }];
}

#pragma mark - UICollectionViewDataSource && UICollectionViewDelegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 3;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (section == 1) {
        return 2;
    }
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        HeaderRollCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCarouselCellIdentify forIndexPath:indexPath];
        cell.cellDelegate = self;
        [cell setDataArray:self.bannerListViewModel.dataArray];
        return cell;
    }
    else if (indexPath.section == 1) {
        HomeInteractCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[HomeInteractCollectionViewCell getTheReuseIdentifier] forIndexPath:indexPath];
        
        if (indexPath.row == 0) {
            cell.bgImageIcon.image = [UIImage imageNamed:@"home_liaoba"];
            cell.titleLab.text = @"聊吧";
        }
        else {
            cell.bgImageIcon.image = [UIImage imageNamed:@"diantai2"];
            cell.titleLab.text = @"艺讯";
        }
        return cell;
    }
    else {
        AnswerLsCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:[AnswerLsCollectionViewCell cellIdentity] forIndexPath:indexPath];
        cell.cellDeleagte = self;
        [cell setDataArray:self.answerlrViewModel.specListArr];
        return cell;
    }
    
}

// 设置headerView和footerView的
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *reusableView = nil;
    if (kind == UICollectionElementKindSectionHeader) {
        BaseCollectionReusableView * header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:[BaseCollectionReusableView cellIdentity] forIndexPath:indexPath];
        header.hidden = YES;
        reusableView = header;
        
        if (indexPath.section == 0) {
            
        }
        else if (indexPath.section == 1) {
            SubCategateCollectionReusableView * header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:[SubCategateCollectionReusableView cellIdentity] forIndexPath:indexPath];
            header.titleLabel.text = @"艺起聊吧";
            reusableView = header;
        }
        else {
            SubCategateCollectionReusableView * header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:[SubCategateCollectionReusableView cellIdentity] forIndexPath:indexPath];
            header.titleLabel.text = @"聊吧答题";
            reusableView = header;
        }
    }
    if (kind == UICollectionElementKindSectionFooter){
        //        if (indexPath.section == 0 || indexPath.section == 1) {
        //            TopicFooterCollectionReusableView *footerview = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:kFooterViewIdentify1 forIndexPath:indexPath];
        //            reusableView = footerview;
        //        }else{
        //            reusableView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:kFooterViewIdentify forIndexPath:indexPath];
        //        }
    }
    
    return reusableView;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            //聊吧
            
            [Navigation lookLiveRoom:self model:self.lbModel];
        }
        else {
            SubYiXingViewController * yixingVC = [[SubYiXingViewController alloc] initWithNibName:nil bundle:nil];
            [self.navigationController pushViewController:yixingVC animated:YES];
//            //电台
//            
//            HomeSubRadioController *vc = [[HomeSubRadioController alloc] init];
//            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}

#pragma mark - UICollectionViewDelegateFlowLayout

//每个item之间的横向间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 10;
}

//每个item之间的纵向的行间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 10;
}

// 设置每个cell上下左右相距
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    if (section == 1) {
        return UIEdgeInsetsMake(0, 10, 0, 10);
    }
    return UIEdgeInsetsZero;
}

//设置每个单元格的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        return CGSizeMake(kMainScreenWidth, 150);
    }
    else if (indexPath.section == 1) {
        return CGSizeMake((kMainScreenWidth - 45)/2.0, (kMainScreenWidth - 45)/2.0 * (180/165.0));
    }else{
        return CGSizeMake(kMainScreenWidth, 105 + 20);
    }
}
//头部view高度
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
 
    if (section == 0) {
        return CGSizeZero;
    }
    return CGSizeMake(kMainScreenWidth, 50);
}

//尾部view高度
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    return CGSizeZero;
}

#pragma mark - HeaderRollCollectionCellDelegate
- (void)carouselviewDidSelectItemAtIndex:(NSInteger)index{
    HomeBannerListModel * bannerModel = self.bannerListViewModel.dataArray[index];
    [Navigation showBanner:self bannerModel:bannerModel];
}

#pragma mark - AnswerLsControllerDelegate

- (void)buttonAction:(GetSpecListModel *)specListModel{
    self.answerlrViewModel.selectSpecModel = specListModel;
    [Navigation getServeDate:specListModel.specId from:self isBanner:NO];
}

#pragma mark - NavAction

- (void)messageAction {
    
}

- (void)historyAction {

    [Navigation showPlayerHistoryViewController:self];
}

- (void)searchAction {
    PYSearchViewController * pySearchVC = [PYSearchViewController searchViewControllerWithHotSearches:nil searchBarPlaceholder:@"搜索您感兴趣的内容" didSearchBlock:^(PYSearchViewController *searchViewController, UISearchBar *searchBar, NSString *searchText) {
        
        SearchViewController *searchVC = [[SearchViewController alloc] init];
        searchVC.keywords = searchText;
        searchViewController.searchResultController = searchVC;
//        [searchViewController.navigationController pushViewController:searchVC animated:YES];
    }];
    UIButton * cancelBtn = (UIButton *)pySearchVC.navigationItem.rightBarButtonItem.customView;
    [cancelBtn setTitleColor:UIColorFromHex(0x2b2b2b) forState:UIControlStateNormal];
    // 3.设置风格
    //        [_searchVC setHotSearchStyle:PYHotSearchStyleDefault]; // 热门搜索风格为默认
    [pySearchVC setSearchHistoryStyle:PYSearchHistoryStyleDefault]; // 搜索历史风格根据选择
    pySearchVC.searchResultShowMode = PYSearchResultShowModeEmbed;
    pySearchVC.dataSource = self;
    // 4. 设置代理
    [pySearchVC setDelegate:self];
    
    CustomNavigationController *nav = [[CustomNavigationController alloc] initWithRootViewController:pySearchVC];
    [self presentViewController:nav animated:YES completion:nil];
}

#pragma mark - getter

- (UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        
        [_collectionView registerClass:[HeaderRollCollectionCell class] forCellWithReuseIdentifier:kCarouselCellIdentify];
        [_collectionView registerClass:[BaseCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:[BaseCollectionReusableView cellIdentity]];
        [_collectionView registerClass:[SubCategateCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:[SubCategateCollectionReusableView cellIdentity]];
        [_collectionView registerNib:[UINib nibWithNibName:@"HomeInteractCollectionViewCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:[HomeInteractCollectionViewCell getTheReuseIdentifier]];
        [_collectionView registerNib:[UINib nibWithNibName:@"AnswerLsCollectionViewCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:[AnswerLsCollectionViewCell cellIdentity]];
        
#ifdef __IPHONE_11_0
        if ([_collectionView respondsToSelector:@selector(setContentInsetAdjustmentBehavior:)]) {
            _collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
#endif
        
        __weak typeof(self) weakSelf = self;
        _collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [weakSelf requestGetBannerList];
            [weakSelf requestGetHomeChatID];
            [weakSelf requestGetSpecList];
        }];
        
    }
    return _collectionView;
}

- (HomeBanerListViewModel *)bannerListViewModel {
    if (!_bannerListViewModel) {
        _bannerListViewModel = [[HomeBanerListViewModel alloc] init];
    }
    return _bannerListViewModel;
}

- (GuessULikeModel *)lbModel {
    if (!_lbModel) {
        _lbModel = [[GuessULikeModel alloc] init];
    }
    return _lbModel;
}

- (AnswerlrViewModel *)answerlrViewModel {
    if (!_answerlrViewModel) {
        _answerlrViewModel = [AnswerlrViewModel sharedInstance];
    }
    return _answerlrViewModel;
}

#pragma mark -

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
