//
//  AuctionOrderStateTableViewCell.h
//  HWTou
//
//  Created by robinson on 2018/4/23.
//  Copyright © 2018年 LieMi. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "GetMySellerListModel.h"

@interface AuctionOrderStateTableViewCell : BaseTableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *nowPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *youPriceLabel;

@property (nonatomic,assign) AuctionOrderStateType type;
@property (nonatomic,strong) GetMySellerListModel * getMySellerListModel;

@end
