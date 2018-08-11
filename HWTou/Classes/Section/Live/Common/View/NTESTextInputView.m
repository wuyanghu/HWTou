//
//  NTESTextInputView.m
//  NIMLiveDemo
//
//  Created by chris on 16/3/28.
//  Copyright © 2016年 Netease. All rights reserved.
//

#import "NTESTextInputView.h"
#import "UIView+NTES.h"
#import "NTESGrowingInternalTextView.h"
#import "AppConfigMacro.h"

@interface NTESTextInputView()<NTESGrowingTextViewDelegate,UITextViewDelegate>

@end

@implementation NTESTextInputView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.textView];
        [self addSubview:self.sendButton];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGFloat spacing = 10.f;
    CGFloat sendbuttonWidth = 70.f;
    CGFloat textViewWidth = self.ntesWidth - spacing * 2 - sendbuttonWidth;
    
    self.textView.ntesWidth = textViewWidth;
    self.textView.ntesLeft  = spacing;
    self.textView.ntesCenterY = self.ntesHeight * .5f;
    
    self.sendButton.ntesWidth  = sendbuttonWidth;
    self.sendButton.ntesRight  = self.ntesWidth;
    self.sendButton.ntesHeight = self.ntesHeight;
}

#pragma mark - NTESGrowingTextViewDelegate
- (void)willChangeHeight:(CGFloat)height
{
    CGFloat bottom = self.ntesBottom;
    self.ntesSize = [self measureViewSize:height];
    self.ntesBottom = bottom;
    
    if ([self.delegate respondsToSelector:@selector(willChangeHeight:)]) {
        [self.delegate willChangeHeight:height];
    }
}

- (void)didChangeHeight:(CGFloat)height
{
    if ([self.delegate respondsToSelector:@selector(didChangeHeight:)]) {
        [self.delegate didChangeHeight:height];
    }
}

- (BOOL)shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)replacementText
{
    if ([replacementText isEqualToString:@"\n"]) {
        [self onSend:self.textView.text];
        return NO;
    }
    return YES;
}


#pragma mark - Get
- (SZTextView *)textView
{
    if (!_textView) {
        CGFloat spacing = 10.f;
        CGFloat sendbuttonWidth = 70.f;
        CGFloat textViewWidth = self.ntesWidth - spacing * 2 - sendbuttonWidth;
        
        _textView = [[SZTextView alloc] initWithFrame:CGRectMake(spacing, 0, textViewWidth, 36)];
        _textView.placeholder = @"聊点什么吧";
        _textView.inputAccessoryView = [[UIView alloc] init];
        _textView.delegate = self;
        _textView.font = SYSTEM_FONT(18);
        _textView.placeholderTextColor = UIColorFromRGB(0x909090);
        _textView.textColor = UIColorFromRGB(0x909090);
    }
    
    return _textView;
}


- (UIButton *)sendButton
{
    if (!_sendButton) {
        _sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_sendButton setBackgroundColor:UIColorFromRGB(0x2294ff)];
        _sendButton.titleLabel.font = [UIFont systemFontOfSize:14.f];
        [_sendButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_sendButton setTitle:@"发送" forState:UIControlStateNormal];
        [_sendButton addTarget:self action:@selector(onSend:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sendButton;
}


- (void)onSend:(id)sender
{
    NSString *text = self.textView.text;
    if (!text.length) {
        return;
    }
    self.textView.text = @"";
    if ([self.delegate respondsToSelector:@selector(didSendText:)]) {
        [self.delegate didSendText:text];
    }
}


#pragma mark - Private
- (CGSize)measureViewSize:(CGFloat)newTextViewHeight
{
    CGFloat topSpacing = (self.ntesHeight - self.textView.ntesHeight) / 2;
    CGFloat height = topSpacing * 2 + newTextViewHeight;
    return CGSizeMake(self.ntesWidth, height);
}


@end
