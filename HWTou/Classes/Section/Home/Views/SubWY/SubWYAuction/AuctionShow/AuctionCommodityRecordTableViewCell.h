//
//  AuctionCommodityRecordTableViewCell.h
//  HWTou
//
//  Created by robinson on 2018/4/20.
//  Copyright © 2018年 LieMi. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "GetBidSellerRecordModel.h"

@interface AuctionCommodityRecordTableViewCell : BaseTableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;

@property (nonatomic,strong) GetBidSellerRecordModel * recordModel;

@end
