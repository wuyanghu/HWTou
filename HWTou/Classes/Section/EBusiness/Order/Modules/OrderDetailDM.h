//
//  OrderDetailDM.h
//  HWTou
//
//  Created by 彭鹏 on 2017/4/1.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ProductAttributeDM.h"

typedef NS_ENUM(NSInteger, OrderStatusType) {
    OrderStatusAll = -1,        // 全部订单
    OrderStatusCancel,          // 订单取消
    OrderStatusWaitPay,         // 待支付
    OrderStatusSendGoods,       // 待发货
    OrderStatusReapGoods,       // 待收货
    OrderStatusWaitComment,     // 待评价
    OrderStatusCompleted,       // 已完成
    OrderStatusReturnProce,     // 退款中
    OrderStatusReturnComp,      // 退款完成
    OrderStatusPayProcess,      // 支付处理中
};

@interface OrderBillDM : NSObject

@property (nonatomic, assign) NSInteger type;   // 支付类型
@property (nonatomic, assign) CGFloat price;      // 支付金额
@property (nonatomic, copy) NSString  *create_time; // 付款时间

@end

@interface OrderProductDM : NSObject

@property (nonatomic, assign) NSInteger order_id;   // 商品订单id
@property (nonatomic, assign) NSInteger num;        // 商品数量
@property (nonatomic, assign) CGFloat price;          // 价格
@property (nonatomic, assign) CGFloat price_total;    // 总价格
@property (nonatomic, copy) NSString    *title;
@property (nonatomic, copy) NSString    *remark;
@property (nonatomic, copy) NSString    *img_url;

@property (nonatomic, strong) ProductAttStockDM *miv;

@end

@interface OrderDetailDM : NSObject

@property (nonatomic, assign) OrderStatusType status; // 订单状态
@property (nonatomic, assign) NSInteger mpid;   // 订单ID
@property (nonatomic, assign) CGFloat postage;    // 邮费
@property (nonatomic, assign) CGFloat price_total;// 总价格
@property (nonatomic, copy) NSString  *order_no;// 订单号
@property (nonatomic, copy) NSString  *mail_no; // 物流单号
@property (nonatomic, copy) NSString  *name;    // 收货人姓名
@property (nonatomic, copy) NSString  *tel;     // 收货人电话
@property (nonatomic, copy) NSString  *address; // 收货地址
@property (nonatomic, copy) NSString  *create_time; // 订单创建时间
@property (nonatomic, copy) NSArray   *itemList;    // 商品列表
@property (nonatomic, copy) NSString  *bill_type;   // 支付方式
@property (nonatomic, copy) NSArray   *bill;        // 支付账单

@end
