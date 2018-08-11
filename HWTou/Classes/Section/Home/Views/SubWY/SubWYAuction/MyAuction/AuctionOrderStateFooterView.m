//
//  AuctionOrderStateFooterView.m
//  HWTou
//
//  Created by robinson on 2018/4/23.
//  Copyright © 2018年 LieMi. All rights reserved.
//

#import "AuctionOrderStateFooterView.h"

@implementation AuctionOrderStateFooterView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)setListModel:(GetMySellerListModel *)listModel{
    if (listModel.acStatus == 2 && listModel.isGet == 0) {
        self.label1.text = @"未拍中本品，保证金将于24小时内退还至您账户";
        self.labelState.text = @"退款中";
    }
    if (listModel.acStatus == 1 && listModel.isProvePay == 1) {
        self.label1.text = @"本场拍卖正在进行中";
        self.labelState.text = @"冻结中";
    }
    if (listModel.acStatus == 2 && listModel.isGet == 1){
        self.label1.text = @"您已拍中本商品，请尽快付款";
        if (listModel.isPay == 0) {
            self.labelState.text = @"冻结中";
        }else{
            self.labelState.text = @"已扣除";
        }
    }
    if (listModel.acStatus == 0 && listModel.isProvePay == 1) {
        self.label1.text = @"拍卖暂未开始";
        self.labelState.text = @"冻结中";
    }
}

+ (NSString *)cellIdentity{
    return @"AuctionOrderStateFooterView";
}
@end
