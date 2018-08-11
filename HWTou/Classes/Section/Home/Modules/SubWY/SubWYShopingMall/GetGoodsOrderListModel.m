//
//  GetGoodsOrderListModel.m
//  HWTou
//
//  Created by robinson on 2018/4/17.
//  Copyright © 2018年 LieMi. All rights reserved.
//

#import "GetGoodsOrderListModel.h"

@implementation GetGoodsOrderListModel

- (NSMutableArray<GoodsDetailModel *> *)goodsDetailArray{
    if (!_goodsDetailArray) {
        _goodsDetailArray = [[NSMutableArray alloc] init];
    }
    return _goodsDetailArray;
}

@end
@implementation GoodsDetailModel
@end
