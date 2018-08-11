//
//  AudioPlayerView.h
//  HWTou
//
//  Created by Reyna on 2017/12/29.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

// 播放器的几种状态
typedef NS_ENUM(NSInteger, WMPlayerState) {
    WMPlayerStateFailed,          // 播放失败
    WMPlayerStateBuffering,       // 缓冲中
    WMPlayerStatePlaying,         // 播放中
    WMPlayerStateStopped,         // 播放停止
    WMPlayerStatePause,           // 播放暂停
};

// 枚举值，包含水平移动方向和垂直移动方向
typedef NS_ENUM(NSInteger, PanDirection){
    PanDirectionHorizontalMoved, // 横向移动
    PanDirectionVerticalMoved    // 纵向移动
};

@class AudioPlayerView;
@protocol WMPlayerDelegate <NSObject>
@optional
//播放器事件
-(void)playerClickedPlayButton;//播放
-(void)playerClickedPauseButton;//暂停
//播放失败的代理方法
-(void)playerFailedPlayWithStatus:(WMPlayerState)state;
//准备播放的代理方法
-(void)playerReadyToPlayWithStatus:(WMPlayerState)state;
//播放完毕的代理方法
-(void)playerFinishedPlay;

@end

@interface AudioPlayerView : UIView

/** 播放器的代理 */
@property (nonatomic, weak)id <WMPlayerDelegate> delegate;

@property (nonatomic, copy) NSString *URLString;

/**
 * 播放完毕是否需要回到初始值,默认为YES - (话题需要重播传YES)(聊吧需要下一段传NO)
 */
@property (nonatomic, assign) BOOL isNeedSeekToZero;

/**
 * 是否展示进度条
 */
@property (nonatomic, assign) BOOL isDisplayProgressBar;

+ (instancetype)sharedInstance;

- (BOOL)getUserPauseState;

- (void)play;
- (void)pause;

//重置播放器
- (void )resetPlayer;

- (void)resumeByVoiceReplyEnd;
- (void)pauseForPlayVoiceReply;

- (NSTimeInterval)getCurrentTime;
- (void)setSeekTime:(float)value urlString:(NSString *)urlString;

@end
