//
//  AddresseeListViewController.m
//  HWTou
//
//  Created by robinson on 2018/4/12.
//  Copyright © 2018年 LieMi. All rights reserved.
//

#import "AddresseeListViewController.h"
#import "AddresseeListTableViewCell.h"
#import "AddAddressViewController.h"
#import "ShopMallRequest.h"
#import "UIView+Toast.h"
#import "GetGoodsAddrListModel.h"

@interface AddresseeListViewController ()<UITableViewDelegate,UITableViewDataSource,AddAddressViewControllerDelegate,AddresseeListTableViewCellDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong) GetGoodsAddrListParam * getGoodsAddrListParam;
@property (nonatomic,strong) UpdateGoodsAddrParam * updateGoodsAddrParam;
@property (nonatomic,strong) NSMutableArray<GetGoodsAddrListModel *> * dataArray;
@end

@implementation AddresseeListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setTitle:@"收件人列表"];
    
    [self dataInit];
    [self getGoodsAddrListRequest];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)dataInit{
    self.view.backgroundColor = UIColorFromRGB(0xF3F4F6);
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    UIView* footView = [[UIView alloc]initWithFrame:CGRectZero];
    footView.backgroundColor = UIColorFromRGB(0xF3F4F6);
    [self.tableView setTableFooterView:footView];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"AddresseeListTableViewCell" bundle:nil]
         forCellReuseIdentifier:[AddresseeListTableViewCell cellReuseIdentifierInfo]];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

#pragma mark - delegate

//AddAddressViewControllerDelegate
- (void)addAddressVCAction{
    [self getGoodsAddrListRequest];
}

//AddresseeListTableViewCellDelegate
- (void)addresseeListCellAction:(GetGoodsAddrListModel *)addrModel{
    [self updateGoodsAddrRequest:addrModel.addrId];
}

#pragma mark - ntework

- (void)updateGoodsAddrRequest:(NSInteger)addrId{
    self.updateGoodsAddrParam.isDef = 1;
    self.updateGoodsAddrParam.addrId = addrId;
    [ShopMallRequest updateGoodsAddr:self.updateGoodsAddrParam Success:^(AnswerLsDict *response) {
        if (response.status == 200) {
            [self getGoodsAddrListRequest];
        }else{
            [self.view makeToast:response.msg duration:2.0f position:CSToastPositionCenter];
        }
    } failure:^(NSError *error) {
        [self.view makeToast:@"网络繁忙" duration:2.0f position:CSToastPositionCenter];
    }];
}

- (void)getGoodsAddrListRequest{
    [ShopMallRequest getGoodsAddrList:self.getGoodsAddrListParam Success:^(AnswerLsArray *response) {
        if (response.status == 200) {
            [self.dataArray removeAllObjects];
            for (NSDictionary * dict in response.data) {
                GetGoodsAddrListModel * listModel = [GetGoodsAddrListModel new];
                [listModel setValuesForKeysWithDictionary:dict];
                
                [self.dataArray addObject:listModel];
            }
            [self.tableView reloadData];
        }else{
            [self.view makeToast:response.msg duration:2.0f position:CSToastPositionCenter];
        }
    } failure:^(NSError *error) {
        [self.view makeToast:@"网络繁忙" duration:2.0f position:CSToastPositionCenter];
    }];
}

#pragma mark - action

- (IBAction)addAddressAction:(id)sender {
    AddAddressViewController * addVC = [[AddAddressViewController alloc] initWithNibName:nil bundle:nil];
    addVC.delegate = self;
    [self.navigationController pushViewController:addVC animated:YES];
}

#pragma mark - tableview

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    AddresseeListTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:[AddresseeListTableViewCell cellReuseIdentifierInfo] forIndexPath:indexPath];
    cell.delegate = self;
    [cell setGetGoodsAddrListModel:self.dataArray[indexPath.section]];
    return cell;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 73;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == self.dataArray.count-1) {
        return 0;
    }
    return 10;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

#pragma mark - getter

- (UpdateGoodsAddrParam *)updateGoodsAddrParam{
    if (!_updateGoodsAddrParam) {
        _updateGoodsAddrParam = [UpdateGoodsAddrParam new];
    }
    return _updateGoodsAddrParam;
}

- (GetGoodsAddrListParam *)getGoodsAddrListParam{
    if (!_getGoodsAddrListParam) {
        _getGoodsAddrListParam = [GetGoodsAddrListParam new];
    }
    return _getGoodsAddrListParam;
}

- (NSMutableArray<GetGoodsAddrListModel *> *)dataArray{
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
