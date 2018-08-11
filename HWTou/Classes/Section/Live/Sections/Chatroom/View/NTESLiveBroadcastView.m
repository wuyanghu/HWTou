//
//  NTESLiveBroadcastView.m
//  NIM
//
//  Created by chris on 15/12/17.
//  Copyright © 2015年 Netease. All rights reserved.
//

#import "NTESLiveBroadcastView.h"
#import "UIView+NTES.h"

@interface NTESLiveBroadcastView ()

@property (nonatomic, strong) UIImageView *iconImageView;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UITextView *contentTextView;

@end

@implementation NTESLiveBroadcastView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.iconImageView];
        [self addSubview:self.titleLabel];
        [self addSubview:self.contentTextView];
    }
    return self;
}

- (void)refresh:(NIMChatroom *)room{
    self.contentTextView.text = room.announcement.length ? room.announcement : @"暂无公告";
    [self.contentTextView sizeToFit];
    self.titleLabel.text = @"直播公告";
    [self.titleLabel sizeToFit];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    CGFloat spacing = 10.f;
    self.iconImageView.ntesTop  = spacing;
    self.iconImageView.ntesLeft = spacing;
    self.titleLabel.ntesWidth   = (self.ntesWidth - self.iconImageView.ntesRight) - 2 * spacing;
    [self.titleLabel sizeToFit];
    self.titleLabel.ntesCenterY = self.iconImageView.ntesCenterY;
    self.titleLabel.ntesLeft = self.iconImageView.ntesRight + spacing;
    self.contentTextView.ntesWidth  = self.ntesWidth - spacing * 2;
    self.contentTextView.ntesHeight = self.ntesHeight - self.titleLabel.ntesHeight - spacing * 2;
    self.contentTextView.ntesLeft =  spacing;
    self.contentTextView.ntesTop  =  self.iconImageView.ntesBottom + spacing * 2;
}

- (UIImageView *)iconImageView{
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"chatroom_announce"]];
    }
    return _iconImageView;
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLabel.adjustsFontSizeToFitWidth = YES;
        _titleLabel.numberOfLines = 3;
    }
    return _titleLabel;
}

-(UITextView *)contentTextView{
    if (!_contentTextView) {
        _contentTextView = [[UITextView alloc] initWithFrame:CGRectZero];
        _contentTextView.backgroundColor  = [UIColor clearColor];
        _contentTextView.font             = [UIFont systemFontOfSize:14.f];
        _contentTextView.editable         = NO;
        _contentTextView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    }
    return _contentTextView;
}

@end
