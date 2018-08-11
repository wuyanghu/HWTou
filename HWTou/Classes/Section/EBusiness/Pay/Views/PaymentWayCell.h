//
//  PaymentWayCell.h
//  HWTou
//
//  Created by 彭鹏 on 2017/3/31.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PaymentWayDM;

@interface PaymentGoldCell : UITableViewCell

@property (nonatomic, strong) PaymentWayDM *dmWay;

/** 提前花余额 */
@property (nonatomic, assign) CGFloat gold;

@end

@interface PaymentWayCell : UITableViewCell

@property (nonatomic, strong) PaymentWayDM *dmWay;

@end
