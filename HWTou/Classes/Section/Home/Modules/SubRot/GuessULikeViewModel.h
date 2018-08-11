//
//  GuessULikeViewModel.h
//  HWTou
//
//  Created by robinson on 2017/12/11.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "BaseViewModel.h"
#import "GuessULikeModel.h"
#import "GetHotRecListModel.h"
#import "RotRequest.h"

@interface GuessULikeViewModel : BaseViewModel
@property (nonatomic,strong) NSMutableArray<GuessULikeModel *> * likeArray;//猜你喜欢
@property (nonatomic,strong) NSMutableArray<GuessULikeModel *> * hotNewRecListArray;//热门最新推荐
@property (nonatomic,strong) NSMutableArray<GetHotRecListModel *> * hotRecListArray;//热门推荐

@property (nonatomic,strong) GuessULikeParam * guessULikeParam;//猜你喜欢请求参数
@property (nonatomic,strong) HotRecChangeListParam * changeListParam;//热门换一批请求参数

- (void)bindWithGetHotRecList:(NSArray *)resultArr isRefresh:(BOOL)isRefresh;//热门推荐列表
- (void)bindWithGuessULike:(NSArray *)resultArr isRefresh:(BOOL)isRefresh;//猜你喜欢
- (void)bindWithHotNewRecList:(NSArray *)resultArr isRefresh:(BOOL)isRefresh;//热门最新推荐列表
- (void)bindWithGetHotRecChangeList:(NSDictionary *)data recListModel:(GetHotRecListModel * )recListModel;//热门换一批
- (NSInteger)getSection;
@end
