//
//  CouponModel.h
//  HWTou
//
//  Created by 赤 那 on 2017/4/6.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, CouponType){
    
    CouponType_Product = 0,
    CouponType_Vouchers = 1,        // 代金券
    CouponType_Rates = 2,           // 加息劵
    CouponType_Experience = 3,      // 体验劵
    
};

@interface CouponModel : NSObject

@property (nonatomic, assign) NSInteger cuid;
@property (nonatomic, assign) NSInteger coupon_id;      // 优惠券模板编号
@property (nonatomic, strong) NSString *name;           // 优惠券名称
@property (nonatomic, assign) CouponType type;          // 优惠券类型(1:商城代金券,2:加息券,3:体验券)
@property (nonatomic, strong) NSString *rule;           // 规则 当type为1时，值为代金券金额
@property (nonatomic, assign) NSInteger status;         // 1：已使用 其他:未使用
@property (nonatomic, strong) NSString *start_time;     // 开始时间
@property (nonatomic, strong) NSString *end_time;       // 结束时间

@end

@interface CouponSelDM : CouponModel

@property (nonatomic, assign) BOOL selected;

@end
