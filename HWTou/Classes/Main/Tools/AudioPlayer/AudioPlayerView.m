//
//  AudioPlayerView.m
//  HWTou
//
//  Created by Reyna on 2017/12/29.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "AudioPlayerView.h"
#import "PublicHeader.h"
#import "MainTabBarPlayerBtn.h"

static void *PlayViewStatusObservationContext = &PlayViewStatusObservationContext;

@interface AudioPlayerView () <UIGestureRecognizerDelegate>

@property (nonatomic, strong) UIImageView *fastView; //快进快退View
@property (nonatomic, strong) UILabel *fastTimeLabel; //快进快退时间

@property (nonatomic, strong) UIProgressView *progressView; //进度条
@property (nonatomic, strong) UISlider *videoSlider; //滑杆

@property (nonatomic, strong) UIView *contentView; //背景View
@property (nonatomic, strong) UIActivityIndicatorView *loadingView; //加载菊花
@property (nonatomic, strong) UIButton *playOrPauseBtn; //播放暂停按钮
@property (nonatomic, strong) UIButton *playIconBtn; //播放暂停Icon
@property (nonatomic, strong) UIButton *loadFailedBtn; //加载失败后重新加载按钮

@property (nonatomic, assign) WMPlayerState state;

@property (nonatomic, strong) AVPlayer *player;
@property (nonatomic, retain) AVPlayerItem *currentItem;

/** 是否正在拖拽 */
@property (nonatomic, assign) BOOL isDragged;
@property (nonatomic, assign) NSInteger seekTime;
/** 用来保存快进的总时长 */
@property (nonatomic, assign) CGFloat sumTime;
/** slider上次的值 */
@property (nonatomic, assign) CGFloat sliderLastValue;
/** 定义一个实例变量，保存枚举值 */
@property (nonatomic, assign) PanDirection panDirection;
@property (nonatomic, strong) UIPanGestureRecognizer *panGesture;//快进快退手势

/** 是否被用户暂停 */
@property (nonatomic, assign) BOOL isPauseByUser;
/** 是否被打断 (YES -> 需要恢复 NO -> 不需要恢复)*/
@property (nonatomic, assign) BOOL isBeInterrupted;

@end

@implementation AudioPlayerView

+ (instancetype)sharedInstance {
    static AudioPlayerView *player = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        player = [[AudioPlayerView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenWidth * 250/375.0)];
    });
    return player;
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self initPlayer];
    }
    return self;
}

- (void)initPlayer {
    
    NSError *setCategoryErr = nil;
    NSError *activationErr  = nil;
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:&setCategoryErr];
    [[AVAudioSession sharedInstance] setActive:YES error:&activationErr];
    
    self.contentView = [[UIView alloc] init];
    [self addSubview:self.contentView];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    self.loadingView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [self.contentView addSubview:self.loadingView];
    [self.loadingView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.contentView);
    }];
    self.playOrPauseBtn.hidden = YES;
    
    self.playOrPauseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.playOrPauseBtn.showsTouchWhenHighlighted = YES;
    [self.playOrPauseBtn addTarget:self action:@selector(PlayOrPause:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.playOrPauseBtn];
    [self.playOrPauseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
    
    self.playIconBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.playIconBtn.userInteractionEnabled = NO;
    [self.playIconBtn setImage:[UIImage imageNamed:@"ts_icon_zt"] forState:UIControlStateNormal];
    [self.playIconBtn setImage:[UIImage imageNamed:@"ts_icon_play"] forState:UIControlStateSelected];
    [self.playOrPauseBtn addSubview:self.playIconBtn];
    [self.playIconBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.playOrPauseBtn);
        make.height.mas_equalTo(53);
        make.width.mas_equalTo(53);
    }];
    
    [self addSubview:self.progressView];
    [self addSubview:self.videoSlider];
    
    self.panGesture = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panDirection:)];
    self.panGesture.delegate = self;
    [self.panGesture setMaximumNumberOfTouches:1];
    [self.panGesture setDelaysTouchesBegan:YES];
    [self.panGesture setDelaysTouchesEnded:YES];
    [self.panGesture setCancelsTouchesInView:YES];
    [self addGestureRecognizer:self.panGesture];
    
    [self addSubview:self.fastView];
    [self.fastView addSubview:self.fastTimeLabel];
    
    [self.fastView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.contentView);
        make.width.mas_equalTo(123);
        make.height.mas_equalTo(18.5);
    }];
    [self.fastTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.fastView);
        make.width.mas_equalTo(123);
        make.height.mas_equalTo(18.5);
    }];
    
    self.isNeedSeekToZero = YES;
    self.isPauseByUser = NO;
}


