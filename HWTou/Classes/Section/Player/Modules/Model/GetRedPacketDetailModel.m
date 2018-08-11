//
//  GetRedPacketDetailModel.m
//  HWTou
//
//  Created by Reyna on 2018/3/8.
//  Copyright © 2018年 LieMi. All rights reserved.
//

#import "GetRedPacketDetailModel.h"

@implementation GetRedPacketDetailModel

- (void)bindWithDic:(NSDictionary *)dic {
    
    self.getAvater = [dic objectForKey:@"getAvater"];
    self.getNickName = [dic objectForKey:@"getNickName"];
    self.getTime = [dic objectForKey:@"getTime"];
    self.getUserId = [dic objectForKey:@"getUserId"];
    self.getMoney = [dic objectForKey:@"getMoney"];
    
    self.getMax = [[dic objectForKey:@"getMax"] intValue];
}

@end
