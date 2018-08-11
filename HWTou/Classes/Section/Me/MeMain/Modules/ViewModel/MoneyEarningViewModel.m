//
//  MoneyEarningViewModel.m
//  HWTou
//
//  Created by Reyna on 2018/3/30.
//  Copyright © 2018年 LieMi. All rights reserved.
//

#import "MoneyEarningViewModel.h"

@implementation MoneyEarningViewModel

- (void)bindWithDic:(NSDictionary *)dic {
    
    NSDictionary *dddd = [dic objectForKey:@"data"];
    
    self.todayTips = [dddd objectForKey:@"todayTips"];
    self.allTips = [dddd objectForKey:@"allTips"];
    
    NSArray *array = [dddd objectForKey:@"tipRecordRes"];
    if (array.count) {
        [self.dataArr removeAllObjects];
        
        for (int i=0; i<array.count; i++) {
            NSDictionary *d = [array objectAtIndex:i];
            MoneyEarningModel *m = [[MoneyEarningModel alloc] init];
            [m bindWithDic:d];
            [_dataArr addObject:m];
        }
    }
}

- (void)bindWithDic:(NSDictionary *)dic isRefresh:(BOOL)isRefresh {
    if (isRefresh) {
        [self.dataArr removeAllObjects];
    }
    
    NSDictionary *dddd = [dic objectForKey:@"data"];
    
    self.todayTips = [dddd objectForKey:@"todayTips"];
    self.allTips = [dddd objectForKey:@"allTips"];
    
    NSArray *array = [dddd objectForKey:@"tipRecordRes"];
    if (array.count) {
        for (int i=0; i<array.count; i++) {
            NSDictionary *d = [array objectAtIndex:i];
            MoneyEarningModel *m = [[MoneyEarningModel alloc] init];
            [m bindWithDic:d];
            [self.dataArr addObject:m];
        }
        
        self.isMoreData = array.count < self.pagesize ? NO : YES;
    }
    else {
        self.isMoreData = NO;
    }
}

- (NSMutableArray <MoneyEarningModel *> *)dataArr {
    if (!_dataArr) {
        _dataArr = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _dataArr;
}

@end
