//
//  CollectionViewModel.h
//  HWTou
//
//  Created by robinson on 2017/12/27.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "BaseViewModel.h"

@class GuessULikeModel;

@interface CollectionViewModel : BaseViewModel
@property (nonatomic, strong) NSMutableArray<GuessULikeModel *> * dataArray;
@property (nonatomic,assign) int flag;
@end
