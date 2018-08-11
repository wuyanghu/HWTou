//
//  GetShopCartListModel.h
//  HWTou
//
//  Created by robinson on 2018/4/13.
//  Copyright © 2018年 LieMi. All rights reserved.
//

#import "BaseModel.h"

@class GetShopCartListResultModel;

@interface GetShopCartListModel : BaseModel
@property (nonatomic,assign) NSInteger uid;//用户ID
@property (nonatomic,copy) NSString * sellerName;//卖家名
@property (nonatomic,assign) NSInteger sellerId;//卖家ID
@property (nonatomic,strong) NSMutableArray<GetShopCartListResultModel *> * cartGoodsListArr;//商品集合

@property (nonatomic,copy) NSString * sellerWord;//留言
@end

@interface GetShopCartListResultModel : BaseModel
@property (nonatomic,assign) NSInteger cartId;//购物车ID
@property (nonatomic,assign) NSInteger goodsId;//商品ID
@property (nonatomic,copy) NSString * goodsName;//商品名
@property (nonatomic,copy) NSString * imgUrl;//商品图片
@property (nonatomic,copy) NSString * introduction;//商品简介
@property (nonatomic,assign) NSInteger stockNum;//商品库存（注意：若库存为0客户端要限制不能勾选结算）
@property (nonatomic,copy) NSString * actualMoney;//商品售价
@end
