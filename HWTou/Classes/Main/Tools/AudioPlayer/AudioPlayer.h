//
//  AudioPlayer.h
//  HWTou
//
//  Created by Reyna on 2017/12/28.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, AudioPlayerStatus) {
    AudioPlayerStatusReadyToPlay = 0, // 准备好播放
    AudioPlayerStatusLoadingVideo,    // 加载视频
    AudioPlayerStatusPlayEnd,         // 播放结束
    AudioPlayerStatusCacheData,       // 缓冲视频
    AudioPlayerStatusCacheEnd,        // 缓冲结束
    AudioPlayerStatusPlayStop,        // 播放中断 （多是没网）
    AudioPlayerStatusItemFailed,      // 视频资源问题
    AudioPlayerStatusEnterBack,       // 进入后台
    AudioPlayerStatusBecomeActive,    // 从后台返回
};

@protocol AudioPlayerDelegate <NSObject>

- (void)audioPlayerFinishedPlay;

@end

@interface AudioPlayer : NSObject

@property (nonatomic, weak)id <AudioPlayerDelegate> delegate;
@property (nonatomic, strong) NSString *urlPath;

+ (instancetype)sharedInstance;

- (void)play;
- (void)pause;

@end
