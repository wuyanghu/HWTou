//
//  MoneyAccountModel.m
//  HWTou
//
//  Created by Reyna on 2018/2/7.
//  Copyright © 2018年 LieMi. All rights reserved.
//

#import "MoneyAccountModel.h"

@implementation MoneyAccountModel

- (void)bindWithDic:(NSDictionary *)dic {

    self.userId = [[dic objectForKey:@"userId"] integerValue];
    self.balance = [dic objectForKey:@"balance"];
    self.freezen = [dic objectForKey:@"freezen"];
    self.qAward = [dic objectForKey:@"qAward"];
    self.iAward = [dic objectForKey:@"iAward"];
}

@end
