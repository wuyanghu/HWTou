//
//  CouponColCell.h
//  HWTou
//
//  Created by 赤 那 on 2017/4/6.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CouponModel.h"

#define kCouponColCellId        (@"CouponColCellId")

@class CouponSelDM;

@interface CouponColCell : UICollectionViewCell

@property (nonatomic, strong, readonly) CouponModel *m_Model;

- (void)setCouponColCellUpDataSource:(CouponModel *)model
               cellForRowAtIndexPath:(NSIndexPath *)indexPath;

@end

@interface CouponColSelectCell : CouponColCell

@property (nonatomic, strong) CouponSelDM *dmCoupon;

@end
