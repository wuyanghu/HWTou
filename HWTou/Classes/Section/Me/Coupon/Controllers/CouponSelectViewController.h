//
//  CouponSelectViewController.h
//  HWTou
//
//  Created by 彭鹏 on 2017/4/7.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "BaseViewController.h"
#import "CouponModel.h"

@class CouponSelDM;

@protocol CouponSelectControllerDelegate <NSObject>

- (void)onDidSelectCoupons:(NSArray<CouponSelDM *> *)coupons;

@end

@interface CouponSelectViewController : BaseViewController

@property (nonatomic, weak) id<CouponSelectControllerDelegate> m_Delegate;

@property (nonatomic, assign) CGFloat totalPrice;

@property (nonatomic, copy) NSArray<CouponSelDM *> *coupons;

@end
