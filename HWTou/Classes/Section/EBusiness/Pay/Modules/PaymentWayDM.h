//
//  PaymentWayDM.h
//  HWTou
//
//  Created by 彭鹏 on 2017/3/31.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PaymentRequest.h"

@interface PaymentWayDM : NSObject

@property (nonatomic, copy) NSString *imgName;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *detail;
@property (nonatomic, assign) BOOL selected;
@property (nonatomic, assign) PaymentWay payWay;

@end
