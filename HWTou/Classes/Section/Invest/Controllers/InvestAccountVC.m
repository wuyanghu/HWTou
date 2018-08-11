//
//  InvestAccountVC.m
//  HWTou
//
//  Created by 彭鹏 on 2017/7/26.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "InvestAccountCell.h"
#import "InvestAccountVC.h"
#import "RongduManager.h"
#import "PublicHeader.h"
#import <HWTSDK/HWTAPI.h>

@interface InvestAccountVC () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, copy) NSArray *listData;

@end

@implementation InvestAccountVC

static  NSString * const kCellIdentifier = @"CellIdentifier";

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self createUI];
}

- (void)createUI
{
    self.navigationItem.title = @"铜钱账户";
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = UIColorFromHex(0xf4f4f4);
    self.tableView.rowHeight = 50;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[InvestAccountCell class] forCellReuseIdentifier:kCellIdentifier];
    
    [self.view addSubview:self.tableView];
    [self.tableView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

- (NSArray *)listData
{
    NSArray *array = @[@"投资管理", @"资产计划", @"回款计划", @"充值", @"提现", @"充值提现记录", @"实名认证", @"忘记密码", @"退出登录"];
    return array;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.listData.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView*)tableView heightForFooterInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 1.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
    NSString *content;
    OBJECTOFARRAYATINDEX(content, self.listData, indexPath.section);
    cell.textLabel.text = content;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.section) {
        case 0: // 投资管理
            [[HWTAPI sharedInstance] jumpToInvestmentManagementSegementVCFromVC:self];
            break;
        case 1: // 资产计划
            [[HWTAPI sharedInstance] jumpToAssetStatisticsFromVC:self];
            break;
        case 2: // 回款计划
            [[HWTAPI sharedInstance] jumpToPaybackSegementFromVC:self];
            break;
        case 3: // 充值
            [[HWTAPI sharedInstance] jumpToRechargeTableViewControllerFromVC:self];
            break;
        case 4: // 提现
            [[HWTAPI sharedInstance] jumpToCashTableViewControllerFromVC:self];
            break;
        case 5: // 充值和投资记录
            [[HWTAPI sharedInstance] jumpToRechargeRecordSegementVCFromVC:self withIndex:recharge];
            break;
        case 6: // 实名认证
            [[HWTAPI sharedInstance] jumpToAccountRealNameTableViewControllerFromVC:self];
            break;
        case 7: // 忘记密码
//            [[HWTAPI sharedInstance] jumpToForgetPassword:self];
            break;
        case 8: // 账号解绑
            [[RongduManager share] unbindAccount];
            break;
        default:
            break;
    }
}


@end
