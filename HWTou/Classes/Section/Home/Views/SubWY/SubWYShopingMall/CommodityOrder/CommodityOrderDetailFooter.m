//
//  CommodityOrderDetailFooter.m
//  HWTou
//
//  Created by robinson on 2018/4/17.
//  Copyright © 2018年 LieMi. All rights reserved.
//

#import "CommodityOrderDetailFooter.h"

@implementation CommodityOrderDetailFooter

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)setGetGoodsOrderListModel:(GetGoodsOrderListModel *)getGoodsOrderListModel{
    _getGoodsOrderListModel = getGoodsOrderListModel;
    self.countTimeLabel.text = [NSString stringWithFormat:@"支付时间还剩%@",getGoodsOrderListModel.countTime];
}

#pragma mark - action

- (IBAction)waitPayGoPayAction:(id)sender {
    [self.delegate orderSurePayAction:_getGoodsOrderListModel];
}

- (IBAction)waitPayCancelPayAction:(id)sender {
    [self.delegate orderCancelPayAction:_getGoodsOrderListModel.oId];
}

+ (NSString *)cellIdentity{
    return @"CommodityOrderDetailFooter";
}
@end
