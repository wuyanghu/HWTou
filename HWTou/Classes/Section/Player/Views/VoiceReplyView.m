//
//  VoiceReplyView.m
//  HWTou
//
//  Created by Reyna on 2018/1/4.
//  Copyright © 2018年 LieMi. All rights reserved.
//

#import "VoiceReplyView.h"
#import "VoiceUtil.h"
#import "PublicHeader.h"


@interface VoiceReplyView () {
    NSMutableArray *_imgArr;
    BOOL _isPlaying;
}

@property (nonatomic, strong) NSString *voiceUrl;

@property (nonatomic, strong) UIButton *voiceBtn;
@property (nonatomic, strong) UILabel *voiceLab;
@property (nonatomic, strong) UIImageView *iconIV;
@end
@implementation VoiceReplyView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:CGRectMake(frame.origin.x, frame.origin.y, 158, 30)];
    if (self) {
        [self setupSelf];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setupSelf];
    }
    return self;
}

- (void)setupSelf {
    _voiceUrl = @"";
    _voiceDuration = 0;
    _imgArr = [[NSMutableArray alloc] initWithCapacity:0];
    for (int i=1; i<4; i++) {
        [_imgArr addObject:[UIImage imageNamed:[NSString stringWithFormat:@"voice_%d.png",i]]];
    }
    
    [self addSubview:self.voiceBtn];
    [self.voiceBtn addSubview:self.iconIV];
    [self.voiceBtn addSubview:self.voiceLab];
}

- (void)play {
    [[VoiceUtil sharedInstance] playWithPlayUrlString:self.voiceUrl];
    [self startSelfAnimation];
}

- (void)startSelfAnimation {
//    NSLog(@"开始动画 - %@",self.voiceUrl);
    [self.iconIV setAnimationImages:_imgArr];
    [self.iconIV setAnimationRepeatCount:0];
    [self.iconIV setAnimationDuration:3*0.25];
    [self.iconIV startAnimating];
}

- (void)stopSelfAnimation {
//    NSLog(@"停止动画 - %@",self.voiceUrl);
    [self.iconIV stopAnimating];
}

- (void)clearPlay {
    [[VoiceUtil sharedInstance] clear];
    [self stopSelfAnimation];
}

#pragma mark - Action

- (void)voiceBtnAction:(id)sender {
    if (_isClickPlay) {
        if (_voiceReplyDelegate) {
            [_voiceReplyDelegate voiceReplyViewClick];
        }
        return;
    }
    
    if (_voiceUrl) {
        if (![_voiceUrl isEqualToString:@""]) {
            [self play];
        }
        else {
            [HUDProgressTool showOnlyText:@"语音还未处理完成，请稍候下拉刷新"];
        }
    }
}

#pragma mark - NotificationResposeAction

- (void)voicePlayEnd:(NSNotification *)notification {

//    NSLog(@"end = %@",notification.name);
    [self stopSelfAnimation];
}

#pragma mark - Set

- (void)registerWithVoiceUrl:(NSString *)voiceUrl {
    
    if (![self.voiceUrl isEqualToString:voiceUrl]) {
        
        if (![self.voiceUrl isEqualToString:@""]) {
            NSString *postName = [NSString stringWithFormat:@"VoiceReplyPlayEnd_%@",self.voiceUrl];
            [[NSNotificationCenter defaultCenter] removeObserver:self name:postName object:nil];
            
            NSString * startPostName = [NSString stringWithFormat:@"startSelfAnimation_%@",self.voiceUrl];
            [[NSNotificationCenter defaultCenter] removeObserver:self name:startPostName object:nil];
            
            NSString * stopPostName = [NSString stringWithFormat:@"stopSelfAnimation_%@",voiceUrl];
            [[NSNotificationCenter defaultCenter] removeObserver:self name:stopPostName object:nil];

        }
        _voiceUrl = voiceUrl;
        NSString *newPostName = [NSString stringWithFormat:@"VoiceReplyPlayEnd_%@",voiceUrl];
        NSString * startPostName = [NSString stringWithFormat:@"startSelfAnimation_%@",voiceUrl];
        NSString * stopPostName = [NSString stringWithFormat:@"stopSelfAnimation_%@",voiceUrl];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(voicePlayEnd:) name:newPostName object:nil];//监听播放是否结束
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(startSelfAnimation) name:startPostName object:nil];//是否需要开启动画
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(stopSelfAnimation) name:stopPostName object:nil];//是否需要开启动画
//        NSLog(@"add - %@",newPostName);
    }
}

- (void)setVoiceDuration:(int)voiceDuration {
    if (_voiceDuration != voiceDuration) {
        _voiceDuration = voiceDuration;
        
        NSString *voiceLabText = [NSString stringWithFormat:@"%d\"",voiceDuration];
        self.voiceLab.text = voiceLabText;
        CGRect labRect = [voiceLabText boundingRectWithSize:CGSizeMake(MAXFLOAT, 20) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil];
        self.voiceLab.frame = CGRectMake(158 - labRect.size.width - 15, 5, labRect.size.width, 20);
    }
}

- (void)dealloc {

    if (![self.voiceUrl isEqualToString:@""]) {
        NSString *postName = [NSString stringWithFormat:@"VoiceReplyPlayEnd_%@",self.voiceUrl];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:postName object:nil];
        NSString * startPostName = [NSString stringWithFormat:@"startSelfAnimation_%@",self.voiceUrl];
        NSString * stopPostName = [NSString stringWithFormat:@"stopSelfAnimation_%@",self.voiceUrl];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:startPostName object:nil];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:stopPostName object:nil];
//        NSLog(@"remove移除 - %@",postName);
    }
}

#pragma mark - Getter

- (UIButton *)voiceBtn {
    if (!_voiceBtn) {
        _voiceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _voiceBtn.frame = self.bounds;
        [_voiceBtn setBackgroundImage:[UIImage imageNamed:@"ht_qipao"] forState:UIControlStateNormal];
        [_voiceBtn addTarget:self action:@selector(voiceBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _voiceBtn;
}

- (UIImageView *)iconIV {
    if (!_iconIV) {
        _iconIV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"voice"]];
        _iconIV.frame = CGRectMake(21, 5.5, 14, 17);
    }
    return _iconIV;
}

- (UILabel *)voiceLab {
    if (!_voiceLab) {
        _voiceLab = [[UILabel alloc] initWithFrame:CGRectMake(123, 5, 20, 20)];
        _voiceLab.font = SYSTEM_FONT(14);
        _voiceLab.textColor = [UIColor whiteColor];
        _voiceLab.textAlignment = NSTextAlignmentRight;
        _voiceLab.text = [NSString stringWithFormat:@"%d\"",_voiceDuration];
    }
    return _voiceLab;
}

@end