- (BOOL)getUserPauseState {

    return self.isPauseByUser;
}

#pragma mark - VoiceReplyPause & Resume

- (void)pauseForPlayVoiceReply {
    
    if (self.state == WMPlayerStatePlaying) {
        [self pause];
        NSLog(@"被打断");
        self.isBeInterrupted = YES;
        if ([self.delegate respondsToSelector:@selector(playerClickedPauseButton)]) {
            [self.delegate playerClickedPauseButton];
        }
    }
}

- (void)resumeByVoiceReplyEnd {
 
    if (self.state == WMPlayerStatePause) {
        if (self.isBeInterrupted) {
            [self play];
            NSLog(@"恢复打断");
            self.isBeInterrupted = NO;
            if ([self.delegate respondsToSelector:@selector(playerClickedPlayButton)]) {
                [self.delegate playerClickedPlayButton];
            }
        }
    }
}

#pragma mark - Lazy

- (UIButton *)loadFailedBtn {
    if (_loadFailedBtn == nil) {
        _loadFailedBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_loadFailedBtn setTitle:@"加载失败,点击重试" forState:UIControlStateNormal];
        _loadFailedBtn.titleLabel.font = SYSTEM_FONT(14);
        [_loadFailedBtn addTarget:self action:@selector(failedBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_loadFailedBtn];
        
        [_loadFailedBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.contentView);
            make.width.equalTo(self.contentView);
            make.height.equalTo(@30);
        }];
    }
    return _loadFailedBtn;
}

- (UIProgressView *)progressView {
    if (!_progressView) {
        _progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, kMainScreenWidth * 250/375.0, kMainScreenWidth, 3)];
        _progressView.progressTintColor = UIColorFromHex(0xff6767);
        _progressView.trackTintColor = [UIColor whiteColor];
    }
    return _progressView;
}

- (UISlider *)videoSlider {
    if (!_videoSlider) {
        _videoSlider = [[UISlider alloc] initWithFrame:CGRectMake(0, kMainScreenWidth * 250/375.0 - 13.5, kMainScreenWidth, 30)];
        
        [_videoSlider setThumbImage:[UIImage imageNamed:@"ht_img_time"] forState:UIControlStateNormal];
        _videoSlider.maximumValue = 1;
        _videoSlider.minimumTrackTintColor = [UIColor clearColor];
        _videoSlider.maximumTrackTintColor = [UIColor clearColor];
        
        // slider开始滑动事件
        [_videoSlider addTarget:self action:@selector(progressSliderTouchBegan:) forControlEvents:UIControlEventTouchDown];
        // slider滑动中事件
        [_videoSlider addTarget:self action:@selector(progressSliderValueChanged:) forControlEvents:UIControlEventValueChanged];
        // slider结束滑动事件
        [_videoSlider addTarget:self action:@selector(progressSliderTouchEnded:) forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchCancel | UIControlEventTouchUpOutside];
        
        UITapGestureRecognizer *sliderTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapSliderAction:)];
        [_videoSlider addGestureRecognizer:sliderTap];
        
        UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panRecognizer:)];
        panRecognizer.delegate = self;
        [panRecognizer setMaximumNumberOfTouches:1];
        [panRecognizer setDelaysTouchesBegan:YES];
        [panRecognizer setDelaysTouchesEnded:YES];
        [panRecognizer setCancelsTouchesInView:YES];
        [_videoSlider addGestureRecognizer:panRecognizer];
    }
    return _videoSlider;
}

- (UIImageView *)fastView {
    if (!_fastView) {
        _fastView = [[UIImageView alloc] init];
    }
    return _fastView;
}

