//
//  CouponColViewController.h
//  HWTou
//
//  Created by 赤 那 on 2017/4/6.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CouponModel.h"
#import "BaseViewController.h"

@protocol CouponColViewControllerDelegate <NSObject>

- (void)onDidSelectItem:(CouponModel *)model withCouponType:(CouponType)type;

@end

@interface CouponColViewController : BaseViewController

@property (nonatomic, weak) id<CouponColViewControllerDelegate> m_Delegate;

- (id)initWithFrame:(CGRect)frame;

- (void)setCouponColViewControllerType:(CouponType)colType;

@end
