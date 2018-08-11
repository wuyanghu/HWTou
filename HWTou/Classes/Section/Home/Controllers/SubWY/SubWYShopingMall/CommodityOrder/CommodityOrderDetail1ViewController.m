//
//  CommodityOrderDetail1ViewController.m
//  HWTou
//
//  Created by robinson on 2018/4/18.
//  Copyright © 2018年 LieMi. All rights reserved.
//

#import "CommodityOrderDetail1ViewController.h"
#import "ShopCartSettleAddressTableViewCell.h"
#import "CommodityOrderDetailTableViewCell.h"
#import "UIView+NTES.h"
#import "ShopCartSettleLeaveFooterView.h"
#import "PayWayViewController.h"
#import "AddresseeListViewController.h"
#import "ShopMallRequest.h"
#import "GetGoodsAddrListModel.h"
#import "ShoppingCartHeaderView.h"
#import "ShopCartTableViewCell.h"
#import "IQKeyboardManager.h"
#import "ShopCartSettleUserNoticeTableViewCell.h"
#import "YYModel.h"
#import "AddGoodsOrderModel.h"

@interface CommodityOrderDetail1ViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UILabel *payPriceLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView * goPayFooterView;

@end

@implementation CommodityOrderDetail1ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //0:已取消订单，1:待付款订单，2:待发货订单，3:待收货订单 ,4:已收货订单
    if (_orderListModel.status == 1) {
        [self setTitle:@"待付款订单"];
    }else if (_orderListModel.status == 2){
        [self setTitle:@"待发货订单"];
    }else if (_orderListModel.status == 3){
        [self setTitle:@"待收货订单"];
    }else if (_orderListModel.status == 4){
        [self setTitle:@"已收货"];
    }
    [self dataInit];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)goPayAction:(id)sender {
    AddGoodsOrderParam * param = [AddGoodsOrderParam new];
    param.addrName = _defaultAddrModel.addrName;
    param.addrPhone = _defaultAddrModel.addrPhone;
    param.address = [NSString stringWithFormat:@"%@ %@",_defaultAddrModel.address,_defaultAddrModel.addressDetail];
    param.flag = 1;
    
    NSMutableArray * sellerDetailArr = [[NSMutableArray alloc] init];
    for (GetShopCartListModel * listModel in self.shopCartDataArray) {
        NSMutableArray * goodsDetailsArr = [[NSMutableArray alloc] init];
        for (GetShopCartListResultModel * reusltModel in listModel.cartGoodsListArr) {
            NSDictionary * resultDict = @{
                                          @"goodsId":@(reusltModel.goodsId),
                                          @"price":reusltModel.actualMoney,
                                          @"num":@(1),
                                          @"cartId":@(reusltModel.cartId)
                                          };
            [goodsDetailsArr addObject:resultDict];
        }
        NSDictionary * dict = @{
                                @"sellerId":@(listModel.sellerId),
                                @"sellerWord":listModel.sellerWord,
                                @"goodsDetails":goodsDetailsArr
                                };
        [sellerDetailArr addObject:dict];
    }
    
    param.sellerDetails = [sellerDetailArr yy_modelToJSONString];
    
    [ShopMallRequest addGoodsOrder:param Success:^(AnswerLsDict *response) {
        if (response.status == 200) {
            
            NSDictionary * dict = response.data;
            AddGoodsOrderModel * orderModel = [AddGoodsOrderModel new];
            [orderModel setValuesForKeysWithDictionary:dict];
            
            for (NSDictionary * resultDict in dict[@"sellerIds"]) {
                AddGoodsOrderResultModel * resultModel = [AddGoodsOrderResultModel new];
                [resultModel setValuesForKeysWithDictionary:resultDict];
                
                [orderModel.sellerIdArr addObject:resultModel];
            }
            
            PayWayViewController * payWayVC = [[PayWayViewController alloc] initWithNibName:nil bundle:nil];
            payWayVC.type = PayWayTypeOrder;
            payWayVC.addGoodsOrderModel = orderModel;
            payWayVC.payPrice = _totalPrice;
            [self.navigationController pushViewController:payWayVC animated:YES];
        }else{
            [self.view makeToast:response.msg duration:2.0f position:CSToastPositionCenter];
        }
    } failure:^(NSError *error) {
        [self.view makeToast:@"网络繁忙" duration:2.0f position:CSToastPositionCenter];
    }];
    
}

- (void)dataInit{
    self.view.backgroundColor = UIColorFromRGB(0xF3F4F6);
    
    self.goPayFooterView.hidden = _orderListModel.status != 1;
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"ShopCartSettleAddressTableViewCell" bundle:nil]
         forCellReuseIdentifier:[ShopCartSettleAddressTableViewCell cellReuseIdentifierInfo]];
    [self.tableView registerNib:[UINib nibWithNibName:@"CommodityOrderDetailTableViewCell" bundle:nil]
         forCellReuseIdentifier:[CommodityOrderDetailTableViewCell cellReuseIdentifierInfo]];
    [self.tableView registerNib:[UINib nibWithNibName:@"ShopCartSettleUserNoticeTableViewCell" bundle:nil]
         forCellReuseIdentifier:[ShopCartSettleUserNoticeTableViewCell cellReuseIdentifierInfo]];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"ShoppingCartHeaderView" bundle:nil] forHeaderFooterViewReuseIdentifier:[ShoppingCartHeaderView cellIdentity]];
    [self.tableView registerNib:[UINib nibWithNibName:@"ShopCartSettleLeaveFooterView" bundle:nil] forHeaderFooterViewReuseIdentifier:[ShopCartSettleLeaveFooterView cellIdentity]];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [[IQKeyboardManager sharedManager] setShouldResignOnTouchOutside:YES];
    
    self.payPriceLabel.text = [NSString stringWithFormat:@"应付：¥%@",_totalPrice];
    
    if (!_defaultAddrModel) {
        [self getGoodsAddrListRequest];
    }
}

