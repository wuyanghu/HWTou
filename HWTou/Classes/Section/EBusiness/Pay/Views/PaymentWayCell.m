//
//  PaymentWayCell.m
//  HWTou
//
//  Created by 彭鹏 on 2017/3/31.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "PaymentWayCell.h"
#import "PublicHeader.h"
#import "PaymentWayDM.h"


@interface PaymentGoldCell ()
{
    UIImageView     *_imgvIcon;
    UIImageView     *_imgvCheck;
    UILabel         *_labTitle;
    UILabel         *_labMoney;
}
@end

@implementation PaymentGoldCell

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
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    _imgvIcon = [[UIImageView alloc] init];
    _imgvCheck = [[UIImageView alloc] init];
    
    _labTitle = [[UILabel alloc] init];
    _labTitle.textColor = UIColorFromHex(0x333333);
    _labTitle.font = FontPFRegular(14.0f);
    
    _labMoney = [[UILabel alloc] init];
    _labMoney.textColor = UIColorFromHex(0x7f7f7f);
    _labMoney.font = FontPFRegular(12.0f);
    self.gold = 0;
    
    [self addSubview:_imgvCheck];
    [self addSubview:_imgvIcon];
    [self addSubview:_labTitle];
    [self addSubview:_labMoney];
    
    [_imgvIcon makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(15);
        make.centerY.equalTo(self);
    }];
    
    [_labTitle makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(_imgvIcon.trailing).offset(15);
        make.centerY.equalTo(self);
    }];
    
    [_labMoney makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.trailing.equalTo(_imgvCheck.leading).offset(-18);
    }];
    
    [_imgvCheck makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.trailing.equalTo(self).offset(-15);
    }];
}

- (void)setDmWay:(PaymentWayDM *)dmWay
{
    _dmWay = dmWay;
    _labTitle.text = dmWay.title;
    _imgvIcon.image = [UIImage imageNamed:dmWay.imgName];
    
    NSString *imgName = dmWay.selected ? @"com_checkbox_sel" : @"com_checkbox_nor";
    _imgvCheck.image = [UIImage imageNamed:imgName];
}

- (void)setGold:(CGFloat)gold
{
    NSString *text = [NSString stringWithFormat:@"可用余额%.2f元", gold];
    NSDictionary *dictAttr = @{NSForegroundColorAttributeName : UIColorFromHex(0xb4292d)};
    NSMutableAttributedString *strAttr = [[NSMutableAttributedString alloc] initWithString:text];
    [strAttr addAttributes:dictAttr range:NSMakeRange(4, text.length - 5)];
    _labMoney.attributedText = strAttr;
}

@end


@interface PaymentWayCell ()
{
    UIImageView     *_imgvIcon;
    UIImageView     *_imgvCheck;
    UILabel         *_labTitle;
}
@end

@implementation PaymentWayCell

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
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    _imgvIcon = [[UIImageView alloc] init];
    _imgvCheck = [[UIImageView alloc] init];
    
    _labTitle = [[UILabel alloc] init];
    _labTitle.textColor = UIColorFromHex(0x333333);
    _labTitle.font = FontPFRegular(14.0f);
    
    [self addSubview:_imgvCheck];
    [self addSubview:_imgvIcon];
    [self addSubview:_labTitle];
    
    [_imgvIcon makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(15);
        make.centerY.equalTo(self);
    }];
    
    [_labTitle makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(_imgvIcon.trailing).offset(15);
        make.centerY.equalTo(self);
    }];
    
    [_imgvCheck makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.trailing.equalTo(self).offset(-15);
    }];
}

- (void)setDmWay:(PaymentWayDM *)dmWay
{
    _dmWay = dmWay;
    _labTitle.text = dmWay.title;
    _imgvIcon.image = [UIImage imageNamed:dmWay.imgName];
    
    NSString *imgName = dmWay.selected ? @"com_radio_sel" : @"com_radio_nor";
    _imgvCheck.image = [UIImage imageNamed:imgName];
}
@end
