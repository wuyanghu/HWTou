//
//  CouponColView.h
//  HWTou
//
//  Created by 赤 那 on 2017/4/6.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CouponModel.h"

@protocol CouponColViewDelegate <NSObject>

- (void)onDidSelectItem:(CouponModel *)model;

@end

@interface CouponColView : UIView

@property (nonatomic, weak) id<CouponColViewDelegate> m_Delegate;

/**
 当优惠券类型为CouponType_Product时，需要指定商品id
 */
@property (nonatomic, copy) NSArray *productIds;

- (void)setCouponColViewType:(CouponType)colType;

@end
