//
//  NTESMirrorView.m
//  NIMLiveDemo
//
//  Created by Simon Blue on 2017/5/18.
//  Copyright © 2017年 Netease. All rights reserved.
//

#import "NTESMirrorView.h"
#import "UIView+NTES.h"

@interface NTESMirrorBar : UIView

@property(nonatomic) id<NTESMirrorViewDelegate> delegate;

@property (nonatomic) BOOL isPreviewMirrorOn;

@property (nonatomic) BOOL isCodeMirrirOn;

@property (nonatomic) BOOL isLastPreviewMirrorOn;

@property (nonatomic) BOOL isLastCodeMirrirOn;

@property (nonatomic) BOOL isBackCamera;


- (void)setMirrorDisabled;

- (void)resetMirror;

- (void)cancel;

@end

@interface NTESMirrorView ()

@property (nonatomic) NTESMirrorBar *bar;

@end

@implementation NTESMirrorView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addTarget:self action:@selector(onTapBackground:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.bar];
    }
    return self;
}

- (void)setDelegate:(id<NTESMirrorViewDelegate>)delegate
{
    _delegate = delegate;
    self.bar.delegate = delegate;
}


- (void)onTapBackground:(id)sender
{
    [self.bar cancel];
}

- (void)show
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self];
    self.bar.ntesTop = self.ntesHeight;
    self.bar.ntesWidth = self.ntesWidth;
    [UIView animateWithDuration:0.25 animations:^{
        self.bar.ntesBottom = self.ntesHeight;
    }];
}

