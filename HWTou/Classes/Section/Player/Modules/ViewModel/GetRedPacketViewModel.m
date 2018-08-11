//
//  GetRedPacketViewModel.m
//  HWTou
//
//  Created by Reyna on 2018/3/8.
//  Copyright © 2018年 LieMi. All rights reserved.
//

#import "GetRedPacketViewModel.h"

@implementation GetRedPacketViewModel

- (void)bindWithDic:(NSDictionary *)dic {
    
    self.avater = [dic objectForKey:@"avater"];
    self.nickName = [dic objectForKey:@"nickName"];
    self.userAvater = [dic objectForKey:@"userAvater"];
    self.userNickName = [dic objectForKey:@"userNickName"];
    self.redText = [dic objectForKey:@"redText"];
    self.getRedMoney = [dic objectForKey:@"getRedMoney"];
    self.redDesc = [dic objectForKey:@"redDesc"];
    
    self.redState = [[dic objectForKey:@"redState"] intValue];
    self.fromUserId = [[dic objectForKey:@"fromUserId"] intValue];
    self.redRId = [[dic objectForKey:@"redRId"] intValue];
    
    [self.redLists removeAllObjects];
    NSArray *lists = [dic objectForKey:@"redLists"];
    for (int i=0; i<lists.count; i++) {
        NSDictionary *ddd = [lists objectAtIndex:i];
        GetRedPacketDetailModel *m = [[GetRedPacketDetailModel alloc] init];
        [m bindWithDic:ddd];
        [self.redLists addObject:m];
    }
}

#pragma mark - GET
- (NSMutableArray *)redLists {
    if (!_redLists) {
        _redLists = [NSMutableArray arrayWithCapacity:0];
    }
    return _redLists;
}

@end
