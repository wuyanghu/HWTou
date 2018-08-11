//
//  GetSellerPerformGoodsListModel.m
//  HWTou
//
//  Created by robinson on 2018/4/19.
//  Copyright © 2018年 LieMi. All rights reserved.
//

#import "GetSellerPerformGoodsListModel.h"

@implementation GetSellerPerformGoodsListModel
- (NSMutableArray<GoodsListModel *> *)goodsListArr{
    if (!_goodsListArr) {
        _goodsListArr = [[NSMutableArray alloc] init];
    }
    return _goodsListArr;
}

@end

@implementation GoodsListModel

- (NSString *)getCurrentPriceStr{
    if ([_donePrice doubleValue] != 0) {
        return [NSString stringWithFormat:@"成交价 ¥%@",_donePrice];
    }else{
        if ([_currentBidMoney doubleValue] != 0) {
            return [NSString stringWithFormat:@"当前报价 ¥%@",_currentBidMoney];
        }else{
            if ([_actualMoney doubleValue] != 0) {
                return [NSString stringWithFormat:@"起拍价 ¥%@",_actualMoney];
            }
        }
    }
    return @"";
}

- (NSString *)getCurrentPrice{
    if ([_donePrice doubleValue] != 0) {
        return _donePrice;
    }else{
        if ([_currentBidMoney doubleValue] != 0) {
            return _currentBidMoney;
        }else{
            if ([_actualMoney doubleValue] != 0) {
                return _actualMoney;
            }
        }
    }
    return @"";
}

@end
