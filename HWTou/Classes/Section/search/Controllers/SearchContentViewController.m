//
//  SearchContentViewController.m
//  HWTou
//
//  Created by robinson on 2017/12/21.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "SearchContentViewController.h"
#import "SearchTableViewCell.h"
#import "PublicHeader.h"
#import "RotRequest.h"
#import "SearchViewModel.h"
#import "AudioPlayerViewController.h"
#import "PlayerHistoryModel.h"
#import "SearchUserTableViewCell.h"
#import "SearchNoResultView.h"

@interface SearchContentViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong) UITableView * tableView;
@property (nonatomic,strong) SearchViewModel * viewModel;
@end

@implementation SearchContentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [self requestSearch:YES];
    [self requestSearchUser:YES];
}

- (void)addNOResultView{
    SearchNoResultView * resultView = [[SearchNoResultView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:resultView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadFooter:(BOOL)isRefresh{
    [self.tableView.mj_footer beginRefreshing];
    [self requestSearch:isRefresh];
    [self requestSearchUser:isRefresh];
}

//搜索用户
- (void)requestSearchUser:(BOOL)isRefresh{
    if (_type == searchUserType) {
        SearchUserParam * userParam = self.viewModel.userParam;
        userParam.searchText = _keywords;
        if (isRefresh) {
            userParam.page = 1;
        }else{
            userParam.page ++;
        }
        [RotRequest searchUser:userParam Success:^(ArrayResponse *response) {
            if (response.status == 200) {
                [self.viewModel bindWithUserDic:response.data isRefresh:isRefresh];
                [self.tableView reloadData];
                if (response.data.count<userParam.pagesize) {
                    [self.tableView.mj_footer endRefreshingWithNoMoreData];
                }else{
                    [self.tableView.mj_footer endRefreshing];
                }
                
                if (self.viewModel.userDataArray.count == 0) {
                    [self addNOResultView];
                }
            }else{
                [self.tableView.mj_footer endRefreshing];
            }
        } failure:^(NSError *error) {
            [self.tableView.mj_footer endRefreshing];
        }];
    }
}

//搜索 广播，话题
- (void)requestSearch:(BOOL)isRefresh{
    if (_type == searchTopicType || _type == searchRadioType || _type == searchChatType) {
        SearchRtcDetailParam * detailParam = self.viewModel.detailParam;
        detailParam.searchText = _keywords;
        if(_type == searchTopicType){
            detailParam.flag = 2;
        }else if (_type == searchRadioType){
            detailParam.flag = 1;
        }else if (_type == searchChatType){
            detailParam.flag = 3;
        }
        if (isRefresh) {
            detailParam.page = 1;
        }else{
            detailParam.page ++;
        }
        [RotRequest searchRtcDetail:detailParam Success:^(ArrayResponse *response) {
            if (response.status == 200) {
                [self.viewModel bindWithDic:response.data isRefresh:isRefresh];
                [self.tableView reloadData];
                if (self.viewModel.dataArray.count == 0) {
                    [self addNOResultView];
                }
                if (response.data.count<detailParam.pagesize) {
                    [self.tableView.mj_footer endRefreshingWithNoMoreData];
                }else{
                    [self.tableView.mj_footer endRefreshing];
                }
            }else{
                [self.tableView.mj_footer endRefreshing];
            }
        } failure:^(NSError *error) {
            [self.tableView.mj_footer endRefreshing];
        }];
    }
}

#pragma mark - reload
- (void)reloadView{
    [self.tableView reloadData];
}

#pragma mark - uitableview

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_type == searchTopicType || _type == searchRadioType || _type == searchChatType) {
        return self.viewModel.dataArray.count;
    }else if (_type == searchUserType){
        return self.viewModel.userDataArray.count;
    }else{
        return 0;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_type == searchTopicType || _type == searchRadioType || _type == searchChatType) {
        SearchTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:[SearchTableViewCell cellReuseIdentifierInfo] forIndexPath:indexPath];
        [cell.listView setLikeModel:self.viewModel.dataArray[indexPath.row] isShowLine:self.viewModel.dataArray.count == indexPath.row+1];
        
        return cell;
    }else if (_type == searchUserType){
        SearchUserTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:[SearchUserTableViewCell cellReuseIdentifierInfo] forIndexPath:indexPath];
        [cell setModel:self.viewModel.userDataArray[indexPath.row]];
        return cell;
    }
    
    return nil;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (_type == searchTopicType || _type == searchRadioType || _type == searchChatType){
        GuessULikeModel * likeModel = self.viewModel.dataArray[indexPath.row];
        _searchVCBlock(likeModel);
    }else if (_type == searchUserType){
        PersonHomeDM * model = self.viewModel.userDataArray[indexPath.row];
        _searchUserVCBlock(model);
    }
    
}

#pragma mark - getter

- (SearchViewModel *)viewModel{
    if (!_viewModel) {
        _viewModel = [[SearchViewModel alloc] init];
    }
    return _viewModel;
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [BasisUITool getTableViewWithFrame:CGRectZero style:UITableViewStylePlain delegate:self dataSource:self scrollEnabled:YES separatorStyle:UITableViewCellSeparatorStyleNone];
        [_tableView registerClass:[SearchTableViewCell class] forCellReuseIdentifier:[SearchTableViewCell cellReuseIdentifierInfo]];
        [_tableView registerNib:[UINib nibWithNibName:@"SearchUserTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:[SearchUserTableViewCell cellReuseIdentifierInfo]];
        _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            [self loadFooter:NO];
        }];
        //高度自适应
        _tableView.estimatedRowHeight = 90;
        _tableView.rowHeight = UITableViewAutomaticDimension;
    }
    return _tableView;
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
