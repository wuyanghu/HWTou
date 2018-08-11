//
//  ShopCartSettleLeaveTableViewCell.m
//  HWTou
//
//  Created by robinson on 2018/4/10.
//  Copyright © 2018年 LieMi. All rights reserved.
//

#import "ShopCartSettleLeaveFooterView.h"

@implementation ShopCartSettleLeaveFooterView

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.leaveTextView.placeholder = @"选填:对本次交易的说明(最多140字）";
    self.leaveTextView.delegate = self;
}

- (void)textViewDidChange:(UITextView *)textView{
    _listModel.sellerWord = textView.text;
}

- (void)setOrderListModel:(GetGoodsOrderListModel *)orderListModel{
    _orderListModel = orderListModel;
    self.orderDetailView.hidden = NO;
    self.orderNumberLabel.text = [NSString stringWithFormat:@"订单编号:%@",orderListModel.orderId];
    self.payNumberLabel.text = [NSString stringWithFormat:@"支付编号:%@",orderListModel.payOrderId];
    self.orderTimeLabel.text = [NSString stringWithFormat:@"下单时间:%@",orderListModel.createTime];
    
    NSString * payWayStr = @"支付方式:";
    if (orderListModel.chargeType == 0) {
        payWayStr = [NSString stringWithFormat:@"%@%@",payWayStr,@"余额支付"];
    }else if (orderListModel.chargeType == 1){
        payWayStr = [NSString stringWithFormat:@"%@%@",payWayStr,@"支付宝支付"];
    }else{
        payWayStr = [NSString stringWithFormat:@"%@%@",payWayStr,@"微信支付"];
    }
    self.payWayLabel.text = payWayStr;
    [self.leaveTextView setEditable:NO];
    self.leaveTextView.placeholder = orderListModel.sellerWord;
    
    if (orderListModel.status == 1) {
        self.payNumberLabel.hidden = YES;
        self.payWayLabel.hidden = YES;
    }
}

+ (NSString *)cellIdentity{
    return @"ShopCartSettleLeaveFooterView";
}
@end
