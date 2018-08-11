//
//  HomeSubTopicController.m
//  HWTou
//
//  Created by Reyna on 2017/11/21.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "HomeSubTopicController.h"
#import "PublicHeader.h"
#import "TopicView.h"
#import "ComCarouselView.h"
#import "TopicRotViewController.h"
#import "CollectSessionReq.h"
#import "TopicWorkDetailModel.h"
#import "PersonHomeReq.h"
#import "PersonalHomePageViewController.h"
#import <MediaPlayer/MediaPlayer.h>
#import "HomeBanerListViewModel.h"
#import "HomeBannerListModel.h"
#import "ComFloorEvent.h"

#define kRotCollectCellIdentify @"kRotCollectCellIdentify"
#define kRotCollectHorizontalCellIdentify @"RotCollectHorizontalCellIdentify"
#define kHeaderViewIdentify @"HeaderView"
#define kFooterViewIdentify @"FooterView"

@interface HomeSubTopicController ()<TopicButtonSelectedDelegate,TopicViewDelegate>
@property (nonatomic,strong) TopicView * topicView;
@property (nonatomic,strong) LabelTopicListParam * listParam;
@property (nonatomic,strong) HomeBanerListViewModel * bannerListViewModel;
@end

@implementation HomeSubTopicController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.topicView];
    [self.topicView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [self requestNetWork];
    
}

#pragma mark - 网络请求
- (void)requestNetWork{
    
    //话题标签列表
    [CollectSessionReq topicLabelList:[BaseParam new] Success:^(MyTopicListResponse *response) {
        if (response.status == 200) {
            NSMutableArray * resultArray = [NSMutableArray arrayWithCapacity:response.data.count];
//            TopicLabelListModel * labelListModel = [TopicLabelListModel new];
//            labelListModel.labelName = @"今日优选";
//            labelListModel.labelId = -1;
//            [resultArray addObject:labelListModel];
            
            for (NSDictionary * dataDict in response.data) {
                TopicLabelListModel * topicLabelListModel = [TopicLabelListModel new];
                [topicLabelListModel setValuesForKeysWithDictionary:dataDict];
                
                [resultArray addObject:topicLabelListModel];
            }
            
            [self.topicView.titleArray removeAllObjects];
            [self.topicView.titleArray addObjectsFromArray:resultArray];
            
            [self.topicView refreshData];
            [self.topicView.collectionView.mj_header endRefreshing];
        }else{
            [HUDProgressTool showErrorWithText:response.msg];
        }

    } failure:^(NSError *error) {
        [HUDProgressTool showErrorWithText:ReqErrCode_Custom_ErrorInfo];
    }];
    
    //热门话题
    HotTopicListParam * hotTopicListParam = [HotTopicListParam new];
    hotTopicListParam.page = 1;
    hotTopicListParam.pagesize = 3;
    
    [CollectSessionReq getHotTopicList:hotTopicListParam Success:^(MyTopicListResponse *response) {
        if (response.status == 200) {
            NSMutableArray * resultArray = [NSMutableArray arrayWithCapacity:response.data.count];
            
            for (NSDictionary * dataDict in response.data) {
                MyTopicListModel * topicLabelListModel = [MyTopicListModel new];
                [topicLabelListModel setValuesForKeysWithDictionary:dataDict];
                
                [resultArray addObject:topicLabelListModel];
            }
            [self.topicView.hotTopicListArr removeAllObjects];
            [self.topicView.hotTopicListArr addObjectsFromArray:resultArray];
            [self.topicView.collectionView reloadData];
            
            [self.topicView.collectionView.mj_header endRefreshing];
        }else{
            [HUDProgressTool showErrorWithText:response.msg];
        }

    } failure:^(NSError *error) {
        [HUDProgressTool showErrorWithText:ReqErrCode_Custom_ErrorInfo];

    }];
    
    NSInteger selectIndex = self.topicView.selectedTopicLabelIndex;
    NSArray * listArr = self.topicView.titleArray;
    TopicLabelListModel * listModel = [TopicLabelListModel new];
    if (selectIndex<listArr.count) {
        if (selectIndex == 0) {//今日优选列表
            listModel.labelId = -1;
            [self selecedLabelTopic:listModel];
        }else{
            listModel = listArr[selectIndex];
            [self selecedLabelTopic:listModel];
        }
    }else{
        //今日优选列表
        listModel.labelId = -1;
        [self selecedLabelTopic:listModel];
    }
    
    //话题banner
    [self requestGetBannerList];

}

