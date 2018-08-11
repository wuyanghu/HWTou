//
//  ShoppingCartSettleViewController.h
//  HWTou
//
//  Created by robinson on 2018/4/9.
//  Copyright © 2018年 LieMi. All rights reserved.
//

#import "BaseViewController.h"
#import "GetGoodsAddrListModel.h"
#import "GetShopCartListModel.h"

@interface ShoppingCartSettleViewController : BaseViewController
@property (nonatomic,strong) GetGoodsAddrListModel * defaultAddrModel;//默认地址
@property (nonatomic,strong) NSMutableArray<GetShopCartListModel *> * shopCartDataArray;
@property (nonatomic,copy) NSString * totalPrice;
@end
