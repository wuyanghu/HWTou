//
//  AuctionCommodityRecordTableViewCell.m
//  HWTou
//
//  Created by robinson on 2018/4/20.
//  Copyright © 2018年 LieMi. All rights reserved.
//

#import "AuctionCommodityRecordTableViewCell.h"

@implementation AuctionCommodityRecordTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setRecordModel:(GetBidSellerRecordModel *)recordModel{
    self.nameLabel.text = recordModel.userName;
    self.timeLabel.text = recordModel.bidTime;
    self.priceLabel.text = [NSString stringWithFormat:@"¥%@",recordModel.bidMoney];
    self.iconImageView.hidden = recordModel.isDone != 1;
}

+ (NSString *)cellReuseIdentifierInfo{
    return @"AuctionCommodityRecordTableViewCell";
}
@end
