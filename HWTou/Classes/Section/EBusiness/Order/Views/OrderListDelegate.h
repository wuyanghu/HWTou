//
//  OrderListDelegate.h
//  HWTou
//
//  Created by 彭鹏 on 2017/4/11.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, OrderEvent)
{
    OrderEventCancel,   // 取消订单
    OrderEventMail,     // 物流跟踪
    OrderEventConfirm,  // 确认收货
    OrderEventComment,  // 商品评价
    OrderEventInvaild,  // 无效事件
};

@class OrderDetailDM;

@protocol OrderListDelegate <NSObject>

@optional
- (void)onOrderEvent:(OrderEvent)event order:(OrderDetailDM *)dmOrder;

@end
