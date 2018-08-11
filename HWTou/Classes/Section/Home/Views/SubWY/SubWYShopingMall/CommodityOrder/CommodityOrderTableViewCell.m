//
//  CommodityOrderTableViewCell.m
//  HWTou
//
//  Created by robinson on 2018/4/17.
//  Copyright © 2018年 LieMi. All rights reserved.
//

#import "CommodityOrderTableViewCell.h"
#import "PublicHeader.h"

@interface CommodityOrderTableViewCell()
@property (nonatomic,strong) GetGoodsOrderListModel * orderListModel;
@property (nonatomic,strong) GoodsDetailModel * orderDetailModel;
@property (nonatomic,assign) BOOL isAuction;//是否拍卖
@end

@implementation CommodityOrderTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)refreshView:(GetGoodsOrderListModel *)orderListModel orderDetailModel:(GoodsDetailModel *)orderDetailModel isAuction:(BOOL)isAuction{
    _orderListModel = orderListModel;
    _orderDetailModel = orderDetailModel;
    _isAuction = isAuction;
    
    [_commodityImageView sd_setImageWithURL:[NSURL URLWithString:orderDetailModel.goodsImg]];
    _commodityTitleLabel.text = orderDetailModel.goodsName;
    _commodityDescLabel.text = @"";
    _commodityPriceLabel.text = [NSString stringWithFormat:@"¥%@",orderDetailModel.price];
    
    NSString * state;
    if (orderDetailModel.goodsState == 0) {
        state = @"退款";
    }else if (orderDetailModel.goodsState == 2){
        state = @"已退款";
    }else if (orderDetailModel.goodsState == 3){
        state = @"商家取消发货退款成功";
    }
    
    [self.refundBtn setTitle:state forState:UIControlStateNormal];
    
    self.refundBtn.hidden = orderListModel.status != 2 || _isAuction;
    
    self.sureBtn.hidden = !(orderListModel.status == 3 || orderListModel.status == 4);
    if (orderListModel.status == 3) {
        [self.sureBtn setTitle:@"确认收货" forState:UIControlStateNormal];
    }else if (orderListModel.status == 4){
        [self.sureBtn setTitle:@"已收货" forState:UIControlStateNormal];
    }
    
}

- (IBAction)refundAction:(id)sender {
    if (_orderDetailModel.goodsState == 0) {
        [self.delegate commodityOrderDetailRefundFooterAction:_orderListModel detailModel:_orderDetailModel];
    }
}


#pragma mark - static method

+ (NSString *)cellReuseIdentifierInfo{
    return @"CommodityOrderTableViewCell";
}

@end
