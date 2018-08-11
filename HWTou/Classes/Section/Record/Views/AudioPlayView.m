//
//  AudioPlayView.m
//  HWTou
//
//  Created by Reyna on 2017/12/27.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "AudioPlayView.h"
#import "PublicHeader.h"
#import "FayeAudioPlayer.h"
//#import "FayeRecordModel.h"
#import "FayeFileManager.h"
#import "FayeRecordStateView.h"

@interface AudioPlayView () {
    CGFloat _leftWidth;
}

@property (nonatomic, strong) FayeRecordStateView *stateView;

@property (nonatomic, strong) UIButton *playButton; //播放按钮
@property (nonatomic, strong) UIButton *rerecordButton; //重录按钮
@property (nonatomic, strong) UIButton *saveButton; //保存按钮

@end


@implementation AudioPlayView

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubViews];
    }
    return self;
}

- (void)setupSubViews {
    
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.colors = @[(__bridge id)UIColorFromHex(0x161a45).CGColor, (__bridge id)UIColorFromHex(0x191631).CGColor];
    gradientLayer.locations = @[@0.0, @0.5, @1.0];
    gradientLayer.startPoint = CGPointMake(0.5, 0);
    gradientLayer.endPoint = CGPointMake(0.5, 1.0);
    gradientLayer.frame = self.bounds;
    [self.layer insertSublayer:gradientLayer atIndex:0];
   
    _leftWidth = (self.bounds.size.width - 97.5 * 2 - 112.5)/2.0;
    
    [self addSubview:self.stateView];
    [self addSubview:self.playButton];
    [self listenProgress]; // 监听进度
    [self addSubview:self.rerecordButton];
    [self addSubview:self.saveButton];
}

#pragma mark - Api

- (void)clearPlayer {
    
    if (self.stateView.recordState != FayeRecordStatePreparePlay) {
        
        [self stopPlay];
    }
}

#pragma mark - Action

- (void)playBtnAction:(id)sender {
    self.playButton.selected = !self.playButton.selected;
    if (self.playButton.selected) {
        if (self.stateView.recordState == FayeRecordStatePlayPause) {
            [[FayeAudioPlayer shared] resumeCurrentAudio];
        }
        else {
            [[FayeAudioPlayer shared] playAudioWith:[FayeFileManager filePath]];
        }
        self.stateView.recordState = FayeRecordStatePlay;
    }else {
//        [self stopPlay];
        [self pausePlay];
    }
}

- (void)stopPlay {
    self.playButton.selected = NO;
    self.stateView.recordState = FayeRecordStatePreparePlay;
    [[FayeAudioPlayer shared] stopCurrentAudio];
    _progressValue = 0;
}

- (void)pausePlay {
    self.playButton.selected = NO;
    self.stateView.recordState = FayeRecordStatePlayPause;
    [[FayeAudioPlayer shared] pauseCurrentAudio];
}

- (void)rerecordBtnAction:(id)sender {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"确定要重录吗？" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        if (self.delegate) {
            [self.delegate rerecordBtnAction];
        }
    }];
    [alert addAction:okAction];
    [alert addAction:cancleAction];
    [self.superview.viewController presentViewController:alert animated:YES completion:^{
        
    }];
}

- (void)saveBtnAction:(id)sender {
    
    if (self.delegate) {
        [self.delegate saveBtnAction];
    }
}

#pragma mark - PlayProgress

- (void)listenProgress {
    __weak typeof(self) weakSelf = self;
    self.stateView.playProgress = ^(CGFloat progress) {
        if (progress == 1) {
            progress = 0;
            [weakSelf stopPlay];
        }
        _progressValue = progress;
    };
}

#pragma mark - Getter

- (FayeRecordStateView *)stateView {
    if (!_stateView) {
        _stateView = [[FayeRecordStateView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, 200) isPlayerStateView:YES];
        _stateView.recordState = FayeRecordStatePreparePlay;
    }
    return  _stateView;
}

- (UIButton *)playButton {
    if (!_playButton) {
        _playButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _playButton.frame = CGRectMake((self.bounds.size.width - 112.5)/2.0, self.bounds.size.height - 112.5 - 68, 112.5, 112.5);
        [_playButton setBackgroundImage:[UIImage imageNamed:@"play_btn_play"] forState:UIControlStateNormal];
        [_playButton setBackgroundImage:[UIImage imageNamed:@"play_btn_zt"] forState:UIControlStateSelected];
        [_playButton addTarget:self action:@selector(playBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        
        UILabel *playLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 112.5 - 24, 112.5, 12)];
        playLab.textAlignment = NSTextAlignmentCenter;
        playLab.textColor = [UIColor whiteColor];
        playLab.font = SYSTEM_FONT(12);
        playLab.text = @"试听";
        [_playButton addSubview:playLab];
    }
    return _playButton;
}

- (UIButton *)rerecordButton {
    if (!_rerecordButton) {
        _rerecordButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _rerecordButton.frame = CGRectMake(_leftWidth, self.bounds.size.height - 98 - 74, 97.5, 98);
        [_rerecordButton setBackgroundImage:[UIImage imageNamed:@"record_btn_reRecord"] forState:UIControlStateNormal];
        [_rerecordButton addTarget:self action:@selector(rerecordBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        
        UILabel *cutLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 98 - 22, 97.5, 12)];
        cutLab.textAlignment = NSTextAlignmentCenter;
        cutLab.textColor = [UIColor whiteColor];
        cutLab.font = SYSTEM_FONT(12);
        cutLab.text = @"重录";
        [_rerecordButton addSubview:cutLab];
        
    }
    return _rerecordButton;
}

- (UIButton *)saveButton {
    if (!_saveButton) {
        _saveButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _saveButton.frame = CGRectMake(_leftWidth + 97.5 + 112.5, self.bounds.size.height - 98 - 74, 97.5, 98);
        [_saveButton setBackgroundImage:[UIImage imageNamed:@"record_btn_save"] forState:UIControlStateNormal];
        [_saveButton addTarget:self action:@selector(saveBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        
        UILabel *saveLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 98 - 22, 97.5, 12)];
        saveLab.textAlignment = NSTextAlignmentCenter;
        saveLab.textColor = [UIColor whiteColor];
        saveLab.font = SYSTEM_FONT(12);
        saveLab.text = @"保存";
        [_saveButton addSubview:saveLab];
    }
    return _saveButton;
}

@end
