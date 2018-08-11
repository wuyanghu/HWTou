//
//  FayeRecordStateView.m
//  HWTou
//
//  Created by Reyna on 2017/12/27.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "FayeRecordStateView.h"
#import "PublicHeader.h"
#import "FayeRecordModel.h"
#import "AudioRecorder.h"

static CGFloat const levelWidth = 3.0;
static CGFloat const levelMargin = 2.0;

@interface FayeRecordStateView () {
    BOOL _isPlayerStateView;
}

/**
 振幅界面相关
 */
@property (nonatomic, strong) UILabel *timeLab;              // 录音时长标签

@property (nonatomic, strong) UIView *levelContentView;       // 振幅所有视图的载体
@property (nonatomic, weak) CAShapeLayer *levelLayer;        // 振幅layer

@property (nonatomic, strong) NSMutableArray *currentLevels; // 当前振幅数组
@property (nonatomic, strong) NSMutableArray *allLevels;     // 所有收集到的振幅,预先保存，用于播放

@property (nonatomic, strong) UIBezierPath *levelPath;       // 画振幅的path

@property (nonatomic, strong) NSTimer *audioTimer;           // 录音时长/播放录音 计时器
@property (nonatomic, strong) CADisplayLink *levelTimer;     // 振幅计时器

@property (nonatomic, assign) NSInteger recordDuration;      // 录音时长

@property (nonatomic, strong) CADisplayLink *playTimer;      // 播放时振幅计时器

@end

@implementation FayeRecordStateView {
    NSInteger _allCount;
}

