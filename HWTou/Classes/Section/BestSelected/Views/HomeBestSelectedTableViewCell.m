//
//  HomeBestSelectedTableViewCell.m
//  HWTou
//
//  Created by robinson on 2018/1/17.
//  Copyright © 2018年 LieMi. All rights reserved.
//

#import "HomeBestSelectedTableViewCell.h"

@implementation HomeBestSelectedTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (NSString *)cellReuseIdentifierInfo{
    return @"HomeBestSelectedTableViewCell";
}

@end
