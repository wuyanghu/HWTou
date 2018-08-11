//
//  PaymentWayViewController.h
//  HWTou
//
//  Created by 彭鹏 on 2017/3/31.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "BaseViewController.h"

@class OrderDetailDM;

@interface PaymentWayViewController : BaseViewController

@property (nonatomic, strong) OrderDetailDM *dmOrder;

///** 订单号 */
//@property (nonatomic, assign) NSInteger mpid;
//
///** 实付金额 */
//@property (nonatomic, assign) CGFloat realPrice;

@end
