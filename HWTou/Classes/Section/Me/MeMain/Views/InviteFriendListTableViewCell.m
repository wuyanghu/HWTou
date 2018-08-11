//
//  InviteFriendListTableViewCell.m
//  HWTou
//
//  Created by robinson on 2018/1/16.
//  Copyright © 2018年 LieMi. All rights reserved.
//

#import "InviteFriendListTableViewCell.h"
#import "PublicHeader.h"

@implementation InviteFriendListTableViewCell

- (void)setFriendModel:(InviteFrendModel *)friendModel{
    [self.headerImageView sd_setImageWithURL:[NSURL URLWithString:friendModel.headUrl]];
    self.titleLabel.text = friendModel.nickname;
    self.subTitleLabel.text = friendModel.sign;
    self.timeLabel.text = friendModel.createTimeStr;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

+ (NSString *)cellReuseIdentifierInfo{
    return @"InviteFriendListTableViewCell";
}

@end
