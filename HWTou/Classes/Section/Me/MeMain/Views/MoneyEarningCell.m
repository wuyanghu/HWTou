//
//  MoneyEarningCell.m
//  HWTou
//
//  Created by Reyna on 2018/3/30.
//  Copyright © 2018年 LieMi. All rights reserved.
//

#import "MoneyEarningCell.h"

@interface MoneyEarningCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;

@end

@implementation MoneyEarningCell

#pragma mark - Api

+ (NSString *)cellReuseIdentifierInfo {
    return @"MoneyEarningCell";
}

+ (CGFloat)singleCellHeight {
    return 44.f;
}

- (void)bind:(MoneyEarningModel *)model {
    
    self.titleLab.text = model.desc;
    self.timeLab.text = model.tipMoney;
}

#pragma mark -

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
