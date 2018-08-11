//
//  MyWalletViewController.m
//  HWTou
//
//  Created by Reyna on 2018/2/2.
//  Copyright © 2018年 LieMi. All rights reserved.
//

#import "MyWalletViewController.h"
#import "AccountManager.h"
#import "MoneyInfoRequest.h"
#import "MoneyListViewModel.h"
#import "MoneyListCell.h"
#import "PublicHeader.h"
#import "TopNavBarView.h"
#import "MoneyAccountModel.h"
#import "MeViewController.h"

@interface MyWalletViewController ()<UITableViewDelegate, UITableViewDataSource, TopNavBarDelegate>

@property (nonatomic, strong) TopNavBarView *navBar;

@property (nonatomic, strong) MoneyAccountModel *accountModel;
@property (nonatomic, strong) MoneyListViewModel *viewModel;
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UIView *tableHeaderView;
@property (nonatomic, strong) UIImageView *headerBMG;
@property (nonatomic, strong) UILabel *balanceLab;
@property (nonatomic, strong) UIButton *reflectBtn;
@end

@implementation MyWalletViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationController setNavigationBarHidden:YES];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.navBar];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // 界面没有隐藏才调用隐藏，防止隐藏动画过程UI显示问题
    if (!self.navigationController.navigationBarHidden) {
        [self.navigationController setNavigationBarHidden:YES animated:YES];
    }
    
    [self userAccountRequest];
    [self moneyListRequest:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    // 如果当前VC是MeViewController则不需要隐藏
    UIViewController *topVC = self.navigationController.topViewController;
    if (![topVC isKindOfClass:[MeViewController class]]) {
        [self.navigationController setNavigationBarHidden:NO animated:YES];
    }
}

#pragma mark - Request

- (void)userAccountRequest {
    
    NSInteger uid = [AccountManager shared].account.uid;
    [MoneyInfoRequest getUserAccountWithUid:uid success:^(NSDictionary *response) {
        
        if ([[response objectForKey:@"status"] intValue] == 200) {
            
            NSDictionary *dataDic =[response objectForKey:@"data"];
            [self.accountModel bindWithDic:dataDic];
            self.balanceLab.text = [NSString stringWithFormat:@"¥%@",self.accountModel.balance];
        }else {
            [HUDProgressTool showErrorWithText:[response objectForKey:@"msg"]];
        }
    } failure:^(NSError *error) {
        [HUDProgressTool showErrorWithText:ReqErrCode_Custom_ErrorInfo];
    }];
}

- (void)moneyListRequest:(BOOL)isRefresh {
    
    if (isRefresh) {
        self.viewModel.page = 1;
        [self.tableView.mj_footer resetNoMoreData];
    }
    else {
        self.viewModel.page = self.viewModel.page + 1;
    }
    
    [MoneyInfoRequest getFinancialRecordsWithPage:self.viewModel.page pageSize:self.viewModel.pagesize flag:1 success:^(NSDictionary *response) {
        
        if ([[response objectForKey:@"status"] intValue] == 200) {
            [self.viewModel bindWithDic:response isRefresh:isRefresh];
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

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 45)];
    view.backgroundColor = [UIColor whiteColor];
    
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(10 + (kMainScreenWidth - 120)/2.0, 15, 100, 15)];
    lab.font = SYSTEM_FONT(15);
    lab.textColor = UIColorFromHex(0x8e8f91);
    lab.text = @"收益记录";
    lab.textAlignment = NSTextAlignmentCenter;
    [view addSubview:lab];
    
    UIView *rLine = [[UIView alloc] initWithFrame:CGRectMake(0, 44.5, kMainScreenWidth, 0.5)];
    rLine.backgroundColor = UIColorFromHex(0xd6d7dc);
    [view addSubview:rLine];
    
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 45.f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Action

- (void)reflectBtnAction {
    
    [Navigation showWithdrawMoneyViewController:self];
}

#pragma mark - TopNavBarDelegate

- (void)topNavBackBtnAction {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Getter

- (TopNavBarView *)navBar {
    if (!_navBar) {
        _navBar = [[TopNavBarView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 64) type:2];
        self.navBar.delegate = self;
    }
    return _navBar;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight) style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView setTableHeaderView:self.tableHeaderView];
#ifdef __IPHONE_11_0
        if ([_tableView respondsToSelector:@selector(setContentInsetAdjustmentBehavior:)]) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
#endif
        [_tableView registerNib:[UINib nibWithNibName:@"MoneyListCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:[MoneyListCell cellReuseIdentifierInfo]];
        
        __weak typeof(self) weakSelf = self;
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [weakSelf userAccountRequest];
            [weakSelf moneyListRequest:YES];
        }];
        _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            [weakSelf moneyListRequest:NO];
        }];
    }
    return _tableView;
}

- (MoneyAccountModel *)accountModel {
    if (!_accountModel) {
        _accountModel = [[MoneyAccountModel alloc] init];
    }
    return _accountModel;
}

- (MoneyListViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[MoneyListViewModel alloc] init];
        _viewModel.page = 1;
        _viewModel.pagesize = 10;
    }
    return _viewModel;
}

- (UIView *)tableHeaderView {
    if (!_tableHeaderView) {
        _tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenWidth * 213/375.0 + 35 + 44)];
        _tableHeaderView.backgroundColor = [UIColor whiteColor];
        
        UIImageView *bmg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenWidth * 213/375.0)];
        bmg.image = [UIImage imageNamed:@"wdqb_img_bg"];
        [_tableHeaderView addSubview:bmg];
        
        UILabel *bLab = [[UILabel alloc] initWithFrame:CGRectMake(15, 90, kMainScreenWidth - 20, 20)];
        bLab.text = @"我的余额（元）";
        bLab.textColor = UIColorFromHex(0xf3f4f6);
        bLab.font = SYSTEM_FONT(18);
        [bmg addSubview:bLab];
        
        [bmg addSubview:self.balanceLab];
        [_tableHeaderView addSubview:self.reflectBtn];
    }
    return _tableHeaderView;
}

- (UILabel *)balanceLab {
    if (!_balanceLab) {
        _balanceLab = [[UILabel alloc] initWithFrame:CGRectMake(15, 127, kMainScreenWidth - 20, 36)];
        _balanceLab.textColor = [UIColor whiteColor];
        _balanceLab.font = SYSTEM_FONT(36);
    }
    return _balanceLab;
}

- (UIButton *)reflectBtn {
    if (!_reflectBtn) {
        _reflectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _reflectBtn.frame = CGRectMake(15, 15 + kMainScreenWidth * 213/375.0, kMainScreenWidth - 30, 44);
        _reflectBtn.backgroundColor = UIColorFromHex(0xff4d49);
        [_reflectBtn setTitle:@"提现" forState:UIControlStateNormal];
        [_reflectBtn.titleLabel setFont:SYSTEM_FONT(15)];
        _reflectBtn.layer.cornerRadius = 4.f;
        _reflectBtn.layer.masksToBounds = YES;
        [_reflectBtn addTarget:self action:@selector(reflectBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _reflectBtn;
}

#pragma mark -

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
