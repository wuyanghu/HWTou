//
//  RadioClassViewModel.m
//  HWTou
//
//  Created by Reyna on 2017/11/24.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "RadioClassViewModel.h"

@implementation RadioClassViewModel

- (void)bindWithDic:(NSDictionary *)dic {
    NSArray *array = [dic objectForKey:@"data"];
    if (array.count) {
        [self.dataArr removeAllObjects];
        
        for (int i=0; i<array.count; i++) {
            NSDictionary *d = [array objectAtIndex:i];
            RadioClassModel *m = [[RadioClassModel alloc] init];
            [m bindWithDic:d];
            [_dataArr addObject:m];
        }
        
        self.defaultVisibilityNum = 7;
        
        [self showSectionDataArr];
    }
}

- (void)showAllDataArr{
    [self.showDataArr removeAllObjects];
    [self.showDataArr addObjectsFromArray:_dataArr];
}

- (void)showSectionDataArr{
    [self.showDataArr removeAllObjects];
    if (_dataArr.count<7) {
        [self.showDataArr addObjectsFromArray:_dataArr];
    }else{
        for (int i = 0; i<7; i++) {
            [self.showDataArr addObject:_dataArr[i]];
        }
    }
}

- (NSMutableArray<RadioClassModel *> *)showDataArr{
    if (!_showDataArr) {
        _showDataArr = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _showDataArr;
}

- (NSMutableArray <RadioClassModel *> *)dataArr {
    if (!_dataArr) {
        _dataArr = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _dataArr;
}

@end
