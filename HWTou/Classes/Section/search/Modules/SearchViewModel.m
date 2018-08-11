//
//  SearchViewModel.m
//  HWTou
//
//  Created by robinson on 2017/12/21.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "SearchViewModel.h"

@implementation SearchViewModel

- (void)bindWithUserDic:(NSArray *)array isRefresh:(BOOL)isRefresh{
    
    if (isRefresh) {
        [self.userDataArray removeAllObjects];
    }
    
    for (NSDictionary * dict in array) {
        PersonHomeDM * likeModel = [PersonHomeDM new];
        [likeModel setValuesForKeysWithDictionary:dict];
        
        [self.userDataArray addObject:likeModel];
    }
}


- (void)bindWithDic:(NSArray *)array isRefresh:(BOOL)isRefresh{
    
    if (isRefresh) {
        [self.dataArray removeAllObjects];
    }
    
    for (NSDictionary * dict in array) {
        GuessULikeModel * likeModel = [GuessULikeModel new];
        [likeModel setValuesForKeysWithDictionary:dict];
        
        [self.dataArray addObject:likeModel];
    }
}

#pragma mark - getter

- (NSMutableArray<PersonHomeDM *> *)userDataArray{
    if (!_userDataArray) {
        _userDataArray = [NSMutableArray array];
    }
    return _userDataArray;
}

- (NSMutableArray<GuessULikeModel *> *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (SearchRtcDetailParam *)detailParam{
    if (!_detailParam) {
        _detailParam = [SearchRtcDetailParam new];
    }
    return _detailParam;
}

- (SearchUserParam *)userParam{
    if (!_userParam) {
        _userParam = [SearchUserParam new];
    }
    return _userParam;
}

@end
