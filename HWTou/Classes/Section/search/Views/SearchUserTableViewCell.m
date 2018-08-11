//
//  SearchUserTableViewCell.m
//  HWTou
//
//  Created by robinson on 2017/12/26.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "SearchUserTableViewCell.h"
#import "PublicHeader.h"

@implementation SearchUserTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self.headerImageView setContentMode:UIViewContentModeScaleAspectFill];
    CAShapeLayer *shape = [BasisUITool headPortraitRoundProcessing:70];
    [self.headerImageView.layer setMask:shape];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(PersonHomeDM *)model{
    _model = model;
    
    [self.headerImageView sd_setImageWithURL:[NSURL URLWithString:model.headUrl]];
    self.nickName.text = model.nickname;
    self.subTitle.text = model.sign;
    self.attend.text = [NSString stringWithFormat:@"关注%ld",model.focusNum];
    self.fans.text = [NSString stringWithFormat:@"粉丝%ld",model.fansNum];
}

#pragma mark - static
+ (NSString *)cellReuseIdentifierInfo{
    return @"SearchUserTableViewCell";
}

@end
