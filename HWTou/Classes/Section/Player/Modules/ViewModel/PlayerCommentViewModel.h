//
//  PlayerCommentViewModel.h
//  HWTou
//
//  Created by Reyna on 2017/11/26.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "BaseViewModel.h"
#import "PlayerCommentModel.h"

@interface PlayerCommentViewModel : BaseViewModel

@property (nonatomic, strong) NSMutableArray<PlayerCommentModel *> *dataArr;

@end
