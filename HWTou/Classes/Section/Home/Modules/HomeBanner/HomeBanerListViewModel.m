//
//  HomeBanerListViewModel.m
//  HWTou
//
//  Created by robinson on 2017/12/12.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "HomeBanerListViewModel.h"
#import "HomeBannerListModel.h"

@implementation HomeBanerListViewModel

- (void)bindWithDic:(NSArray *)data{
    [self.dataArray removeAllObjects];
    
    for (NSDictionary * dict in data) {
        
        HomeBannerListModel * listModel = [HomeBannerListModel new];
        [listModel setValuesForKeysWithDictionary:dict];
    
        [self.dataArray addObject:listModel];
    }
}

- (NSMutableArray<HomeBannerListModel *> *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (BannerListParam *)bannerListParam{
    if (!_bannerListParam) {
        _bannerListParam = [BannerListParam new];
    }
    return _bannerListParam;
}

@end
