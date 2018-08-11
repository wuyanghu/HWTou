//
//  AuctionCustomPriceView.h
//  HWTou
//
//  Created by robinson on 2018/4/24.
//  Copyright © 2018年 LieMi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GetSellerPerformGoodsListModel.h"

@protocol AuctionCustomPriceViewDelegate
- (void)auctionCustomPriceViewAction:(NSString *)price;
@end

@interface AuctionCustomPriceView : UIControl

@property (nonatomic,strong) GoodsListModel * goodsListModel;

@property (nonatomic,weak) id<AuctionCustomPriceViewDelegate> delegate;

@property (weak, nonatomic) IBOutlet UILabel *currentPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *offerPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *raisePriceLabel;
@property (weak, nonatomic) IBOutlet UIButton *addPriceBtn;
@property (weak, nonatomic) IBOutlet UIButton *subPriceBtn;
@property (weak, nonatomic) IBOutlet UIView *bgView;

- (void)show:(GoodsListModel * )goodsListModel;
- (void)dismiss;
@end
