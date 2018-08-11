//
//  AddGoodsOrderModel.m
//  HWTou
//
//  Created by robinson on 2018/4/16.
//  Copyright © 2018年 LieMi. All rights reserved.
//

#import "AddGoodsOrderModel.h"

@implementation AddGoodsOrderModel
- (NSMutableArray<AddGoodsOrderResultModel *> *)sellerIdArr{
    if (!_sellerIdArr) {
        _sellerIdArr = [[NSMutableArray alloc] init];
    }
    return _sellerIdArr;
}
@end

@implementation AddGoodsOrderResultModel
@end
