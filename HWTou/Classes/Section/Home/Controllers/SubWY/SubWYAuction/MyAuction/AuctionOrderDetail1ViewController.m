//
//  AuctionOrderDetail1ViewController.m
//  HWTou
//
//  Created by robinson on 2018/4/24.
//  Copyright © 2018年 LieMi. All rights reserved.
//

#import "AuctionOrderDetail1ViewController.h"
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
#import "SubWYAuctionPayWayViewController.h"

@interface AuctionOrderDetail1ViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UILabel *payPriceLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView * goPayFooterView;

@end

@implementation AuctionOrderDetail1ViewController


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
    UpdateSellerGoodsGoodParam * param = [UpdateSellerGoodsGoodParam new];
    param.addrName = _defaultAddrModel.addrName;
    param.addrPhone = _defaultAddrModel.addrPhone;
    param.address = [NSString stringWithFormat:@"%@ %@",_defaultAddrModel.address,_defaultAddrModel.addressDetail];
    param.oId = _orderListModel.oId;
    if (self.shopCartDataArray.count>0) {
        GetShopCartListModel * listModel = self.shopCartDataArray[0];
        param.sellerWord = listModel.sellerWord;
    }
    
    [ShopMallRequest updateSellerGoodsGood:param Success:^(AnswerLsDict *response) {
        if (response.status == 200) {
            SubWYAuctionPayWayViewController * payWayVC = [[SubWYAuctionPayWayViewController alloc] initWithNibName:nil bundle:nil];
            payWayVC.payPrice = _totalPrice;
            payWayVC.proveOrderId = _orderListModel.orderId;
            payWayVC.isSeller = YES;
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
        [cell setIsAuction:YES];
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

@end
