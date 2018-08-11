//
//  VoiceUtil.m
//  HWTou
//
//  Created by Reyna on 2018/1/4.
//  Copyright © 2018年 LieMi. All rights reserved.
//

#import "VoiceUtil.h"
#import "AudioPlayerView.h"

static void *kRateObservationContext = &kRateObservationContext;

@interface VoiceUtil () {
    
    BOOL _isPlay;
    BOOL seekToZeroBeforePlay;
    BOOL _isEnterBackgound;
}

@property (nonatomic, strong) NSString *urlString;
@property (nonatomic, strong) AVPlayer *mPlayer;
@property (nonatomic, strong) AVPlayerItem *mPlayerItem;

@end
@implementation VoiceUtil

#pragma mark - Api

+ (instancetype)sharedInstance {
    static VoiceUtil *nativeNamager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        nativeNamager = [[VoiceUtil alloc] init];
    });
    return nativeNamager;
}

- (void)playWithPlayUrlString:(NSString *)urlString {
    
    if ([self.urlString isEqualToString:urlString]) {
        seekToZeroBeforePlay = YES;
        [self play];
    }
    else {
        if (self.isPlaying) {
            [self stop];
        }
        
        self.urlString = urlString;
        
        if (_mPlayerItem) {
            [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:_mPlayerItem];
        }
        _mPlayerItem = [AVPlayerItem playerItemWithURL:[NSURL URLWithString:urlString]];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(playerItemDidReachEnd:)
                                                     name:AVPlayerItemDidPlayToEndTimeNotification
                                                   object:_mPlayerItem];
        
        seekToZeroBeforePlay = NO;
        if (_mPlayer) {
            [_mPlayer removeObserver:self forKeyPath:@"rate" context:kRateObservationContext];
        }
        _mPlayer = [AVPlayer playerWithPlayerItem:self.mPlayerItem];
        [self.mPlayer addObserver:self
                           forKeyPath:@"rate"
                              options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew
                              context:kRateObservationContext];
        
        if (self.mPlayer.currentItem != self.mPlayerItem) {
            [self.mPlayer replaceCurrentItemWithPlayerItem:self.mPlayerItem];
        }
        [self play];
    }
}

- (NSString *)getCurrentPlayUrl {
    return self.urlString;
}

- (CMTime)playerCurrentDuration {
    return [self.mPlayer currentTime];
}

- (CMTime)playerItemDuration {
    
    AVPlayerItem *playerItem = [_mPlayer currentItem];
    if (playerItem.status == AVPlayerItemStatusReadyToPlay){
        return([playerItem duration]);
    }
    return(kCMTimeInvalid);
}

#pragma mark - 通知

- (void)appEnteredForeground{
    NSLog(@"---EnteredForeground");
    //    _isEnterBackgound = NO;
    /**
     *  注意：appEnteredForeground 会在 AVPlayerItemStatusReadyToPlay（从后台回到前台会出发ReadyToPlay）
     *  之后被调用，顾设置 _isEnterBackgound = NO 的操作放在了 AVPlayerItemStatusReadyToPlay 之中
     */
}
- (void)appEnteredBackground{
    NSLog(@"---EnteredBackground");
    _isEnterBackgound = YES;
    [self pause];
}

/* 当前是否正在播放视频 */
- (BOOL)isPlaying {
    return [self.mPlayer rate] != 0.f;
}
/* 播放结束的时候回调这个方法. */
- (void)playerItemDidReachEnd:(NSNotification *)notification {
    /* 视频播放结束，再次播放需要从0位置开始播放 */
    seekToZeroBeforePlay = YES;
    [self updateCurrentPlayStatus:AVPlayerPlayStateStop];
}

- (void)updateCurrentPlayStatus:(AVPlayerPlayState)playState {

}

- (void)observeValueForKeyPath:(NSString *)path ofObject:(id)object change:(NSDictionary*)change context:(void*)context {
    if (context == kRateObservationContext){
        if (self.mPlayer.rate == 0) {
//            NSLog(@"__%d\n__%@",_isPlay,self.urlString);
            if (_isPlay) {
                [[AudioPlayerView sharedInstance] resumeByVoiceReplyEnd];
                [self postNotifiWithVoiceUrl:self.urlString];
            }
            _isPlay = NO;
            [self updateCurrentPlayStatus:AVPlayerPlayStateStop];
            
        }
        if (self.mPlayer.rate == 1) {
            [self updateCurrentPlayStatus:AVPlayerPlayStatePlaying];
            _isPlay = YES;
        }
    }
    else {
        [super observeValueForKeyPath:path ofObject:object change:change context:context];
    }
}

#pragma mark - PostNotification

- (void)postNotifiWithVoiceUrl:(NSString *)voiceUrl {
    
    NSString *postName = [NSString stringWithFormat:@"VoiceReplyPlayEnd_%@",voiceUrl];
    [[NSNotificationCenter defaultCenter] postNotificationName:postName object:nil userInfo:nil];
}

#pragma mark - 播放状态控制

- (void)play {
    
    [[AudioPlayerView sharedInstance] pauseForPlayVoiceReply];
    
    /* 如果视频正处于播发的结束位置，我们需要调回到初始位置
     进行播放. */
    if (YES == seekToZeroBeforePlay) {
        seekToZeroBeforePlay = NO;
        [self.mPlayer seekToTime:kCMTimeZero];
    }
    [_mPlayer play];
}

- (void)pause {
    [_mPlayer pause];
}

- (void)stop {
    [self pause];
}

- (void)clear {
    [self pause];
    self.urlString = nil;
    self.mPlayer = nil;
    self.mPlayerItem = nil;
}

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:_mPlayerItem];
    
    [self.mPlayer removeObserver:self forKeyPath:@"rate"];
    
    [self.mPlayer pause];
    
    self.mPlayer = nil;
    self.mPlayerItem = nil;
}

#pragma mark -

- (NSString *)urlString {
    if (!_urlString) {
        _urlString = @"";
    }
    return _urlString;
}

@end
