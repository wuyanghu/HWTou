//
//  OrderCommitView.h
//  HWTou
//
//  Created by 彭鹏 on 2017/3/19.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CouponModel;
@class CouponSelDM;
@class AddressGoodsDM;
@class ProductCartDM;

@protocol OrderCommitDelegate <NSObject>

@optional
- (void)onPaymentEvent;

@end

@interface OrderCommitView : UIView

@property (nonatomic, weak) id<OrderCommitDelegate> delegate;

@property (nonatomic, copy) NSArray<ProductCartDM *> *carts;
@property (nonatomic, copy) NSArray<AddressGoodsDM *> *address;
@property (nonatomic, copy) NSArray<CouponSelDM *> *coupons;

@property (nonatomic, strong) AddressGoodsDM  *dmAddress; // 收获地址
@property (nonatomic, assign) CGFloat   realPrice;  // 实付金额
@property (nonatomic, readonly) CGFloat postage;    // 快递运费
@end
