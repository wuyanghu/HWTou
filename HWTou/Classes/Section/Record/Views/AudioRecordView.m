//
//  AudioRecordView.m
//  HWTou
//
//  Created by Reyna on 2017/12/26.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "AudioRecordView.h"
#import "PublicHeader.h"
#import "AudioRecorder.h"
#import "FayeFileManager.h"
#import "FayeRecordStateView.h"

@interface AudioRecordView () <AudioRecorderDelegate, FayeRecordStateViewDelegate> {
    CGFloat _viewHeight;
    CGFloat _leftWidth;
}

@property (nonatomic, strong) FayeRecordStateView *stateView;

@property (nonatomic, strong) UILabel *stateLab; //状态标签
@property (nonatomic, strong) UIButton *recordBtn; //录制按钮
@property (nonatomic, strong) UIButton *playerBtn; //播放按钮
@property (nonatomic, strong) UIButton *rerecordBtn; //重录按钮
@property (nonatomic, strong) UIButton *saveBtn; //保存按钮

@end

@implementation AudioRecordView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews {
    
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.colors = @[(__bridge id)UIColorFromHex(0x161a45).CGColor, (__bridge id)UIColorFromHex(0x191631).CGColor];
    gradientLayer.locations = @[@0.0, @0.5, @1.0];
    gradientLayer.startPoint = CGPointMake(0.5, 0);
    gradientLayer.endPoint = CGPointMake(0.5, 1.0);
    gradientLayer.frame = self.bounds;
    [self.layer insertSublayer:gradientLayer atIndex:0];
    
    _viewHeight = self.bounds.size.height;
    _leftWidth = (self.bounds.size.width - 97.5 * 3)/2.0;
    
    [self addSubview:self.stateView];
    [self addSubview:self.stateLab];
    
    [self addSubview:self.recordBtn];
    [self addSubview:self.playerBtn];
    [self addSubview:self.rerecordBtn];
    [self addSubview:self.saveBtn];
}

#pragma mark - AudioRecorderDelegate

- (void)recorderPrepare {
    //NSLog(@"准备中......");
    self.stateView.recordState = FayeRecordStatePrepare;
}

- (void)recorderRecording {
    //设置状态view开始录音
    self.stateView.recordState = FayeRecordStateRecording;
    [self.stateView beginRecord];
}

- (void)recorderFailed:(NSString *)failedMessage {
    //NSLog(@"失败：%@",failedMessage);
    self.stateView.recordState = FayeRecordStateClickRecord;
}

#pragma mark - FayeRecordStateViewDelegate

- (void)recordTimeOver {
    
    self.recordBtn.selected = NO;
    self.state = FayeVoiceStateDefault;
    self.stateView.recordState = FayeRecordStateRecordFinished;
    
    [[AudioRecorder shared] endRecord];
    [self.stateView endRecord];
}

#pragma mark - Api

- (void)clearRecord {
    
    self.recordBtn.selected = NO;
    self.state = FayeVoiceStateDefault;
    
    self.stateView.recordState = FayeRecordStateClickRecord;
    [[AudioRecorder shared] endRecord];
    [self.stateView endRecord];
    
    [FayeFileManager removeFile:[FayeFileManager filePath]];
}

#pragma mark - Action

- (void)recordBtnAction:(UIButton *)btn {
    btn.selected = !btn.selected;
    self.state = btn.selected ? FayeVoiceStateRecording : FayeVoiceStateDefault;
    
    if (btn.selected) {
        [AudioRecorder shared].delegate = self;
        NSString *filePath = [FayeFileManager filePath];
        NSLog(@"---------%@---------",filePath);
        [[AudioRecorder shared] beginRecordWithRecordPath:filePath];
    }else {
        
        self.stateView.recordState = FayeRecordStateRecordFinished;
        
        [[AudioRecorder shared] endRecord];
        [self.stateView endRecord];
    }
}

- (void)playBtnAction:(id)sender {
    
    if (self.state == FayeVoiceStateRecording) {
        self.recordBtn.selected = NO;
        self.state = FayeVoiceStateDefault;
        
        self.stateView.recordState = FayeRecordStateRecordFinished;
        [[AudioRecorder shared] endRecord];
        [self.stateView endRecord];
    }
    if ([FayeFileManager isExistWAVVoice]) {
        if (self.delegate) {
            [self.delegate playBtnAction];
        }
    }
    else {
        [HUDProgressTool showOnlyText:@"还没有录制哦～"];
    }
}

