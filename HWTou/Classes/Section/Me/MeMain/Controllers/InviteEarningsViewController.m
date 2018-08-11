//
//  InviteEarningsViewController.m
//  HWTou
//
//  Created by Reyna on 2018/2/7.
//  Copyright © 2018年 LieMi. All rights reserved.
//

#import "InviteEarningsViewController.h"
#import "AccountManager.h"
#import "MoneyInfoRequest.h"
#import "MoneyListViewModel.h"
#import "MoneyListCell.h"
#import "PublicHeader.h"

@interface InviteEarningsViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) MoneyListViewModel *viewModel;
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation InviteEarningsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setTitle:@"收益记录"];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self moneyListRequest:YES];
}

- (void)moneyListRequest:(BOOL)isRefresh {
    
    if (isRefresh) {
        self.viewModel.page = 1;
        [self.tableView.mj_footer resetNoMoreData];
    }
    else {
        self.viewModel.page = self.viewModel.page + 1;
    }
    
    [MoneyInfoRequest getFinancialRecordsWithPage:self.viewModel.page pageSize:self.viewModel.pagesize flag:2 success:^(NSDictionary *response) {
        
        if ([[response objectForKey:@"status"] intValue] == 200) {
            [self.viewModel bindWithDic:response];
            [self.tableView reloadData];
        }else {
            [HUDProgressTool showErrorWithText:[response objectForKey:@"msg"]];
        }
        
        if (isRefresh) {
            [self.tableView.mj_header endRefreshing];
        }else {
            if (!self.viewModel.isMoreData) {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }
            else {
                [self.tableView.mj_footer resetNoMoreData];
            }
        }
    } failure:^(NSError *error) {
        [HUDProgressTool showErrorWithText:ReqErrCode_Custom_ErrorInfo];
        if (isRefresh) {
            [self.tableView.mj_header endRefreshing];
        }
        else {
            if (!self.viewModel.isMoreData) {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }
            else {
                [self.tableView.mj_footer resetNoMoreData];
            }
        }
    }];
}

#pragma mark - TableViewDataSource & Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.viewModel.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MoneyListCell *cell = [tableView dequeueReusableCellWithIdentifier:[MoneyListCell cellReuseIdentifierInfo] forIndexPath:indexPath];
    
    MoneyListModel *m = [self.viewModel.dataArr objectAtIndex:indexPath.row];
    [cell bind:m];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [MoneyListCell singleCellHeight];
}

#pragma mark - Getter

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight) style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
#ifdef __IPHONE_11_0
        if ([_tableView respondsToSelector:@selector(setContentInsetAdjustmentBehavior:)]) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
#endif
        [self.view addSubview:_tableView];
        [_tableView registerNib:[UINib nibWithNibName:@"MoneyListCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:[MoneyListCell cellReuseIdentifierInfo]];
        
        __weak typeof(self) weakSelf = self;
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [weakSelf moneyListRequest:YES];
        }];
        _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            [weakSelf moneyListRequest:NO];
        }];
    }
    return _tableView;
}

- (MoneyListViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[MoneyListViewModel alloc] init];
        _viewModel.page = 1;
        _viewModel.pagesize = 10;
    }
    return _viewModel;
}

#pragma mark -

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
