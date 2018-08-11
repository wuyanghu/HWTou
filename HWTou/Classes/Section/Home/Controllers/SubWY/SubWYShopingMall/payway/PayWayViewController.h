//
//  PayWayViewController.h
//  HWTou
//
//  Created by robinson on 2018/4/10.
//  Copyright © 2018年 LieMi. All rights reserved.
//

#import "BaseViewController.h"
#import "AddGoodsOrderModel.h"
#import "GetGoodsOrderListModel.h"

typedef enum : NSUInteger{
    PayWayTypeDetail,//详情
    PayWayTypeOrder,//订单
}PayWayType;

@interface PayWayViewController : BaseViewController
@property (nonatomic,strong) AddGoodsOrderModel * addGoodsOrderModel;
@property (nonatomic,strong) GetGoodsOrderListModel * getGoodsOrderListModel;
@property (nonatomic,copy) NSString * payPrice;

@property (nonatomic,assign) PayWayType type;
@end
