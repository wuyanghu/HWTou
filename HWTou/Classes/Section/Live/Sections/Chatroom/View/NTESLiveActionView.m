//
//  NTESLiveActionView.m
//  NIM
//
//  Created by chris on 16/1/26.
//  Copyright © 2016年 Netease. All rights reserved.
//

#import "NTESLiveActionView.h"
#import "NTESLiveManager.h"
#import "UIView+NTES.h"
#import "NTESLiveSelectButton.h"

#define numPerRowPortrait 5
#define numPerRowLandscapeRight 9


@interface NTESLiveActionView()<NTESPageViewDelegate,NTESPageViewDataSource>
{
    NSArray *_subviewsCache;
    NSMutableArray * _firstRowSubview;
    NSMutableArray * _secondRowSubview;
    NSMutableDictionary *_subviewIndexCache;
}

@property (nonatomic,assign) CGFloat padding;

@property (nonatomic,assign) CGFloat spacing;

@property (nonatomic,strong) UIButton *sharedButton;

@property (nonatomic,strong) UIButton *presentButton;

@property (nonatomic,strong) UIButton *likeButton;

@property (nonatomic,strong) UIButton *cameraButton;

@property (nonatomic,strong) UIButton *interactButton;

@property (nonatomic,strong) UIButton *beautifyButton;

@property (nonatomic,strong) UIButton *mixAudioButton;

@property (nonatomic,strong) UIButton *snapshotButton;

@property (nonatomic,strong) UIButton *actionViewUpButton;

@property (nonatomic,strong) UIButton *chatButton;

@property (nonatomic,strong) UIButton *flashButton;

@property (nonatomic,strong) UIButton *mirrorButton;

@property (nonatomic,strong) UIButton *waterMarkButton;

@property (nonatomic,strong) UIButton *cameraZoomButton;

@property (nonatomic,strong) UIButton *qualityButton;

@property (nonatomic,strong) UIButton *focusButton;

@property (nonatomic) NSInteger numPerRow;

@property (nonatomic) BOOL isViewMoveUp;

@property (nonatomic) BOOL isShowAnimation;

@property (nonatomic, copy) NSString *showName;

@end

@implementation NTESLiveActionView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _padding = 10.f;
        _spacing = 15.f;
        [self setUp];
    }
    return self;
}

- (void)setUp
{
    if ([NTESLiveManager sharedInstance].role == NTESLiveRoleAnchor)
    {
        if ([NTESLiveManager sharedInstance].type == NTESLiveTypeAudio) {
            [self addSubview:self.chatButton];
            [self addSubview:self.presentButton];
            [self addSubview:self.interactButton];
            [self addSubview:self.cameraButton];
            [self addSubview:self.beautifyButton];
            [self addSubview:self.qualityButton];
            [self addSubview:self.mixAudioButton];
            [self addSubview:self.snapshotButton];
//            [self addSubview:self.sharedButton];
            
        }
        else if ([NTESLiveManager sharedInstance].orientation == NIMVideoOrientationLandscapeRight)
        {
            [self addSubview:self.mirrorButton];
            [self addSubview:self.flashButton];
            [self addSubview:self.qualityButton];
            [self addSubview:self.cameraZoomButton];
            [self addSubview:self.beautifyButton];
            [self addSubview:self.cameraButton];
            [self addSubview:self.interactButton];
            [self addSubview:self.presentButton];
            [self addSubview:self.chatButton];
            
            //第一排
            [self addSubview:self.sharedButton];
            [self addSubview:self.snapshotButton];
            [self addSubview:self.mixAudioButton];
            [self addSubview:self.waterMarkButton];
            [self addSubview:self.focusButton];
            
            [self addSubview:self.actionViewUpButton];
        }
        else if ([NTESLiveManager sharedInstance].orientation == NIMVideoOrientationPortrait)
        {
            //第三排
            [self addSubview:self.beautifyButton];
            [self addSubview:self.cameraButton];
            [self addSubview:self.interactButton];
            [self addSubview:self.presentButton];
            [self addSubview:self.chatButton];
            
            //第二排
            [self addSubview:self.focusButton];
            [self addSubview:self.mirrorButton];
            [self addSubview:self.flashButton];
            [self addSubview:self.qualityButton];
            [self addSubview:self.cameraZoomButton];
            
            //第一排
            [self addSubview:self.sharedButton];
            [self addSubview:self.snapshotButton];
            [self addSubview:self.mixAudioButton];
            [self addSubview:self.waterMarkButton];
            
            
            //最左边button 动画按钮
            [self addSubview:self.actionViewUpButton];
            
        }
        
    }
    else
    {
        
        [self addSubview:self.chatButton];
        [self addSubview:self.presentButton];
        [self addSubview:self.interactButton];
        [self addSubview:self.cameraButton];
//        [self addSubview:self.sharedButton];
        [self addSubview:self.likeButton];
    }
    
    _subviewsCache = [NSArray arrayWithArray:self.subviews];
    _subviewIndexCache = [[NSMutableDictionary alloc] init];
    for (NSInteger i = 0;i < self.subviews.count;i++) {
        UIView *subview = self.subviews[i];
        _subviewIndexCache[@(subview.tag)] = @(i);
    }
}

