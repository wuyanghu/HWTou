//
//  ConsumDetailsListViewController.m
//  HWTou
//
//  Created by hc-101 on 2017/8/24.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "ConsumDetailsListViewController.h"
#import "ConsumptionDetailsView.h"
#import "PublicHeader.h"
#import "ConsumptionGoldReq.h"


@interface ConsumDetailsListViewController ()
@property (nonatomic, strong) ConsumptionDetailsView *vDetail;

@end

@implementation ConsumDetailsListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self createUI];
}

- (void)createUI
{
    ConsumptionDetailsView *consumptionDetailsView = [[ConsumptionDetailsView alloc] init];
    
    self.vDetail = consumptionDetailsView;
    [self.view addSubview:consumptionDetailsView];
    
    [consumptionDetailsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    WeakObj(self);
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [selfWeak loadDetailData:YES];
    }];
    
    header.lastUpdatedTimeLabel.hidden = YES;
    self.vDetail.tableView.mj_header = header;
    [self.vDetail.tableView.mj_header beginRefreshing];
}

- (void)loadDetailData:(BOOL)refresh
{
    ConsumpDetailParam *param = [ConsumpDetailParam new];
    param.start_page = refresh ? 0 : self.vDetail.listData.count;
    param.pages = 20;
    
    if (self.type == 1) {
        [ConsumptionGoldReq extracDetailWithParam:param success:^(ConsumpDetailResp *response) {
            [self handleData:refresh response:response];
        } failure:^(NSError *error) {
            [HUDProgressTool showOnlyText:[error urlErrorCodeDescribe]];
        }];
    } else if (self.type == 2) {
        [ConsumptionGoldReq buyDetailWithParam:param success:^(ConsumpDetailResp *response) {
            [self handleData:refresh response:response];
        } failure:^(NSError *error) {
            [HUDProgressTool showOnlyText:[error urlErrorCodeDescribe]];
        }];
    } else {
        [ConsumptionGoldReq detailWithParam:param success:^(ConsumpDetailResp *response) {
            [self handleData:refresh response:response];
        } failure:^(NSError *error) {
            [HUDProgressTool showOnlyText:[error urlErrorCodeDescribe]];
        }];
    }
}

- (void)handleData:(BOOL)refresh response:(ConsumpDetailResp *)response
{
    if (response.success) {
        if (refresh) {
            self.vDetail.listData = response.data.list;
        } else {
            NSMutableArray *tempData = [NSMutableArray arrayWithArray:self.vDetail.listData];
            [tempData addObjectsFromArray:response.data.list];
            self.vDetail.listData = tempData;
        }
        
        BOOL isMore = self.vDetail.listData.count < response.data.total_pages ? YES : NO;
        [self setLoadMore:isMore];
        [self handleLoadCompleted];
    } else {
        [HUDProgressTool showOnlyText:response.msg];
    }
}

- (void)setLoadMore:(BOOL)isMore
{
    if (isMore) {
        WeakObj(self);
        self.vDetail.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            [selfWeak loadDetailData:NO];
        }];
    } else {
        self.vDetail.tableView.mj_footer = nil;
    }
}

// 更新视图状态显示
- (void)handleLoadCompleted
{
    [self.vDetail.tableView.mj_header endRefreshing];
    [self.vDetail.tableView.mj_footer endRefreshing];
}

@end
