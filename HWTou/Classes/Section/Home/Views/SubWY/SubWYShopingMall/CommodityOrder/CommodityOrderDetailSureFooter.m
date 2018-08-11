//
//  CommodityOrderDetailSureFooter.m
//  HWTou
//
//  Created by robinson on 2018/4/17.
//  Copyright © 2018年 LieMi. All rights reserved.
//

#import "CommodityOrderDetailSureFooter.h"

@implementation CommodityOrderDetailSureFooter

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (IBAction)sureAction:(id)sender {
    [self.delegate orderSureAction:_getGoodsOrderListModel];
}


+ (NSString *)cellIdentity{
    return @"CommodityOrderDetailSureFooter";
}
@end
