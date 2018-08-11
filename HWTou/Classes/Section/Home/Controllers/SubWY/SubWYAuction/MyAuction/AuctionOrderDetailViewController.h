//
//  AuctionOrderDetailViewController.h
//  HWTou
//
//  Created by robinson on 2018/3/20.
//  Copyright © 2018年 LieMi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "GetGoodsOrderListModel.h"
@protocol CommodityOrderDetailDelegate
- (void)orderPushDetailVC:(GetGoodsOrderListModel *)model;
@end

@interface AuctionOrderDetailViewController : BaseViewController
@property (nonatomic,weak) id<CommodityOrderDetailDelegate> delegate;
@property (nonatomic,assign) NSInteger labelId;
@end
