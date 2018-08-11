//
//  RadioHeaderCell.m
//  HWTou
//
//  Created by Reyna on 2017/11/24.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "RadioHeaderCell.h"

@implementation RadioHeaderCell

#pragma mark - Action

- (IBAction)headerTypeAction:(UIButton *)btn {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(radioHeaderSelectAction:)]) {
        [self.delegate radioHeaderSelectAction:btn.tag - 100];
    }
}

#pragma mark -

+ (NSString *)cellReuseIdentifierInfo {
    return @"RadioHeaderCell";
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
