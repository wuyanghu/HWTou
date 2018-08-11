//
//  BaseTableViewCell.m
//  HWTou
//
//  Created by robinson on 2017/12/19.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "BaseTableViewCell.h"

@implementation BaseTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (NSString *)cellReuseIdentifierInfo{
    return @"cellReuseIdentifierInfo";
}
@end
