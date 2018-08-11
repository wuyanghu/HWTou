//
//  HighInfoPlayInstance.m
//  HWTou
//
//  Created by robinson on 2018/1/8.
//  Copyright © 2018年 LieMi. All rights reserved.
//

#import "HighInfoPlayInstance.h"
#import "RadioRequest.h"
#import "PlayHighInfoViewModel.h"
#import "AudioPlayerView.h"
#import "ChatMusicListModel.h"

@interface HighInfoPlayInstance()<WMPlayerDelegate>
{
    NSInteger timeInter;//间隔
    BOOL isPlayBgMusic;
    BOOL isSingleCycle;//单曲循环
}
@property (nonatomic,strong) AudioPlayerView * audioPlayerView;
@property (nonatomic,strong) NSString *voiceUrl;
@property (nonatomic,assign) NSInteger currentPlay;//当前播放
@property (nonatomic,copy) HistoryTopModel * currentTopModel;//用于判断是否重复

@property (nonatomic,copy) ChatMusicListModel * bgCurrentMusicModel;//背景音乐播放
@property (nonatomic,assign) NSInteger bgCurrentPlay;//背景音乐
@end

@implementation HighInfoPlayInstance

#pragma mark - 动画处理

//监听播放是否结束
- (void)registerWithVoiceUrl:(NSString *)voiceUrl {
    
    if (![self.voiceUrl isEqualToString:voiceUrl]) {
        self.voiceUrl = voiceUrl;

        if ([self.audioPlayerView getUserPauseState]) {
            [self stopAnimation];
        }else{
            [self startAnimation];
        }
    }
}

//开始动画
- (void)startAnimation{
    if (self.voiceUrl) {
        NSString * startPostName = [NSString stringWithFormat:@"startSelfAnimation_%@",self.voiceUrl];
        [[NSNotificationCenter defaultCenter] postNotificationName:startPostName object:nil];
    }
    
}
//结束动画
- (void)stopAnimation{
    if (self.voiceUrl) {
        NSString * stopPostName = [NSString stringWithFormat:@"stopSelfAnimation_%@",self.voiceUrl];
        [[NSNotificationCenter defaultCenter] postNotificationName:stopPostName object:nil];
    }
    
}

#pragma mark - 播放逻辑

//播放最后一条
- (void)playLastUrl{
    _currentPlay = self.highInfoVM.dataArray.count - 1;
    [self playCurrentUrl];
}

//播放下一条
- (void)playNextUrl{
    _currentPlay--;
    [self playCurrentUrl];
}

//设置当前播放
- (void)setCurrentPlayModel:(HistoryTopModel *)topModel{
    _currentPlay = [self.highInfoVM getCurrentInt:topModel];
    [self playCurrentUrl];
}

/*
 播放当前
 没有数据时，一分钟一刷
 如果10条以内，自动播放，完成后time刷新
 如果10条，自动播放，完成后time刷新
 当用户自主点击播放某条信息时，播放该信息后按照置顶的时间向最新置顶内容播放
 */
- (void)playCurrentUrl{
    if (_currentPlay<0) {
        if (isPlayBgMusic) {
            _highRefreshViewBlock(nil);
        }else{
            _highBlock(nil);
        }
        
        [self timerRefresh];
        return;
    }
    
    NSLog(@"总共%ld条,播放第%ld条",self.highInfoVM.dataArray.count,_currentPlay+1);
    HistoryTopModel * topModel;
    
    if (_currentPlay<self.highInfoVM.dataArray.count) {
        topModel = self.highInfoVM.dataArray[_currentPlay];
    }else{
        topModel = self.highInfoVM.dataArray.lastObject;
        _currentPlay = [self.highInfoVM getCurrentInt:topModel];
    }
    
    if (_currentTopModel) {
        if (![_currentTopModel.comUrl isEqualToString:topModel.comUrl]) {//停止上一条的动画
            NSString * stopPostName = [NSString stringWithFormat:@"stopSelfAnimation_%@",_currentTopModel.comUrl];
            [[NSNotificationCenter defaultCenter] postNotificationName:stopPostName object:nil];
        }else{
            NSString * startPostName = [NSString stringWithFormat:@"startSelfAnimation_%@",self.voiceUrl];
            [[NSNotificationCenter defaultCenter] postNotificationName:startPostName object:nil];
        }
        
    }
    _currentTopModel = topModel;
    if (_highBlock) {
        isPlayBgMusic = NO;
        
        //如果背景音乐相同，则存储时长
        if ([_bgCurrentMusicModel.mUrl isEqualToString:self.audioPlayerView.URLString]) {
            _bgCurrentMusicModel.bgCurrentTime = [self.audioPlayerView getCurrentTime];
        }
        
        _highBlock(topModel);
        
        self.audioPlayerView.isNeedSeekToZero = NO;
        [self.audioPlayerView setURLString:topModel.comUrl];
    }
    [self registerWithVoiceUrl:topModel.comUrl];
}

#pragma mark - 播放背景音乐
- (void)playBgMusic{
    NSLog(@"播放当前背景音乐");
    if (self.chatMusicListArray.count == 0) {
        return;
    }
    if (_bgCurrentMusicModel) {
        
    }else{
        _bgCurrentMusicModel = self.chatMusicListArray.firstObject;
        _bgCurrentPlay = 0;
    }
    
    if (_bgCurrentMusicModel) {
        isPlayBgMusic = YES;
        
        if ([self.audioPlayerView.URLString isEqualToString:_bgCurrentMusicModel.mUrl] && isSingleCycle) {//单曲循环
            [self.audioPlayerView resetPlayer];
            [self.audioPlayerView play];
        }else{
            self.audioPlayerView.isNeedSeekToZero = NO;
            [self.audioPlayerView setURLString:_bgCurrentMusicModel.mUrl];
        }
        _highRefreshViewBlock(nil);
    }else{
        [self.audioPlayerView pause];
    }
    
}