- (UILabel *)fastTimeLabel {
    if (!_fastTimeLabel) {
        _fastTimeLabel = [[UILabel alloc] init];
        _fastTimeLabel.textColor = [UIColor whiteColor];
        _fastTimeLabel.textAlignment = NSTextAlignmentCenter;
        _fastTimeLabel.font = SYSTEM_FONT(15);
    }
    return _fastTimeLabel;
}

#pragma mark - Sup

// 重置player
- (void)resetPlayer {
    
    self.playIconBtn.selected = YES;
    self.playOrPauseBtn.hidden = YES;
    self.loadFailedBtn.hidden = YES;
    self.fastView.hidden = YES;
    
    self.isPauseByUser = NO;
    
//    self.currentItem = nil;
//    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [self.player pause];
//    self.player = nil;    
    [self.player seekToTime:kCMTimeZero];
    
    if (self.isDisplayProgressBar) {
        self.progressView.progress = 0;
    }
}

- (void)refreshProgressUI {
    self.progressView.progress = 0;
    self.videoSlider.value = 0;
    [self.videoSlider setThumbImage:[self creatThumbImageWithText:@""] forState:UIControlStateNormal];
    
    CGFloat height = self.isDisplayProgressBar == YES ? 3 : 0;
    self.frame = CGRectMake(0, 0, kMainScreenWidth, kMainScreenWidth * 250/375.0 + height);
    self.progressView.hidden = !_isDisplayProgressBar;
    self.videoSlider.hidden = !_isDisplayProgressBar;
    self.panGesture.enabled = _isDisplayProgressBar;
}

- (void)playerCurrentTime:(NSInteger)currentTime totalTime:(NSInteger)totalTime sliderValue:(CGFloat)value {
    // 当前时长进度progress
    NSInteger proMin = currentTime / 60;//当前分
    NSInteger proSec = currentTime % 60;//当前秒
    // duration 总时长
    NSInteger durMin = totalTime / 60;//总分
    NSInteger durSec = totalTime % 60;//总秒
//    if (!self.isDragged) {
        // 更新slider
    self.videoSlider.value = value;
    
    NSString *cT = [NSString stringWithFormat:@"%02zd:%02zd",proMin,proSec];
    NSString *dT = [NSString stringWithFormat:@"%02zd:%02zd",durMin,durSec];
    NSString *thumbText = [NSString stringWithFormat:@"%@/%@",cT,dT];
    [self.videoSlider setThumbImage:[self creatThumbImageWithText:thumbText] forState:UIControlStateNormal];
    
    self.progressView.progress = value;
   
        // 更新当前播放时间
//        self.currentTimeLabel.text       = [NSString stringWithFormat:@"%02zd:%02zd", proMin, proSec];
//    }
    // 更新总时间
//    self.totalTimeLabel.text = [NSString stringWithFormat:@"%02zd:%02zd", durMin, durSec];
}


