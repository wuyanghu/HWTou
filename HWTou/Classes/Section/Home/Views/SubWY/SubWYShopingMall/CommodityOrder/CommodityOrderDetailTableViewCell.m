//
//  CommodityOrderDetailTableViewCell.m
//  HWTou
//
//  Created by robinson on 2018/4/18.
//  Copyright © 2018年 LieMi. All rights reserved.
//

#import "CommodityOrderDetailTableViewCell.h"
#import "PublicHeader.h"

@implementation CommodityOrderDetailTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.sureBtn.layer.cornerRadius = 4.0;//2.0是圆角的弧度，根据需求自己更改
    self.sureBtn.layer.borderColor = UIColorFromRGB(0xAD0021).CGColor;//设置边框颜色
    self.sureBtn.layer.borderWidth = 1.0f;//设置边框颜色
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)setResultModel:(GetShopCartListResultModel *)resultModel{
    _resultModel = resultModel;
    [self.commodityImageView sd_setImageWithURL:[NSURL URLWithString:resultModel.imgUrl]];
    self.commodityNameLabel.text = resultModel.goodsName;
    self.commodityDescLabel.text = resultModel.introduction;
    self.commodityPriceLabel.text = [NSString stringWithFormat:@"¥%@",resultModel.actualMoney];
}

- (void)setOrderListModel:(GetGoodsOrderListModel *)orderListModel{
    _orderListModel = orderListModel;
    
    self.sureBtn.hidden = !(orderListModel.status == 2 || orderListModel.status == 3 || orderListModel.status == 4);
    if (orderListModel.status == 2) {
        [self.sureBtn setTitle:@"退款" forState:UIControlStateNormal];
    }else if (orderListModel.status == 3) {
        [self.sureBtn setTitle:@"确认收货" forState:UIControlStateNormal];
    }else if (orderListModel.status == 4){
        [self.sureBtn setTitle:@"已收货" forState:UIControlStateNormal];
    }
}

- (void)setIsAuction:(BOOL)isAuction{
    _isAuction = isAuction;
    self.sureBtn.hidden = YES;
}

+ (NSString *)cellReuseIdentifierInfo{
    return @"CommodityOrderDetailTableViewCell";
}

- (IBAction)sureAction:(id)sender {
    if (_orderListModel.status == 2) {

    }else if (_orderListModel.status == 3) {

    }
}

@end
