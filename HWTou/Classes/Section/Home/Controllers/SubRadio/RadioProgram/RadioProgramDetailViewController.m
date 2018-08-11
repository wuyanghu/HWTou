//
//  RadioProgramDetailViewController.m
//  HWTou
//
//  Created by robinson on 2017/11/27.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "RadioProgramDetailViewController.h"
#import "PublicHeader.h"
#import "RadioProgramDetailCell.h"
#import "RadioRequest.h"

#define identifity @"identifity"

@interface RadioProgramDetailViewController ()
{
    TIMETYPE _timetype;
    RadioDetailListParam * param;
}
@property (nonatomic,strong) UITableView * tableView;
@property (nonatomic,strong) NSMutableArray * dataArray;
@end

@implementation RadioProgramDetailViewController

- (instancetype)initWithTimeType:(TIMETYPE)timetype{
    self = [super init];
    if (self) {
        _timetype = timetype;
        param = [RadioDetailListParam new];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [self requestRadioDetailList:YES];
}

#pragma mark - loadDataFooter
- (void)loadDataFooter{
    [self.tableView.mj_footer beginRefreshing];
    [self requestRadioDetailList:NO];
}

- (void)requestRadioDetailList:(BOOL)isRefresh{
    if (isRefresh) {
        param.page = 1;
    }else{
        param.page ++;
    }
    
    param.channelId = _channelId;
    if (_timetype == yesterdayType) {
        param.flag = 2;
    }else if (_timetype == todayType){
        param.flag = 0;
    }else{
        param.flag = 1;
    }
    
    [RadioRequest getRadioDetailListWithParam:param success:^(RadioDetailListResponse *response) {
        if (response.status == 200) {
            if (isRefresh) {
                [self.dataArray removeAllObjects];
            }
            [self.dataArray addObjectsFromArray:response.data];
            [self.tableView reloadData];
            if (response.data.count<param.pagesize) {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }else{
                [self.tableView.mj_footer endRefreshing];
            }
        }else{
            [HUDProgressTool showErrorWithText:response.msg];
            [self.tableView.mj_footer endRefreshing];
        }
    } failure:^(NSError *error) {
        [HUDProgressTool showErrorWithText:ReqErrCode_Custom_ErrorInfo];
        [self.tableView.mj_footer endRefreshing];
    }];
}

#pragma mark - uitableivew

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 68;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RadioProgramDetailCell * cell = [self.tableView dequeueReusableCellWithIdentifier:identifity forIndexPath:indexPath];
    NSDictionary * dataDict = self.dataArray[indexPath.row];
    [cell setDataDict:dataDict];
    
    return cell;
}

#pragma mark - getter

- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [BasisUITool getTableViewWithFrame:CGRectZero style:UITableViewStylePlain delegate:self dataSource:self scrollEnabled:YES separatorStyle:UITableViewCellSeparatorStyleSingleLine];
        [_tableView registerClass:[RadioProgramDetailCell class] forCellReuseIdentifier:identifity];
        _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            [self loadDataFooter];
        }];
    }
    return _tableView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
