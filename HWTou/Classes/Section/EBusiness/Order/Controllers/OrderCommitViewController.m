//
//  OrderCommitViewController.m
//  HWTou
//
//  Created by 彭鹏 on 2017/3/19.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "OrderCommitViewController.h"
#import "PaymentWayViewController.h"
#import <YYModel/YYModel.h>
#import "OrderCommitView.h"
#import "AddressRequest.h"
#import "OrderDetailReq.h"
#import "AddressGoodsDM.h"
#import "ProductCartDM.h"
#import "OrderDetailDM.h"
#import "CouponRequest.h"
#import "PublicHeader.h"

@interface OrderCommitViewController () <OrderCommitDelegate>

@property (nonatomic, strong) OrderCommitView *vOrderCommit;

@end

@implementation OrderCommitViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self createUI];
    [self loadData];
}

- (void)createUI
{
    self.title = @"填写订单";
    self.vOrderCommit = [[OrderCommitView alloc] init];
    [self.view addSubview:self.vOrderCommit];
    self.vOrderCommit.delegate = self;
    self.vOrderCommit.carts = self.carts;
    
    [self.vOrderCommit makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

- (void)loadData
{
    [HUDProgressTool showIndicatorWithText:@"加载中..."];
    [AddressRequest obtainConsigneeAddressList:^(AddressResponse *response) {
        if (response.success) {
            self.vOrderCommit.address = response.data;
            [HUDProgressTool dismiss];
        } else {
            [HUDProgressTool showOnlyText:response.msg];
        }
    } failure:^(NSError *error) {
        [HUDProgressTool showOnlyText:[error urlErrorCodeDescribe]];
    }];
    
    CouponProductParam *param = [[CouponProductParam alloc] init];
    param.flag = 1;
    NSMutableArray *items = [NSMutableArray arrayWithCapacity:self.carts.count];
    [self.carts enumerateObjectsUsingBlock:^(ProductCartDM *obj, NSUInteger idx, BOOL *stop) {
        [items addObject:@(obj.item_id)];
    }];
    param.item_ids = items;
    
    [CouponRequest couponProductWithParam:param success:^(CouponResponse *response) {
        
        NSMutableArray *temp = [NSMutableArray arrayWithCapacity:response.data.count];
        for (CouponModel *dmCoupn in response.data) {
            // 对象数据转换
            NSDictionary *dictObj = [dmCoupn yy_modelToJSONObject];
            CouponSelDM *selCoupon = [CouponSelDM yy_modelWithJSON:dictObj];
            [temp addObject:selCoupon];
        }
        
        self.vOrderCommit.coupons = temp;
        
    } failure:^(NSError *error) {
        [HUDProgressTool showOnlyText:[error urlErrorCodeDescribe]];
    }];
}

- (void)onPaymentEvent
{
#if 0
    if (self.vOrderCommit.dmAddress == nil) {
        [HUDProgressTool showOnlyText:@"请选择收货地址"];
        return;
    }
#endif
    // 生成订单参数
    [HUDProgressTool showIndicatorWithText:nil];
    NSMutableArray *cartList = [NSMutableArray arrayWithCapacity:self.carts.count];
    [self.carts enumerateObjectsUsingBlock:^(ProductCartDM *cart, NSUInteger idx, BOOL *stop) {
        OrderCommitDM *dmOrder = [[OrderCommitDM alloc] init];
        dmOrder.cart_id = cart.cart_id;
        dmOrder.item_id = cart.item_id;
        dmOrder.mivid = cart.mivid;
        dmOrder.num = cart.num;
        [cartList addObject:dmOrder];
    }];
    
    OrderCommitParam *param = [OrderCommitParam new];
    param.price_total = self.vOrderCommit.realPrice;
    param.maid = self.vOrderCommit.dmAddress.maid;
    param.postage = self.vOrderCommit.postage;
    param.list = cartList;
    
    NSMutableArray *coupons = [NSMutableArray array];
    [self.vOrderCommit.coupons enumerateObjectsUsingBlock:^(CouponSelDM *obj, NSUInteger idx, BOOL *stop) {
        if (obj.selected) {
            [coupons addObject:@(obj.cuid)];
        }
    }];
    
    if (coupons.count > 0) {
        param.cuids = coupons;
    }

    [OrderDetailReq commitWithParam:param success:^(OrderCommitResp *response) {
        if (response.success) {
            [HUDProgressTool dismiss];
            // 进入付款页面
            PaymentWayViewController *payWay =  [[PaymentWayViewController alloc] init];
            
            OrderDetailDM *dmOrder = [OrderDetailDM new];
            dmOrder.mpid = response.data.mpid;
            dmOrder.price_total = self.vOrderCommit.realPrice;
            payWay.dmOrder = dmOrder;
            [self.navigationController pushViewController:payWay animated:YES];
        } else {
            [HUDProgressTool showOnlyText:response.msg];
        }
    } failure:^(NSError *error) {
        [HUDProgressTool showOnlyText:[error urlErrorCodeDescribe]];
    }];
}

@end
