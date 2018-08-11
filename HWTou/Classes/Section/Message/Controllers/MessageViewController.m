//
//  MessageViewController.m
//  HWTou
//
//  Created by 彭鹏 on 2017/4/10.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "MessageViewController.h"
#import "PublicHeader.h"
#import "MessageView.h"
#import "MessageReq.h"

@interface MessageViewController ()

@property (nonatomic, strong) MessageView *vMessage;

@end

@implementation MessageViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self createUI];
}

- (void)createUI
{
    self.title = @"站内信";
    self.vMessage = [[MessageView alloc] init];
    [self.view addSubview:self.vMessage];
    [self.vMessage makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    WeakObj(self);
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [selfWeak loadListData:YES];
    }];
    
    header.lastUpdatedTimeLabel.hidden = YES;
    self.vMessage.tableView.mj_header = header;
    [self.vMessage.tableView.mj_header beginRefreshing];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.vMessage.tableView reloadData];
}

- (void)refreshListData
{
    if (self.vMessage.tableView.mj_header.state == MJRefreshStateIdle) {
        [self.vMessage.tableView.mj_header beginRefreshing];
    }
}

- (void)loadListData:(BOOL)refresh
{
    MessageListParam *param = [[MessageListParam alloc] init];
    param.start_page = refresh ? 0 : self.vMessage.listData.count;
    param.pages = 20;
    
    [MessageReq listWithParam:param success:^(MessageResp *response) {
        
        if (refresh) {
            self.vMessage.listData = response.data.list;
        } else {
            NSMutableArray *tempData = [NSMutableArray arrayWithArray:self.vMessage.listData];
            [tempData addObjectsFromArray:response.data.list];
            self.vMessage.listData = tempData;
        }
        
        BOOL isMore = self.vMessage.listData.count < response.data.total_pages ? YES : NO;
        [self setLoadMore:isMore];
        [self handleLoadCompleted];
        
    } failure:^(NSError *error) {
        [self handleLoadCompleted];
        [HUDProgressTool showOnlyText:[error urlErrorCodeDescribe]];
    }];
}

- (void)setLoadMore:(BOOL)isMore
{
    if (isMore) {
        WeakObj(self);
        self.vMessage.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            [selfWeak loadListData:NO];
        }];
    } else {
        self.vMessage.tableView.mj_footer = nil;
    }
}

// 更新视图状态显示
- (void)handleLoadCompleted
{
    [self.vMessage.tableView.mj_header endRefreshing];
    [self.vMessage.tableView.mj_footer endRefreshing];
}

@end
