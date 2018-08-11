//
//  AuctionOrderStateTableViewCell.m
//  HWTou
//
//  Created by robinson on 2018/4/23.
//  Copyright © 2018年 LieMi. All rights reserved.
//

#import "AuctionOrderStateTableViewCell.h"
#import "PublicHeader.h"

@implementation AuctionOrderStateTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setGetMySellerListModel:(GetMySellerListModel *)getMySellerListModel{
    _getMySellerListModel = getMySellerListModel;
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:getMySellerListModel.goodsImg]];
    self.nameLabel.text = getMySellerListModel.goodsName;
    
    if (_type == AuctionOrderStateTypeProceed) {
        self.nowPriceLabel.text = [NSString stringWithFormat:@"当前报价:%@",getMySellerListModel.currentBidMoney];
        self.youPriceLabel.text = [NSString stringWithFormat:@"您的报价:%@",getMySellerListModel.mineBidMoney];
    }else if (_type == AuctionOrderStateTypeNoGet){
        self.nowPriceLabel.text = @"";
        self.youPriceLabel.text = [NSString stringWithFormat:@"成交价:%@",getMySellerListModel.doneBidMoney];
    }else if (_type == AuctionOrderStateTypeMargin){
        self.nowPriceLabel.text = [NSString stringWithFormat:@"商家:%@",getMySellerListModel.sellerName];
        self.nowPriceLabel.textColor = UIColorFromRGB(0x4E4E4E);
        self.youPriceLabel.text = [NSString stringWithFormat:@"已缴纳保证金:%@",getMySellerListModel.proveMoney];
    }
}

@end
