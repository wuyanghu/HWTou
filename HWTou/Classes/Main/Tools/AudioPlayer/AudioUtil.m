//
//  AudioUtil.m
//  HWTou
//
//  Created by Reyna on 2017/11/25.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "AudioUtil.h"

#import <AVFoundation/AVFoundation.h>

@interface AudioUtil() <AVAudioPlayerDelegate>
@property (nonatomic, strong) AVAudioPlayer *player;
@property (nonatomic, strong) NSMutableArray *durationArr;

- (void)play;
@end

@implementation AudioUtil

# pragma mark -  SharedInstance

+ (instancetype)sharedInstance {
    
    static AudioUtil *sharedInstance = nil;
    static dispatch_once_t onceToken = 0;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[AudioUtil alloc] init];
    });
    return sharedInstance;
}

#pragma mark - Playlist

@synthesize playlist = _playlist;

- (void)setPlaylist:(NSArray *)playlist {
    
    NSMutableArray *playArray = [[NSMutableArray alloc] initWithCapacity:[playlist count]];
    NSError *error;
    
    for (NSURL *audioURL in playlist) {
        [playArray addObject:[[AVAudioPlayer alloc] initWithContentsOfURL:audioURL error:&error]];
        if (error) {
            NSLog(@"error: %@", error);
        }
    }
    
    _player = [playArray objectAtIndexedSubscript:0];
    
    _playlist = [playArray copy];
}

# pragma mark - Api

- (void)play {
    
    [self stopPlaying];
    
    [self.durationArr removeAllObjects];
    
    [_player prepareToPlay];
    _player.delegate = self;
    [_player play];
}

- (void)playNext {
    
    if (_player.playing) {
        [_player stop];
    }
    int nextIndex = (int)[_playlist indexOfObject:_player] + 1;
    _player = [_playlist objectAtIndexedSubscript:nextIndex];
    [self play];
}

- (void)playSingleFile:(NSURL *)audioURL {
    
    if (_player.playing) {
        
        [_player stop];
    }
    
    NSError *error;
    _player = [[AVAudioPlayer alloc] initWithContentsOfURL:audioURL error:&error];
    _player.numberOfLoops = -1;
    
    
    if (!error) {
        [self play];
    } else {
        NSLog(@"error: %@", error);
    }
    
}

- (void)playSingleFileWithStringPath:(NSString *)audioPath {
    
    if (_player.playing) {
        
        [_player stop];
    }
    
    NSError *error;
    NSData *data = [[NSFileManager defaultManager] contentsAtPath:audioPath];
    _player = [[AVAudioPlayer alloc] initWithData:data fileTypeHint:AVFileTypeMPEGLayer3 error:&error];
    _player.numberOfLoops = -1;
    
    if (!error) {
        [self play];
    } else {
        NSLog(@"error: %@", error);
    }
}

- (void)playSingleFileWithStringPath:(NSString *)audioPath downloadVC:(UIViewController *)downloadVC {
    
    if (_player.playing) {
        
        [_player stop];
    }
    
    NSError *error;
    NSData *data = [[NSFileManager defaultManager] contentsAtPath:audioPath];
    _player = [[AVAudioPlayer alloc] initWithData:data fileTypeHint:AVFileTypeMPEGLayer3 error:&error];
    _player.numberOfLoops = -1;
    
    
    if (!error) {
        if ([self isDownloadVCMatchingCurrentVC:downloadVC] == YES) {
            [self play];
        }
    } else {
        NSLog(@"error: %@", error);
    }
}

- (void)playPlaylistWithArrayOfURLs:(NSArray *)audioList {
    
    [self setPlaylist:audioList];
    [self play];
}

- (void)pausePlay {
    
    if (_player.playing) {
        [_player pause];
        
        NSTimeInterval cur = _player.currentTime;
        NSNumber *nCur = [NSNumber numberWithDouble:cur];
        [self.durationArr addObject:nCur];
    }
    //    else if(!_player.playing) {
    //        [_player play];
    //    }
}

- (void)resumePlay {
    if (!_player.playing) {
        
        NSNumber *nCur = [self.durationArr lastObject];
        NSTimeInterval cur = [nCur doubleValue];
        [_player setCurrentTime:cur];
        [_player play];
    }
}

- (void)stopPlaying {
    
    if (_player.playing) {
        
        [_player stop];
    }
    
//    NSLog(@"是否正在播放 = %d",_player.playing);
//    NSLog(@"是否在预播放 = %d",_player.prepareToPlay);
}

- (void)deleteLastDuration {
    
    if (_durationArr.count > 0) {
        
        [_durationArr removeLastObject];
    }
}

