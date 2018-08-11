//
//  CommodityShowCollectionViewCell.m
//  HWTou
//
//  Created by robinson on 2018/4/10.
//  Copyright © 2018年 LieMi. All rights reserved.
//

#import "CommodityShowCollectionViewCell.h"
#import "PublicHeader.h"

@implementation CommodityShowCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setGetGoodsListModel:(GetGoodsListModel *)getGoodsListModel{
    _getGoodsListModel = getGoodsListModel;
    [self.commodityImageView sd_setImageWithURL:[NSURL URLWithString:getGoodsListModel.imgUrl]];
    self.commodityTitleLabel.text = getGoodsListModel.goodsName;
    self.commodityDesLabel.text = getGoodsListModel.introduction;
}

- (void)setGoodsListModel:(GoodsListModel *)goodsListModel{
    _goodsListModel = goodsListModel;
    [self.commodityImageView sd_setImageWithURL:[NSURL URLWithString:goodsListModel.imgUrl]];
    self.commodityTitleLabel.text = goodsListModel.goodsName;
    self.commodityDesLabel.text = [goodsListModel getCurrentPriceStr];
}

+ (NSString *)cellIdentity{
    return @"CommodityShowCollectionViewCell";
}

@end
