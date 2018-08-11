//
//  HomeMoneyIsComingViewController.m
//  HWTou
//
//  Created by robinson on 2017/12/19.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "HomeMoneyIsComingViewController.h"
#import "PublicHeader.h"
#import "GuessULikeViewModel.h"
#import "HomeMoneyIsComingView.h"
#import "HotGuessULikeMoreViewController.h"
#import "HotRecMoreViewController.h"
#import "PlayerHistoryModel.h"
#import "RadioRequest.h"
#import "PlayerDetailViewModel.h"

@interface HomeMoneyIsComingViewController ()<HomeMoneyIsComingViewDelegate>
@property (nonatomic,strong) HomeMoneyIsComingView * moneyIsComingView;
@property (nonatomic,strong) GuessULikeViewModel * viewModel;
@property (nonatomic,strong) HomeBanerListViewModel * bannerListViewModel;
@property (nonatomic, strong) PlayerDetailViewModel *detailVM;
@end

@implementation HomeMoneyIsComingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setTitle:@"钱潮"];
    
    [self.view addSubview:self.moneyIsComingView];
    [self.moneyIsComingView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [self loadHeaderData];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self requestMoneyComChat];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - HomeMoneyIsComingViewDelegate

- (void)carouselviewDidSelectItemAtIndex:(NSInteger)index{
    HomeBannerListModel * bannerModel = self.bannerListViewModel.dataArray[index];
    [Navigation showBanner:self bannerModel:bannerModel];
}

- (void)loadHeaderData{
    [self requestGetBannerList];
    [self requestGetHotRecList:YES];
    [self.moneyIsComingView.collectionView.mj_header endRefreshing];
}

- (void)loadFooterData{
    [self.moneyIsComingView.collectionView.mj_footer endRefreshing];
}

- (void)buttonSelected:(UIButton *)button indexPath:(NSIndexPath *)indexPath{
    if (button.tag == exchangeBtnType) {//换一批
        GetHotRecListModel * recListModel = self.viewModel.hotRecListArray[indexPath.section-2];
        [self requestGetHotRecChangeList:recListModel];//热门推荐换一批
    }else if (button.tag == moreBtnType){//更多
        GetHotRecListModel * recListModel = self.viewModel.hotRecListArray[indexPath.section-2];
        HotRecMoreViewController * moreVC = [HotRecMoreViewController new];
        moreVC.recListModel = recListModel;
        [self.navigationController pushViewController:moreVC animated:YES];
    }
    
}

- (void)didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    GuessULikeModel * likeModel = nil;
    if (indexPath.section == 0) {//banner
        
    }else if (indexPath.section == 1){
        NSLog(@"进入答题车神聊吧");
        PlayerHistoryModel *hisModel = [[PlayerHistoryModel alloc] init];
        hisModel.rtcId = self.detailVM.rtcId;
        hisModel.flag = 3;
        
        [Navigation showAudioPlayerViewController:self radioModel:hisModel];
    }else if (indexPath.section<[self.viewModel getSection]){//热门推荐
        GetHotRecListModel * recListModel = self.viewModel.hotRecListArray[indexPath.section-2];
        likeModel = recListModel.rtcDetailArr[indexPath.row];
    }
    if (likeModel) {
        [Navigation showAudioPlayerViewController:self radioModel:likeModel];
    }
    
}

#pragma mark - request
//banner列表
- (void)requestGetBannerList{
    BannerListParam * bannerListParam = self.bannerListViewModel.bannerListParam;
    bannerListParam.flag = 3;
    [RotRequest getBannerList:bannerListParam Success:^(ArrayResponse *response) {
        [self.bannerListViewModel bindWithDic:response.data];
        [self.moneyIsComingView.collectionView reloadSections:[NSIndexSet indexSetWithIndex:0]];
    } failure:^(NSError *error) {
        
    }];
}

//钱潮推荐列表
- (void)requestGetHotRecList:(BOOL)isRefresh{
    
    [CollectSessionReq getMCRecList:[BaseParam new] Success:^(MyTopicListResponse *response) {
        [self.viewModel bindWithGetHotRecList:response.data isRefresh:isRefresh];
        [self.moneyIsComingView refreshData];
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
        if (guessULikeParam.page>5) {
            guessULikeParam.page=1;
        }
    }
    
    [RotRequest guessULike:guessULikeParam Success:^(ArrayResponse *response) {
        [self.viewModel bindWithGuessULike:response.data isRefresh:isRefresh];
        [self.moneyIsComingView.collectionView reloadSections:[NSIndexSet indexSetWithIndex:1]];
    } failure:^(NSError *error) {
        
    }];
}

//热门推荐换一批及更多
- (void)requestGetHotRecChangeList:(GetHotRecListModel * )recListModel{
    HotRecChangeListParam * changeListParam = self.viewModel.changeListParam;
    changeListParam.recId = recListModel.recId;
    
    [RotRequest getHotRecChangeList:changeListParam Success:^(DictResponse *response) {
        [self.viewModel bindWithGetHotRecChangeList:response.data recListModel:recListModel];
        [self.moneyIsComingView refreshData];
    } failure:^(NSError *error) {
        
    }];
    
}

//获取钱潮id
- (void)requestMoneyComChat{
    [CollectSessionReq getMoneyComChat:[BaseParam new] Success:^(MoneyComChatResponse *response) {
        if (response.status == 200) {
            [self requestGetChatState:[response.data intValue]];
        }
    } failure:^(NSError *error) {
        
    }];
}

- (void)requestGetChatState:(int)rtcId{
    [RadioRequest getChatState:rtcId success:^(NSDictionary * response) {
        if ([[response objectForKey:@"status"] intValue] == 200) {
            [self.detailVM bindWithDic:response];
            self.moneyIsComingView.detailVM = self.detailVM;
            [self.moneyIsComingView.collectionView reloadSections:[NSIndexSet indexSetWithIndex:1]];
        }
    } failure:^(NSError * error) {
        
    }];
}


#pragma mark - getter

- (PlayerDetailViewModel *)detailVM {
    if (!_detailVM) {
        _detailVM = [[PlayerDetailViewModel alloc] init];
    }
    return _detailVM;
}

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

- (HomeMoneyIsComingView *)moneyIsComingView{
    if (!_moneyIsComingView) {
        _moneyIsComingView = [[HomeMoneyIsComingView alloc] init];
        _moneyIsComingView.HomeMoneyIsComingViewDelegate = self;
        _moneyIsComingView.viewModel = self.viewModel;
        _moneyIsComingView.bannerListViewModel = self.bannerListViewModel;
    }
    return _moneyIsComingView;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
