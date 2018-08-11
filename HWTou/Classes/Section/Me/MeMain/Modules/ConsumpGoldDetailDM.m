//
//  ConsumpGoldDetailDM.m
//  HWTou
//
//  Created by 彭鹏 on 2017/7/11.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "ConsumpGoldDetailDM.h"

@implementation ConsumpGoldDetailDM

- (void)setMoney_order:(NSString *)money_order
{
    _money_order = money_order;
    self.price = money_order;
}
@end
