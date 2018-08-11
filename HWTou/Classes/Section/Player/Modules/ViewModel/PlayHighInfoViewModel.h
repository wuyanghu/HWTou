//
//  PlayHighInfoViewModel.h
//  HWTou
//  重要信息
//  Created by robinson on 2018/1/5.
//  Copyright © 2018年 LieMi. All rights reserved.
//

#import "BaseViewModel.h"
#import "RadioRequest.h"
#import "HistoryTopModel.h"

@interface PlayHighInfoViewModel : BaseViewModel

@property (nonatomic,strong) TopComsParam * topComsParam;
@property (nonatomic,strong) NSMutableArray <HistoryTopModel *>* dataArray;
- (void)bindWithHigh:(NSDictionary *)dict;
//获取当前播放
- (NSInteger)getCurrentInt:(HistoryTopModel *)currentTopModel;
@end
