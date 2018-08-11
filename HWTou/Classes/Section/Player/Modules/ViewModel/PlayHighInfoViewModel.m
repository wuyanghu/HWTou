//
//  PlayHighInfoViewModel.m
//  HWTou
//
//  Created by robinson on 2018/1/5.
//  Copyright © 2018年 LieMi. All rights reserved.
//

#import "PlayHighInfoViewModel.h"

@implementation PlayHighInfoViewModel

//去除重复的，加载历史数据
- (void)bindWithDic:(NSDictionary *)dic isRefresh:(BOOL)isRefresh{
    
    NSArray *array = [dic objectForKey:@"data"][@"topComDetails"];
    if ([array isKindOfClass:[NSNull class]]) {
        return;
    }
    NSMutableArray * newResultArr = [NSMutableArray array];
    
    for (int i=0; i<array.count; i++) {
        NSDictionary *mDic = [array objectAtIndex:i];
        HistoryTopModel * newTopModel = [[HistoryTopModel alloc] init];
        [newTopModel setValuesForKeysWithDictionary:mDic];
        
        NSInteger currentPlayIndex = [self.dataArray indexOfObject:newTopModel];
        if (currentPlayIndex == NSNotFound) {
            [newResultArr addObject:newTopModel];//未找到
        }else{
            [self.dataArray replaceObjectAtIndex:currentPlayIndex withObject:newTopModel];//找到替换最新的
        }
    }
    
    if (isRefresh) {//把数据加到前面
        NSRange range = NSMakeRange(0, [newResultArr count]);
        NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:range];
        [self.dataArray insertObjects:newResultArr atIndexes:indexSet];
    }else{//把数据加到后面
        NSRange range = NSMakeRange(self.dataArray.count-1, [newResultArr count]);
        NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:range];
        [self.dataArray insertObjects:newResultArr atIndexes:indexSet];
    }
    
    self.isMoreData = array.count < self.topComsParam.pagesize ? NO : YES;
}


//去除重复的，把model添加到前面
- (void)bindWithHigh:(NSDictionary *)dict{
    [self bindWithDic:dict isRefresh:YES];
}

//获取当前播放
- (NSInteger)getCurrentInt:(HistoryTopModel *)currentTopModel{
    NSInteger currentPlayIndex = [self.dataArray indexOfObject:currentTopModel];
    if (currentPlayIndex == NSNotFound) {
        NSLog(@"未找到");
        return -1;
    }else{
        NSLog(@"总共%ld条，获取当前第%ld条",self.dataArray.count,currentPlayIndex+1);
        return currentPlayIndex;
    }
    
}

#pragma mark - getter

- (NSMutableArray<HistoryTopModel *> *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (TopComsParam *)topComsParam{
    if (!_topComsParam) {
        _topComsParam = [TopComsParam new];
    }
    return _topComsParam;
}

@end
