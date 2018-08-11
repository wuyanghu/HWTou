//
//  CommodityOrderDetailViewController.m
//  HWTou
//
//  Created by robinson on 2018/3/20.
//  Copyright © 2018年 LieMi. All rights reserved.
//

#import "CommodityOrderDetailViewController.h"
#import "PublicHeader.h"
#import "CommodityOrderTableViewCell.h"
#import "ShopMallRequest.h"
#import "GetGoodsOrderListModel.h"
#import "CommodityOrderDetailHeader.h"
#import "PayWayViewController.h"
#import "CommodityOrderDetailFooter.h"
#import "CommodityOrderDetailCancelFooter.h"
#import "CommodityOrderDetailSureFooter.h"
#import "RedPacketRequest.h"

@interface CommodityOrderDetailViewController ()<UITableViewDelegate,UITableViewDataSource,CommodityOrderDetailFooterDelegate,CommodityOrderDetailSureFooterDelegate,CommodityOrderProtocol>
{
    GetGoodsOrderListParam * orderParam;
}
@property (nonatomic,strong) NSMutableArray<GetGoodsOrderListModel *> * dataArray;
@property (nonatomic, strong) UITableView  *tableView;
@end

@implementation CommodityOrderDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(-60);
    }];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self getGoodsListRequest:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - request

- (void)getGoodsListRequest:(BOOL)isRefresh{
    if (!orderParam) {
        orderParam = [GetGoodsOrderListParam new];
        orderParam.pagesize = 20;
        orderParam.flag = 1;
    }
    orderParam.status = _labelId;
    if (isRefresh) {
        orderParam.page = 1;
    }else{
        orderParam.page++;
    }
    
    [ShopMallRequest getGoodsOrderList:orderParam Success:^(AnswerLsArray *response) {
        if (response.status == 200) {
            if (isRefresh) {
                [self.dataArray removeAllObjects];
            }
            for (NSDictionary * dict in response.data) {
                GetGoodsOrderListModel * model = [GetGoodsOrderListModel new];
                [model setValuesForKeysWithDictionary:dict];
                
                for (NSDictionary * detailDict in dict[@"goodsDetail"]) {
                    GoodsDetailModel * detailModel = [GoodsDetailModel new];
                    [detailModel setValuesForKeysWithDictionary:detailDict];
                    
                    [model.goodsDetailArray addObject:detailModel];
                }
                
                [self.dataArray addObject:model];
                
            }
            [self.tableView reloadData];
            if (isRefresh) {
                [self.tableView.mj_header endRefreshing];
                [self.tableView.mj_footer resetNoMoreData];
            }else{
                if (response.data.count<orderParam.pagesize) {
                    [self.tableView.mj_footer endRefreshingWithNoMoreData];
                }else{
                    [self.tableView.mj_footer endRefreshing];
                }
            }
        }else{
            [self.view makeToast:response.msg duration:2.0f position:CSToastPositionCenter];
        }
    } failure:^(NSError *error) {
        [self.view makeToast:@"网络繁忙" duration:2.0f position:CSToastPositionCenter];
    }];
    
}

#pragma mark - delegate
//CommodityOrderTableViewCellDelegate
- (void)orderSurePayAction:(GetGoodsOrderListModel *)getGoodsOrderListModel{
    [self.delegate commodityOrderGoPayPushAction:getGoodsOrderListModel];
}

- (void)orderCancelPayAction:(NSInteger)old{
    CancelOrderParam * param = [CancelOrderParam new];
    param.oId = old;
    [ShopMallRequest cancelOrder:param Success:^(AnswerLsDict *response) {
        if (response.status == 200) {
            [self.view makeToast:@"取消付款成功" duration:2.0f position:CSToastPositionCenter];
            [self getGoodsListRequest:YES];
        }else{
            [self.view makeToast:response.msg duration:2.0f position:CSToastPositionCenter];
        }
    } failure:^(NSError *error) {
        [self.view makeToast:@"网络繁忙" duration:2.0f position:CSToastPositionCenter];
    }];
}

//CommodityOrderDetailSureFooterDelegate
- (void)orderSureAction:(GetGoodsOrderListModel *)getGoodsOrderListModel{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil
                                                                             message:@"要确认收货吗?"
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消"
                                                        style:UIAlertActionStyleCancel
                                                      handler:nil]];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        CancelOrderParam * cancelParam = [CancelOrderParam new];
        cancelParam.oId = getGoodsOrderListModel.oId;
        [ShopMallRequest confirmReceipt:cancelParam Success:^(AnswerLsDict *response) {
            if (response.status == 200) {
                [self.view makeToast:@"确认收货成功" duration:2.0f position:CSToastPositionCenter];
                [self getGoodsListRequest:YES];
            }else{
                [self.view makeToast:response.msg duration:2.0f position:CSToastPositionCenter];
            }
        } failure:^(NSError *error) {
            [self.view makeToast:@"网络繁忙" duration:2.0f position:CSToastPositionCenter];
        }];
    }]];
    
    [self presentViewController:alertController animated:YES completion:nil];
    
}