- (void)playNextBgMusic{
    NSLog(@"播放下一首背景音乐");
    if (self.chatMusicListArray.count == 0) {
        return;
    }
    //如果背景音乐被播放过，继续播放
    if (_bgCurrentMusicModel.bgCurrentTime>0) {
        [self.audioPlayerView setSeekTime:_bgCurrentMusicModel.bgCurrentTime urlString:_bgCurrentMusicModel.mUrl];
        _bgCurrentMusicModel.bgCurrentTime = 0;
        return;
    }
    _bgCurrentPlay ++;
    if (_bgCurrentPlay<self.chatMusicListArray.count) {//循环播放
        
    }else{
        _bgCurrentPlay = 0;
    }
    _bgCurrentMusicModel = self.chatMusicListArray[_bgCurrentPlay];
    [self playBgMusic];
}

#pragma mark - 定时刷新

- (void)timerRefresh{
//    NSLog(@"启动定时刷新");
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(insideTopComsRequest) object:nil];
    [self performSelector:@selector(insideTopComsRequest) withObject:nil
               afterDelay:timeInter];
}

//获取重要信息-外部请求，与循环请求分开
- (void)externalTopComsRequest{
    isSingleCycle = NO;
    self.highInfoVM.topComsParam.chatId = _chatId;
    [RadioRequest getTopComs:self.highInfoVM.topComsParam success:^(NSDictionary * response) {
        
        NSArray *array = [response objectForKey:@"data"][@"topComDetails"];
        
        if ([array isKindOfClass:[NSNull class]] || array == nil || array.count == 0) {
            _highBlock(nil);
            [self playBgMusic];
            
            [self timerRefresh];
            return ;
        }
        if (_currentTopModel) {
            [self.highInfoVM bindWithHigh:response];
            _currentPlay = [self.highInfoVM getCurrentInt:_currentTopModel];
            if(_currentPlay == 0) {
                [self playNextUrl];
            }else{
                [self playCurrentUrl];
            }
            
            
        }else{
            [self.highInfoVM bindWithDic:response isRefresh:YES];//第一次
            [self playLastUrl];
        }
    } failure:^(NSError * error) {
        [self timerRefresh];
    }];
}

//获取重要信息
- (void)insideTopComsRequest{
    NSLog(@"15秒刷一次");
    self.highInfoVM.topComsParam.chatId = _chatId;
    [RadioRequest getTopComs:self.highInfoVM.topComsParam success:^(NSDictionary * response) {
        
        NSArray *array = [response objectForKey:@"data"][@"topComDetails"];
        
        if ([array isKindOfClass:[NSNull class]] || array == nil || array.count == 0) {
            [self playNextUrl];
            [self timerRefresh];
            return ;
        }
        if (_currentTopModel) {
            [self.highInfoVM bindWithHigh:response];
            _currentPlay = [self.highInfoVM getCurrentInt:_currentTopModel];
            [self playNextUrl];
            
        }else{
            [self.highInfoVM bindWithDic:response isRefresh:YES];//第一次
            [self playLastUrl];
        }
    } failure:^(NSError * error) {
        [self timerRefresh];
    }];
}

#pragma mark - WMPlayerDelegate
//播放
- (void)playerClickedPlayButton {
    [self startAnimation];
}
//暂停
- (void)playerClickedPauseButton {
    [self stopAnimation];
}

- (void)playerReadyToPlayWithStatus:(WMPlayerState)state {
    
}
//播放完成
- (void)playerFinishedPlay {
    [self stopAnimation];
    if (_currentPlay>0) {
        [self playNextUrl];
    }else{
        isSingleCycle = YES;
        [self timerRefresh];
        [self playNextBgMusic];
    }
}

- (void)playerFailedPlayWithStatus:(WMPlayerState)state {
    [self stopAnimation];
}

#pragma mark - getter、setter
- (PlayHighInfoViewModel *)highInfoVM{
    if (!_highInfoVM) {
        _highInfoVM = [[PlayHighInfoViewModel alloc] init];
    }
    return _highInfoVM;
}

- (AudioPlayerView *)audioPlayerView{
    if (!_audioPlayerView) {
        _audioPlayerView = [AudioPlayerView sharedInstance];
        _audioPlayerView.delegate = self;
    }
    return _audioPlayerView;
}

- (void)setChatId:(NSInteger)chatId{
    _chatId = chatId;
}

#pragma mark - 系统方法

//初始化方法
- (void)dataInit:(NSInteger)chatId{
    if (_chatId != chatId) {
        _currentTopModel = nil;
        _bgCurrentMusicModel = nil;
        isPlayBgMusic = NO;
    }
    _bgCurrentMusicModel = nil;
    _voiceUrl = nil;
    _highInfoVM = [[PlayHighInfoViewModel alloc] init];
    [self handleDelloc];
}

//销毁变量
- (void)handleDelloc{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(insideTopComsRequest) object:nil];
}

+ (instancetype)sharedInstance {
    static HighInfoPlayInstance *_instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    return _instance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        timeInter = 15;
    }
    return self;
}

@end
