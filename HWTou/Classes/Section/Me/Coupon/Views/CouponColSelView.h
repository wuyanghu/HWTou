//
//  CouponColSelView.h
//  HWTou
//
//  Created by 彭鹏 on 2017/5/25.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CouponSelDM;

@interface CouponColSelView : UIView

@property (nonatomic, assign) CGFloat totalPrice;

@property (nonatomic, strong) NSMutableArray<CouponSelDM *> *selCoupons;

@property (nonatomic, copy) NSArray<CouponSelDM *> *coupons;

@end
