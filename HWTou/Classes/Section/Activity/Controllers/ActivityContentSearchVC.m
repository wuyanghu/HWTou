//
//  ActivityContentSearchVC.m
//  HWTou
//
//  Created by 彭鹏 on 2017/6/6.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "ActivityDetailViewController.h"
#import "ActivityContentSearchVC.h"
#import "ActivityContentCell.h"
#import "ActivityNewsReq.h"
#import "PublicHeader.h"

@interface ActivityContentSearchVC () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, copy) NSArray *listData;

@end

@implementation ActivityContentSearchVC

static  NSString * const kCellIdentifier = @"CellIdentifier";

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self creatUI];
}

#pragma mark - 页面初始化
- (void)creatUI
{
    self.title = @"内容";
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = UIColorFromHex(0xf4f4f4);
    self.tableView.rowHeight = 0.4 * kMainScreenWidth;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[ActivityContentCell class] forCellReuseIdentifier:kCellIdentifier];
    
    [self.view addSubview:self.tableView];
    [self.tableView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    WeakObj(self);
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [selfWeak loadListData:YES];
    }];
    
    header.lastUpdatedTimeLabel.hidden = YES;
    self.tableView.mj_header = header;
    [self.tableView.mj_header beginRefreshing];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.listData.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView*)tableView heightForFooterInSection:(NSInteger)section
{
    return 10.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ActivityContentCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
    [cell setDmNews:self.listData[indexPath.section]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ActivityDetailViewController *detailVC = [[ActivityDetailViewController alloc] init];
    detailVC.dmNews = self.listData[indexPath.section];
    detailVC.type = ActivityDetailNews;
    [[UIApplication topViewController].navigationController pushViewController:detailVC animated:YES];
}

- (void)loadListData:(BOOL)refresh
{
    NewsListParam *param = [NewsListParam new];
    param.start_page = refresh ? 0 : self.listData.count;
    param.keywords = self.keywords;
    param.pages = 20;
    
    [ActivityNewsReq listWithParam:param success:^(ActivityNewsResp *response) {
        
        if (refresh) {
            self.listData = response.data.list;
        } else {
            NSMutableArray *tempData = [NSMutableArray arrayWithArray:self.listData];
            [tempData addObjectsFromArray:response.data.list];
            self.listData = tempData;
        }
        
        BOOL isMore = self.listData.count < response.data.total_pages ? YES : NO;
        [self setLoadMore:isMore];
        [self handleLoadCompleted];
        
        if (self.listData.count == 0) {
            [HUDProgressTool showOnlyText:@"未搜索到内容，换个关键词试试"];
        }
        
    } failure:^(NSError *error) {
        [self handleLoadCompleted];
        [HUDProgressTool showOnlyText:[error urlErrorCodeDescribe]];
    }];
}

- (void)setLoadMore:(BOOL)isMore
{
    if (isMore) {
        WeakObj(self);
        self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            [selfWeak loadListData:NO];
        }];
    } else {
        self.tableView.mj_footer = nil;
    }
}

// 更新视图状态显示
- (void)handleLoadCompleted
{
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
    [self.tableView reloadData];
}

@end