//
//  NTESCameraZoomView.m
//  NIMLiveDemo
//
//  Created by Simon Blue on 2017/5/19.
//  Copyright © 2017年 Netease. All rights reserved.
//

#import "NTESCameraZoomView.h"
#import "UIView+NTES.h"
@interface NTESCameraZoomView ()<NIMNetCallManagerDelegate>

@property (nonatomic, strong) UISlider *slider;

@property (nonatomic, strong) UIButton *minusButton;

@property (nonatomic, strong) UIButton *plusButton;


@end

@implementation NTESCameraZoomView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.slider];
        [self addSubview:self.minusButton];
        [self addSubview:self.plusButton];
    }
    return self;
}

- (void)layoutSubviews
{
    _slider.ntesTop = 0;
    _slider.ntesHeight = self.ntesHeight;
    _slider.ntesCenterX = self.ntesWidth * .5f;
    _slider.ntesWidth = self.ntesWidth - _minusButton.ntesWidth - _plusButton.ntesWidth - 2 * 15.f;
    
    _minusButton.ntesLeft = 0;
    _minusButton.ntesCenterY = _slider.ntesCenterY;
    
    _plusButton.ntesRight = self.ntesWidth;
    _plusButton.ntesCenterY = _slider.ntesCenterY;
}

- (UISlider *)slider
{
    if (!_slider) {
        _slider = [[UISlider alloc]init];
        [_slider setMinimumValue:1.f];
        [_slider setMaximumValue:6.f];
        [_slider addTarget:self action:@selector(onSliderValueChanged) forControlEvents:UIControlEventValueChanged];
    }
    
    return _slider;
}

- (UIButton *)minusButton
{
    if (!_minusButton) {
        _minusButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_minusButton setImage:[UIImage imageNamed:@"icon_zoom_minus"] forState:UIControlStateNormal];
        [_minusButton addTarget:self action:@selector(onMinusButtonPresseed)  forControlEvents:UIControlEventTouchUpInside];

        [_minusButton sizeToFit];
    }
    return _minusButton;
}

- (UIButton *)plusButton
{
    if (!_plusButton) {
        _plusButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_plusButton setImage:[UIImage imageNamed:@"icon_zoom_plus"] forState:UIControlStateNormal];
        [_plusButton addTarget:self action:@selector(onPlusButtonPresseed)  forControlEvents:UIControlEventTouchUpInside];

        [_plusButton sizeToFit];
    }
    return _plusButton;
}

- (void)reset
{
    self.slider.value = 1.f;
}

- (void)onSliderValueChanged
{
    [[NIMAVChatSDK sharedSDK].netCallManager changeLensPosition: _slider.value];
}

- (void)onMinusButtonPresseed
{
    CGFloat zoomNum =  _slider.value - _slider.maximumValue / 6;
    if (zoomNum < _slider.minimumValue) {
        zoomNum = _slider.minimumValue;
    }
    _slider.value = zoomNum;
    [[NIMAVChatSDK sharedSDK].netCallManager changeLensPosition:zoomNum];
}

- (void)onPlusButtonPresseed
{
    CGFloat zoomNum =  _slider.value + _slider.maximumValue / 6;
    if (zoomNum > _slider.maximumValue) {
        zoomNum = _slider.maximumValue;
    }
    _slider.value = zoomNum;
    [[NIMAVChatSDK sharedSDK].netCallManager changeLensPosition:zoomNum];
}

@end
