//
//  PlayerHistoryViewModel.m
//  HWTou
//
//  Created by Reyna on 2017/12/5.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "PlayerHistoryViewModel.h"

@implementation PlayerHistoryViewModel

- (void)bindWithDic:(NSDictionary *)dic isRefresh:(BOOL)isRefresh{
    if (isRefresh) {
        [self.dataArr removeAllObjects];
    }
    
    NSArray *array = [dic objectForKey:@"data"];
    if ([array isKindOfClass:[NSNull class]]) {
        return;
    }
    for (int i=0; i<array.count; i++) {
        NSDictionary *mDic = [array objectAtIndex:i];
        PlayerHistoryModel *m = [[PlayerHistoryModel alloc] init];
        [m bindWithDic:mDic];
        [self.dataArr addObject:m];
    }
    
}

- (NSMutableArray *)dataArr {
    if (!_dataArr) {
        _dataArr = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _dataArr;
}

@end
