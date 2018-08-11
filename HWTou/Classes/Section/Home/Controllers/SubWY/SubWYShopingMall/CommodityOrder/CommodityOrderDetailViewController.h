//
//  CommodityOrderDetailViewController.h
//  HWTou
//
//  Created by robinson on 2018/3/20.
//  Copyright © 2018年 LieMi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "GetGoodsOrderListModel.h"
@protocol CommodityOrderDetailDelegate
- (void)commodityOrderGoPayPushAction:(GetGoodsOrderListModel *)model;
- (void)orderPushDetailVC:(GetGoodsOrderListModel *)model;
@end

@interface CommodityOrderDetailViewController : BaseViewController
@property (nonatomic,weak) id<CommodityOrderDetailDelegate> delegate;
@property (nonatomic,assign) NSInteger labelId;
@end
