//
//  ActivityListViewController.m
//  HWTou
//
//  Created by 彭鹏 on 2017/4/6.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "ActivityListViewController.h"
#import "ActivityListView.h"
#import "ActivityListDM.h"
#import "PublicHeader.h"
#import "ActivityReq.h"

@interface ActivityListViewController ()

@property (nonatomic, strong) ActivityListView *vList;

@property (nonatomic, strong) NSMutableArray *listCurrent;
@property (nonatomic, strong) NSMutableArray *listHistory;
@property (nonatomic, strong) NSMutableArray *listPrepare;

@property (nonatomic, assign) BOOL isLoading;

@end

@implementation ActivityListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self creatUI];
}

#pragma mark - 页面初始化
- (void)creatUI
{
    self.vList = [[ActivityListView alloc] init];
    [self.view addSubview:self.vList];
    
    [self.vList makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    WeakObj(self);
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [selfWeak loadListData:YES];
    }];
    
    header.lastUpdatedTimeLabel.hidden = YES;
    self.vList.tableView.mj_header = header;
    [self.vList.tableView.mj_header beginRefreshing];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self loadListData:YES];
}

- (void)loadListData:(BOOL)refresh
{
    if (self.isLoading) {
        return;
    }
    self.isLoading = YES;
    
    if (self.onlyApplied) {
        ActAppliedParam *param = [ActAppliedParam new];
        param.start_page = refresh ? 0 : (self.listCurrent.count + self.listHistory.count);
        param.pages = 20;
        
        [ActivityReq listAppliedWithParam:param success:^(ActivityResp *response) {
            [self handleRequestData:response refresh:refresh];
        } failure:^(NSError *error) {
            [self handleLoadCompleted];
            [HUDProgressTool showOnlyText:[error urlErrorCodeDescribe]];
        }];
    } else {
        ActivityParam *param = [ActivityParam new];
        param.start_page = refresh ? 0 : (self.listCurrent.count + self.listHistory.count);
        param.keywords = self.keywords;
        param.type = 0;
        param.pages = 20;
        
        [ActivityReq listWithParam:param success:^(ActivityResp *response) {
            
            [self handleRequestData:response refresh:refresh];
        } failure:^(NSError *error) {
            [self handleLoadCompleted];
            [HUDProgressTool showOnlyText:[error urlErrorCodeDescribe]];
        }];
    }
    
}

- (void)handleRequestData:(ActivityResp *)response refresh:(BOOL)refresh
{
    if (refresh) {
        [self.listCurrent removeAllObjects];
        [self.listHistory removeAllObjects];
        [self.listPrepare removeAllObjects];
        
        if (self.keywords.length > 0 && response.data.list.count == 0) {
            [HUDProgressTool showOnlyText:@"未搜索到内容，换个关键词试试"];
        }
    }
    [response.data.list enumerateObjectsUsingBlock:^(ActivityListDM *dmList, NSUInteger idx, BOOL * _Nonnull stop) {
        if (dmList.type == 2) { // 已结束
            [self.listHistory addObject:dmList];
        } else if (dmList.type == 3) { // 未开始
            [self.listPrepare addObject:dmList];
        } else {
            [self.listCurrent addObject:dmList];
        }
    }];
    
    BOOL isMore = (self.listCurrent.count + self.listHistory.count) < response.data.total_pages ? YES : NO;
    [self setLoadMore:isMore];
    [self handleLoadCompleted];
    
    self.vList.listData = [NSArray arrayWithObjects:self.listPrepare, self.listCurrent, self.listHistory, nil];
    [self.vList reloadTableData];
}

- (void)setLoadMore:(BOOL)isMore
{
    if (isMore) {
        WeakObj(self);
        self.vList.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            [selfWeak loadListData:NO];
        }];
    } else {
        self.vList.tableView.mj_footer = nil;
    }
}

// 更新视图状态显示
- (void)handleLoadCompleted
{
    self.isLoading = NO;
    [self.vList.tableView.mj_header endRefreshing];
    [self.vList.tableView.mj_footer endRefreshing];
}

- (NSMutableArray *)listCurrent
{
    if (!_listCurrent) {
        _listCurrent = [NSMutableArray array];
    }
    return _listCurrent;
}

- (NSMutableArray *)listHistory
{
    if (!_listHistory) {
        _listHistory = [NSMutableArray array];
    }
    return _listHistory;
}

- (NSMutableArray *)listPrepare
{
    if (!_listPrepare) {
        _listPrepare = [NSMutableArray array];
    }
    return _listPrepare;
}
@end