- (void)playReplyVoiceWithVoicePath:(NSString *)voicePath {
    
    if (_player.playing) {
        
        [_player stop];
    }
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSError *error;
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:voicePath]];
        _player = [[AVAudioPlayer alloc] initWithData:data fileTypeHint:AVFileTypeMPEG4 error:&error];
        _player.numberOfLoops = 0;
    
        // 回到主线程
        dispatch_async(dispatch_get_main_queue(), ^{
            if (!error) {
                [self play];
            } else {
                NSLog(@"error: %@", error);
            }
        });
    });
}

#pragma mark - Sup


- (BOOL)isDownloadVCMatchingCurrentVC:(UIViewController *)downloadVC {
    
    if ([self findTopViewController:[self getCurrentVC]] == downloadVC) {
        return YES;
    }
    else {
        return NO;
    }
}

- (UIViewController *)getCurrentVC {
    UIViewController *result = nil;
    
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal) {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows) {
            if (tmpWin.windowLevel == UIWindowLevelNormal) {
                window = tmpWin;
                break;
            }
        }
    }
    
    UIView *frontView = [[window subviews] objectAtIndex:0];
    id nextResponder = [frontView nextResponder];
    
    if ([nextResponder isKindOfClass:[UIViewController class]]) {
        result = nextResponder;
    }
    else {
        result = window.rootViewController;
    }
    
    return result;
}

- (id)findTopViewController:(id)controller {
    
    if ([controller isKindOfClass:[UITabBarController class]]) {
        UITabBarController *tab = (UITabBarController *)controller;
        return [self findTopViewController:[tab selectedViewController]];
    }
    else if ([controller isKindOfClass:[UINavigationController class]]) {
        UINavigationController *nav = (UINavigationController *)controller;
        return [self findTopViewController:[nav visibleViewController]];
    }
    else if ([controller isKindOfClass:[UIViewController class]]) {
        return controller;
    }
    else {
        NSLog(@"Failed with controllerClass in AudioUtil.m 235");
        return nil;
    }
}

#pragma mark - Delegates

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    NSLog(@"播放完成");
    if (!flag) {
        NSLog(@"player finished playing unsuccessfully");
    } else {
        if ([_playlist count] >= 1) {
            [self playNext];
        }
    }
}

#pragma mark - Lazy

- (NSMutableArray *)durationArr {
    if (!_durationArr) {
        _durationArr = [NSMutableArray array];
    }
    return _durationArr;
}

+ (void)editVideoSynthesizeVieoPath:(NSURL *)assetURL BGMPath:(NSURL *)BGMPath  needOriginalVoice:(BOOL)needOriginalVoice videoVolume:(CGFloat)videoVolume BGMVolume:(CGFloat)BGMVolume complition:(void (^)(NSURL *outputPath,BOOL isSucceed)) completionHandle{
    //    素材
    AVAsset *asset = [AVAsset assetWithURL:assetURL];
    AVAsset *audioAsset = [AVAsset assetWithURL:BGMPath];
    
    //    分离素材
    AVAssetTrack *videoAssetTrack = [[asset tracksWithMediaType:AVMediaTypeVideo]objectAtIndex:0];//视频素材
    AVAssetTrack *audioAssetTrack = [[audioAsset tracksWithMediaType:AVMediaTypeAudio]objectAtIndex:0];//音频素材
    
    //    编辑视频环境
    AVMutableComposition *composition = [[AVMutableComposition alloc]init];
    
    //    视频素材加入视频轨道
    AVMutableCompositionTrack *videoCompositionTrack = [composition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
    [videoCompositionTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, videoAssetTrack.timeRange.duration) ofTrack:videoAssetTrack atTime:kCMTimeZero error:nil];
    
    //    音频素材加入音频轨道
    AVMutableCompositionTrack *audioCompositionTrack = [composition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
    [audioCompositionTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, videoAssetTrack.timeRange.duration) ofTrack:audioAssetTrack atTime:kCMTimeZero error:nil];
    
    //    是否加入视频原声
    AVMutableCompositionTrack *originalAudioCompositionTrack = nil;
    if (needOriginalVoice) {
        AVAssetTrack *originalAudioAssetTrack = [[asset tracksWithMediaType:AVMediaTypeAudio]objectAtIndex:0];
        originalAudioCompositionTrack = [composition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
        [originalAudioCompositionTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, videoAssetTrack.timeRange.duration) ofTrack:originalAudioAssetTrack atTime:kCMTimeZero error:nil];
    }
    
    //    导出素材
    AVAssetExportSession *exporter = [[AVAssetExportSession alloc]initWithAsset:composition presetName:AVAssetExportPresetMediumQuality];
    
    //    音量控制
    CMTime duration = videoAssetTrack.timeRange.duration;
    CGFloat videoDuration = duration.value / (float)duration.timescale;
    exporter.audioMix = [self buildAudioMixWithVideoTrack:originalAudioCompositionTrack VideoVolume:videoVolume BGMTrack:audioCompositionTrack BGMVolume:BGMVolume controlVolumeRange:CMTimeMake(0, videoDuration)];
    
    //    设置输出路径
    NSURL *outputPath = [self exporterPath];
    exporter.outputURL = [self exporterPath];
    exporter.outputFileType = AVFileTypeMPEG4;//指定输出格式
    
    [exporter exportAsynchronouslyWithCompletionHandler:^{
        switch ([exporter status]) {
            case AVAssetExportSessionStatusFailed: {
                NSLog(@"合成失败：%@",[[exporter error] description]);
                completionHandle(outputPath,NO);
            } break;
            case AVAssetExportSessionStatusCancelled: {
                completionHandle(outputPath,NO);
            } break;
            case AVAssetExportSessionStatusCompleted: {
                completionHandle(outputPath,YES);
            } break;
            default: {
                completionHandle(outputPath,NO);
            } break;
        }
    }];
}