// 创建滑块图片
- (UIImage *)creatThumbImageWithText:(NSString *)text {
    UIImage *sourceImage = [UIImage imageNamed:@"ht_img_time"];
    CGSize imageSize = [sourceImage size]; //画的背景 大小
    UIGraphicsBeginImageContextWithOptions(imageSize, NO, 0.0);
    [sourceImage drawAtPoint:CGPointMake(0, 0)];
    //获得 图形上下文
    CGContextRef context=UIGraphicsGetCurrentContext();
    CGContextDrawPath(context, kCGPathStroke);
    
    //返回绘制的新图形
    UIFont *font = [UIFont systemFontOfSize:10];
    CGRect rect = CGRectMake(0, 0, imageSize.width, 19);
    CGFloat yOffset = (rect.size.height - font.pointSize) / 2.0 - 1.25;
    CGRect textRect = CGRectMake(0, yOffset, rect.size.width, rect.size.height - yOffset);
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle defaultParagraphStyle] mutableCopy];
    paragraphStyle.alignment = NSTextAlignmentCenter;
    [text drawInRect:textRect withAttributes:@{NSFontAttributeName: font, NSParagraphStyleAttributeName:paragraphStyle, NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    UIImage *newImage=UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

#pragma mark - Action

- (void)PlayOrPause:(UIButton *)sender {
    self.isPauseByUser = !self.isPauseByUser;
    if (self.isPauseByUser) {
        [self pause];
        if ([self.delegate respondsToSelector:@selector(playerClickedPauseButton)]) {
            [self.delegate playerClickedPauseButton];
        }
    } else {
        [self play];
        if ([self.delegate respondsToSelector:@selector(playerClickedPlayButton)]) {
            [self.delegate playerClickedPlayButton];
        }
    }
}

- (void)play {
    if (self.state == WMPlayerStatePause || self.state == WMPlayerStateStopped) {
        self.state = WMPlayerStatePlaying;
    }
    self.isPauseByUser = NO;
    [UIView animateWithDuration:2 animations:^{
        self.playOrPauseBtn.backgroundColor = [UIColor clearColor];
        self.playIconBtn.alpha = 0;
    } completion:^(BOOL finished) {
        
    }];
    self.playIconBtn.selected = NO;
    UIButton *btn = CYLExternPlusButton;
    btn.selected = YES;
    [self.player play];
}

- (void)pause {
    if (self.state == WMPlayerStatePlaying) {
        self.state = WMPlayerStatePause;
    }
    self.isPauseByUser = YES;
    self.playOrPauseBtn.backgroundColor =  [[UIColor blackColor] colorWithAlphaComponent:0.5];
    self.playIconBtn.alpha = 1;
    self.playIconBtn.selected = YES;
    UIButton *btn = CYLExternPlusButton;
    btn.selected = NO;
    [self.player pause];
}

- (void)failedBtnAction:(UIButton *)sender {
    self.loadFailedBtn.hidden = YES;
    self.isPauseByUser = NO;
    
    _currentItem = nil;
    AVURLAsset *urlAsset = [AVURLAsset assetWithURL:[NSURL URLWithString:self.URLString]];
    self.currentItem = [AVPlayerItem playerItemWithAsset:urlAsset];
    
    self.state = WMPlayerStateBuffering;
    [self play];
}

- (void)progressSliderTouchBegan:(UISlider *)slider {
    
//    [self progressSliderTouchBegan:sender];
}

- (void)progressSliderValueChanged:(UISlider *)slider {

    // 拖动改变视频播放进度
    if (self.player.currentItem.status == AVPlayerItemStatusReadyToPlay) {
        self.isDragged = YES;
        BOOL style = false;
        CGFloat value = slider.value - self.sliderLastValue;
        if (value > 0) {
            style = YES;
        }
        if (value < 0) {
            style = NO;
        }
        if (value == 0) {
            return;
        }
        self.sliderLastValue  = slider.value;
        CGFloat totalTime = (CGFloat)_currentItem.duration.value / _currentItem.duration.timescale;
        //计算出拖动的当前秒数
        CGFloat dragedSeconds = floorf(totalTime * slider.value);
        
        //转换成CMTime才能给player来控制播放进度
//        CMTime dragedCMTime = CMTimeMake(dragedSeconds, 1);
        
        [self playerDraggedTime:dragedSeconds totalTime:totalTime isForward:style hasPreview:NO];
        
        if (totalTime > 0) { // 当总时长 > 0时候才能拖动slider
            
        } else {
            // 此时设置slider值为0
            slider.value = 0;
        }
    } else { // player状态加载失败
        // 此时设置slider值为0
        slider.value = 0;
    }
}

- (void)progressSliderTouchEnded:(UISlider *)slider {
//    self.showing = YES;

     if (self.player.currentItem.status == AVPlayerItemStatusReadyToPlay) {
        self.isPauseByUser = NO;
        self.isDragged = NO;
        // 视频总时间长度
        CGFloat total = (CGFloat)_currentItem.duration.value / _currentItem.duration.timescale;
        //计算出拖动的当前秒数
        NSInteger dragedSeconds = floorf(total *slider.value);
        [self seekToTime:dragedSeconds completionHandler:nil];
    }
}

- (void)tapSliderAction:(UITapGestureRecognizer *)tap {
    if ([tap.view isKindOfClass:[UISlider class]]) {
        UISlider *slider = (UISlider *)tap.view;
        CGPoint point = [tap locationInView:slider];
        CGFloat length = slider.frame.size.width;
        // 视频跳转的value
        CGFloat tapValue = point.x / length;
        
        // 视频总时间长度
        CGFloat total = (CGFloat)self.currentItem.duration.value / self.currentItem.duration.timescale;
        //计算出拖动的当前秒数
        NSInteger dragedSeconds = floorf(total * tapValue);
        
        if (self.playIconBtn.selected) {
            self.isPauseByUser = NO;
            [UIView animateWithDuration:2 animations:^{
                self.playOrPauseBtn.backgroundColor = [UIColor clearColor];
                self.playIconBtn.alpha = 0;
            } completion:^(BOOL finished) {
                
            }];
            self.playIconBtn.selected = NO;
            UIButton *btn = CYLExternPlusButton;
            btn.selected = YES;
        }
        [self seekToTime:dragedSeconds completionHandler:^(BOOL finished) {}];
    }
}

// 不做处理，只是为了滑动slider其他地方不响应其他手势
- (void)panRecognizer:(UIPanGestureRecognizer *)sender {
    
}

#pragma mark - UIPanGestureRecognizer手势方法

- (void)panDirection:(UIPanGestureRecognizer *)pan {
    //根据在view上Pan的位置，确定是调音量还是亮度
//    CGPoint locationPoint = [pan locationInView:self.contentView];
    // 我们要响应水平移动和垂直移动
    // 根据上次和本次移动的位置，算出一个速率的point
    CGPoint veloctyPoint = [pan velocityInView:self];
    
    // 判断是垂直移动还是水平移动
    switch (pan.state) {
        case UIGestureRecognizerStateBegan: { // 开始移动
            // 使用绝对值来判断移动的方向
            CGFloat x = fabs(veloctyPoint.x);
            CGFloat y = fabs(veloctyPoint.y);
            if (x > y) {
                // 水平移动
                // 取消隐藏
                self.panDirection = PanDirectionHorizontalMoved;
                // 给sumTime初值
                CMTime time = self.player.currentTime;
                self.sumTime = time.value/time.timescale;
            } else if (x < y) {
                // 垂直移动
                self.panDirection = PanDirectionVerticalMoved;
                // 开始滑动的时候,状态改为正在控制音量
//                if (locationPoint.x > self.bounds.size.width / 2) {
//                    self.isVolume = YES;
//                }else { // 状态改为显示亮度调节
//                    self.isVolume = NO;
//                }
            }
            break;
        }
        case UIGestureRecognizerStateChanged: { // 正在移动
            switch (self.panDirection) {
                case PanDirectionHorizontalMoved:{
                    [self horizontalMoved:veloctyPoint.x]; // 水平移动的方法只要x方向的值
                    break;
                }
                case PanDirectionVerticalMoved:{
//                    [self verticalMoved:veloctyPoint.y]; // 垂直移动方法只要y方向的值
                    break;
                }
                default:
                    break;
            }
            break;
        }
        case UIGestureRecognizerStateEnded: { // 移动停止
            // 移动结束也需要判断垂直或者平移
            // 比如水平移动结束时，要快进到指定位置，如果这里没有判断，当我们调节音量完之后，会出现屏幕跳动的bug
            switch (self.panDirection) {
                case PanDirectionHorizontalMoved:{
                    self.isPauseByUser = NO;
                    [self seekToTime:self.sumTime completionHandler:nil];
                    // 把sumTime滞空，不然会越加越多
                    self.sumTime = 0;
                    break;
                }
                case PanDirectionVerticalMoved:{
                    // 垂直移动结束后，把状态改为不再控制音量
//                    self.isVolume = NO;
                    break;
                }
                default:
                    break;
            }
            break;
        }
        default:
            break;
    }
}

// pan水平移动的方法
- (void)horizontalMoved:(CGFloat)value {
    // 每次滑动需要叠加时间
    self.sumTime += value / 200;
    // 需要限定sumTime的范围
    CMTime totalTime = self.currentItem.duration;
    CGFloat totalMovieDuration = (CGFloat)totalTime.value/totalTime.timescale;
    if (self.sumTime > totalMovieDuration) {
        self.sumTime = totalMovieDuration;
    }
    if (self.sumTime < 0) { self.sumTime = 0; }
    
    BOOL style = false;
    if (value > 0) {
        style = YES;
    }
    if (value < 0) {
        style = NO;
    }
    if (value == 0) {
        return;
    }
    
    self.isDragged = YES;
    [self playerDraggedTime:self.sumTime totalTime:totalMovieDuration isForward:style hasPreview:NO];
}

- (void)playerDraggedTime:(NSInteger)draggedTime totalTime:(NSInteger)totalTime isForward:(BOOL)forawrd hasPreview:(BOOL)preview {
    // 快进快退时候停止菊花
    [self.loadingView stopAnimating];
    // 拖拽的时长
    NSInteger proMin = draggedTime / 60;//当前秒
    NSInteger proSec = draggedTime % 60;//当前分钟
    
    //duration 总时长
    NSInteger durMin = totalTime / 60;//总秒
    NSInteger durSec = totalTime % 60;//总分钟
    
    NSString *currentTimeStr = [NSString stringWithFormat:@"%02zd:%02zd", proMin, proSec];
    NSString *totalTimeStr = [NSString stringWithFormat:@"%02zd:%02zd", durMin, durSec];
    CGFloat  draggedValue = (CGFloat)draggedTime/(CGFloat)totalTime;
    NSString *timeStr = [NSString stringWithFormat:@"%@ / %@", currentTimeStr, totalTimeStr];
    
    // 显示、隐藏预览窗
    //    self.videoSlider.popUpView.hidden = !preview;
    // 更新slider的值
    //    self.videoSlider.value            = draggedValue;
    // 更新bottomProgressView的值
//    self.progressView.progress  = draggedValue;
    //    // 更新当前时间
    //    self.currentTimeLabel.text        = currentTimeStr;
    // 正在拖动控制播放进度
    self.isDragged = YES;
    
    if (forawrd) {
        self.fastView.image = [UIImage imageNamed:@"ht_img_wq"];
    } else {
        self.fastView.image = [UIImage imageNamed:@"ht_img_wh"];
    }
    self.fastView.hidden = preview;
    self.fastTimeLabel.text = timeStr;
}

// 从xx秒开始播放视频跳转
- (void)seekToTime:(NSInteger)dragedSeconds completionHandler:(void (^)(BOOL finished))completionHandler {
    if (self.player.currentItem.status == AVPlayerItemStatusReadyToPlay) {
        // seekTime:completionHandler:不能精确定位
        // 如果需要精确定位，可以使用seekToTime:toleranceBefore:toleranceAfter:completionHandler:
        // 转换成CMTime才能给player来控制播放进度
        [self.loadingView startAnimating];
        
        [self.player pause];
        CMTime dragedCMTime = CMTimeMake(dragedSeconds, 1); //kCMTimeZero
        __weak typeof(self) weakSelf = self;
        [self.player seekToTime:dragedCMTime toleranceBefore:CMTimeMake(1,1) toleranceAfter:CMTimeMake(1,1) completionHandler:^(BOOL finished) {
            [weakSelf.loadingView stopAnimating];
            // 视频跳转回调
            if (completionHandler) {
                completionHandler(finished);
            }
            [weakSelf.player play];
            weakSelf.seekTime = 0;
            weakSelf.isDragged = NO;
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                self.fastView.hidden = YES;
            });
            self.isDragged = NO;
            // 结束滑动时候把开始播放按钮改为播放状态
            if (self.playIconBtn.selected) {
                self.isPauseByUser = NO;
                [UIView animateWithDuration:2 animations:^{
                    self.playOrPauseBtn.backgroundColor = [UIColor clearColor];
                    self.playIconBtn.alpha = 0;
                } completion:^(BOOL finished) {
                    
                }];
                self.playIconBtn.selected = NO;
                UIButton *btn = CYLExternPlusButton;
                btn.selected = YES;
            }
            
//            if (!weakSelf.currentItem.isPlaybackLikelyToKeepUp) {
//                weakSelf.state = WMPlayerStateBuffering;
//            }
        }];
    }
}

