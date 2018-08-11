//
//  AudioPlayer.m
//  HWTou
//
//  Created by Reyna on 2017/12/28.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "AudioPlayer.h"
#import <AVFoundation/AVFoundation.h>

@interface AudioPlayer ()

@property (nonatomic, strong) AVPlayer *player;
@property (nonatomic, strong) AVPlayerItem *playerItem;

@end

@implementation AudioPlayer

#pragma mark - Api

+ (instancetype)sharedInstance {
    static AudioPlayer *player = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        player = [[AudioPlayer alloc] init];
    });
    return player;
}

- (void)play {
    if (self.player.rate == 0) {
        [self.player play];
    }
}

- (void)pause {
    if (self.player.rate == 1.0) {
        [self.player pause];
    }
}

#pragma mark - Notification

- (void)addNotification {
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    
    [center addObserver:self selector:@selector(videoPlayEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    [center addObserver:self selector:@selector(videoPlayError:) name:AVPlayerItemPlaybackStalledNotification object:nil];
    [center addObserver:self selector:@selector(videoPlayEnterBack:) name:UIApplicationDidEnterBackgroundNotification object:nil];
    [center addObserver:self selector:@selector(videoPlayBecomeActive:) name:UIApplicationDidBecomeActiveNotification object:nil];
}

- (void)removeNotification {
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    
    [center removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    [center removeObserver:self name:AVPlayerItemPlaybackStalledNotification object:nil];
    [center removeObserver:self name:UIApplicationDidEnterBackgroundNotification object:nil];
    [center removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];
    [center removeObserver:self];
}

- (void)videoPlayEnd:(NSNotification *)noti {
    NSLog(@"视频播放结束");
    
    [self.player seekToTime:kCMTimeZero];
    if (self.delegate) {
        [self.delegate audioPlayerFinishedPlay];
    }
}

- (void)videoPlayError:(NSNotification *)noti {
    NSLog(@"视频异常中断");
    
    [self pause];
}

- (void)videoPlayEnterBack:(NSNotification *)noti {
    NSLog(@"进入后台");
}

- (void)videoPlayBecomeActive:(NSNotification *)noti {
    NSLog(@"返回前台");
}

#pragma mark - URL

- (void)setUrlPath:(NSString *)urlPath {
    
    if (![_urlPath isEqualToString:urlPath]) {
        [self pause];
        
        AVPlayerItem *item = [AVPlayerItem playerItemWithURL:[NSURL URLWithString:urlPath]];
        if (_player) {
            [_player replaceCurrentItemWithPlayerItem:item];
        }
        else {
            _player = [[AVPlayer alloc] initWithPlayerItem:item];
        }
        
        _urlPath = urlPath;
    }
}

#pragma mark - Getter

- (AVPlayer *)player {
    if (!_player) {
        
        AVPlayerItem *item = [AVPlayerItem playerItemWithURL:[NSURL URLWithString:self.urlPath]];
        _player = [[AVPlayer alloc] initWithPlayerItem:item];
        [self addNotification];
    }
    return _player;
}

@end
