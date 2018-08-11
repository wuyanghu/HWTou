//
//  GuessULikeViewModel.m
//  HWTou
//
//  Created by robinson on 2017/12/11.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "GuessULikeViewModel.h"

@implementation GuessULikeViewModel
//热门推荐列表
- (void)bindWithGetHotRecList:(NSArray *)resultArr isRefresh:(BOOL)isRefresh{
    if (isRefresh) {
        [self.hotRecListArray removeAllObjects];
    }
    for (NSDictionary * resultDict in resultArr) {
        GetHotRecListModel * listModel = [GetHotRecListModel new];
        [listModel setValuesForKeysWithDictionary:resultDict];
        
        for (NSDictionary * rtcDetaiDict in resultDict[@"rtcDetail"]) {
            GuessULikeModel * uLikeModel = [GuessULikeModel new];
            [uLikeModel setValuesForKeysWithDictionary:rtcDetaiDict];
            
            [listModel.rtcDetailArr addObject:uLikeModel];
        }
        [self.hotRecListArray addObject:listModel];
    }
}

//猜你喜欢列表
- (void)bindWithGuessULike:(NSArray *)resultArr isRefresh:(BOOL)isRefresh{
    [self.likeArray removeAllObjects];
    for (NSDictionary * resultDict in resultArr) {
        GuessULikeModel * likeModel = [GuessULikeModel new];
        [likeModel setValuesForKeysWithDictionary:resultDict];
        
        [self.likeArray addObject:likeModel];
    }
}

//热门最新推荐列表
- (void)bindWithHotNewRecList:(NSArray *)resultArr isRefresh:(BOOL)isRefresh{
    if (isRefresh) {
        [self.hotNewRecListArray removeAllObjects];
    }
    for (NSDictionary * resultDict in resultArr) {
        GuessULikeModel * likeModel = [GuessULikeModel new];
        [likeModel setValuesForKeysWithDictionary:resultDict];
        
        [self.hotNewRecListArray addObject:likeModel];
    }
}

//热门换一批
- (void)bindWithGetHotRecChangeList:(NSDictionary *)data recListModel:(GetHotRecListModel * )recListModel{
    NSInteger count = [data[@"count"] integerValue];
    NSArray * rtcDetailListArr = data[@"RtcDetailList"];
    
    if (self.changeListParam.page*self.changeListParam.pagesize>count) {
        self.changeListParam.page = 1;
    }else{
        self.changeListParam.page++;
    }
    
    NSMutableArray * resultArr = [NSMutableArray array];
    for (NSDictionary * resultDict in rtcDetailListArr) {
        GuessULikeModel * likeModel = [GuessULikeModel new];
        [likeModel setValuesForKeysWithDictionary:resultDict];
        
        [resultArr addObject:likeModel];
    }
    if (resultArr.count!=0) {
        [recListModel.rtcDetailArr removeAllObjects];
        [recListModel.rtcDetailArr addObjectsFromArray:resultArr];
    }
}

#pragma mark - getter

- (HotRecChangeListParam *)changeListParam{
    if (!_changeListParam) {
        _changeListParam = [HotRecChangeListParam new];
        _changeListParam.page = 2;
        _changeListParam.pagesize = 3;
    }
    return _changeListParam;
}

- (GuessULikeParam *)guessULikeParam{
    if (!_guessULikeParam) {
        _guessULikeParam = [GuessULikeParam new];
    }
    return _guessULikeParam;
}

- (NSInteger)getSection{
    return 2+self.hotRecListArray.count;
}

- (NSMutableArray<GetHotRecListModel *> *)hotRecListArray{
    if (!_hotRecListArray) {
        _hotRecListArray = [[NSMutableArray alloc] init];
    }
    return _hotRecListArray;
}

- (NSMutableArray<GuessULikeModel *> *)likeArray{
    if (!_likeArray) {
        _likeArray = [[NSMutableArray alloc] init];
    }
    return _likeArray;
}

- (NSMutableArray<GuessULikeModel *> *)hotNewRecListArray{
    if (!_hotNewRecListArray) {
        _hotNewRecListArray = [[NSMutableArray alloc] init];
    }
    return _hotNewRecListArray;
}

@end
