//
//  CommodityOrderDetailSureFooter.h
//  HWTou
//
//  Created by robinson on 2018/4/17.
//  Copyright © 2018年 LieMi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GetGoodsOrderListModel.h"
#import "CommodityOrderProtocol.h"


@interface CommodityOrderDetailSureFooter : UITableViewHeaderFooterView
+ (NSString *)cellIdentity;
@property (nonatomic,weak) id<CommodityOrderDetailSureFooterDelegate> delegate;
@property (nonatomic,strong) GetGoodsOrderListModel * getGoodsOrderListModel;
@end
