//
//  OrderListHeader.h
//  HWTou
//
//  Created by 彭鹏 on 2017/4/1.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import <UIKit/UIKit.h>

@class OrderDetailDM;

@interface OrderListHeader : UITableViewHeaderFooterView

@property (nonatomic, strong) OrderDetailDM *dmOrder;

@end
