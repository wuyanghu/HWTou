//
//  MeEarningView.m
//  HWTou
//
//  Created by robinson on 2017/12/1.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "MeEarningView.h"
#import "PublicHeader.h"
#import "WorkBenchView.h"
#import "MeEarningHeaderView.h"
#import "MeEarningTableViewCell.h"
#import "MoneyEarningViewModel.h"
#import "MoneyInfoRequest.h"

#define identify @"identify"
#define identify1 @"identify1"
#define headerIdentify @"headerIdentify"
#define headerIdentify1 @"headerIdentify1"

@interface MeEarningView()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) MoneyEarningViewModel *viewModel;
@property (nonatomic,strong) UITableView * tableView;
@property (nonatomic,strong) NSArray * dataArray;
@end

@implementation MeEarningView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.tableView];
        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        [self moneyEarningRequest:YES];
    }
    return self;
}

- (void)moneyEarningRequest:(BOOL)isRefresh {
    
    if (isRefresh) {
        self.viewModel.page = 1;
        [self.tableView.mj_footer resetNoMoreData];
    }
    else {
        self.viewModel.page = self.viewModel.page + 1;
    }
    
    [MoneyInfoRequest getAnchorTipsInfoWithPage:self.viewModel.page pageSize:self.viewModel.pagesize flag:3 success:^(NSDictionary *response) {
        
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }else{
        return self.viewModel.dataArr.count;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 276;
    }
    return 0;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        MeEarningHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:headerIdentify];
        [headerView setViewModel:self.viewModel];
        return headerView;
    }
    MeEarningTitleHeaderView * titleHeaderView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:headerIdentify1];
    return titleHeaderView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 0;
    }
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section != 0) {
        MeEarningTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identify1 forIndexPath:indexPath];
        MoneyEarningModel * model = self.viewModel.dataArr[indexPath.row];
        [cell setModel:model];
        return cell;
    }else{
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identify forIndexPath:indexPath];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        return cell;
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

}

#pragma mark - getter

- (NSArray *)dataArray{
    if (!_dataArray) {
        _dataArray = @[@"我的聊吧",@"资金流水",@"历史置顶"];
    }
    return _dataArray;
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [BasisUITool getTableViewWithFrame:self.frame style:UITableViewStylePlain delegate:self dataSource:self scrollEnabled:YES separatorStyle:UITableViewCellSeparatorStyleSingleLine];
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:identify];
        [_tableView registerClass:[MeEarningTableViewCell class] forCellReuseIdentifier:identify1];
        [_tableView registerClass:[MeEarningHeaderView class] forHeaderFooterViewReuseIdentifier:headerIdentify];
//        [_tableView registerClass:[MeEarningTitleHeaderView class] forHeaderFooterViewReuseIdentifier:headerIdentify1];
        
        __weak typeof(self) weakSelf = self;
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [weakSelf moneyEarningRequest:YES];
        }];
        _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            [weakSelf moneyEarningRequest:NO];
        }];
        
    }
    return _tableView;
}

- (MoneyEarningViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[MoneyEarningViewModel alloc] init];
        _viewModel.page = 1;
        _viewModel.pagesize = 10;
    }
    return _viewModel;
}

@end