- (void)dismiss
{
    [UIView animateWithDuration:0.25 animations:^{
        self.bar.ntesTop = self.ntesHeight;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)setMirrorDisabled;
{
    self.bar.isBackCamera = YES;
    [self.bar setMirrorDisabled];
}

- (void)setIsPreviewMirrorOn:(BOOL)isPreviewMirrorOn
{
    self.bar.isPreviewMirrorOn = isPreviewMirrorOn;
}

-(void)setIsCodeMirrirOn:(BOOL)isCodeMirrirOn
{
    self.bar.isCodeMirrirOn = isCodeMirrirOn;
}

- (void)resetMirror;
{
    self.bar.isBackCamera = NO;
    [self.bar resetMirror];
}

- (NTESMirrorBar *)bar
{
    if (!_bar) {
        _bar = [[NTESMirrorBar alloc]initWithFrame:CGRectMake(0, 0, self.ntesWidth, 212)];
    }
    return _bar;
}


@end

@interface NTESMirrorBar ()

@property (nonatomic, strong)  UILabel * title;

@property (nonatomic, strong)  UIView * separatorTop;

@property (nonatomic, strong)  UIView * separatorCenter;

@property (nonatomic, strong)  UIView * separatorBottom;

@property (nonatomic, strong)  UIView * separatorVertical;

@property (nonatomic, strong)  UILabel * previewMirrorLable;

@property (nonatomic, strong)  UILabel * codeMirrorLable;

@property (nonatomic, strong)  UISwitch * previewMirrorSwitch;

@property (nonatomic, strong)  UISwitch * codeMirrorSwitch;

@property (nonatomic, strong)  UIButton * cancleButton;

@property (nonatomic, strong)  UIButton * confirmButton;

@end

@implementation NTESMirrorBar

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        //默认预览镜像开启
        self.isPreviewMirrorOn = YES;
        self.isLastPreviewMirrorOn = self.isPreviewMirrorOn;
        self.isLastCodeMirrirOn = self.isCodeMirrirOn;
        
        self.backgroundColor = UIColorFromRGBA(0x000000, 0.8);

        [self addSubview:self.title];
        [self addSubview:self.previewMirrorLable];
        [self addSubview:self.codeMirrorLable];
        [self addSubview:self.separatorBottom];
        [self addSubview:self.separatorCenter];
        [self addSubview:self.separatorTop];
        [self addSubview:self.separatorVertical];
        [self addSubview:self.cancleButton];
        [self addSubview:self.confirmButton];
        [self addSubview:self.previewMirrorSwitch];
        [self addSubview:self.codeMirrorSwitch];
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    _title.ntesTop = 10.f;
    _title.ntesLeft = 10.f;
    
    _separatorTop.ntesTop = 45.f;
    _separatorTop.ntesLeft = 0;
    _separatorTop.ntesWidth = self.ntesWidth;
    _separatorTop.ntesHeight = .5f;
    
    _previewMirrorLable.ntesTop = _separatorTop.ntesBottom + 20.f;
    _previewMirrorLable.ntesLeft = 10.f;
    
    _previewMirrorSwitch.ntesCenterY = _previewMirrorLable.ntesCenterY;
    _previewMirrorSwitch.ntesRight = self.ntesWidth - 10.f;
    
    _separatorCenter.ntesTop = _previewMirrorLable.ntesBottom + 20.f;
    _separatorCenter.ntesLeft = 10.f;
    _separatorCenter.ntesWidth = self.ntesWidth - 2 * 10.f;
    _separatorCenter.ntesHeight = .5f;
    
    _codeMirrorLable.ntesTop = _separatorCenter.ntesBottom + 20.f;
    _codeMirrorLable.ntesLeft = 10.f;
    
    _codeMirrorSwitch.ntesCenterY = _codeMirrorLable.ntesCenterY;
    _codeMirrorSwitch.ntesRight = self.ntesWidth - 10.f;

    _separatorBottom.ntesTop = _codeMirrorLable.ntesBottom + 20.f;
    _separatorBottom.ntesLeft = 0;
    _separatorBottom.ntesWidth = self.ntesWidth;
    _separatorBottom.ntesHeight = .5f;
    
    _cancleButton.ntesTop = _separatorBottom.ntesBottom;
    _cancleButton.ntesLeft = 0;
    _cancleButton.ntesWidth = self.ntesWidth * .5f;
    _cancleButton.ntesHeight = self.ntesHeight - _separatorBottom.ntesBottom;

    _separatorVertical.ntesTop = _separatorBottom.ntesBottom;
    _separatorVertical.ntesCenterX = self.ntesWidth *.5f;
    _separatorVertical.ntesHeight = _cancleButton.ntesHeight;
    _separatorVertical.ntesWidth = .5f;
    
    _confirmButton.ntesTop = _separatorBottom.ntesBottom;
    _confirmButton.ntesLeft = _separatorVertical.ntesRight;
    _confirmButton.ntesWidth = self.ntesWidth * .5f;
    _confirmButton.ntesHeight = self.ntesHeight - _separatorBottom.ntesBottom;

}

-(UILabel *)title
{
    if (!_title) {
        _title = [[UILabel alloc]init];
        _title.text = @"镜像设置";
        _title.font = [UIFont systemFontOfSize:15];
        _title.textColor = UIColorFromRGB(0xffffff);
        _title.textAlignment = NSTextAlignmentCenter;
        [_title sizeToFit];
    }
    return _title;
}

- (UILabel *)previewMirrorLable
{
    if (!_previewMirrorLable) {
        _previewMirrorLable = [[UILabel alloc]init];
        _previewMirrorLable.text = @"本地镜像（仅影响自己）";
        _previewMirrorLable.font = [UIFont systemFontOfSize:17];
        _previewMirrorLable.textColor = UIColorFromRGB(0xffffff);
        _previewMirrorLable.textAlignment = NSTextAlignmentCenter;
        [_previewMirrorLable sizeToFit];
    }
    return _previewMirrorLable;
}

- (UILabel *)codeMirrorLable
{
    if (!_codeMirrorLable) {
        _codeMirrorLable = [[UILabel alloc]init];
        _codeMirrorLable.text = @"推流镜像（仅影响观众）";
        _codeMirrorLable.font = [UIFont systemFontOfSize:17];
        _codeMirrorLable.textColor = UIColorFromRGB(0xffffff);
        _codeMirrorLable.textAlignment = NSTextAlignmentCenter;
        [_codeMirrorLable sizeToFit];
    }
    return _codeMirrorLable;
}

- (UIView *)separatorVertical
{
    if (!_separatorVertical) {
        _separatorVertical = [[UIView alloc] initWithFrame:CGRectZero];
        _separatorVertical.backgroundColor = UIColorFromRGB(0x545454);
    }
    return _separatorVertical;
}

- (UIView *)separatorTop
{
    if (!_separatorTop) {
        _separatorTop = [[UIView alloc] initWithFrame:CGRectZero];
        _separatorTop.backgroundColor = UIColorFromRGB(0x545454);
    }
    return _separatorTop;
}

- (UIView *)separatorCenter
{
    if (!_separatorCenter) {
        _separatorCenter = [[UIView alloc] initWithFrame:CGRectZero];
        _separatorCenter.backgroundColor = UIColorFromRGB(0x545454);
    }
    return _separatorCenter;
}

- (UIView *)separatorBottom
{
    if (!_separatorBottom) {
        _separatorBottom = [[UIView alloc] initWithFrame:CGRectZero];
        _separatorBottom.backgroundColor = UIColorFromRGB(0x545454);
    }
    return _separatorBottom;
}

- (UIButton *)cancleButton
{
    if(!_cancleButton){
        _cancleButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [_cancleButton setTitle:@"取消" forState:UIControlStateNormal];
        [_cancleButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_cancleButton addTarget:self action:@selector(onCancelButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancleButton;
}

- (UIButton *)confirmButton
{
    if(!_confirmButton){
        _confirmButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [_confirmButton setTitle:@"确定" forState:UIControlStateNormal];
        [_confirmButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_confirmButton addTarget:self action:@selector(onConfirmButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    }
    return _confirmButton;
}

-(UISwitch *)previewMirrorSwitch
{
    if (!_previewMirrorSwitch) {
        _previewMirrorSwitch = [[UISwitch alloc]init];
        _previewMirrorSwitch.on = self.isPreviewMirrorOn;
        [_previewMirrorSwitch addTarget:self action:@selector(onSwitchPreviewMirror) forControlEvents:UIControlEventValueChanged];
    }
    return _previewMirrorSwitch;
}

-(UISwitch *)codeMirrorSwitch
{
    if (!_codeMirrorSwitch) {
        _codeMirrorSwitch = [[UISwitch alloc]init];
        _codeMirrorSwitch.on = self.isCodeMirrirOn;
        [_codeMirrorSwitch addTarget:self action:@selector(onSwitchCodeMirror) forControlEvents:UIControlEventValueChanged];
    }
    return _codeMirrorSwitch;
}


-(void)setPreViewMirror:(BOOL)isOn
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(onPreviewMirror:)]) {
        [self.delegate onPreviewMirror:isOn];
    }
}

-(void)setCodeMirror:(BOOL)isOn
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(onCodeMirror:)]) {
        [self.delegate onCodeMirror:isOn];
    }
}

