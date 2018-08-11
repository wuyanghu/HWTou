//
//  OrderListViewController.h
//  HWTou
//
//  Created by 彭鹏 on 2017/3/31.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "BaseViewController.h"
#import "OrderDetailDM.h"

@interface OrderListViewController : BaseViewController

@property (nonatomic, assign) OrderStatusType status;
@property (nonatomic, copy) NSString *keywords; // 搜索关键字

@end
