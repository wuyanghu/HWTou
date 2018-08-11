//
//  AuctionOrderDetail1ViewController.h
//  HWTou
//
//  Created by robinson on 2018/4/24.
//  Copyright © 2018年 LieMi. All rights reserved.
//

#import "BaseViewController.h"
#import "GetGoodsAddrListModel.h"
#import "GetShopCartListModel.h"
#import "GetGoodsOrderListModel.h"

@interface AuctionOrderDetail1ViewController : BaseViewController
@property (nonatomic,strong) GetGoodsAddrListModel * defaultAddrModel;//默认地址
@property (nonatomic,strong) GetGoodsOrderListModel * orderListModel;
@property (nonatomic,strong) NSMutableArray<GetShopCartListModel *> * shopCartDataArray;
@property (nonatomic,copy) NSString * totalPrice;
@end
