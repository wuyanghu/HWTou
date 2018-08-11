//
//  NTESLiveroomInfoView.m
//  NIMLiveDemo
//
//  Created by chris on 16/4/1.
//  Copyright © 2016年 Netease. All rights reserved.
//

#import "NTESLiveroomInfoView.h"
#import "NIMAvatarImageView.h"
#import "NTESLiveManager.h"
#import "NTESDataManager.h"
#import "UIView+NTES.h"

@interface NTESLiveroomInfoView()

@property (nonatomic,strong) NIMAvatarImageView *avatar;

@property (nonatomic,strong) UILabel *nameLabel;

@property (nonatomic,strong) UILabel *countLabel;

@end

@implementation NTESLiveroomInfoView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.image = [[UIImage imageNamed:@"icon_live_present_bg"] resizableImageWithCapInsets:UIEdgeInsetsMake(20, 20, 20, 20) resizingMode:UIImageResizingModeStretch];
        [self addSubview:self.avatar];
        [self addSubview:self.nameLabel];
        [self addSubview:self.countLabel];
    }
    return self;
}

- (void)refreshWithChatroom:(NIMChatroom *)chatroom
{
    self.countLabel.text = [NSString stringWithFormat:@"%zd人",chatroom.onlineUserCount];
    [self.countLabel sizeToFit];
    self.nameLabel.text = chatroom.creator;
    [self.nameLabel sizeToFit];
    [self.avatar nim_setImageWithURL:nil placeholderImage:[NTESDataManager sharedInstance].defaultUserAvatar];
    
    __weak typeof(self) wself = self;
    [[NTESLiveManager sharedInstance] anchorInfo:chatroom.roomId handler:^(NSError *error, NIMChatroomMember *anchor) {
        wself.nameLabel.text = anchor.roomNickname;
        [wself.nameLabel sizeToFit];
        [wself.avatar nim_setImageWithURL:[NSURL URLWithString:anchor.roomAvatar] placeholderImage:[NTESDataManager sharedInstance].defaultUserAvatar];
        [wself sizeToFit];
    }];
}

- (CGSize)sizeThatFits:(CGSize)size
{
    CGFloat height = 28.f;
    CGFloat width  = self.avatar.ntesWidth + self.avatarAndNickSpacing + self.nameLabel.ntesWidth + self.nickRightMargin;
    return CGSizeMake(width, height);
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.avatar.ntesCenterY = self.ntesHeight * .5f;
    self.nameLabel.ntesLeft = self.avatar.ntesRight + self.avatarAndNickSpacing;
    self.nameLabel.ntesTop  = self.nickTopMargin;
    self.countLabel.ntesLeft = self.nameLabel.ntesLeft;
    self.countLabel.ntesTop = self.nameLabel.ntesBottom + self.nickAndCountSpacing;
}

#pragma mark - Get

- (NIMAvatarImageView *)avatar
{
    if (!_avatar) {
        _avatar = [[NIMAvatarImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    }
    return _avatar;
}

- (UILabel *)nameLabel
{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _nameLabel.textColor = UIColorFromRGB(0xffffff);
        _nameLabel.font = [UIFont systemFontOfSize:11.f];
    }
    return _nameLabel;
}

- (UILabel *)countLabel
{
    if (!_countLabel) {
        _countLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _countLabel.textColor = UIColorFromRGB(0xffffff);
        _countLabel.font = [UIFont systemFontOfSize:9.f];
    }
    return _countLabel;
}

- (CGFloat)avatarAndNickSpacing
{
    return 5.f;
}

- (CGFloat)nickAndCountSpacing
{
    return 1.0f;
}

- (CGFloat)nickRightMargin
{
    return 13.f;
}

- (CGFloat)nickTopMargin
{
    return 2.f;
}

@end
