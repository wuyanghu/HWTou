//
//  OrderListView.h
//  HWTou
//
//  Created by 彭鹏 on 2017/4/1.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderListDelegate.h"

@interface OrderListView : UIView

@property (nonatomic, weak) id<OrderListDelegate> delegate;
@property (nonatomic, copy) NSArray *listOrder;
@property (nonatomic, readonly) UITableView  *tableView;

@end