#pragma mark - setItem

- (void)setCurrentItem:(AVPlayerItem *)playerItem {
    if (_currentItem == playerItem) {
        return;
    }
    if (_currentItem) {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:_currentItem];
        [_currentItem removeObserver:self forKeyPath:@"status"];
        [_currentItem removeObserver:self forKeyPath:@"playbackBufferEmpty"];
        [_currentItem removeObserver:self forKeyPath:@"playbackLikelyToKeepUp"];
        
        _currentItem = nil;
    }
    _currentItem = playerItem;
    if (_currentItem) {
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(moviePlayDidEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:_currentItem];
        [_currentItem addObserver:self
                       forKeyPath:@"status"
                          options:NSKeyValueObservingOptionNew
                          context:PlayViewStatusObservationContext];
        [_currentItem addObserver:self forKeyPath:@"playbackBufferEmpty" options: NSKeyValueObservingOptionNew context:PlayViewStatusObservationContext];
        [_currentItem addObserver:self forKeyPath:@"playbackLikelyToKeepUp" options: NSKeyValueObservingOptionNew context:PlayViewStatusObservationContext];
        
        if (_player) {
            [_player replaceCurrentItemWithPlayerItem:_currentItem];
        }else {
            _player = [AVPlayer playerWithPlayerItem:_currentItem];
        }
        
        __weak typeof(self) weakSelf = self;
        [self.player addPeriodicTimeObserverForInterval:CMTimeMakeWithSeconds(1, 1) queue:nil usingBlock:^(CMTime time){
            AVPlayerItem *currentItem = weakSelf.currentItem;
            NSArray *loadedRanges = currentItem.seekableTimeRanges;
            if (loadedRanges.count > 0 && currentItem.duration.timescale != 0) {
                NSInteger currentTime = (NSInteger)CMTimeGetSeconds([currentItem currentTime]);
                CGFloat totalTime = (CGFloat)currentItem.duration.value / currentItem.duration.timescale;
                CGFloat value = CMTimeGetSeconds([currentItem currentTime]) / totalTime;
                [weakSelf playerCurrentTime:currentTime totalTime:totalTime sliderValue:value];
            }
        }];
    }
}

