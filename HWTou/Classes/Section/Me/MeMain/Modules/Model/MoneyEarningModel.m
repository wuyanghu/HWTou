//
//  MoneyEarningModel.m
//  HWTou
//
//  Created by Reyna on 2018/3/30.
//  Copyright © 2018年 LieMi. All rights reserved.
//

#import "MoneyEarningModel.h"

@implementation MoneyEarningModel

- (void)bindWithDic:(NSDictionary *)dic {
    
    self.userId = [[dic objectForKey:@"userId"] intValue];
    self.rtcId = [[dic objectForKey:@"rtcId"] intValue];
    self.rtcUid = [[dic objectForKey:@"rtcUid"] intValue];
    
    self.tipMoney = [dic objectForKey:@"tipMoney"];
    self.chargeType = [[dic objectForKey:@"chargeType"] intValue];
    self.tipTime = [dic objectForKey:@"tipTime"];
    
    self.flag = [[dic objectForKey:@"flag"] intValue];
    self.avater = [dic objectForKey:@"avater"];
    self.nickName = [dic objectForKey:@"nickName"];
    self.desc = [dic objectForKey:@"desc"];
    self.totalCount = [[dic objectForKey:@"totalCount"] intValue];
}

@end