#pragma mark - 调节合成的音量
+ (AVAudioMix *)buildAudioMixWithVideoTrack:(AVCompositionTrack *)videoTrack VideoVolume:(float)videoVolume BGMTrack:(AVCompositionTrack *)BGMTrack BGMVolume:(float)BGMVolume controlVolumeRange:(CMTime)volumeRange {
    
    //    创建音频混合类
    AVMutableAudioMix *audioMix = [AVMutableAudioMix audioMix];
    
    //    拿到视频声音轨道设置音量
    AVMutableAudioMixInputParameters *Videoparameters = [AVMutableAudioMixInputParameters audioMixInputParametersWithTrack:videoTrack];
    [Videoparameters setVolume:videoVolume atTime:volumeRange];
    
    //    设置背景音乐音量
    AVMutableAudioMixInputParameters *BGMparameters = [AVMutableAudioMixInputParameters audioMixInputParametersWithTrack:BGMTrack];
    [Videoparameters setVolume:BGMVolume atTime:volumeRange];
    
    //    加入混合数组
    audioMix.inputParameters = @[Videoparameters,BGMparameters];
    
    return audioMix;
}

#pragma mark - 音视频剪辑,如果是视频把下面的类型换为AVFileTypeAppleM4V
+ (void)cutAudioVideoResourcePath:(NSURL *)assetURL startTime:(CGFloat)startTime endTime:(CGFloat)endTime complition:(void (^)(NSURL *outputPath,BOOL isSucceed)) completionHandle{
    //    素材
    AVAsset *asset = [AVAsset assetWithURL:assetURL];
    
    //    导出素材
    AVAssetExportSession *exporter = [[AVAssetExportSession alloc]initWithAsset:asset presetName:AVAssetExportPresetAppleM4A];
    
    //剪辑(设置导出的时间段)
    CMTime start = CMTimeMakeWithSeconds(startTime, asset.duration.timescale);
    CMTime duration = CMTimeMakeWithSeconds(endTime - startTime,asset.duration.timescale);
    exporter.timeRange = CMTimeRangeMake(start, duration);
    
    //    输出路径
    NSURL *outputPath = [self exporterPath];
    exporter.outputURL = [self exporterPath];
    
    //    输出格式
    exporter.outputFileType = AVFileTypeAppleM4A;
    
    exporter.shouldOptimizeForNetworkUse= YES;
    
    //    合成后的回调
    [exporter exportAsynchronouslyWithCompletionHandler:^{
        switch ([exporter status]) {
            case AVAssetExportSessionStatusFailed: {
                NSLog(@"合成失败：%@",[[exporter error] description]);
                completionHandle(outputPath,NO);
            } break;
            case AVAssetExportSessionStatusCancelled: {
                completionHandle(outputPath,NO);
            } break;
            case AVAssetExportSessionStatusCompleted: {
                completionHandle(outputPath,YES);
            } break;
            default: {
                completionHandle(outputPath,NO);
            } break;
        }
    }];
}

#pragma mark - 输出路径
+ (NSURL *)exporterPath {
    
    NSInteger nowInter = (long)[[NSDate date] timeIntervalSince1970];
    NSString *fileName = [NSString stringWithFormat:@"output%ld.mp4",(long)nowInter];
    
    NSString *documentsDirectory = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject;
    
    NSString *outputFilePath =[documentsDirectory stringByAppendingPathComponent:fileName];
    
    if([[NSFileManager defaultManager]fileExistsAtPath:outputFilePath]){
        
        [[NSFileManager defaultManager]removeItemAtPath:outputFilePath error:nil];
    }
    
    return [NSURL fileURLWithPath:outputFilePath];
}

@end