- (void)createCurrentItemAndReadyToPlayWithURLString:(NSString *)urlString {
    AVURLAsset *urlAsset = [AVURLAsset assetWithURL:[NSURL URLWithString:urlString]];
    self.currentItem = [AVPlayerItem playerItemWithAsset:urlAsset];
    if ([self.player respondsToSelector:@selector(automaticallyWaitsToMinimizeStalling)]) {
        self.player.automaticallyWaitsToMinimizeStalling = YES;
    }
    self.player.usesExternalPlaybackWhileExternalScreenIsActive = YES;
    self.state = WMPlayerStateBuffering;
    [self play];
}

- (void)setURLString:(NSString *)URLString {
    
    if ([_URLString isEqualToString:URLString]) {
        return;
    }
    [self resetPlayer];
    _URLString = URLString;
    
    [self createCurrentItemAndReadyToPlayWithURLString:URLString];
}

- (void)setIsDisplayProgressBar:(BOOL)isDisplayProgressBar {
    
    _isDisplayProgressBar = isDisplayProgressBar;
    
    [self refreshProgressUI];
}

- (void)setState:(WMPlayerState)state {
    _state = state;
    
    if (state == WMPlayerStateBuffering) {
        self.playOrPauseBtn.hidden = YES;
        [self.loadingView startAnimating];
    }
    else {
        self.playOrPauseBtn.hidden = NO;
        [self.loadingView stopAnimating];
    }
    
    if (state == WMPlayerStateFailed) {
        self.playOrPauseBtn.hidden = YES;
        self.loadFailedBtn.hidden = NO;
    }
}

