//
//  MoneyListModel.m
//  HWTou
//
//  Created by Reyna on 2018/2/2.
//  Copyright © 2018年 LieMi. All rights reserved.
//

#import "MoneyListModel.h"

@implementation MoneyListModel

- (void)bindWithDic:(NSDictionary *)dic {

    self.rId = [[dic objectForKey:@"rId"] intValue];
    self.uid = [[dic objectForKey:@"uid"] intValue];
    self.createTime = [[dic objectForKey:@"createTime"] integerValue];
    self.endTime = [[dic objectForKey:@"endTime"] integerValue];
    self.financialType = [[dic objectForKey:@"financialType"] intValue];
    
    self.financialDesc = [dic objectForKey:@"financialDesc"];
    
    self.money = [dic objectForKey:@"money"];
    self.realAmt = [dic objectForKey:@"realAmt"];
    
    self.ordId = [dic objectForKey:@"ordId"];
    
    self.ordDate = [[dic objectForKey:@"ordDate"] integerValue];
    self.withdrawStatus = [[dic objectForKey:@"withdrawStatus"] intValue];
    self.rewardType = [[dic objectForKey:@"rewardType"] intValue];
}

@end