- (void)rerecordBtnAction:(id)sender {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"确定要重录吗？" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [self clearRecord];
    }];
    [alert addAction:okAction];
    [alert addAction:cancleAction];
    [self.superview.viewController presentViewController:alert animated:YES completion:^{
        
    }];
}

- (void)saveBtnAction:(id)sender {
    if (self.state == FayeVoiceStateRecording) {
        self.recordBtn.selected = NO;
        self.state = FayeVoiceStateDefault;
        
        self.stateView.recordState = FayeRecordStateRecordFinished;
        [[AudioRecorder shared] endRecord];
        [self.stateView endRecord];
    }
    if ([FayeFileManager isExistWAVVoice]) {
        if (self.delegate) {
            [self.delegate saveBtnAction];
        }
    }
    else {
        [HUDProgressTool showOnlyText:@"还没有录制哦～"];
    }
}

#pragma mark - Getter

- (FayeRecordStateView *)stateView {
    if (!_stateView) {
        _stateView = [[FayeRecordStateView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, 200) isPlayerStateView:NO];
        _stateView.recordState = FayeRecordStateClickRecord;
        _stateView.delegate = self;
    }
    return  _stateView;
}

- (UILabel *)stateLab {
    if (!_stateLab) {
        _stateLab = [[UILabel alloc] initWithFrame:CGRectMake(10, _viewHeight - 112.5 - 68 - 30, self.bounds.size.width - 20, 14)];
        _stateLab.text = @"最长【90分钟】录制哦";
        _stateLab.textColor = [UIColor whiteColor];
        _stateLab.font = SYSTEM_FONT(12);
        _stateLab.textAlignment = NSTextAlignmentCenter;
        
    }
    return _stateLab;
}

- (UIButton *)recordBtn {
    if (!_recordBtn) {
        _recordBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _recordBtn.frame = CGRectMake((self.bounds.size.width - 112.5)/2.0, _viewHeight - 112.5 - 68, 112.5, 112.5);
        [_recordBtn setBackgroundImage:[UIImage imageNamed:@"recording_button"] forState:UIControlStateNormal];
        [_recordBtn setBackgroundImage:[UIImage imageNamed:@"recording_button2"] forState:UIControlStateSelected];
        [_recordBtn addTarget:self action:@selector(recordBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _recordBtn;
}

- (UIButton *)playerBtn {
    if (!_playerBtn) {
        _playerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _playerBtn.frame = CGRectMake(_leftWidth, _viewHeight - 98, 97.5, 98);
        [_playerBtn setBackgroundImage:[UIImage imageNamed:@"record_btn_audition"] forState:UIControlStateNormal];
        [_playerBtn addTarget:self action:@selector(playBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        
        UILabel *playLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 98 - 22, 97.5, 12)];
        playLab.textAlignment = NSTextAlignmentCenter;
        playLab.textColor = [UIColor whiteColor];
        playLab.font = SYSTEM_FONT(12);
        playLab.text = @"试听";
        [_playerBtn addSubview:playLab];
    }
    return _playerBtn;
}

- (UIButton *)rerecordBtn {
    if (!_rerecordBtn) {
        _rerecordBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _rerecordBtn.frame = CGRectMake(_leftWidth + 97.5, _viewHeight - 98, 97.5, 98);
        [_rerecordBtn setBackgroundImage:[UIImage imageNamed:@"record_btn_reRecord"] forState:UIControlStateNormal];
        [_rerecordBtn addTarget:self action:@selector(rerecordBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        
        UILabel *rerecordLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 98 - 22, 97.5, 12)];
        rerecordLab.textAlignment = NSTextAlignmentCenter;
        rerecordLab.textColor = [UIColor whiteColor];
        rerecordLab.font = SYSTEM_FONT(12);
        rerecordLab.text = @"重录";
        [_rerecordBtn addSubview:rerecordLab];
    }
    return _rerecordBtn;
}

- (UIButton *)saveBtn {
    if (!_saveBtn) {
        _saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _saveBtn.frame = CGRectMake(_leftWidth + 97.5 * 2, _viewHeight - 98, 97.5, 98);
        [_saveBtn setBackgroundImage:[UIImage imageNamed:@"record_btn_save"] forState:UIControlStateNormal];
        [_saveBtn addTarget:self action:@selector(saveBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        
        UILabel *saveLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 98 - 22, 97.5, 12)];
        saveLab.textAlignment = NSTextAlignmentCenter;
        saveLab.textColor = [UIColor whiteColor];
        saveLab.font = SYSTEM_FONT(12);
        saveLab.text = @"保存";
        [_saveBtn addSubview:saveLab];
    }
    return _saveBtn;
}

@end
