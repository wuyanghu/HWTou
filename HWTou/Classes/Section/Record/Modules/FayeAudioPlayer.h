//
//  FayeAudioPlayer.h
//  HWTou
//
//  Created by Reyna on 2017/12/27.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import "SingletonMacro.h"

@interface FayeAudioPlayer : NSObject

/**
 *  单例
 */
SingletonH();

/**
 播放音频
 
 @param audioPath 音频的本地路径
 @return 音频播放器
 */
- (AVAudioPlayer *)playAudioWith:(NSString *)audioPath;

/**
 恢复播放音频
 */
- (void)resumeCurrentAudio;

/**
 暂停播放
 */
- (void)pauseCurrentAudio;

/**
 停止播放
 */
- (void)stopCurrentAudio;


/**
 播放进度
 */
@property (nonatomic, assign, readonly) float progress;

@end
