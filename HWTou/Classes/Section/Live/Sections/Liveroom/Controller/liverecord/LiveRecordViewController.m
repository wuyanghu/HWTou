//
//  LiveRecordViewController.m
//  HWTou
//
//  Created by robinson on 2018/3/27.
//  Copyright © 2018年 LieMi. All rights reserved.
//

#import "LiveRecordViewController.h"
#import "LiverecordTableViewCell.h"
#import "RotRequest.h"
#import "HUDProgressTool.h"
#import "PublicHeader.h"
#import "GetChatRecordsModel.h"
#import "LiveRecordDetailViewController.h"
#import "WorkBenchViewController.h"

@interface LiveRecordViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic,strong) NSMutableArray * dataArray;

@end

@implementation LiveRecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:@"直播记录"];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleDone target:self action:@selector(onReturn:)];

    [self.tableView registerNib:[UINib nibWithNibName:@"LiverecordTableViewCell" bundle:nil] forCellReuseIdentifier:[LiverecordTableViewCell cellReuseIdentifierInfo]];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [self request:NO];
    }];
    UIView * footerView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.tableView setTableFooterView:footerView];
    
    [self request:YES];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)onReturn:(UIButton *)button{
    NSArray * viewControllers = self.navigationController.viewControllers;
    UIViewController * viewController = viewControllers[1];
    if ([viewController isKindOfClass:[WorkBenchViewController class]]) {
        [self.navigationController popToViewController:viewController animated:YES];
    }else{
        [self dismissViewControllerAnimated:YES completion:^{
            
        }];
    }
    
}

#pragma mark - 网络请求

- (void)request:(BOOL)isRefresh{
    if (isRefresh) {//下拉刷新
        self.getChatRecordsParam.page = 1;
    }else{
        self.getChatRecordsParam.page+=1;
    }
    [RotRequest getChatRecords:self.getChatRecordsParam Success:^(ArrayResponse *response) {
        if (response.status == 200) {
            if (isRefresh) {
                [self.dataArray removeAllObjects];
            }
            NSMutableArray * array = [NSMutableArray array];
            for (NSDictionary * dict in response.data) {
                GetChatRecordsModel * listModel = [GetChatRecordsModel new];
                [listModel setValuesForKeysWithDictionary:dict];
                [array addObject:listModel];
            }
            [self.dataArray addObjectsFromArray:array];
            [self.tableView reloadData];
            
            if (response.data.count<self.getChatRecordsParam.pagesize) {
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

#pragma mark - tableview

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LiverecordTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:[LiverecordTableViewCell cellReuseIdentifierInfo] forIndexPath:indexPath];
    [cell setRecordsModel:self.dataArray[indexPath.row]];
    return cell;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 110;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    LiveRecordDetailViewController * liveDetailVC = [[LiveRecordDetailViewController alloc] initWithNibName:@"LiveRecordDetailViewController" bundle:nil];
    liveDetailVC.getChatRecordsModel = self.dataArray[indexPath.row];
    [self.navigationController pushViewController:liveDetailVC animated:YES];
}

#pragma mark -  getter

- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
}

- (GetChatRecordsParam *)getChatRecordsParam{
    if (!_getChatRecordsParam) {
        _getChatRecordsParam = [GetChatRecordsParam new];
        _getChatRecordsParam.pagesize = 20;
        _getChatRecordsParam.flag = 1;
        _getChatRecordsParam.anchorId = [[AccountManager shared] account].uid;
    }
    return _getChatRecordsParam;
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
