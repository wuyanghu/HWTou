//
//  PlayerHistoryManager.h
//  HWTou
//
//  Created by Reyna on 2017/12/6.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PlayerHistoryViewModel.h"

@interface PlayerHistoryManager : NSObject

+ (instancetype)sharedInstance;

/**
 写入最新的播放记录数据
 */
- (void)writeNewestPlayerHistoryModel:(PlayerHistoryModel *)phModel;

/**
 读取最近的播放记录数据
 */
- (PlayerHistoryModel *)readNewestPlayerHistoryModel;

@end
