//
//  AuctionCommodityDetailTableViewCell.m
//  HWTou
//
//  Created by robinson on 2018/4/19.
//  Copyright © 2018年 LieMi. All rights reserved.
//

#import "AuctionCommodityDetailTableViewCell.h"
#import "ComFloorEvent.h"

@implementation AuctionCommodityDetailTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setGoodsListModel:(GoodsListModel *)goodsListModel{
    _goodsListModel = goodsListModel;
    
    self.nameLabel.text = goodsListModel.goodsName;
    self.descLabel.text = goodsListModel.introduction;
    
    self.priceLabel.text = [goodsListModel getCurrentPriceStr];
    
    self.sellLabel.text = [NSString stringWithFormat:@"卖方:%@",goodsListModel.sellerName];
    
    self.startPriceLabel.text = [NSString stringWithFormat:@"起拍价:%@",goodsListModel.actualMoney];
    [self setLabelTextColor:self.startPriceLabel length:4];
    self.topPriceLabel.text = [NSString stringWithFormat:@"封顶价:%@",goodsListModel.adviceMoney];
    [self setLabelTextColor:self.topPriceLabel length:4];
    self.addPriceRangeLabel.text = [NSString stringWithFormat:@"加价幅度:%@",goodsListModel.courierMoney];
    [self setLabelTextColor:self.addPriceRangeLabel length:5];
    self.offerPriceCountLabel.text = [NSString stringWithFormat:@"出价次数:%ld次",goodsListModel.bidCount];
    [self setLabelTextColor:self.offerPriceCountLabel length:5];
}

- (void)setPerformGoodsListModel:(GetSellerPerformGoodsListModel *)performGoodsListModel{
    _performGoodsListModel = performGoodsListModel;
    self.startTimeLabel.text = [NSString stringWithFormat:@"开始时间:%@",performGoodsListModel.startTime];
    [self setLabelTextColor:self.startTimeLabel length:5];
    self.endTimeLabel.text = [NSString stringWithFormat:@"结束时间:%@",performGoodsListModel.endTime];
    [self setLabelTextColor:self.endTimeLabel length:5];
}

- (void)setLabelTextColor:(UILabel *)label length:(NSInteger)length{
    
    NSRange range = NSMakeRange(0,length);
    NSMutableAttributedString *strAttr = [[NSMutableAttributedString alloc] initWithString:label.text];
    [strAttr addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0x9A9A9A) range:range];
    [strAttr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:range];
    
    range = NSMakeRange(length,label.text.length-length);
    [strAttr addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0xAD0021) range:range];
    [strAttr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:range];
    
    label.attributedText = strAttr;
    
}

- (void)setRecordCount:(NSInteger)recordCount{
    self.recordCountLabel.text = [NSString stringWithFormat:@"%ld条",recordCount];
}

- (IBAction)recordAction:(id)sender {
    [self.delegate recordAction];
}

- (IBAction)informationDetailAction:(id)sender {
    FloorItemDM * itemDM = [FloorItemDM new];
    itemDM.type = FloorEventParam;
    itemDM.title = @"拍卖资料";
    itemDM.param = @"https://baidu.com";
    [ComFloorEvent handleEventWithFloor:itemDM];
}

+ (NSString *)cellReuseIdentifierInfo{
    return @"AuctionCommodityDetailTableViewCell";
}
@end
