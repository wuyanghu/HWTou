//
//  PlayerHistoryViewModel.h
//  HWTou
//
//  Created by Reyna on 2017/12/5.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "BaseViewModel.h"
#import "PlayerHistoryModel.h"

@interface PlayerHistoryViewModel : BaseViewModel

@property (nonatomic, strong) NSMutableArray <PlayerHistoryModel *>* dataArr;

@end