- (CGSize)sizeThatFits:(CGSize)size
{
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    return CGSizeMake(width, self.subviews.firstObject.ntesHeight);
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    
    //音频模式or观众
//    if ([NTESLiveManager sharedInstance].type == NTESLiveTypeAudio||[NTESLiveManager sharedInstance].role == NTESLiveRoleAudience)
//    {
//        [self layoutSubviewsWithAudioTypeOrAudience];
//    }
//    //横屏
//    else  if([NTESLiveManager sharedInstance].orientation == NIMVideoOrientationLandscapeRight)
//    {
//        [self layoutSubviewsWithOrientatin:NIMVideoOrientationLandscapeRight];
//    }
//    //竖屏
//    else
//    {
//        [self layoutSubviewsWithOrientatin:NIMVideoOrientationPortrait];
//    }
}


- (void)layoutSubviewsWithOrientatin:(NIMVideoOrientation)orientation
{
    //基准View
    UIView * baseSubView ;
    if (orientation == NIMVideoOrientationPortrait) {
        _numPerRow = numPerRowPortrait;
        baseSubView = self.beautifyButton;
    }
    else
    {
        _numPerRow = numPerRowLandscapeRight;
        baseSubView = self.mirrorButton;
    }
    
    //行数
    NSInteger rowNum = [self calculateRowNum:_numPerRow];
    //第一行的个数
    NSInteger firstRowNum = [self calculateFirstRowNum:_numPerRow];
    
    CGFloat width = self.subviews.firstObject.ntesWidth;
    CGFloat height = self.subviews.firstObject.ntesHeight;
    CGFloat right = self.ntesWidth - self.padding;
    
    //self frame
    if (_isViewMoveUp) {
        self.ntesHeight = rowNum * width + (rowNum -1) * self.padding;
    }
    else
    {
        self.ntesHeight = height;
    }
    self.ntesBottom = self.superview.ntesHeight - 10.f;
    
    //subviews frame
    for (NSInteger j = 0; j < rowNum; j++) {
        NSInteger numOfRow = j < rowNum - 1 ? _numPerRow : firstRowNum;
        for (NSInteger k = 0; k < numOfRow; k++) {
            NSInteger i = j * _numPerRow + k;
            UIView *subview = self.subviews[i];
            if (j == 0) {
                if (subview == baseSubView) {
                    subview.ntesRight = self.ntesWidth - self.padding;
                    subview.ntesBottom = self.ntesHeight;
                }
                else
                {
                    right -= width + self.padding;
                    subview.ntesRight = right;
                    subview.ntesBottom = self.ntesHeight;
                }
            }
            else
            {
                //前一行的view
                UIView *preSubview = self.subviews[i - numOfRow];
                if (_isViewMoveUp) {
                    subview.ntesCenterX = preSubview.ntesCenterX;
                    subview.ntesBottom = preSubview.ntesTop - self.padding;
                    subview.hidden = NO;
                }
                else
                {
                    subview.ntesCenterX = preSubview.ntesCenterX;
                    subview.ntesCenterY = preSubview.ntesCenterY;
                    //动画期间不要执行hidden
                    if (!_isShowAnimation) {
                        subview.hidden  = YES;
                    }
                }
            }
        }
    }
    
    //动画按钮 另行布局
    UIView *subview = self.subviews.lastObject;
    if (subview == self.actionViewUpButton) {
        subview.ntesLeft = self.padding;
        subview.ntesBottom = self.ntesHeight;
    }
}