#pragma mark - 设置播放时间

- (NSTimeInterval)getCurrentTime{
    CMTime time = self.player.currentTime;
    
    NSTimeInterval currentTimeSec = time.value/time.timescale;
    
    NSLog(@"当前时间:%.f",currentTimeSec);
    return currentTimeSec;
}

- (NSTimeInterval)totalTime {
    CMTime totalTime = self.player.currentItem.duration;
    NSTimeInterval sec = CMTimeGetSeconds(totalTime);
    NSLog(@"总时间:%.f",sec);
    if (isnan(sec)) {
        return 0;
    }
    return sec;
}

- (void)setSeekTime:(float)value urlString:(NSString *)urlString{
    [self resetPlayer];
    _URLString = urlString;
    [self createCurrentItemAndReadyToPlayWithURLString:urlString];
    //跳转到当前指定时间
    [self.player seekToTime:CMTimeMake(value, 1)];
//    [self play];
}

- (void)saveCurrentTime{
    
}

- (void)readCurrentTime{
    
}

#pragma mark - PlayerDidEnd

- (void)moviePlayDidEnd:(NSNotification *)notification {
    
//    self.state = WMPlayerStateStopped;
    self.state = WMPlayerStatePause;
    [self pause];
    if (self.delegate&&[self.delegate respondsToSelector:@selector(playerFinishedPlay)]) {
        [self.delegate playerFinishedPlay];
    }
    if (self.isNeedSeekToZero) {
//        __weak typeof(self) weakSelf = self;
        [self.player seekToTime:kCMTimeZero toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero completionHandler:^(BOOL finished) {
            if (finished) {
//                dispatch_async(dispatch_get_main_queue(), ^{
//
//                    weakSelf.state = WMPlayerStatePause;
//                    [weakSelf pause];
//                });
            }
        }];
    }
}

