//
//  CollectionViewModel.m
//  HWTou
//
//  Created by robinson on 2017/12/27.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "CollectionViewModel.h"
#import "GuessULikeModel.h"

@implementation CollectionViewModel

- (void)bindWithDic:(NSDictionary *)dic isRefresh:(BOOL)isRefresh{
    NSArray *array = [dic objectForKey:@"data"];
    if (isRefresh) {
        [self.dataArray removeAllObjects];
    }
    
    for (int i=0; i<array.count; i++) {
        NSDictionary *d = [array objectAtIndex:i];
        GuessULikeModel *m = [[GuessULikeModel alloc] init];
        [m setValuesForKeysWithDictionary:d];
        [self.dataArray addObject:m];
    }
    
    self.isMoreData = array.count < self.pagesize ? NO : YES;
//    if (array.count) {
//        
//    }
//    else {
//        self.isMoreData = NO;
//    }
}

- (NSMutableArray<GuessULikeModel *> *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

@end
