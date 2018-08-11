//
//  AudioPlayerViewController.h
//  HWTou
//
//  Created by Reyna on 2017/11/16.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "BaseViewController.h"
#import "PlayerHistoryModel.h"

//0:节目点播  1:电台广播
typedef NS_ENUM(NSUInteger, AudioPlayerControllerType) {
    VODAudioPlayerControllerType = 0,
    LSSAudioPlayerControllerType = 1,
};

@interface AudioPlayerViewController : BaseViewController

@property (nonatomic, strong) PlayerHistoryModel *historyModel;

- (void)reloadDataWithHistoryModel:(PlayerHistoryModel *)model;

@end