#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    
    if (context == PlayViewStatusObservationContext) {
        if ([keyPath isEqualToString:@"status"]) {
            AVPlayerStatus status = [[change objectForKey:NSKeyValueChangeNewKey] integerValue];
            switch (status)
            {
                case AVPlayerStatusUnknown:
                {
                    
                }
                    break;
                case AVPlayerStatusReadyToPlay:
                {
                    self.state = WMPlayerStatePlaying;
                    
                    if (self.delegate && [self.delegate respondsToSelector:@selector(playerReadyToPlayWithStatus:)]) {
                        [self.delegate playerReadyToPlayWithStatus:WMPlayerStatePlaying];
                    }
                }
                    break;
                case AVPlayerStatusFailed:
                {
                    self.state = WMPlayerStateFailed;
                    
                    if (self.delegate&&[self.delegate respondsToSelector:@selector(playerFailedPlayWithStatus:)]) {
                        [self.delegate playerFailedPlayWithStatus:WMPlayerStateFailed];
                    }
                }
                    break;
            }
        }
        else if ([keyPath isEqualToString:@"playbackBufferEmpty"]) {
            
            if (self.currentItem.playbackBufferEmpty) {
                self.state = WMPlayerStateBuffering;
                [self bufferingSomeSecond];
            }
        }
        else if ([keyPath isEqualToString:@"playbackLikelyToKeepUp"]) {
            
            if (self.currentItem.playbackLikelyToKeepUp && self.state == WMPlayerStateBuffering) {
                self.state = WMPlayerStatePlaying;
            }
        }
    }
}

#pragma mark - 缓冲较差时候

/**
 *  缓冲较差时候回调这里
 */
- (void)bufferingSomeSecond {
    self.state = WMPlayerStateBuffering;
    // playbackBufferEmpty会反复进入，因此在bufferingOneSecond延时播放执行完之前再调用bufferingSomeSecond都忽略
    __block BOOL isBuffering = NO;
    if (isBuffering) return;
    isBuffering = YES;
    
    // 需要先暂停一小会之后再播放，否则网络状况不好的时候时间在走，声音播放不出来
    [self.player pause];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        // 如果此时用户已经暂停了，则不再需要开启播放了
        if (self.isPauseByUser) {
            isBuffering = NO;
            return;
        }
        [self play];
        // 如果执行了play还是没有播放则说明还没有缓存好，则再次缓存一段时间
        isBuffering = NO;
        if (!self.currentItem.isPlaybackLikelyToKeepUp) {
            [self bufferingSomeSecond];
        }
    });
}

- (void)dealloc {
    NSLog(@"WMPlayer dealloc");
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.player.currentItem cancelPendingSeeks];
    [self.player.currentItem.asset cancelLoading];
    [self.player pause];
    
    //移除观察者
    [_currentItem removeObserver:self forKeyPath:@"status"];
    [_currentItem removeObserver:self forKeyPath:@"playbackBufferEmpty"];
    [_currentItem removeObserver:self forKeyPath:@"playbackLikelyToKeepUp"];
    
    _currentItem = nil;
    
    [self.player replaceCurrentItemWithPlayerItem:nil];
    self.player = nil;
    self.playOrPauseBtn = nil;
}

@end

