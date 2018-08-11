//
//  ActivityContentController.m
//  HWTou
//
//  Created by mac on 2017/3/15.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "ActivityContentCategoryVC.h"
#import "ActivityContentController.h"
#import "ActivityContentView.h"
#import "ActivityNewsReq.h"
#import "PublicHeader.h"
#import "BannerAdReq.h"

@interface ActivityContentController () <ActivityContentViewDelegate>


@property (nonatomic, copy) NSArray *categorys;
@property (nonatomic, strong) ActivityContentView   *vContent;

@end

@implementation ActivityContentController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self creatUI];
}

#pragma mark - 页面初始化
- (void)creatUI
{
    self.vContent = [[ActivityContentView alloc] init];
    self.vContent.delegate = self;
    [self.view addSubview:self.vContent];
    
    [self.vContent makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    WeakObj(self);
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [selfWeak loadNewData];
    }];
    
    header.lastUpdatedTimeLabel.hidden = YES;
    self.vContent.tableView.mj_header = header;
    [self.vContent.tableView.mj_header beginRefreshing];
}

- (void)onSelectCategoryAtIndex:(NSInteger)index
{
    ActivityContentCategoryVC *listVC = [[ActivityContentCategoryVC alloc] init];
    listVC.category = self.categorys;
    listVC.currentPage = index;
    [[UIApplication topViewController].navigationController pushViewController:listVC animated:YES];
}

- (void)loadNewData
{
    dispatch_group_t dispatchGroup = dispatch_group_create();
    dispatch_group_enter(dispatchGroup);
    
    BannerAdParam *bParam = [[BannerAdParam alloc] init];
    bParam.type = BannerAdActivity;
    [BannerAdReq bannerWithParam:bParam success:^(BannerAdResp *response) {
        self.vContent.banners = response.data.list;
        dispatch_group_leave(dispatchGroup);
    } failure:^(NSError *error) {
        dispatch_group_leave(dispatchGroup);
    }];
    
    dispatch_group_enter(dispatchGroup);
    
    [ActivityNewsReq categorySuccess:^(NewsCategoryResp *response) {
        self.vContent.categorys = self.categorys = response.data;
        dispatch_group_leave(dispatchGroup);
    } failure:^(NSError *error) {
        dispatch_group_leave(dispatchGroup);
    }];
    
    dispatch_group_enter(dispatchGroup);
    [self loadListData:YES completed:^{
        dispatch_group_leave(dispatchGroup);
    }];
    
    dispatch_group_notify(dispatchGroup, dispatch_get_main_queue(), ^(){
        [HUDProgressTool dismiss];
        [self.vContent.tableView reloadData];
        [self.vContent.tableView.mj_header endRefreshing];
    });
}

- (void)loadListData:(BOOL)refresh completed:(void(^)(void))completed
{
    NewsListParam *param = [NewsListParam new];
    param.start_page = refresh ? 0 : self.vContent.listData.count;
    param.pages = 20;
    [ActivityNewsReq listWithParam:param success:^(ActivityNewsResp *response) {
        
        if (refresh) {
            self.vContent.listData = response.data.list;
        } else {
            NSMutableArray *tempData = [NSMutableArray arrayWithArray:self.vContent.listData];
            [tempData addObjectsFromArray:response.data.list];
            self.vContent.listData = tempData;
        }
        
        BOOL isMore = self.vContent.listData.count < response.data.total_pages ? YES : NO;
        [self.vContent.tableView.mj_header endRefreshing];
        [self setLoadMore:isMore];
        !completed ?: completed();
        
    } failure:^(NSError *error) {
        !completed ?: completed();
        [self.vContent.tableView.mj_header endRefreshing];
        [HUDProgressTool showOnlyText:[error urlErrorCodeDescribe]];
    }];
}

- (void)setLoadMore:(BOOL)isMore
{
    if (isMore) {
        WeakObj(self);
        self.vContent.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            [selfWeak loadListData:NO completed:nil];
        }];
    } else {
        self.vContent.tableView.mj_footer = nil;
    }
}

// 更新视图状态显示
- (void)handleLoadCompleted
{
    [self.vContent.tableView.mj_footer endRefreshing];
}
@end
