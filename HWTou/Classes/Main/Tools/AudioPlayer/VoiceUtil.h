//
//  VoiceUtil.h
//  HWTou
//
//  Created by Reyna on 2018/1/4.
//  Copyright © 2018年 LieMi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,AVPlayerPlayState) {
    
    AVPlayerPlayStatePreparing = 0, // 准备播放
    AVPlayerPlayStatePlaying,      // 正在播放
    AVPlayerPlayStateStop,          // 播放结束
};

@interface VoiceUtil : NSObject
@property (nonatomic, assign, readonly) BOOL isPlaying;

+ (instancetype)sharedInstance;

- (void)playWithPlayUrlString:(NSString *)urlString;

- (NSString *)getCurrentPlayUrl;

//- (CMTime)playerCurrentDuration;
//- (CMTime)playerItemDuration;
//
//// 播放控制
//- (void)play;
- (void)pause;
- (void)stop;
- (void)clear;

@end
