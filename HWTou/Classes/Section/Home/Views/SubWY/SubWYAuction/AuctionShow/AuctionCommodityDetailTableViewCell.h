//
//  AuctionCommodityDetailTableViewCell.h
//  HWTou
//
//  Created by robinson on 2018/4/19.
//  Copyright © 2018年 LieMi. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "GetSellerPerformGoodsListModel.h"
#import "AuctionCommodityCellProtocol.h"

@interface AuctionCommodityDetailTableViewCell : BaseTableViewCell
@property (nonatomic,strong) GoodsListModel * goodsListModel;
@property (nonatomic,strong) GetSellerPerformGoodsListModel * performGoodsListModel;
@property (nonatomic,assign) NSInteger recordCount;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@property (weak, nonatomic) IBOutlet UILabel *sellLabel;

@property (weak, nonatomic) IBOutlet UILabel *startPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *topPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *startTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *addPriceRangeLabel;
@property (weak, nonatomic) IBOutlet UILabel *offerPriceCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *endTimeLabel;

@property (weak, nonatomic) IBOutlet UILabel *recordCountLabel;

@property (nonatomic,weak) id<AuctionCommodityCellProtocol> delegate;
@end
