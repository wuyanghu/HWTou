//
//  RewardViewController.m
//  HWTou
//
//  Created by robinson on 2018/3/27.
//  Copyright © 2018年 LieMi. All rights reserved.
//

#import "RewardViewController.h"
#import "GetChatInfoModel.h"
#import "PublicHeader.h"
#import "RewardTableViewCell.h"
#import "RedPacketRequest.h"
#import "SaveRoomInfoModel.h"
#import "HUDProgressTool.h"
#import "RewardModel.h"

typedef enum : NSUInteger{
    RewardBtnTypeNormalColor,
    RewardBtnTypeNormalSelector,
}RewardBtnType;

@interface RewardViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
@property (weak, nonatomic) IBOutlet UILabel *nickNameLabe;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@property (weak, nonatomic) IBOutlet UIButton *homeLiveBtn;
@property (weak, nonatomic) IBOutlet UIButton *weekRankBtn;
@property (weak, nonatomic) IBOutlet UIButton *totalBtn;
@property (weak, nonatomic) IBOutlet UIView *homeLiveLineView;
@property (weak, nonatomic) IBOutlet UIView *weekRankLineView;
@property (weak, nonatomic) IBOutlet UIView *totalLineView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic,strong) NSMutableArray * btnArr;
@property (nonatomic,strong) NSMutableArray * lineViewArr;

@property (nonatomic,assign) NSInteger selectRow;
@property (nonatomic,strong) GetTipsByTopTimeParam * getTipsByTopTimeParam;
@property (nonatomic,strong) NSMutableArray * dataArray;
@end

@implementation RewardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    // Do any additional setup after loading the view from its nib.
    [self setTitle:@"打赏详情"];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"RewardTableViewCell" bundle:nil]
     forCellReuseIdentifier:[RewardTableViewCell cellReuseIdentifierInfo]];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [self request:NO flag:_selectRow+1];
    }];
    UIView * footerView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.tableView setTableFooterView:footerView];
    
    [self request:YES flag:1];
    
    [self.btnArr addObject:self.homeLiveBtn];
    [self.btnArr addObject:self.weekRankBtn];
    [self.btnArr addObject:self.totalBtn];
    
    [self.lineViewArr addObject:self.homeLiveLineView];
    [self.lineViewArr addObject:self.weekRankLineView];
    [self.lineViewArr addObject:self.totalLineView];
    
    [self setSelectBtnColor:0];
    
    [self.headerImageView sd_setImageWithURL:[NSURL URLWithString:_getChatInfoModel.avater]];
    self.nickNameLabe.text = _getChatInfoModel.nickname;
    self.contentLabel.text = _getChatInfoModel.sign;
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

- (void)setSelectBtnColor:(NSInteger)selectRow{
    _selectRow = selectRow;
    for (int i = 0; i<self.btnArr.count; i++) {
        UIButton * btn = self.btnArr[i];
        UIView * lineView = self.lineViewArr[i];
        if (i == selectRow) {
            [btn setTitleColor:UIColorFromHex(0xFF4D49) forState:UIControlStateNormal];
            lineView.backgroundColor = UIColorFromHex(0xFF4D49);
            lineView.hidden = NO;
        }else{
            [btn setTitleColor:UIColorFromHex(0x737373) forState:UIControlStateNormal];
            lineView.backgroundColor = UIColorFromHex(0x737373);
            lineView.hidden = YES;
        }
    }
}

#pragma mark - 网络请求

- (void)request:(BOOL)isRefresh flag:(NSInteger)flag{
    if (isRefresh) {//下拉刷新
        self.getTipsByTopTimeParam.page = 1;
    }else{
        self.getTipsByTopTimeParam.page+=1;
    }
    self.getTipsByTopTimeParam.flag = flag;
    [RedPacketRequest getTipsByTopTime:self.getTipsByTopTimeParam success:^(RedPacketResponseArr * response) {
        if (response.status == 200) {
            if (isRefresh) {
                [self.dataArray removeAllObjects];
            }
            NSMutableArray * array = [NSMutableArray array];
            for (NSDictionary * dict in response.data) {
                RewardModel * listModel = [RewardModel new];
                [listModel setValuesForKeysWithDictionary:dict];
                [array addObject:listModel];
            }
            [self.dataArray addObjectsFromArray:array];
            [self.tableView reloadData];
            
            if (response.data.count<self.getTipsByTopTimeParam.pagesize) {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }else{
                [self.tableView.mj_footer endRefreshing];
            }
            
        }else{
            [HUDProgressTool showErrorWithText:response.msg];
            [self.tableView.mj_footer endRefreshing];
        }
    } failure:^(NSError * error) {
        [HUDProgressTool showErrorWithText:ReqErrCode_Custom_ErrorInfo];
        [self.tableView.mj_footer endRefreshing];
    }];
    
}

#pragma mark - tableview

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    RewardTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:[RewardTableViewCell cellReuseIdentifierInfo] forIndexPath:indexPath];
    [cell refresh:self.dataArray[indexPath.row] selectRow:indexPath.row];
    return cell;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - action

- (IBAction)homeLiveAction:(id)sender {
    [self setSelectBtnColor:0];
    [self request:YES flag:1];
}

- (IBAction)weekRankAction:(id)sender {
    [self setSelectBtnColor:1];
    [self request:YES flag:2];
}

- (IBAction)totalAction:(id)sender {
    [self setSelectBtnColor:2];
    [self request:YES flag:3];
}

#pragma mark - getter

- (GetTipsByTopTimeParam *)getTipsByTopTimeParam{
    if (!_getTipsByTopTimeParam) {
        _getTipsByTopTimeParam = [GetTipsByTopTimeParam new];
        _getTipsByTopTimeParam.pagesize = 20;
        _getTipsByTopTimeParam.rtcId = _saveRoomInfoModel.chatId;
        _getTipsByTopTimeParam.rtcUid = _saveRoomInfoModel.userId;
    }
    return _getTipsByTopTimeParam;
}

- (NSMutableArray *)btnArr{
    if (!_btnArr) {
        _btnArr = [[NSMutableArray alloc] init];
    }
    return _btnArr;
}

- (NSMutableArray *)lineViewArr{
    if (!_lineViewArr) {
        _lineViewArr = [[NSMutableArray alloc] init];
    }
    return _lineViewArr;
}

- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
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
