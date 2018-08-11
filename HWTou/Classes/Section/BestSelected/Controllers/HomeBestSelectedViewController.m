//
//  HomeBestSelectedViewController.m
//  HWTou
//
//  Created by robinson on 2018/1/17.
//  Copyright © 2018年 LieMi. All rights reserved.
//

#import "HomeBestSelectedViewController.h"
#import "PublicHeader.h"
#import "HomeBanerListViewModel.h"
#import "HomeBestSelectedTableViewCell.h"
#import "HomeBannerListModel.h"

@interface HomeBestSelectedViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) HomeBanerListViewModel * bannerListViewModel;
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation HomeBestSelectedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setTitle:@"好选"];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [self requestGetBannerList];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 网络请求
//banner列表
- (void)requestGetBannerList{
    BannerListParam * bannerListParam = self.bannerListViewModel.bannerListParam;
    bannerListParam.flag = 4;
    [RotRequest getBannerList:bannerListParam Success:^(ArrayResponse *response) {
        if (response.status == 200) {
            [self.bannerListViewModel bindWithDic:response.data];
            [self.tableView reloadData];
        }
        [self.tableView.mj_header endRefreshing];
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark - uitableview

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.bannerListViewModel.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HomeBestSelectedTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[HomeBestSelectedTableViewCell cellReuseIdentifierInfo] forIndexPath:indexPath];
    HomeBannerListModel * bannerModel = self.bannerListViewModel.dataArray[indexPath.section];
    [cell.bannerImageView sd_setImageWithURL:[NSURL URLWithString:bannerModel.bannerImg]];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 200;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;{
    HomeBannerListModel * bannerModel = self.bannerListViewModel.dataArray[indexPath.section];
    [Navigation showBanner:self bannerModel:bannerModel];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView * bgVview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 10)];
    bgVview.backgroundColor = UIColorFromHex(0xF3F4F6);
    return bgVview;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}

#pragma mark - getter

- (HomeBanerListViewModel *)bannerListViewModel{
    if (!_bannerListViewModel) {
        _bannerListViewModel = [[HomeBanerListViewModel alloc] init];
    }
    return _bannerListViewModel;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        [_tableView registerNib:[UINib nibWithNibName:@"HomeBestSelectedTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:[HomeBestSelectedTableViewCell cellReuseIdentifierInfo]];
        WeakObj(self);
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [selfWeak requestGetBannerList];
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
