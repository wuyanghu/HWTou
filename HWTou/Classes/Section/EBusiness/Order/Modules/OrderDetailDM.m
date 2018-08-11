//
//  OrderDetailDM.m
//  HWTou
//
//  Created by 彭鹏 on 2017/4/1.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "OrderDetailDM.h"

@implementation OrderProductDM

@end

@implementation OrderBillDM

@end

@implementation OrderDetailDM

+ (NSDictionary *)modelContainerPropertyGenericClass
{
    return @{@"itemList" : [OrderProductDM class],
             @"bill" : [OrderBillDM class]};
}

@end
