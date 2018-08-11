//
//  PersonalAttendViewController.m
//  HWTou
//
//  Created by robinson on 2017/11/16.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "PersonalAttendViewController.h"
#import "PublicHeader.h"
#import "PersonInfoViewTableViewCell.h"
#import "PersonHomeReq.h"
#import "PersonalHomePageViewController.h"

@interface PersonalAttendViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) PersonHomeParam * param;
@property (nonatomic,strong) UITableView * tableView;
@property (nonatomic,strong) NSMutableArray * dataArray;
@end

@implementation PersonalAttendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    if (_personalAttendType == personalAttendType) {
        if (self.param.uid == 0) {
            [self setTitle:@"我的关注"];
        }else{
            [self setTitle:@"TA的关注"];
        }
        
    }else if (_personalAttendType == personalFansType){
        if (self.param.uid == 0) {
            [self setTitle:@"我的粉丝"];
        }else{
            [self setTitle:@"TA的粉丝"];
        }
        
    }
    // Do any additional setup after loading the view.
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];

}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self requestFocus:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)requestFocus:(BOOL)isrefresh{
    if (isrefresh) {
        self.param.page = 1;
    }else{
        self.param.page++;
    }
    //粉丝列表
    [PersonHomeRequest focusAndFansAndShiledList:self.param Success:^(CityInfoResponse *response) {
        if (response.status == 200) {
            if (isrefresh) {
                [self.dataArray removeAllObjects];
            }
            
            NSMutableArray * resultArray = [NSMutableArray arrayWithCapacity:response.data.count];
            for (NSDictionary * dataDict in response.data) {
                FocusUserListDM * listDM = [FocusUserListDM new];
                [listDM setValuesForKeysWithDictionary:dataDict];
                
                [resultArray addObject:listDM];
            }
            [self.dataArray addObjectsFromArray:resultArray];
            [self.tableView reloadData];
            if (resultArray.count<self.param.pagesize) {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }else{
                [self.tableView.mj_footer endRefreshing];
            }
        }else{
            [HUDProgressTool showErrorWithText:response.msg];
        }
    } failure:^(NSError *error) {
        [self.tableView.mj_footer endRefreshing];
        [HUDProgressTool showIndicatorWithText:ReqErrCode_Custom_ErrorInfo];
    }];
}

- (void)loadDataFooter{
    [self.tableView.mj_footer beginRefreshing];
    [self requestFocus:NO];
}

#pragma mark - uitableview

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
    PersonInfoViewTableViewCell * cell = [self.tableView dequeueReusableCellWithIdentifier:[PersonInfoViewTableViewCell cellReuseIdentifierInfo] forIndexPath:indexPath];
    [cell setUersListDM:self.dataArray[indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    FocusUserListDM * uersListDM = self.dataArray[indexPath.row];
    [Navigation showPersonalHomePageViewController:self attendType:dynamicButtonType uid:uersListDM.uid];
}

#pragma mark - getter

- (PersonHomeParam *)param{
    if (!_param) {
        _param = [PersonHomeParam new];
        if (_personalAttendType == personalAttendType) {
            _param.flag = 1;
        }else if (_personalAttendType == personalFansType){
            _param.flag = 2;
        }
        _param.uid = _uid;
    }
    return _param;
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
        [_tableView registerClass:[PersonInfoViewTableViewCell class] forCellReuseIdentifier:[PersonInfoViewTableViewCell cellReuseIdentifierInfo]];
        _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            [self loadDataFooter];
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