//返回行数
- (NSInteger)calculateRowNum:(NSInteger)numPerRow
{
    //动画按钮另行布局 这里减1
    NSInteger remainder = (self.subviews.count - 1) % numPerRow;
    NSInteger integer = (self.subviews.count - 1) / numPerRow;
    
    NSInteger row = integer;
    
    if (remainder > 0) {
        row ++ ;
    }
    return row;
}

//返回第一行个数
- (NSInteger)calculateFirstRowNum:(NSInteger)numPerRow
{
    NSInteger remainder = (self.subviews.count - 1) % numPerRow;
    NSInteger firstRowNum = remainder ? : numPerRow;
    
    return firstRowNum;
}

- (void)layoutSubviewsWithAudioTypeOrAudience
{
    CGFloat width = self.subviews.firstObject.ntesWidth;
    CGFloat left = self.padding;
    
    for (NSInteger i = 0;i < self.subviews.count;i++) {
        
        UIView *subview = self.subviews[i];
        if (subview == self.likeButton) {
            subview.ntesRight = self.ntesWidth - self.padding;
            subview.ntesBottom = self.ntesHeight;
        }
        else
        {
            subview.ntesLeft = left;
            left += (width + self.padding);
            subview.ntesBottom = self.ntesHeight;
        }
    }
}

- (void)showAnimation
{
    _isShowAnimation = YES;
    
    [UIView animateWithDuration:0.5 animations:^{
        [self setNeedsLayout];
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        _isShowAnimation = NO;
        
        //下拉动画结束隐藏 按钮
        if (!_isViewMoveUp) {
            for (NSInteger i = 0; i < self.subviews.count; i++) {
                UIView *view = self.subviews[i];
                //最底层 不需要隐藏
                if (i >= _numPerRow ) {
                    if (view != self.actionViewUpButton) {
                        view.hidden = YES;
                    }
                }
            }
        }
    }];
}


#pragma mark - Public

- (void)setActionType:(NTESLiveActionType)type disable:(BOOL)disable
{
    UIView *view;
    for (UIView *subView in _subviewsCache) {
        if (subView.tag == type) {
            view = subView;
            break;
        }
    }
    if (view) {
        if (disable) {
            [view removeFromSuperview];
        }
        else
        {
            [self addSubview:view];
            NSArray *subviews = [self.subviews sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
                NSInteger index1 = [_subviewsCache indexOfObject:obj1];
                NSInteger index2 = [_subviewsCache indexOfObject:obj2];
                return index1>index2? NSOrderedDescending : NSOrderedAscending;
            }];
            
            for (UIView *view in subviews) {
                [self insertSubview:view atIndex:self.subviews.count];
            }
        }
        [UIView animateWithDuration:.25 animations:^{
            [self layoutIfNeeded];
        }];
    }
}

