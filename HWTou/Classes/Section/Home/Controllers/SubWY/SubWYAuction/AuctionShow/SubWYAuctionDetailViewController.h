//
//  SubWYAuctionDetailViewController.h
//  HWTou
//
//  Created by robinson on 2018/4/19.
//  Copyright © 2018年 LieMi. All rights reserved.
//

#import "BaseViewController.h"
#import "GetSellerPerformGoodsListModel.h"

@interface SubWYAuctionDetailViewController : BaseViewController
@property (nonatomic,strong) GoodsListModel * goodsListModel;
@property (nonatomic,strong) GetSellerPerformGoodsListModel * performGoodsListModel;
@end