#pragma mark - ntework

- (void)getGoodsAddrListRequest{
    GetGoodsAddrListParam * param = [GetGoodsAddrListParam new];
    param.isDef = 1;
    [ShopMallRequest getGoodsAddrList:param Success:^(AnswerLsArray *response) {
        if (response.status == 200) {
            
            for (NSDictionary * dict in response.data) {
                GetGoodsAddrListModel * listModel = [GetGoodsAddrListModel new];
                [listModel setValuesForKeysWithDictionary:dict];
                if (listModel.isDef == 1) {
                    _defaultAddrModel = listModel;
                }
            }
            [self.tableView reloadData];
        }else{
            [self.view makeToast:response.msg duration:2.0f position:CSToastPositionCenter];
        }
    } failure:^(NSError *error) {
        [self.view makeToast:@"网络繁忙" duration:2.0f position:CSToastPositionCenter];
    }];
}

#pragma mark - private mothed

- (NSInteger)getShopCartSection{
    return 1+_shopCartDataArray.count;
}

#pragma mark - tableview

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }else if(section<[self getShopCartSection]){
        GetShopCartListModel * listModel = _shopCartDataArray[section-1];
        return listModel.cartGoodsListArr.count;
    }else{
        return 1;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [self getShopCartSection]+1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        ShopCartSettleAddressTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:[ShopCartSettleAddressTableViewCell cellReuseIdentifierInfo] forIndexPath:indexPath];
        [cell setDefaultAddrModel:_defaultAddrModel];
        return cell;
    }else if (indexPath.section < [self getShopCartSection]){
        GetShopCartListModel * model = self.shopCartDataArray[indexPath.section-1];
        GetShopCartListResultModel * resultModel = model.cartGoodsListArr[indexPath.row];
        CommodityOrderDetailTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:[CommodityOrderDetailTableViewCell cellReuseIdentifierInfo] forIndexPath:indexPath];
        [cell setResultModel:resultModel];
        [cell setOrderListModel:_orderListModel];
        return cell;
        
    }else{
        ShopCartSettleUserNoticeTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:[ShopCartSettleUserNoticeTableViewCell cellReuseIdentifierInfo] forIndexPath:indexPath];
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    if ([view isKindOfClass:[UITableViewHeaderFooterView class]]) {
        ((UITableViewHeaderFooterView *)view).backgroundView.backgroundColor = [UIColor whiteColor];
    }
}

- (void)tableView:(UITableView *)tableView willDisplayFooterView:(nonnull UIView *)view forSection:(NSInteger)section{
    if ([view isKindOfClass:[UITableViewHeaderFooterView class]]) {
        ((UITableViewHeaderFooterView *)view).backgroundView.backgroundColor = [UIColor whiteColor];
    }
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return nil;
    }else if (section<[self getShopCartSection]){
        ShoppingCartHeaderView *cartView = (ShoppingCartHeaderView *)[tableView dequeueReusableHeaderFooterViewWithIdentifier:[ShoppingCartHeaderView cellIdentity]];
        GetShopCartListModel * listModel = self.shopCartDataArray[section-1];
        cartView.addressLabel.text = listModel.sellerName;
        return cartView;
    }else{
        return nil;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (section == 0) {
        UIView* footView = [[UIView alloc]initWithFrame:CGRectZero];
        footView.backgroundColor = UIColorFromRGB(0xF3F4F6);
        return footView;
    }else if (section<[self getShopCartSection]){
        ShopCartSettleLeaveFooterView *cartView = (ShopCartSettleLeaveFooterView *)[tableView dequeueReusableHeaderFooterViewWithIdentifier:[ShopCartSettleLeaveFooterView cellIdentity]];
        GetShopCartListModel * listModel = self.shopCartDataArray[section-1];
        [cartView setListModel:listModel];
        [cartView setOrderListModel:_orderListModel];
        return cartView;
    }else{
        UIView* footView = [[UIView alloc]initWithFrame:CGRectZero];
        footView.backgroundColor = UIColorFromRGB(0xF3F4F6);
        return footView;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 0.01f;
    }else if (section<[self getShopCartSection]){
        return 33;
    }else{
        return 0.01f;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 73;
    }else if (indexPath.section < [self getShopCartSection]){
        return 98;
    }else{
        return 104;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 0) {
        return 10;
    }else if (section<[self getShopCartSection]){
        return 250;
    }else{
        return 0.01f;
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0 && _orderListModel.status == 1) {
        AddresseeListViewController * listVC = [[AddresseeListViewController alloc] initWithNibName:nil bundle:nil];
        [self.navigationController pushViewController:listVC animated:YES];
    }
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