- (instancetype)initWithFrame:(CGRect)frame isPlayerStateView:(BOOL)isPlayerStateView {
    self = [super initWithFrame:frame];
    if (self) {
        _isPlayerStateView = isPlayerStateView;
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews {
    
    [self addSubview:self.levelContentView];
    [self addSubview:self.timeLab];
}

#pragma mark - displayLink

- (void)startMeterTimer {
    [self stopMeterTimer];
    self.levelTimer = [CADisplayLink displayLinkWithTarget:self selector:@selector(updateMeter)];
    
    if ([[UIDevice currentDevice].systemVersion floatValue] > 10.0) {
        self.levelTimer.preferredFramesPerSecond = 10;
    }else {
        self.levelTimer.frameInterval = 6;
    }
    [self.levelTimer addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
}

// 停止定时器
- (void)stopMeterTimer {
    [self.levelTimer invalidate];
}

#pragma mark - audioTimer

- (void)startAudioTimer {
    [self.audioTimer invalidate];
    if (_recordState != FayeRecordStatePlay) {
        _recordDuration = 0;
    }
    self.audioTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(addSeconed) userInfo:nil repeats:YES];
}

- (void)addSeconed {
    if (_recordState == FayeRecordStatePlay) {
        if (_recordDuration == [FayeRecordModel shared].duration) {
            [self.audioTimer invalidate];
            return;
        }
    }
    if (_recordDuration < 5400) {
        _recordDuration++;
        [self updateTimeLab];
    }
    else {
        if (self.delegate) {
            [self.delegate recordTimeOver];
        }
    }
}

- (void)updateTimeLab {
    NSString *text ;
    if (_recordDuration < 60) {
        text = [NSString stringWithFormat:@"00:%02zd",_recordDuration];
    }else {
        NSInteger minutes = _recordDuration / 60;
        NSInteger seconed = _recordDuration % 60;
        text = [NSString stringWithFormat:@"%zd:%02zd",minutes,seconed];
    }
    self.timeLab.text = text;
}

- (void)updateMeter {
    CGFloat level = [[AudioRecorder shared] levels];
    [self.currentLevels removeLastObject];
    [self.currentLevels insertObject:@(level) atIndex:0];
    
    [self.allLevels addObject:@(level)];
    NSLog(@"%@",self.allLevels);
    [self updateLevelLayer];
}

- (void)updateLevelLayer {
    self.levelPath = [UIBezierPath bezierPath];
    
    CGFloat height = CGRectGetHeight(self.levelLayer.frame);
    for (int i = 0; i < self.currentLevels.count; i++) {
        CGFloat x = i * (levelWidth + levelMargin) + 5;
        CGFloat pathH = [self.currentLevels[i] floatValue] * height;
        CGFloat startY = height / 2.0 - pathH / 2.0;
        CGFloat endY = height / 2.0 + pathH / 2.0;
        [_levelPath moveToPoint:CGPointMake(x, startY)];
        [_levelPath addLineToPoint:CGPointMake(x, endY)];
    }
    self.levelLayer.path = _levelPath.CGPath;
}

#pragma mark - setter

- (void)setRecordState:(FayeRecordState)recordState {
    
    self.levelContentView.hidden = YES;
    
//    [self.activityView stopAnimating];
    switch (recordState) {
        case FayeRecordStateDefault:
//            self.titleLb.text = @"按住说话";
            break;
        case FayeRecordStateClickRecord:
//            self.titleLb.text = @"点击录音";
            break;
        case FayeRecordStateTouchChangeVoice:
//            self.titleLb.text = @"按住变声";
            break;
        case FayeRecordStateListen:
//            self.titleLb.text = @"松手试听";
            break;
        case FayeRecordStateCancel:
//            self.titleLb.text = @"松手取消发送";
            break;
        case FayeRecordStatePrepare:
//            self.titleLb.text = @"准备中";
//            [self.activityView startAnimating];
            break;
        case FayeRecordStateRecording:
        {
            self.levelContentView.hidden = NO;
        }
            break;
        case FayeRecordStateRecordFinished:
        {
//            self.levelContentView.hidden = YES;
        }
            break;
        case FayeRecordStatePlay:
        {
            self.levelContentView.hidden = NO;
            if (_recordState == FayeRecordStatePlayPause) {
                [self resumePlay];
            }
            else {
                [self playAndMetering];
            }
        }
            break;
        case FayeRecordStatePlayPause:
        {
            self.levelContentView.hidden = NO;
            [self pausePlay];
        }
            break;
        case FayeRecordStatePreparePlay:
        {
            self.levelContentView.hidden = YES;
            [self preparePlay];
        }
            break;
        default:
            break;
    }
    
    _recordState = recordState;
}

#pragma mark - recorde play
// 开始录音
- (void)beginRecord {
    
    self.levelContentView.hidden = NO;
    
    // 开始录音先把上一次录音的振幅删掉
    [self.allLevels removeAllObjects];
    self.currentLevels = nil;
    [self startMeterTimer];
    [self startAudioTimer];
}

// 结束录音
- (void)endRecord {
    NSLog(@"endRecord---------结束录音");
    //    NSLog(@"%@",self.allLevels);
//    [FayeRecordModel shared].path = [Recorder shareInstance].recordPath;
    [FayeRecordModel shared].levels = [NSArray arrayWithArray:self.allLevels];
    [FayeRecordModel shared].duration = (NSTimeInterval)_recordDuration;
    
    if (self.recordState == FayeRecordStateClickRecord) {
        _recordDuration = 0;
        [self updateTimeLab];
    }
    [self stopMeterTimer];
    [self.audioTimer invalidate];
    self.currentLevels = nil;
    self.levelContentView.hidden = YES;
}

// 准备播放
- (void)preparePlay {
    
    [self.playTimer invalidate];
    [self.audioTimer invalidate];
    
    self.allLevels = [[FayeRecordModel shared].levels mutableCopy];
    [self.currentLevels removeAllObjects];
    
    for (NSInteger i = self.allLevels.count - 1 ; i >= self.allLevels.count - 10 ; i--) {
        CGFloat l = 0.05;
        if (i >= 0) {
            l = [self.allLevels[i] floatValue];
        }
        [self.currentLevels addObject:@(l)];
    }
//        NSLog(@"%@-----%@",self.allLevels,self.currentLevels);
    _recordDuration = [FayeRecordModel shared].duration;
    
    [self updateLevelLayer];
    [self updateTimeLab];
}

// 播放录音
- (void)playAndMetering {

    [self preparePlay];
    
    _recordDuration = 0;
    [self updateTimeLab];
    
    [self startPlayTimer];
    [self startAudioTimer];
}

- (void)resumePlay {
    [self startPlayTimer];
    [self.audioTimer setFireDate:[NSDate date]];
}

- (void)pausePlay {
    
    [self.playTimer invalidate];
    [self.audioTimer setFireDate:[NSDate distantFuture]];
}

- (void)startPlayTimer {
    _allCount = self.allLevels.count;
    [self.playTimer invalidate];
    self.playTimer = [CADisplayLink displayLinkWithTarget:self selector:@selector(updatePlayMeter)];
    
    if ([[UIDevice currentDevice].systemVersion floatValue] > 10.0) {
        self.playTimer.preferredFramesPerSecond = 10;
    }else {
        self.playTimer.frameInterval = 6;
    }
    [self.playTimer addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
}

- (void)updatePlayMeter {
    
    CGFloat value = 1 - (CGFloat)self.allLevels.count / _allCount;
    
    if (value == 1) {
        [self.playTimer invalidate];
        [self.audioTimer invalidate];
    }
    
    if (_playProgress) {
        _playProgress(value);
    }
    
    if (value == 1)  return;
    
    CGFloat level = [self.allLevels.firstObject floatValue];
    [self.currentLevels removeLastObject];
    [self.currentLevels insertObject:@(level) atIndex:0];
    [self.allLevels removeObjectAtIndex:0];
    [self updateLevelLayer];
}

#pragma mark - Getter

- (NSMutableArray *)allLevels {
    if (_allLevels == nil) {
        _allLevels = [NSMutableArray array];
    }
    return _allLevels;
}

- (NSMutableArray *)currentLevels {
    if (_currentLevels == nil) {
        _currentLevels = [NSMutableArray arrayWithArray:@[@0.05,@0.05,@0.05,@0.05,@0.05,@0.05,@0.05,@0.05,@0.05,@0.05]];
    }
    return _currentLevels;
}

- (UIView *)levelContentView {
    if (!_levelContentView) {
        _levelContentView = [[UIView alloc] initWithFrame:CGRectMake(30, 20, 200, 45)];
        _levelContentView.hidden = YES;
        
        UIView *roundView = [[UIView alloc] initWithFrame:CGRectMake(5, 5, 6, 6)];
        roundView.backgroundColor = UIColorFromHex(0xff6767);
        roundView.layer.cornerRadius = 3.f;
        roundView.layer.masksToBounds = YES;
        [_levelContentView addSubview:roundView];
        
        UILabel *recLab = [[UILabel alloc] initWithFrame:CGRectMake(16, 3, 40, 10)];
        recLab.textColor = UIColorFromHex(0xff6767);
        recLab.font = SYSTEM_FONT(9);
        recLab.text = _isPlayerStateView ? @"PLAY" : @"REC";
        [_levelContentView addSubview:recLab];
        
        UIImageView *musicIcon = [[UIImageView alloc] initWithFrame:CGRectMake(4, 25, 11, 19)];
        musicIcon.image = [UIImage imageNamed:@"record_music_icon"];
        [_levelContentView addSubview:musicIcon];
        
        [_levelContentView.layer addSublayer:self.levelLayer];
    }
    return _levelContentView;
}

- (UILabel *)timeLab {
    if (!_timeLab) {
        _timeLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 90, kMainScreenWidth, 40)];
        _timeLab.font = [UIFont boldSystemFontOfSize:36];
        _timeLab.textColor = [UIColor whiteColor];
        _timeLab.textAlignment = NSTextAlignmentCenter;
        _timeLab.text = @"00:00";
        [self.levelContentView addSubview:_timeLab];
    }
    return _timeLab;
}

- (CAShapeLayer *)levelLayer {
    if (!_levelLayer) {
        CAShapeLayer *layer = [CAShapeLayer layer];
        layer.frame = CGRectMake(14, 24, 80, 20);
        layer.strokeColor = UIColorFromRGBA(0xF6276B, 1.0).CGColor;
        layer.lineWidth = levelWidth;
        [self.levelContentView.layer addSublayer:layer];
        _levelLayer = layer;
    }
    return _levelLayer;
}

@end
