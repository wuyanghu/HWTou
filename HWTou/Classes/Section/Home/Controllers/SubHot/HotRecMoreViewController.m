//
//  HotRecMoreViewController.m
//  HWTou
//
//  Created by robinson on 2017/12/12.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "HotRecMoreViewController.h"
#import "HotMoreTableViewCell.h"
#import "PublicHeader.h"
#import "RotRequest.h"
#import "GuessULikeViewModel.h"

#define identifity @"identifity"

@interface HotRecMoreViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong) UITableView * tableView;
@property (nonatomic,strong) HotRecChangeListParam * changeListParam;
@property (nonatomic,strong) NSMutableArray * dataArray;

@end

@implementation HotRecMoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    [self requestChangeListParam:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - network
- (void)requestChangeListParam:(BOOL)isRefresh{
    
    if (isRefresh) {
        self.changeListParam.page = 1;
    }else{
        self.changeListParam.page ++;
    }
    [RotRequest getHotRecChangeList:self.changeListParam Success:^(DictResponse *response) {
        if (isRefresh) {
            [self.dataArray removeAllObjects];
        }
        NSArray * rtcDetailListArr = response.data[@"RtcDetailList"];
        
        NSMutableArray * resultArr = [NSMutableArray array];
        for (NSDictionary * resultDict in rtcDetailListArr) {
            GuessULikeModel * likeModel = [GuessULikeModel new];
            [likeModel setValuesForKeysWithDictionary:resultDict];
            
            [resultArr addObject:likeModel];
        }
        [self.dataArray addObjectsFromArray:resultArr];
        
        if (rtcDetailListArr.count<self.changeListParam.pagesize) {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }else{
            [self.tableView.mj_footer endRefreshing];
        }
        
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark - UITableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HotMoreTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifity forIndexPath:indexPath];
    [cell setUlistModel:self.dataArray[indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [Navigation showAudioPlayerViewController:self radioModel:self.dataArray[indexPath.row]];
}

#pragma mark - getter

- (void)setRecListModel:(GetHotRecListModel *)recListModel{
    _recListModel = recListModel;
    [self setTitle:recListModel.title];
    self.changeListParam.recId = recListModel.recId;
}

- (HotRecChangeListParam *)changeListParam{
    if (!_changeListParam) {
        _changeListParam = [HotRecChangeListParam new];
        _changeListParam.page = 1;
        _changeListParam.pagesize = 10;
    }
    return _changeListParam;
}

- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [BasisUITool getTableViewWithFrame:CGRectZero style:UITableViewStylePlain delegate:self dataSource:self scrollEnabled:YES separatorStyle:UITableViewCellSeparatorStyleSingleLine];
        [_tableView registerClass:[HotMoreTableViewCell class] forCellReuseIdentifier:identifity];
        _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            [self requestChangeListParam:NO];
        }];
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
