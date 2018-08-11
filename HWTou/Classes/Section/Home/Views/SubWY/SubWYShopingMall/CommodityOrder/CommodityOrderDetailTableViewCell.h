//
//  CommodityOrderDetailTableViewCell.h
//  HWTou
//
//  Created by robinson on 2018/4/18.
//  Copyright © 2018年 LieMi. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "GetShopCartListModel.h"
#import "GetGoodsOrderListModel.h"

@interface CommodityOrderDetailTableViewCell : BaseTableViewCell
@property (nonatomic,strong) GetShopCartListResultModel * resultModel;

@property (nonatomic,strong) GetGoodsOrderListModel * orderListModel;

@property (weak, nonatomic) IBOutlet UIImageView *commodityImageView;
@property (weak, nonatomic) IBOutlet UILabel *commodityNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *commodityDescLabel;
@property (weak, nonatomic) IBOutlet UILabel *commodityPriceLabel;
@property (weak, nonatomic) IBOutlet UIButton *sureBtn;

@property (nonatomic,assign) BOOL isAuction;//是否拍买
@end