- (void)firstLineViewMoveToggle:(BOOL)isMoveUp;
{
    _isViewMoveUp = isMoveUp;
    if (_isViewMoveUp) {
        [_actionViewUpButton setImage:[UIImage imageNamed:@"icon_button_down_n"] forState:UIControlStateNormal];
        [_actionViewUpButton setImage:[UIImage imageNamed:@"icon_button_down_p"] forState:UIControlStateHighlighted];
    }
    else
    {
        [_actionViewUpButton setImage:[UIImage imageNamed:@"icon_button_up_n"] forState:UIControlStateNormal];
        [_actionViewUpButton setImage:[UIImage imageNamed:@"icon_button_up_p"] forState:UIControlStateHighlighted];
    }
    
    //开始动画
    [self showAnimation];
    
}

- (void)updateInteractButton:(NSInteger)count
{
    if (!count)
    {
        [self.interactButton setBackgroundImage:[UIImage imageNamed:@"icon_interact_n"] forState:UIControlStateNormal];
        [self.interactButton setBackgroundImage:[UIImage imageNamed:@"icon_interact_p"] forState:UIControlStateHighlighted];
        [self.interactButton setTitle:@"" forState:UIControlStateNormal];
    }
    else
    {
        [self.interactButton setBackgroundImage:[UIImage imageNamed:@"icon_interact_count_n"] forState:UIControlStateNormal];
        [self.interactButton setBackgroundImage:[UIImage imageNamed:@"icon_interact_count_p"] forState:UIControlStateHighlighted];
        [self.interactButton setTitle:@(count).stringValue forState:UIControlStateNormal];
    }
}

- (void)updateBeautify:(BOOL)isBeautify
{
    if (isBeautify) {
        [_beautifyButton setImage:[UIImage imageNamed:@"icon_filter_on_n"] forState:UIControlStateNormal];
        [_beautifyButton setImage:[UIImage imageNamed:@"icon_filter_on_p"] forState:UIControlStateHighlighted];
    }
    else
    {
        [_beautifyButton setImage:[UIImage imageNamed:@"icon_filter_off_n"] forState:UIControlStateNormal];
        [_beautifyButton setImage:[UIImage imageNamed:@"icon_filter_p"] forState:UIControlStateHighlighted];
    }
    
}
- (void)updateQualityButton:(BOOL)isHigh
{
    if (isHigh) {
        [_qualityButton setImage:[UIImage imageNamed:@"icon_quality_high_n"] forState:UIControlStateNormal];
        [_qualityButton setImage:[UIImage imageNamed:@"icon_quality_high_p"] forState:UIControlStateHighlighted];
    }
    else
    {
        [_qualityButton setImage:[UIImage imageNamed:@"icon_quality_normal_n"] forState:UIControlStateNormal];
        [_qualityButton setImage:[UIImage imageNamed:@"icon_quality_normal_p"] forState:UIControlStateHighlighted];
    }
    
}

- (void)updateWaterMarkButton:(BOOL)isOn
{
    if (isOn) {
        [_waterMarkButton setImage:[UIImage imageNamed:@"icon_watermark_on_n"] forState:UIControlStateNormal];
        [_waterMarkButton setImage:[UIImage imageNamed:@"icon_watermark_on_p"] forState:UIControlStateHighlighted];
    }
    else
    {
        [_waterMarkButton setImage:[UIImage imageNamed:@"icon_watermark_n"] forState:UIControlStateNormal];
        [_waterMarkButton setImage:[UIImage imageNamed:@"icon_watermark_p"] forState:UIControlStateHighlighted];
    }
}

- (void)updateflashButton:(BOOL)isOn
{
    if (isOn) {
        [_flashButton setImage:[UIImage imageNamed:@"icon_flash_on_n"] forState:UIControlStateNormal];
        [_flashButton setImage:[UIImage imageNamed:@"icon_flash_on_p"] forState:UIControlStateHighlighted];
    }
    else
    {
        [_flashButton setImage:[UIImage imageNamed:@"icon_flash_off_n"] forState:UIControlStateNormal];
        [_flashButton setImage:[UIImage imageNamed:@"icon_flash_off_p"] forState:UIControlStateHighlighted];
    }
}

