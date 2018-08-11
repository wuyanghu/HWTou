//
//  ShopCartSettleDetailTableViewCell.h
//  HWTou
//
//  Created by robinson on 2018/4/9.
//  Copyright © 2018年 LieMi. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "GetShopCartListModel.h"

@interface ShopCartSettleDetailTableViewCell : BaseTableViewCell
@property (nonatomic,strong) GetShopCartListResultModel * resultModel;

@property (weak, nonatomic) IBOutlet UIImageView *commodityImageView;
@property (weak, nonatomic) IBOutlet UILabel *commodityNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *commodityDescLabel;
@property (weak, nonatomic) IBOutlet UILabel *commodityPriceLabel;

@end