//banner列表
- (void)requestGetBannerList{
    BannerListParam * bannerListParam = self.bannerListViewModel.bannerListParam;
    bannerListParam.flag = 2;
    [RotRequest getBannerList:bannerListParam Success:^(ArrayResponse *response) {
        if (response.status == 200) {
            [self.bannerListViewModel bindWithDic:response.data];
            [self.topicView.collectionView reloadData];
            [self.topicView.collectionView.mj_header endRefreshing];
        }else{
            
        }
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark - TopicViewDelegate

- (void)carouselviewDidSelectItemAtIndex:(NSInteger)index{
    HomeBannerListModel * bannerModel = self.bannerListViewModel.dataArray[index];
    [Navigation showBanner:self bannerModel:bannerModel];
}

- (void)loadHistoryData:(TopicLabelListModel *)labelListModel{
    [self.topicView.collectionView.mj_footer beginRefreshing];
    self.listParam.labelId = labelListModel.labelId;
    //今日优选列表
    if (labelListModel.labelId != -1) {
        [self requestLabelTopicList:NO];
    }else{
        [self requestTodayTopicList:NO];
    }
}

- (void)loadNewData{

    [self.topicView.collectionView.mj_header beginRefreshing];
    [self requestNetWork];
}
//今日优选列表
- (void)selectedTodayTopicList:(MyTopicListModel *)topicListModel{
    [Navigation showAudioPlayerViewController:self radioModel:topicListModel];
}

//选择热门
- (void)selectedTopicListModel:(MyTopicListModel *)topicListModel{
    [Navigation showAudioPlayerViewController:self radioModel:topicListModel];
}
//今日优选
- (void)requestTodayTopicList:(BOOL)isRefresh{
    if (isRefresh) {//下拉刷新
        self.listParam.page = 1;
    }else{
        self.listParam.page+=1;
    }
    [CollectSessionReq getTodayTopicList:self.listParam Success:^(MyTopicListResponse *response) {
        if (response.status == 200) {
            if (isRefresh) {
                [self.topicView.todayTopicListArr removeAllObjects];
            }
            NSMutableArray * array = [NSMutableArray array];
            for (NSDictionary * dict in response.data) {
                MyTopicListModel * listModel = [MyTopicListModel new];
                [listModel setValuesForKeysWithDictionary:dict];
                [array addObject:listModel];
            }
            [self.topicView.todayTopicListArr addObjectsFromArray:array];
            [self.topicView.collectionView reloadData];
            
            if (response.data.count<self.listParam.pagesize) {
                [self.topicView.collectionView.mj_footer endRefreshingWithNoMoreData];
            }else{
                [self.topicView.collectionView.mj_footer endRefreshing];
            }
            
        }else{
            [HUDProgressTool showErrorWithText:response.msg];
            [self.topicView.collectionView.mj_footer endRefreshing];
        }
        
    } failure:^(NSError *error) {
        [HUDProgressTool showErrorWithText:ReqErrCode_Custom_ErrorInfo];
        [self.topicView.collectionView.mj_footer endRefreshing];
        
    }];
    
}

- (void)requestLabelTopicList:(BOOL)isRefresh{
    if (isRefresh) {//下拉刷新
        self.listParam.page = 1;
    }else{
        self.listParam.page+=1;
    }
    [CollectSessionReq getLabelTopicList:self.listParam Success:^(MyTopicListResponse *response) {
        if (response.status == 200) {
            if (isRefresh) {
                [self.topicView.todayTopicListArr removeAllObjects];
            }
            NSMutableArray * array = [NSMutableArray array];
            for (NSDictionary * dict in response.data) {
                MyTopicListModel * listModel = [MyTopicListModel new];
                [listModel setValuesForKeysWithDictionary:dict];
                [array addObject:listModel];
            }
            [self.topicView.todayTopicListArr addObjectsFromArray:array];
            [self.topicView.collectionView reloadData];
            
            if (response.data.count<self.listParam.pagesize) {
                [self.topicView.collectionView.mj_footer endRefreshingWithNoMoreData];
            }else{
                [self.topicView.collectionView.mj_footer endRefreshing];
            }
            
        }else{
            [HUDProgressTool showErrorWithText:response.msg];
            [self.topicView.collectionView.mj_footer endRefreshing];
        }
        
    } failure:^(NSError *error) {
        [HUDProgressTool showErrorWithText:ReqErrCode_Custom_ErrorInfo];
        [self.topicView.collectionView.mj_footer endRefreshing];
        
    }];
}

//选择今日优选标签
- (void)selecedLabelTopic:(TopicLabelListModel *)labelListModel{
//    [HUDProgressTool showIndicatorWithText:ReqLoadingIn];
    
    self.listParam.labelId = labelListModel.labelId;
    self.listParam.page = 1;
    [self.topicView.collectionView.mj_footer resetNoMoreData];
    
    if (labelListModel.labelId != -1) {
        //根据标签查询话题列表
        [self requestLabelTopicList:YES];
    }else{
        //今日优选列表
        [self requestTodayTopicList:YES];
    }
}

- (void)addTodayTopicListArr:(NSArray *)data{
    if (data.count<self.listParam.pagesize) {
         [self.topicView.collectionView.mj_footer endRefreshingWithNoMoreData];
    }

    [self.topicView.todayTopicListArr removeAllObjects];
    [self addHistoryTodayTopicListArr:data];
}

- (void)addHistoryTodayTopicListArr:(NSArray *)data{
    NSMutableArray * resultArray = [NSMutableArray arrayWithCapacity:data.count];
    
    for (NSDictionary * dataDict in data) {
        MyTopicListModel * topicLabelListModel = [MyTopicListModel new];
        [topicLabelListModel setValuesForKeysWithDictionary:dataDict];
        
        [resultArray addObject:topicLabelListModel];
    }
    [self.topicView.todayTopicListArr addObjectsFromArray:resultArray];
    [self.topicView.collectionView reloadData];
}

#pragma mark - ButtonSelectedDelegate

- (void)buttonSelected:(UIButton *)button{
    
    if (button.tag == moreBtnType) {//更多
        TopicRotViewController * topVC = [[TopicRotViewController alloc] init];
        topVC.topicType = TopicRotType;
        [self.navigationController pushViewController:topVC animated:YES];
    }else if (button.tag == playBtnType){//播放
        NSLog(@"播放");
//        [Navigation showAudioPlayerViewController:self radioModel:topicListModel];
    }else if (button.tag == commentBtnType){//评论
        NSLog(@"评论");
//        [Navigation showAudioPlayerViewController:self radioModel:topicListModel];
    }
    
}

#pragma mark - getter

- (HomeBanerListViewModel *)bannerListViewModel{
    if (!_bannerListViewModel) {
        _bannerListViewModel = [[HomeBanerListViewModel alloc] init];
    }
    return _bannerListViewModel;
}

- (LabelTopicListParam *)listParam{
    if (!_listParam) {
        _listParam = [LabelTopicListParam new];
    }
    return _listParam;
}

- (TopicView *)topicView{
    if (!_topicView) {
        _topicView = [[TopicView alloc] init];
        _topicView.btnDelegate = self;
        _topicView.topicViewDelegate = self;
        _topicView.bannerListViewModel = self.bannerListViewModel;
    }
    return _topicView;
}

#pragma mark -

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
