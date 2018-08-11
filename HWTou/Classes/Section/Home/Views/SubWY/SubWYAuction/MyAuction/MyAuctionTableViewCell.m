//
//  MyAuctionTableViewCell.m
//  HWTou
//
//  Created by robinson on 2018/4/23.
//  Copyright © 2018年 LieMi. All rights reserved.
//

#import "MyAuctionTableViewCell.h"

@implementation MyAuctionTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (NSString *)cellReuseIdentifierInfo{
    return @"MyAuctionTableViewCell";
}

@end
