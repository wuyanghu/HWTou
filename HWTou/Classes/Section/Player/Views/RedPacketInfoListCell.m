//
//  RedPacketInfoListCell.m
//  HWTou
//
//  Created by Reyna on 2018/3/9.
//  Copyright © 2018年 LieMi. All rights reserved.
//

#import "RedPacketInfoListCell.h"
#import "PublicHeader.h"

@implementation RedPacketInfoListCell

+ (NSString *)cellReuseIdentifierInfo {
    return @"RedPacketInfoListCell";
}

- (void)bind:(GetRedPacketDetailModel *)model {
    
    [self.headIV sd_setImageWithURL:[NSURL URLWithString:model.getAvater]];
    self.nickNameLab.text = model.getNickName;
    self.priceLab.text = [NSString stringWithFormat:@"%@元",model.getMoney];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
