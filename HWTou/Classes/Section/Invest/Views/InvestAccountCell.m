//
//  InvestAccountCell.m
//  HWTou
//
//  Created by 彭鹏 on 2017/7/26.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "InvestAccountCell.h"
#import "PublicHeader.h"

@interface InvestAccountCell ()
{
    UIImageView     *_imgvArrow;
}
@end

@implementation InvestAccountCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createUI];
    }
    return self;
}

- (void)createUI
{
    self.textLabel.font = FontPFRegular(14.0f);
    self.textLabel.textColor = UIColorFromHex(0x333333);
    
    _imgvArrow = [[UIImageView alloc] init];
    _imgvArrow.image = [UIImage imageNamed:@"public_cell_arrow"];
    
    [self addSubview:_imgvArrow];
    [_imgvArrow makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.trailing.equalTo(self).offset(-15);
    }];
}

@end
