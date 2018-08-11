//
//  SearchViewModel.h
//  HWTou
//
//  Created by robinson on 2017/12/21.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "BaseViewModel.h"
#import "RotRequest.h"
#import "GuessULikeModel.h"
#import "PersonHomeDM.h"

@interface SearchViewModel : BaseViewModel
@property (nonatomic,strong) SearchRtcDetailParam * detailParam;
@property (nonatomic,strong) NSMutableArray<GuessULikeModel *> * dataArray;

@property (nonatomic,strong) SearchUserParam * userParam;
@property (nonatomic,strong) NSMutableArray<PersonHomeDM *> * userDataArray;//用户

- (void)bindWithDic:(NSArray *)array isRefresh:(BOOL)isRefresh;
- (void)bindWithUserDic:(NSArray *)array isRefresh:(BOOL)isRefresh;
@end
