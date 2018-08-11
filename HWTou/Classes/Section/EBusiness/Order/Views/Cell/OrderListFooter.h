//
//  OrderListFooter.h
//  HWTou
//
//  Created by 彭鹏 on 2017/4/1.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderListDelegate.h"

@class OrderDetailDM;

@interface OrderListFooter : UITableViewHeaderFooterView

@property (nonatomic, weak) id<OrderListDelegate> delegate;

@property (nonatomic, strong) OrderDetailDM *dmOrder;

@end
