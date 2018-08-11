//
//  ShopCartSettleDetailTableViewCell.m
//  HWTou
//
//  Created by robinson on 2018/4/9.
//  Copyright © 2018年 LieMi. All rights reserved.
//

#import "ShopCartSettleDetailTableViewCell.h"
#import "PublicHeader.h"

@implementation ShopCartSettleDetailTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
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

+ (NSString *)cellReuseIdentifierInfo{
    return @"ShopCartSettleDetailTableViewCell";
}

@end
