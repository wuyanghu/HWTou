//
//  CommodityOrderTableViewCell.h
//  HWTou
//
//  Created by robinson on 2018/4/17.
//  Copyright © 2018年 LieMi. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "GetGoodsOrderListModel.h"
#import "CommodityOrderProtocol.h"

@interface CommodityOrderTableViewCell : BaseTableViewCell

@property (nonatomic,weak) id<CommodityOrderProtocol> delegate;

@property (weak, nonatomic) IBOutlet UIImageView *commodityImageView;
@property (weak, nonatomic) IBOutlet UILabel *commodityTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *commodityDescLabel;
@property (weak, nonatomic) IBOutlet UILabel *commodityPriceLabel;
@property (weak, nonatomic) IBOutlet UIButton *refundBtn;
@property (weak, nonatomic) IBOutlet UIButton *sureBtn;

- (void)refreshView:(GetGoodsOrderListModel *)orderListModel orderDetailModel:(GoodsDetailModel *)orderDetailModel isAuction:(BOOL)isAuction;

@end
