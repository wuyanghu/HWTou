//
//  SubYiXingTableViewCell.m
//  HWTou
//
//  Created by robinson on 2018/4/27.
//  Copyright © 2018年 LieMi. All rights reserved.
//

#import "SubYiXingTableViewCell.h"
#import "PublicHeader.h"

@implementation SubYiXingTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setGetFayeArtModel:(GetFayeArtModel *)getFayeArtModel{
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:getFayeArtModel.imgUrl]];
    self.titleLabel.text = getFayeArtModel.title;
}

+ (NSString *)cellReuseIdentifierInfo{
    return @"SubYiXingTableViewCell";
}

@end
