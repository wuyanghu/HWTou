//
//  LuckyMoneyViewController.m
//  HWTou
//
//  Created by 张维扬 on 2017/8/10.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "LuckyMoneyViewController.h"
#import "LuckyMoneyTableViewCell.h"
#import "VersionUpdateTool.h"
#import "ComFloorEvent.h"
#import "PublicHeader.h"
#import "InvestReq.h"

@interface LuckyMoneyViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIButton *useBtn;
@property (nonatomic, copy) NSArray *dataArr;
@property (nonatomic, strong) InvestListResp *resp;
@property (nonatomic, strong) UIView *vFooter;

@end

@implementation LuckyMoneyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setTitle:@"红包"];
    [self loadData];
    [self createUI];
}
- (void)loadData
{
    [HUDProgressTool showIndicatorWithText:nil];
    
    LuckyMoneyParam *param = [[LuckyMoneyParam alloc] init];
    param.status = @"1";
    param.start_page = @0;
    param.pages = @100;
    
    [InvestReq redPackWithParam:param success:^(InvestConfigResponse *result) {
        _dataArr = result.data.list;
        [self.tableView reloadData];
        [HUDProgressTool dismiss];
    } failure:^(NSError *error) {
        [HUDProgressTool showOnlyText:[error urlErrorCodeDescribe]];
    }];

}
- (void)createUI
{
    [self setupFooterView];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = UIColorFromHex(0xf4f4f4);
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tableView registerClass:[LuckyMoneyTableViewCell class] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:_tableView];
    
    if ([VersionUpdateTool shared].isShowInvest) {
        _useBtn = [[UIButton alloc] init];
        [_useBtn addTarget:self action:@selector(useBtnAction) forControlEvents:UIControlEventTouchUpInside];
        _useBtn.backgroundColor = UIColorFromHex(0xa31f24);
        [_useBtn setTitle:@"立即使用" forState:UIControlStateNormal];
        [self.view addSubview:_useBtn];
        [_useBtn makeConstraints:^(MASConstraintMaker *make) {
            make.leading.trailing.bottom.equalTo(self.view);
            make.height.equalTo(CoordYSizeScale(50));
        }];
        
        [_tableView makeConstraints:^(MASConstraintMaker *make) {
            make.top.leading.trailing.equalTo(self.view);
            make.bottom.equalTo(_useBtn.top);
        }];
    } else {
        [_tableView makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 140.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (_dataArr.count > 0) {
        return self.vFooter;
    }
    return nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return CoordXSizeScale(125);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LuckyMoneyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = UIColorFromHex(0xf4f4f4);
    OBJECTOFARRAYATINDEX(_resp, _dataArr, indexPath.row);
    cell.model = _resp;
    return cell;
}

- (void)useBtnAction
{
    FloorItemDM *dmItem = [FloorItemDM new];
    dmItem.type = FloorEventInvest;
    [ComFloorEvent handleEventWithFloor:dmItem];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIF_SkipInvestProduct object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupFooterView
{
    self.vFooter = [UIView new];
    
    UILabel *labTitle = [[UILabel alloc] init];
    labTitle.font = FontPFMedium(12.0f);
    labTitle.textColor = UIColorFromHex(0x6b6b6b);
    labTitle.text = @"温馨提示";
    
    UILabel *labContent = [[UILabel alloc] init];
    labContent.font = FontPFRegular(10.0f);
    labContent.textColor = UIColorFromHex(0x7f7f7f);
    labContent.text = @"1. 赚铜钱新手及体验金活动面向新用户（原杭文投用户不可参与哦）\n2. 完成赚铜钱账户注册和实名认证后，红包和体验金也可在‘我的-铜钱账户’内查看";
    labContent.numberOfLines = 0;
    
    [self.vFooter addSubview:labTitle];
    [self.vFooter addSubview:labContent];
    
    [labTitle makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.vFooter);
        make.top.equalTo(self.vFooter).offset(20);
    }];
    
    [labContent makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.vFooter).offset(20);
        make.trailing.equalTo(self.vFooter).offset(-20);
        make.top.equalTo(labTitle.bottom).offset(6);
    }];
}

@end
