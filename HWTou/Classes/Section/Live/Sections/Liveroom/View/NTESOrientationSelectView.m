//
//  NTESOrientationSelectView.m
//  NIMLiveDemo
//
//  Created by Simon Blue on 17/3/27.
//  Copyright © 2017年 Netease. All rights reserved.
//

#import "NTESOrientationSelectView.h"
#import "UIView+NTES.h"

@interface NTESOrientationSelectView ()

@property (nonatomic, strong) UIImageView *verticalScreenImgView;        //竖屏按钮

@property (nonatomic, strong) UIImageView *horizontalScreenImgView;      //横屏按钮

@property (nonatomic, strong) UILabel *verticalScreenLabel;          //竖屏标签

@property (nonatomic, strong) UILabel *horizontalScreenLabel;        //横屏标签

@property (nonatomic, strong) UIView  *verticalLine;                 //分割线

@property (nonatomic, strong) UIView  *leftView;

@property (nonatomic, strong) UIView  *rightView;

@end

@implementation NTESOrientationSelectView

-(instancetype)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame])
    {
        [self addSubview:self.leftView];
        [self addSubview:self.rightView];
        [self addSubview:self.verticalLine];
        [self.leftView addSubview:self.verticalScreenImgView];
        [self.rightView addSubview:self.horizontalScreenImgView];
        [self.leftView addSubview:self.verticalScreenLabel];
        [self.rightView addSubview:self.horizontalScreenLabel];
    }
    return self;
}

-(void)layoutSubviews
{
    _verticalLine.ntesWidth = 0.5f;
    _verticalLine.ntesHeight = self.ntesHeight;
    _verticalLine.ntesCenterX = self.ntesWidth/2;
    _verticalLine.ntesBottom = self.ntesHeight;
    
    _leftView.ntesWidth = self.ntesWidth/2;
    _leftView.ntesHeight = self.ntesHeight;
    _leftView.ntesCenterX = self.ntesWidth/4;
    _leftView.ntesBottom = self.ntesHeight;
    
    _rightView.ntesWidth = self.ntesWidth/2;
    _rightView.ntesHeight = self.ntesHeight;
    _rightView.ntesCenterX = 3 * self.ntesWidth/4;
    _rightView.ntesBottom = self.ntesHeight;
    

    _verticalScreenImgView.ntesCenterX = _leftView.ntesWidth/2;
    _verticalScreenImgView.ntesTop = 15.f;
    
    _horizontalScreenImgView.ntesCenterX = _rightView.ntesWidth/2;
    _horizontalScreenImgView.ntesTop = 15.f;
    
    _verticalScreenLabel.ntesCenterX = _verticalScreenImgView.ntesCenterX;
    _verticalScreenLabel.ntesTop = _verticalScreenImgView.ntesBottom + 15.f;
    
    _horizontalScreenLabel.ntesCenterX = _horizontalScreenImgView.ntesCenterX;
    _horizontalScreenLabel.ntesTop = _horizontalScreenImgView.ntesBottom + 15.f;
}

- (UILabel *)horizontalScreenLabel
{
    if (!_horizontalScreenLabel) {
        _horizontalScreenLabel = [[UILabel alloc]init];
        _horizontalScreenLabel.text = @"横屏直播";
        _horizontalScreenLabel.font = [UIFont systemFontOfSize:15];
        _horizontalScreenLabel.textColor = UIColorFromRGB(0xffffff);
        _horizontalScreenLabel.textAlignment = NSTextAlignmentCenter;
        [_horizontalScreenLabel sizeToFit];
    }
    return _horizontalScreenLabel;
}

- (UILabel *)verticalScreenLabel
{
    if (!_verticalScreenLabel) {
        _verticalScreenLabel = [[UILabel alloc]init];
        _verticalScreenLabel.text = @"竖屏直播";
        _verticalScreenLabel.font = [UIFont systemFontOfSize:15];
        _verticalScreenLabel.textColor = UIColorFromRGB(0x238efa);
        _verticalScreenLabel.textAlignment = NSTextAlignmentCenter;
        [_verticalScreenLabel sizeToFit];

    }
    return _verticalScreenLabel;
}

- (UIView *)verticalLine
{
    if (!_verticalLine) {
        _verticalLine = [[UIView alloc] initWithFrame:CGRectZero];
        _verticalLine.backgroundColor = UIColorFromRGB(0x545454);
    }
    return _verticalLine;
}

- (UIView *)leftView
{
    if (!_leftView) {
        _leftView = [[UIView alloc] initWithFrame:CGRectZero];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onVerticalScreenPressed)];
        [_leftView addGestureRecognizer:tap];
    }
    return _leftView;

}

- (UIView *)rightView
{
    if (!_rightView) {
        _rightView = [[UIView alloc] initWithFrame:CGRectZero];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onHorizontalScreenPressed)];
        [_rightView addGestureRecognizer:tap];
    }
    return _rightView;
}

- (UIImageView *)horizontalScreenImgView
{
    if (!_horizontalScreenImgView) {
        _horizontalScreenImgView = [[UIImageView alloc]init];
        [_horizontalScreenImgView setImage:[UIImage imageNamed:@"icon_horizontal_screen_normal"]];
        [_horizontalScreenImgView sizeToFit];
    }
    return _horizontalScreenImgView;
}

- (UIImageView *)verticalScreenImgView
{
    if (!_verticalScreenImgView) {
        _verticalScreenImgView = [[UIImageView alloc]init];
    }
    [_verticalScreenImgView setImage:[UIImage imageNamed:@"icon_vertical_screen_selected"]];
    [_verticalScreenImgView sizeToFit];

    return _verticalScreenImgView;
}


- (BOOL)clickDisabled
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(interactionDisabled)]) {
        return   [self.delegate interactionDisabled];
    }
    return NO;
}

#pragma mark - action

-(void)onHorizontalScreenPressed
{
    if ([self clickDisabled]) {
        return;
    }
    
    _horizontalScreenLabel.textColor = UIColorFromRGB(0x238efa);
    _verticalScreenLabel.textColor = UIColorFromRGB(0xffffff);
    [_horizontalScreenImgView setImage:[UIImage imageNamed:@"icon_horizontal_screen_selected"]];
    [_verticalScreenImgView setImage:[UIImage imageNamed:@"icon_vertical_screen_normal"]];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(onHorizontalScreenButtonSelected)]) {
        [self.delegate onHorizontalScreenButtonSelected];
    }
    
}

-(void)onVerticalScreenPressed
{
    if ([self clickDisabled]) {
        return;
    }
    _verticalScreenLabel.textColor = UIColorFromRGB(0x238efa);
    _horizontalScreenLabel.textColor = UIColorFromRGB(0xffffff);
    [_verticalScreenImgView setImage:[UIImage imageNamed:@"icon_vertical_screen_selected"]];
    [_horizontalScreenImgView setImage:[UIImage imageNamed:@"icon_horizontal_screen_normal"]];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(onVerticalScreenButtonSelected)]) {
        [self.delegate onVerticalScreenButtonSelected];
    }

}

@end
