//
//  AuctionRecordViewController.h
//  HWTou
//
//  Created by robinson on 2018/4/20.
//  Copyright © 2018年 LieMi. All rights reserved.
//

#import "BaseViewController.h"
#import "GetSellerPerformGoodsListModel.h"

@interface AuctionRecordViewController : BaseViewController
@property (nonatomic,strong) GoodsListModel * goodsListModel;
@property (nonatomic,strong) GetSellerPerformGoodsListModel * performGoodsListModel;
@end
