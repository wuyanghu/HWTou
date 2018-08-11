//
//  CommodityShowCollectionViewCell.h
//  HWTou
//
//  Created by robinson on 2018/4/10.
//  Copyright © 2018年 LieMi. All rights reserved.
//

#import "BaseCollectionViewCell.h"
#import "GetGoodsListModel.h"
#import "GetSellerPerformGoodsListModel.h"

@interface CommodityShowCollectionViewCell : BaseCollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *commodityImageView;
@property (weak, nonatomic) IBOutlet UILabel *commodityTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *commodityDesLabel;

@property (nonatomic,strong) GetGoodsListModel * getGoodsListModel;
@property (nonatomic,strong) GoodsListModel * goodsListModel;
@end
