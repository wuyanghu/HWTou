//
//  GetShopCartListModel.m
//  HWTou
//
//  Created by robinson on 2018/4/13.
//  Copyright © 2018年 LieMi. All rights reserved.
//

#import "GetShopCartListModel.h"

@implementation GetShopCartListModel

- (instancetype)init{
    self = [super init];
    if (self) {
        _sellerWord = @"";
    }
    return self;
}

- (NSMutableArray<GetShopCartListResultModel *> *)cartGoodsListArr{
    if (!_cartGoodsListArr) {
        _cartGoodsListArr = [[NSMutableArray alloc] init];
    }
    return _cartGoodsListArr;
}

- (BOOL)isEqual:(id)object{
    if (self == object) {//对象本身
        return YES;
    }
    
    if (![object isKindOfClass:[GetShopCartListModel class]]) {//不是本类
        return NO;
    }
    
    return [self isEqualToLocModel:(GetShopCartListModel *)object];//必须全部属性相同 但是在实际开发中关键属性相同就可以
}

-(BOOL)isEqualToLocModel:(GetShopCartListModel *)model{
    if (!model) {
        return NO;
    }
    
    BOOL haveEqualNames = (!self.sellerName && !model.sellerName) || [self.sellerName isEqualToString:model.sellerName];
    BOOL haveEqualComId = (self.uid == model.uid);
    BOOL haveEqualSellerId = (self.sellerId == model.sellerId);
    return haveEqualNames && haveEqualComId && haveEqualSellerId;
}


- (NSUInteger)hash {
    return [self.sellerName hash] ^ self.uid ^ self.sellerId;
}

@end

@implementation GetShopCartListResultModel
-(BOOL)isEqualToLocModel:(GetShopCartListResultModel *)model{
    if (!model) {
        return NO;
    }
    BOOL haveEqualcartId = (self.cartId == model.cartId);
    return haveEqualcartId;
}


- (NSUInteger)hash {
    return self.cartId;
}
@end
