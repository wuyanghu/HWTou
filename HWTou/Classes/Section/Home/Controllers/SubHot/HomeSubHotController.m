//
//  HomeSubHotController.m
//  HWTou
//
//  Created by Reyna on 2017/11/21.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "HomeSubHotController.h"
#import "RotView.h"
#import "PublicHeader.h"
#import "RotRequest.h"
#import "HotGuessULikeMoreViewController.h"
#import "HotRecMoreViewController.h"
#import "HomeBannerListModel.h"
#import "HomeBanerListViewModel.h"
#import "ComFloorEvent.h"

@interface HomeSubHotController ()<RotViewDelegate>
@property (nonatomic,strong) RotView * rotView;
@property (nonatomic,strong) GuessULikeViewModel * viewModel;
@property (nonatomic,strong) HomeBanerListViewModel * bannerListViewModel;
@end

@implementation HomeSubHotController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.rotView];
    [self.rotView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];

    [self loadHeaderData];
}

#pragma mark - RotViewDelegate

- (void)carouselviewDidSelectItemAtIndex:(NSInteger)index{
    HomeBannerListModel * bannerModel = self.bannerListViewModel.dataArray[index];
    [Navigation showBanner:self bannerModel:bannerModel];
}

- (void)loadHeaderData{
    [self requestGetBannerList];
    [self requestGetHotRecList:YES];
    [self requestGuessULike:YES];
    [self requestHotNewRecList:YES];
    [self.rotView.collectionView.mj_header endRefreshing];
}

- (void)loadFooterData{
    [self.rotView.collectionView.mj_footer endRefreshingWithNoMoreData];
}

- (void)buttonSelected:(UIButton *)button indexPath:(NSIndexPath *)indexPath{
    if (button.tag == exchangeBtnType) {//换一批
        if (indexPath.section == 1) {//猜你喜欢换一批
            [self requestGuessULike:NO];
        }else{
            GetHotRecListModel * recListModel = self.viewModel.hotRecListArray[indexPath.section-2];
            [self requestGetHotRecChangeList:recListModel];//热门推荐换一批
        }
    }else if (button.tag == moreBtnType){//更多
        if (indexPath.section == 1) {//猜你喜欢
            HotGuessULikeMoreViewController * moreVC = [[HotGuessULikeMoreViewController alloc] init];
            [self.navigationController pushViewController:moreVC animated:YES];
        }else if(indexPath.section<2+self.viewModel.hotRecListArray.count){
            GetHotRecListModel * recListModel = self.viewModel.hotRecListArray[indexPath.section-2];
            HotRecMoreViewController * moreVC = [HotRecMoreViewController new];
            moreVC.recListModel = recListModel;
            [self.navigationController pushViewController:moreVC animated:YES];
        }
    }
    
}

- (void)didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    GuessULikeModel * likeModel = nil;
    if (indexPath.section == 0) {//banner
        
    }else if (indexPath.section == 1){//猜你喜欢
        likeModel = self.viewModel.likeArray[indexPath.row];
    }else if (indexPath.section<2+self.viewModel.hotRecListArray.count){//热门推荐
        GetHotRecListModel * recListModel = self.viewModel.hotRecListArray[indexPath.section-2];
        likeModel = recListModel.rtcDetailArr[indexPath.row];
    }else{//热门最新推荐
        likeModel = self.viewModel.hotNewRecListArray[indexPath.row];
    }
    if (likeModel) {
        [Navigation showAudioPlayerViewController:self radioModel:likeModel];
    }
    
}

#pragma mark - request
//banner列表
- (void)requestGetBannerList{
    BannerListParam * bannerListParam = self.bannerListViewModel.bannerListParam;
    bannerListParam.flag = 1;
    [RotRequest getBannerList:bannerListParam Success:^(ArrayResponse *response) {
        if (response.status == 200) {
            [self.bannerListViewModel bindWithDic:response.data];
            [self.rotView.collectionView reloadSections:[NSIndexSet indexSetWithIndex:0]];
        }
    } failure:^(NSError *error) {
        
    }];
}

//热门推荐列表
- (void)requestGetHotRecList:(BOOL)isRefresh{
    [RotRequest getHotRecList:[BaseParam new] Success:^(ArrayResponse *response) {
        if (response.status == 200) {
            [self.viewModel bindWithGetHotRecList:response.data isRefresh:isRefresh];
            [self.rotView refreshData];
        }
    } failure:^(NSError *error) {
        
    }];
}
//猜你喜欢列表
- (void)requestGuessULike:(BOOL)isRefresh{
    GuessULikeParam * guessULikeParam = self.viewModel.guessULikeParam;
    if (isRefresh) {
        guessULikeParam.page = 1;
    }else{
        guessULikeParam.page++;
        if (guessULikeParam.page>4) {
            guessULikeParam.page=1;
        }
    }
    
    [RotRequest guessULike:guessULikeParam Success:^(ArrayResponse *response) {
        if (response.status == 200) {
            [self.viewModel bindWithGuessULike:response.data isRefresh:isRefresh];
            [self.rotView.collectionView reloadSections:[NSIndexSet indexSetWithIndex:1]];
        }
    } failure:^(NSError *error) {
        
    }];
}

//热门最新推荐列表
- (void)requestHotNewRecList:(BOOL)isRefresh{
    [RotRequest getHotNewRecList:[BaseParam new] Success:^(ArrayResponse *response) {
        if (response.status == 200) {
            [self.viewModel bindWithHotNewRecList:response.data isRefresh:isRefresh];
            [self.rotView refreshData];
        }
        
    } failure:^(NSError *error) {
        
    }];
}
//热门推荐换一批及更多
- (void)requestGetHotRecChangeList:(GetHotRecListModel * )recListModel{
    HotRecChangeListParam * changeListParam = self.viewModel.changeListParam;
    changeListParam.recId = recListModel.recId;
    
    [RotRequest getHotRecChangeList:changeListParam Success:^(DictResponse *response) {
        if (response.status == 200) {
            [self.viewModel bindWithGetHotRecChangeList:response.data recListModel:recListModel];
            [self.rotView refreshData];
        }
        
    } failure:^(NSError *error) {
        
    }];
    
}


#pragma mark - getter

- (HomeBanerListViewModel *)bannerListViewModel{
    if (!_bannerListViewModel) {
        _bannerListViewModel = [[HomeBanerListViewModel alloc] init];
    }
    return _bannerListViewModel;
}

- (GuessULikeViewModel *)viewModel{
    if (!_viewModel) {
        _viewModel = [GuessULikeViewModel new];
    }
    return _viewModel;
}

- (RotView *)rotView{
    if (!_rotView) {
        _rotView = [[RotView alloc] init];
        _rotView.rotViewDelegate = self;
        _rotView.viewModel = self.viewModel;
        _rotView.bannerListViewModel = self.bannerListViewModel;
    }
    return _rotView;
}

#pragma mark -

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
