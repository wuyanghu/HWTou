//
//  CommodityOrderProtocol.h
//  HWTou
//
//  Created by robinson on 2018/4/18.
//  Copyright © 2018年 LieMi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GetGoodsOrderListModel.h"

@protocol CommodityOrderProtocol <NSObject>
- (void)commodityOrderDetailRefundFooterAction:(GetGoodsOrderListModel *)getGoodsOrderListModel detailModel:(GoodsDetailModel *)detailModel;
@end

@protocol CommodityOrderDetailSureFooterDelegate<NSObject>
- (void)orderSureAction:(GetGoodsOrderListModel *)getGoodsOrderListModel;
@end