- (void)commodityOrderDetailRefundFooterAction:(GetGoodsOrderListModel *)getGoodsOrderListModel detailModel:(GoodsDetailModel *)detailModel{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil
                                                                             message:@"要确认退款吗？"
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消"
                                                        style:UIAlertActionStyleCancel
                                                      handler:nil]];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        RefundOrderParam * param = [RefundOrderParam new];
        param.orderId = getGoodsOrderListModel.orderId;
        param.sellerId = getGoodsOrderListModel.sellerId;
        param.goodsId = detailModel.goodsId;
        [RedPacketRequest refundOrder:param Success:^(RedPacketResponseDict *response) {
            if (response.status == 200) {
                [self getGoodsListRequest:YES];
            }else{
                [self.view makeToast:response.msg duration:2.0f position:CSToastPositionCenter];
            }
        } failure:^(NSError *error) {
            [self.view makeToast:@"网络繁忙" duration:2.0f position:CSToastPositionCenter];
        }];
    }]];
    
    [self presentViewController:alertController animated:YES completion:nil];
    
}

#pragma mark - tableview

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    GetGoodsOrderListModel * orderListModel = self.dataArray[section];
    return orderListModel.goodsDetailArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CommodityOrderTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:[CommodityOrderTableViewCell cellReuseIdentifierInfo] forIndexPath:indexPath];
    cell.delegate = self;
    GetGoodsOrderListModel * orderListModel = self.dataArray[indexPath.section];
    GoodsDetailModel * orderDetailModel = orderListModel.goodsDetailArray[indexPath.row];
    [cell refreshView:orderListModel orderDetailModel:orderDetailModel isAuction:NO];
    return cell;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 99;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    GetGoodsOrderListModel * orderListModel = self.dataArray[section];
    if (orderListModel.status == 2 || orderListModel.status == -1) {
        return 10;
    }
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40;
}

- (void)tableView:(UITableView *)tableView willDisplayFooterView:(nonnull UIView *)view forSection:(NSInteger)section{
    if ([view isKindOfClass:[UITableViewHeaderFooterView class]]) {
        ((UITableViewHeaderFooterView *)view).backgroundView.backgroundColor = UIColorFromRGB(0xF3F4F6);
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    CommodityOrderDetailHeader *cartView = (CommodityOrderDetailHeader *)[tableView dequeueReusableHeaderFooterViewWithIdentifier:[CommodityOrderDetailHeader cellIdentity]];
    GetGoodsOrderListModel * listModel = self.dataArray[section];
    cartView.titleLabel.text = listModel.sellerName;
    return cartView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    GetGoodsOrderListModel * orderListModel = self.dataArray[section];
    if (orderListModel.status == 0 || orderListModel.status == 4) {
        CommodityOrderDetailCancelFooter *cartView = (CommodityOrderDetailCancelFooter *)[tableView dequeueReusableHeaderFooterViewWithIdentifier:[CommodityOrderDetailCancelFooter cellIdentity]];
        if (orderListModel.status == 0) {
            cartView.titleLabel.text = @"买家已取消付款";
        }else if (orderListModel.status == 4){
            cartView.titleLabel.text = @"订单已完成";
        }
        
        return cartView;
    }else if (orderListModel.status == 1) {
        CommodityOrderDetailFooter *cartView = (CommodityOrderDetailFooter *)[tableView dequeueReusableHeaderFooterViewWithIdentifier:[CommodityOrderDetailFooter cellIdentity]];
        cartView.delegate = self;
        [cartView setGetGoodsOrderListModel:orderListModel];
        return cartView;
    }else if(orderListModel.status == 3){
        CommodityOrderDetailSureFooter *cartView = (CommodityOrderDetailSureFooter *)[tableView dequeueReusableHeaderFooterViewWithIdentifier:[CommodityOrderDetailSureFooter cellIdentity]];
        cartView.delegate = self;
        [cartView setGetGoodsOrderListModel:orderListModel];
        return cartView;
    }
    UIView* footView = [[UIView alloc]initWithFrame:CGRectZero];
    footView.backgroundColor = UIColorFromRGB(0xF3F4F6);
    return footView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    GetGoodsOrderListModel * listModel = self.dataArray[indexPath.section];
    [self.delegate orderPushDetailVC:listModel];
}

#pragma mark - load

- (void)loadHeaderData{
    
}

- (void)loadFooterData{
    
}

#pragma mark - getter

- (NSMutableArray<GetGoodsOrderListModel *> *)dataArray{
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [BasisUITool getTableViewWithFrame:CGRectZero style:UITableViewStyleGrouped delegate:self dataSource:self scrollEnabled:YES separatorStyle:UITableViewCellSeparatorStyleNone];
        
        _tableView.dataSource = self;
        _tableView.delegate = self;
        [_tableView registerNib:[UINib nibWithNibName:@"CommodityOrderTableViewCell" bundle:nil]
             forCellReuseIdentifier:[CommodityOrderTableViewCell cellReuseIdentifierInfo]];
        [_tableView registerNib:[UINib nibWithNibName:@"CommodityOrderDetailHeader" bundle:nil] forHeaderFooterViewReuseIdentifier:[CommodityOrderDetailHeader cellIdentity]];
        [_tableView registerNib:[UINib nibWithNibName:@"CommodityOrderDetailFooter" bundle:nil] forHeaderFooterViewReuseIdentifier:[CommodityOrderDetailFooter cellIdentity]];
        [_tableView registerNib:[UINib nibWithNibName:@"CommodityOrderDetailCancelFooter" bundle:nil] forHeaderFooterViewReuseIdentifier:[CommodityOrderDetailCancelFooter cellIdentity]];
        [_tableView registerNib:[UINib nibWithNibName:@"CommodityOrderDetailSureFooter" bundle:nil] forHeaderFooterViewReuseIdentifier:[CommodityOrderDetailSureFooter cellIdentity]];
        _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            [self getGoodsListRequest:NO];
        }];
        
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [self getGoodsListRequest:YES];
        }];
    }
    return _tableView;
}

@end