- (void)updateFocusButton:(BOOL)isOn
{
    if (isOn) {
        [_focusButton setImage:[UIImage imageNamed:@"icon_focus_on_n"] forState:UIControlStateNormal];
        [_focusButton setImage:[UIImage imageNamed:@"icon_focus_on_p"] forState:UIControlStateHighlighted];
    }
    else
    {
        [_focusButton setImage:[UIImage imageNamed:@"icon_focus_off_n"] forState:UIControlStateNormal];
        [_focusButton setImage:[UIImage imageNamed:@"icon_focus_off_p"] forState:UIControlStateHighlighted];
    }
}

- (void)updateMirrorButton:(BOOL)isOn
{
    if (isOn) {
        [_mirrorButton setImage:[UIImage imageNamed:@"icon_mirror_on_n"] forState:UIControlStateNormal];
        [_mirrorButton setImage:[UIImage imageNamed:@"icon_mirror_on_p"] forState:UIControlStateHighlighted];
    }
    else
    {
        [_mirrorButton setImage:[UIImage imageNamed:@"icon_mirror_n"] forState:UIControlStateNormal];
        [_mirrorButton setImage:[UIImage imageNamed:@"icon_mirror_p"] forState:UIControlStateHighlighted];
    }
}

#pragma mark - Action
- (void)onAction:(UIButton *)button
{
    if ([self.delegate respondsToSelector:@selector(onActionType:sender:)]) {
        NTESLiveActionType type = button.tag;
        [self.delegate onActionType:type sender:button];
    }
}

#pragma mark - Get

