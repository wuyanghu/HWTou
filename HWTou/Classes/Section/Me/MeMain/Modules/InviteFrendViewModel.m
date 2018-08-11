//
//  InviteFrendViewModel.m
//  HWTou
//
//  Created by robinson on 2018/1/16.
//  Copyright © 2018年 LieMi. All rights reserved.
//

#import "InviteFrendViewModel.h"

@implementation InviteFrendViewModel


- (void)bindWithArray:(NSArray *)array isRefresh:(BOOL)isRefresh{
    if (isRefresh) {
        [self.inviteDataArr removeAllObjects];
    }
    
    for (NSDictionary * dict in array) {
        InviteFrendModel * friendModel = [InviteFrendModel new];
        [friendModel setValuesForKeysWithDictionary:dict];
        friendModel.createTimeStr = [self cStringFromTimestamp:friendModel.createTime];
        
        [self.inviteDataArr addObject:friendModel];
    }
}

//时间戳——字符串时间
-(NSString *)cStringFromTimestamp:(NSInteger)timestamp{
    //时间戳转时间的方法
    NSDate *timeData = [NSDate dateWithTimeIntervalSince1970:timestamp/1000.0];
    NSDateFormatter *dateFormatter =[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString *strTime = [dateFormatter stringFromDate:timeData];
    return strTime;
}

- (NSMutableArray<InviteFrendModel *> *)inviteDataArr{
    if (!_inviteDataArr) {
        _inviteDataArr = [[NSMutableArray alloc] init];
    }
    return _inviteDataArr;
}

- (InviteListParam *)inviteListParam{
    if (!_inviteListParam) {
        _inviteListParam = [[InviteListParam alloc] init];
    }
    return _inviteListParam;
}

@end
