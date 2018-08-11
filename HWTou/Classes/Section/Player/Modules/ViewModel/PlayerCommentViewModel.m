//
//  PlayerCommentViewModel.m
//  HWTou
//
//  Created by Reyna on 2017/11/26.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "PlayerCommentViewModel.h"

@implementation PlayerCommentViewModel

- (void)bindWithDic:(NSDictionary *)dic {
    NSArray *array = [dic objectForKey:@"data"];
    if (array.count) {
        [self.dataArr removeAllObjects];
        
        for (int i=0; i<array.count; i++) {
            NSDictionary *d = [array objectAtIndex:i];
            PlayerCommentModel *m = [[PlayerCommentModel alloc] init];
            [m bindWithDic:d];
            [_dataArr addObject:m];
        }
    }
}

- (void)bindWithDic:(NSDictionary *)dic isRefresh:(BOOL)isRefresh {
    if (isRefresh) {
        [self.dataArr removeAllObjects];
    }
    
    NSArray *array = [dic objectForKey:@"data"];
    if (array.count) {
        for (int i=0; i<array.count; i++) {
            NSDictionary *d = [array objectAtIndex:i];
            PlayerCommentModel *m = [[PlayerCommentModel alloc] init];
            [m bindWithDic:d];
            [self.dataArr addObject:m];
        }
        
        self.isMoreData = array.count < self.pagesize ? NO : YES;
    }
    else {
        self.isMoreData = NO;
    }
}

- (NSMutableArray <PlayerCommentModel *> *)dataArr {
    if (!_dataArr) {
        _dataArr = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _dataArr;
}

@end