- (UIButton *)actionViewUpButton
{
    if (!_actionViewUpButton) {
        _actionViewUpButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _actionViewUpButton.tag = NTESLiveActionTypeMoveUp;
        [_actionViewUpButton setImage:[UIImage imageNamed:@"icon_button_up_n"] forState:UIControlStateNormal];
        [_actionViewUpButton setImage:[UIImage imageNamed:@"icon_button_up_p"] forState:UIControlStateHighlighted];
        [_actionViewUpButton sizeToFit];
        [_actionViewUpButton addTarget:self action:@selector(onAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _actionViewUpButton;
}

- (UIButton *)sharedButton
{
    if (!_sharedButton) {
        _sharedButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _sharedButton.tag = NTESLiveActionTypeShare;
        [_sharedButton setImage:[UIImage imageNamed:@"icon_share_n"] forState:UIControlStateNormal];
        [_sharedButton setImage:[UIImage imageNamed:@"icon_share_p"] forState:UIControlStateHighlighted];
        [_sharedButton sizeToFit];
        [_sharedButton addTarget:self action:@selector(onAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sharedButton;
}

- (UIButton *)presentButton
{
    if (!_presentButton) {
        _presentButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _presentButton.tag = NTESLiveActionTypePresent;
        [_presentButton setImage:[UIImage imageNamed:@"icon_present_n"] forState:UIControlStateNormal];
        [_presentButton setImage:[UIImage imageNamed:@"icon_present_p"] forState:UIControlStateHighlighted];
        [_presentButton sizeToFit];
        [_presentButton addTarget:self action:@selector(onAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _presentButton;
}

- (UIButton *)likeButton
{
    if (!_likeButton) {
        _likeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _likeButton.tag = NTESLiveActionTypeLike;
        [_likeButton setImage:[UIImage imageNamed:@"icon_like_n"] forState:UIControlStateNormal];
        [_likeButton setImage:[UIImage imageNamed:@"icon_like_p"] forState:UIControlStateHighlighted];
        [_likeButton sizeToFit];
        [_likeButton addTarget:self action:@selector(onAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _likeButton;
}

- (UIButton *)qualityButton
{
    if (!_qualityButton) {
        _qualityButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _qualityButton.tag = NTESLiveActionTypeQuality;
        [_qualityButton setImage:[UIImage imageNamed:@"icon_quality_normal_n"] forState:UIControlStateNormal];
        [_qualityButton setImage:[UIImage imageNamed:@"icon_quality_normal_p"] forState:UIControlStateHighlighted];
        [_qualityButton sizeToFit];
        [_qualityButton addTarget:self action:@selector(onAction:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _qualityButton;
}

- (UIButton *)interactButton
{
    if (!_interactButton) {
        _interactButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _interactButton.tag = NTESLiveActionTypeInteract;
        [_interactButton setBackgroundImage:[UIImage imageNamed:@"icon_interact_n"] forState:UIControlStateNormal];
        [_interactButton setBackgroundImage:[UIImage imageNamed:@"icon_interact_p"] forState:UIControlStateHighlighted];
        _interactButton.ntesSize = [UIImage imageNamed:@"icon_interact_n"].size;
        [_interactButton addTarget:self action:@selector(onAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _interactButton;
}

- (UIButton *)beautifyButton
{
    if (!_beautifyButton) {
        _beautifyButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _beautifyButton.tag = NTESLiveActionTypeBeautify;
        [_beautifyButton setImage:[UIImage imageNamed:@"icon_filter_off_n"] forState:UIControlStateNormal];
        [_beautifyButton setImage:[UIImage imageNamed:@"icon_filter_p"] forState:UIControlStateHighlighted];
        _beautifyButton.ntesSize = [UIImage imageNamed:@"icon_beautify_on_normal"].size;
        [_beautifyButton addTarget:self action:@selector(onAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _beautifyButton;
}

- (UIButton *)mixAudioButton
{
    if (!_mixAudioButton) {
        _mixAudioButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _mixAudioButton.tag = NTESLiveActionTypeMixAudio;
        [_mixAudioButton setBackgroundImage:[UIImage imageNamed:@"icon_mix_audio_normal"] forState:UIControlStateNormal];
        [_mixAudioButton setBackgroundImage:[UIImage imageNamed:@"icon_mix_audio_pressed"] forState:UIControlStateHighlighted];
        _mixAudioButton.ntesSize = [UIImage imageNamed:@"icon_mix_audio_normal"].size;
        [_mixAudioButton addTarget:self action:@selector(onAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _mixAudioButton;
}

- (UIButton *)snapshotButton
{
    if (!_snapshotButton) {
        _snapshotButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _snapshotButton.tag = NTESLiveActionTypeSnapshot;
        [_snapshotButton setBackgroundImage:[UIImage imageNamed:@"icon_snapshot_n"] forState:UIControlStateNormal];
        [_snapshotButton setBackgroundImage:[UIImage imageNamed:@"icon_snapshot_p"] forState:UIControlStateHighlighted];
        _snapshotButton.ntesSize = [UIImage imageNamed:@"icon_mix_audio_normal"].size;
        [_snapshotButton addTarget:self action:@selector(onAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _snapshotButton;
}

- (UIButton *)cameraButton
{
    if (!_cameraButton) {
        _cameraButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _cameraButton.tag = NTESLiveActionTypeCamera;
        [_cameraButton setImage:[UIImage imageNamed:@"icon_camera_n"] forState:UIControlStateNormal];
        [_cameraButton setImage:[UIImage imageNamed:@"icon_camera_p"] forState:UIControlStateHighlighted];
        [_cameraButton addTarget:self action:@selector(onAction:) forControlEvents:UIControlEventTouchUpInside];
        _cameraButton.ntesSize = [UIImage imageNamed:@"icon_camera_n"].size;
        
    }
    return _cameraButton;
}

-(UIButton *)chatButton
{
    
    if (!_chatButton) {
        _chatButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _chatButton.tag = NTESLiveActionTypeChat;
        [_chatButton setImage:[UIImage imageNamed:@"icon_chat_n"] forState:UIControlStateNormal];
        [_chatButton setImage:[UIImage imageNamed:@"icon_chat_p"] forState:UIControlStateHighlighted];
        [_chatButton addTarget:self action:@selector(onAction:) forControlEvents:UIControlEventTouchUpInside];
        _chatButton.ntesSize = [UIImage imageNamed:@"icon_chat_n"].size;
    }
    return _chatButton;
    
}

-(UIButton *)flashButton
{
    if (!_flashButton) {
        _flashButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _flashButton.tag = NTESLiveActionTypeFlash;
        [_flashButton setImage:[UIImage imageNamed:@"icon_flash_off_n"] forState:UIControlStateNormal];
        [_flashButton setImage:[UIImage imageNamed:@"icon_flash_off_p"] forState:UIControlStateHighlighted];
        [_flashButton addTarget:self action:@selector(onAction:) forControlEvents:UIControlEventTouchUpInside];
        _flashButton.ntesSize = [UIImage imageNamed:@"icon_flash_off_n"].size;
    }
    return _flashButton;
}

-(UIButton *)mirrorButton
{
    if (!_mirrorButton) {
        _mirrorButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _mirrorButton.tag = NTESLiveActionTypeMirror;
        [_mirrorButton setImage:[UIImage imageNamed:@"icon_mirror_on_n"] forState:UIControlStateNormal];
        [_mirrorButton setImage:[UIImage imageNamed:@"icon_mirror_on_p"] forState:UIControlStateHighlighted];
        [_mirrorButton addTarget:self action:@selector(onAction:) forControlEvents:UIControlEventTouchUpInside];
        _mirrorButton.ntesSize = [UIImage imageNamed:@"icon_mirror_n"].size;
    }
    return _mirrorButton;
}

-(UIButton *)waterMarkButton
{
    if (!_waterMarkButton) {
        _waterMarkButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _waterMarkButton.tag = NTESLiveActionTypeWaterMark;
        [_waterMarkButton setImage:[UIImage imageNamed:@"icon_watermark_n"] forState:UIControlStateNormal];
        [_waterMarkButton setImage:[UIImage imageNamed:@"icon_watermark_p"] forState:UIControlStateHighlighted];
        [_waterMarkButton addTarget:self action:@selector(onAction:) forControlEvents:UIControlEventTouchUpInside];
        _waterMarkButton.ntesSize = [UIImage imageNamed:@"icon_watermark_n"].size;
    }
    return _waterMarkButton;
}

- (UIButton *)focusButton
{
    if (!_focusButton) {
        _focusButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _focusButton.tag = NTESLiveActionTypeFocus;
        [_focusButton setImage:[UIImage imageNamed:@"icon_focus_off_n"] forState:UIControlStateNormal];
        [_focusButton setImage:[UIImage imageNamed:@"icon_focus_off_p"] forState:UIControlStateHighlighted];
        [_focusButton sizeToFit];
        [_focusButton addTarget:self action:@selector(onAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _focusButton;
}

-(UIButton *)cameraZoomButton
{
    
    if (!_cameraZoomButton) {
        _cameraZoomButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _cameraZoomButton.tag = NTESLiveActionTypeZoom;
        [_cameraZoomButton setImage:[UIImage imageNamed:@"icon_camera_zoom_n"] forState:UIControlStateNormal];
        [_cameraZoomButton setImage:[UIImage imageNamed:@"icon_camera_zoom_n"] forState:UIControlStateHighlighted];
        [_cameraZoomButton addTarget:self action:@selector(onAction:) forControlEvents:UIControlEventTouchUpInside];
        _cameraZoomButton.ntesSize = [UIImage imageNamed:@"icon_camera_zoom_n"].size;
    }
    return _cameraZoomButton;
}

@end


