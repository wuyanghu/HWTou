//
//  MeEarningTableViewCell.m
//  HWTou
//
//  Created by robinson on 2017/12/1.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "MeEarningTableViewCell.h"
#import "PublicHeader.h"
#import "Navigation.h"
#import "UIApplication+Extension.h"

@implementation MeEarningTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UIImageView * imageView = [BasisUITool getImageViewWithImage:@"btn_areward" withIsUserInteraction:NO];
        [self addSubview:imageView];
        
        [self addSubview:self.titleLabel];
        [self addSubview:self.priceLabel];
        
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.equalTo(CGSizeMake(22, 22));
            make.left.equalTo(self).offset(10);
            make.top.equalTo(self).offset(10);
        }];
        
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(imageView.right).offset(10);
            make.height.equalTo(12);
            make.centerY.equalTo(self);
        }];
        
        [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.titleLabel);
            make.width.equalTo(60);
            make.height.equalTo(self.titleLabel);
            make.right.equalTo(self).offset(-10);
        }];
        
        
    }
    return self;
}

- (void)setModel:(MoneyEarningModel *)model{
    _model = model;
    self.titleLabel.text = [NSString stringWithFormat:@"%@ 打赏",model.desc];
    self.priceLabel.text = model.tipMoney;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [BasisUITool getLabelWithTextColor:UIColorFromHex(0x2B2B2B) size:12];
    }
    return _titleLabel;
}

- (UILabel *)priceLabel{
    if (!_priceLabel) {
        _priceLabel = [BasisUITool getLabelWithTextColor:UIColorFromHex(0x2B2B2B) size:14];
    }
    return _priceLabel;
}

@end
