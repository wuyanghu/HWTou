//
//  PaymentWayView.h
//  HWTou
//
//  Created by 彭鹏 on 2017/3/31.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PaymentRequest.h"

@class PaymentWayDM;

@protocol PaymentWayDelegate <NSObject>

@optional

- (void)onPaymentWay:(PaymentWay)way;

@end


@interface PaymentWayView : UIView

@property (nonatomic, weak) id<PaymentWayDelegate> delegate;

/** 支付方式模型，二维数组 */
@property (nonatomic, copy) NSArray<NSArray<PaymentWayDM *> *> *listData;

/** 实付金额 */
@property (nonatomic, assign) CGFloat realPrice;

/** 提前花余额 */
@property (nonatomic, assign) CGFloat gold;

@end
