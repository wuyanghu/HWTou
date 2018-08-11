//
//  CouponModel.m
//  HWTou
//
//  Created by 赤 那 on 2017/4/6.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "CouponModel.h"
#import <objc/runtime.h>

@implementation CouponModel

- (id)copyWithZone:(NSZone *)zone
{
    CouponModel *coupon = [[[self class] allocWithZone:zone] init];
    coupon.name = [_name copy];
    coupon.rule = [_rule copy];
    coupon.start_time = [_start_time copy];
    coupon.end_time   = [_end_time copy];
    coupon.status     = _status;
    coupon.type       = _type;
    coupon.coupon_id = _coupon_id;
    coupon.cuid      = _cuid;
    
    return coupon;
}

@end

@implementation CouponSelDM

- (id)copyWithZone:(NSZone *)zone {
    
    CouponSelDM *coupon = [super copyWithZone:zone];
    coupon.selected  = _selected;
    return coupon;
}

@end
