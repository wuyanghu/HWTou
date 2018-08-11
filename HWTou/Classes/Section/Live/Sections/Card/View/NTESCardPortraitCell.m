//
//  NTESCardPortraitCell.m
//  NIM
//
//  Created by chris on 15/9/28.
//  Copyright © 2015年 Netease. All rights reserved.
//

#import "NTESCardPortraitCell.h"
#import "NIMAvatarImageView.h"
#import "NIMCommonTableData.h"
#import "UIView+NTES.h"
#import "NTESSessionUtil.h"


@interface NTESCardPortraitCell()

@property (nonatomic,strong) NIMAvatarImageView *avatar;

@property (nonatomic,strong) UILabel *nameLabel;

@property (nonatomic,strong) UILabel *nickNameLabel;

@property (nonatomic,strong) UILabel *accountLabel;

@property (nonatomic,strong) UIImageView *genderIcon;

@end

@implementation NTESCardPortraitCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        CGFloat avatarWidth = 55.f;
        _avatar = [[NIMAvatarImageView alloc] initWithFrame:CGRectMake(0, 0, avatarWidth, avatarWidth)];
        [self addSubview:_avatar];
        _nameLabel      = [[UILabel alloc] initWithFrame:CGRectZero];
        _nameLabel.font = [UIFont systemFontOfSize:18.f];
        [self addSubview:_nameLabel];
        _nickNameLabel  = [[UILabel alloc] initWithFrame:CGRectZero];
        _nickNameLabel.font = [UIFont systemFontOfSize:13.f];
        _nickNameLabel.textColor = [UIColor grayColor];
        [self addSubview:_nickNameLabel];
        _accountLabel   = [[UILabel alloc] initWithFrame:CGRectZero];
        _accountLabel.font = [UIFont systemFontOfSize:13.f];
        _accountLabel.textColor = [UIColor grayColor];
        [self addSubview:_accountLabel];
        _genderIcon = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 14, 14)];
        [self addSubview:_genderIcon];
    }
    return self;
}

- (void)refreshData:(NIMCommonTableRow *)rowData tableView:(UITableView *)tableView{
    self.textLabel.text       = rowData.title;
    self.detailTextLabel.text = rowData.detailTitle;
    NSString *uid = rowData.extraInfo;
    if ([uid isKindOfClass:[NSString class]]) {
        NIMUser *user = [[NIMSDK sharedSDK].userManager userInfo:uid];
        NIMKitInfo *info = [[NIMKit sharedKit] infoByUser:uid option:nil];
        self.nameLabel.text   = info.showName ;
        self.accountLabel.text = [NSString stringWithFormat:@"帐号：%@",uid];
        [self.accountLabel sizeToFit];
        [self.avatar nim_setImageWithURL:[NSURL URLWithString:info.avatarUrlString] placeholderImage:info.avatarImage options:SDWebImageRetryFailed];
        if (user.userInfo.gender == NIMUserGenderMale) {
            _genderIcon.image = [UIImage imageNamed:@"icon_gender_male"];
            _genderIcon.hidden = NO;
        }
        else if(user.userInfo.gender == NIMUserGenderFemale) {
            _genderIcon.image = [UIImage imageNamed:@"icon_gender_female"];
            _genderIcon.hidden = NO;
        }
        else {
            _genderIcon.hidden = YES;
        }
        NSString *nickName  = user.userInfo.nickName ? user.userInfo.nickName : @"";
        _nickNameLabel.hidden = !user.alias.length;
        _nickNameLabel.text = [NSString stringWithFormat:@"昵称：%@",nickName];
        [_nickNameLabel sizeToFit];
    }
}


#define AvatarLeft 30
#define TitleAndAvatarSpacing 12
#define TitleTop 22
#define AccountBottom 22
#define GenderIconAndTitleSpacing 12

- (void)layoutSubviews{
    [super layoutSubviews];
    self.avatar.ntesLeft    = AvatarLeft;
    self.avatar.ntesCenterY = self.ntesHeight * .5f;
    
    CGFloat scale = self.ntesWidth / 320;
    CGFloat maxTextLabelWidth = 180 * scale;
    [self.nameLabel sizeToFit];
    self.nameLabel.ntesWidth = MIN(self.nameLabel.ntesWidth, maxTextLabelWidth);
    self.nameLabel.ntesLeft = self.avatar.ntesRight + TitleAndAvatarSpacing;
    self.nameLabel.ntesTop  = TitleTop;
    
    if (self.nickNameLabel.hidden) {
        self.accountLabel.ntesLeft    = self.nameLabel.ntesLeft;
        self.accountLabel.ntesBottom  = self.ntesHeight - AccountBottom;
    }else{
        self.nickNameLabel.ntesLeft    = self.nameLabel.ntesLeft;
        self.nickNameLabel.ntesBottom  = self.ntesHeight - AccountBottom;
        self.accountLabel.ntesLeft     = self.nameLabel.ntesLeft;
        self.accountLabel.ntesCenterY  = (self.nickNameLabel.ntesTop + self.nameLabel.ntesBottom) * .5f;
    }

    self.genderIcon.ntesLeft    = self.nameLabel.ntesRight + GenderIconAndTitleSpacing;
    self.genderIcon.ntesCenterY = self.nameLabel.ntesCenterY;
}

@end
