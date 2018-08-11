//
//  SubCommentViewModel.m
//  HWTou
//
//  Created by Reyna on 2017/11/28.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "SubCommentViewModel.h"

@implementation SubCommentViewModel

- (void)bindWithDic:(NSDictionary *)dic {
    
    NSArray *array = [dic objectForKey:@"data"];
    
    [self.dataArr removeAllObjects];
    for (int i=0; i<array.count; i++) {
        NSDictionary *mDic = [array objectAtIndex:i];
        SubCommentModel *m = [[SubCommentModel alloc] init];
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