-(void)onSwitchPreviewMirror
{
    [self setPreViewMirror:self.previewMirrorSwitch.on];
}

-(void)onSwitchCodeMirror
{
    [self setCodeMirror:self.codeMirrorSwitch.on];
}

- (void)setMirrorDisabled
{
    self.previewMirrorSwitch.on = NO;
    self.codeMirrorSwitch.on = NO;
}

- (void)resetMirror
{
    [self setPreViewMirror:self.isLastPreviewMirrorOn];
    [self setCodeMirror:self.isLastCodeMirrirOn];
    [self onConfirmButtonPressed];
}

-(void)onCancelButtonPressed
{
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(onMirrorCancelButtonPressed)]) {
        [self.delegate onMirrorCancelButtonPressed];
    }
    
    //恢复原始设置 并dismiss view
    if (!_isBackCamera) {
        [self setPreViewMirror:self.isLastPreviewMirrorOn];
        [self setCodeMirror:self.isLastCodeMirrirOn];
    }
}

-(void)onConfirmButtonPressed
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(onMirrorConfirmButtonPressedWithPreviewMirror:CodeMirror:)]) {
        [self.delegate onMirrorConfirmButtonPressedWithPreviewMirror:_previewMirrorSwitch.on CodeMirror:_codeMirrorSwitch.on];
    }
    
    //保存设置 并dismiss view
    if (!_isBackCamera) {
        self.isLastPreviewMirrorOn = _previewMirrorSwitch.on;
        self.isLastCodeMirrirOn = _codeMirrorSwitch.on;
    }
}


#pragma mark - public
- (void)setIsPreviewMirrorOn:(BOOL)isPreviewMirrorOn
{
    _isPreviewMirrorOn = isPreviewMirrorOn;
    self.previewMirrorSwitch.on = isPreviewMirrorOn;
}

-(void)setIsCodeMirrirOn:(BOOL)isCodeMirrirOn
{
    _isCodeMirrirOn = isCodeMirrirOn;
    self.codeMirrorSwitch.on = isCodeMirrirOn;
}

- (void)cancel
{
    [self onCancelButtonPressed];
}

@end
