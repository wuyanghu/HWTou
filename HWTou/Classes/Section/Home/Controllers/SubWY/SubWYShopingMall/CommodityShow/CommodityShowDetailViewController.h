//
//  CommodityShowDetailViewController.h
//  HWTou
//
//  Created by robinson on 2018/3/20.
//  Copyright © 2018年 LieMi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "GetGoodsListModel.h"
@protocol CommodityShowDetailDelegate
- (void)commodityShowDetailPushAction:(GetGoodsListModel *)model;
@end

@interface CommodityShowDetailViewController : BaseViewController
@property (nonatomic,weak) id<CommodityShowDetailDelegate> delegate;
@property (nonatomic,assign) NSInteger labelId;
@end
