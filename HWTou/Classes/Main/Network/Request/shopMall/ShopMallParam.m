//
//  ShopMallParam.m
//  HWTou
//
//  Created by robinson on 2018/4/12.
//  Copyright © 2018年 LieMi. All rights reserved.
//

#import "ShopMallParam.h"

@implementation ShopMallParam
@end


@implementation AddGoodsAddrParam
@end

@implementation UpdateGoodsAddrParam
@end

@implementation GetGoodsAddrListParam
@end

@implementation DelGoodsAddrParam
@end

@implementation GetGoodsClassesParam
@end

@implementation GetGoodsListParam
@end

@implementation GetGoodsDetailParam
@end

@implementation AddShopCartParam
@end

@implementation DelShopCartParam
@end

@implementation GetShopCartListParam
@end

@implementation AddGoodsOrderParam
@end

@implementation GetGoodsOrderListParam
@end

@implementation CancelOrderParam
@end

@implementation GetSellerPerformListParam
- (instancetype)init{
    self = [super init];
    if (self) {
        _state = 1;
    }
    return self;
}
@end

@implementation GetSellerPerformGoodsListParam
@end

@implementation GetSellerPerformGoodsParam
@end

@implementation AddProveMoneyOrderParam
@end

@implementation BidSellerGoodsParam
@end

@implementation GetBidSellerRecordParam
@end

@implementation GetMySellerListParam
@end

@implementation UpdateSellerGoodsGoodParam
@end

@implementation GetFayeArtParam
@end
