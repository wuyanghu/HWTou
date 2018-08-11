//
//  BaseViewModel.m
//  HWTou
//
//  Created by Reyna on 2017/11/23.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "BaseViewModel.h"

@implementation BaseViewModel

- (void)bindWithDic:(NSDictionary *)dic isRefresh:(BOOL)isRefresh {
    
}


- (void)insertData:(BOOL)isRefresh dataArray:(NSMutableArray *)dataArray newResultArr:(NSMutableArray *)newResultArr {
    if (isRefresh) {//把数据加到前面
        NSRange range = NSMakeRange(0, [newResultArr count]);
        NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:range];
        [dataArray insertObjects:newResultArr atIndexes:indexSet];
    }else{//把数据加到后面
        NSUInteger location = dataArray.count>0?dataArray.count-1:0;
        NSRange range = NSMakeRange(location, [newResultArr count]);
        NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:range];
        [dataArray insertObjects:newResultArr atIndexes:indexSet];
    }
}

@end
