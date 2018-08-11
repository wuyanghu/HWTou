//
//  OrderAddressView.m
//  HWTou
//
//  Created by 彭鹏 on 2017/3/19.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "OrderAddressView.h"
#import "AddressRequest.h"
#import "PublicHeader.h"
#import "AddressGoodsDM.h"

@interface OrderAddressView ()
{
    UILabel     *_labName;
    UILabel     *_labPhone;
    UILabel     *_labAddress;
    UIImageView *_imgvArrow;
}
@property (nonatomic, strong) UILabel     *labDefault;

@end

@implementation OrderAddressView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createUI];
    }
    return self;
}

- (void)createUI
{
    self.backgroundColor = [UIColor whiteColor];
    
    _imgvArrow = [[UIImageView alloc] init];
    _imgvArrow.image = [UIImage imageNamed:@"public_cell_arrow"];
    
    _labName = [[UILabel alloc] init];
    _labName.textColor = UIColorFromHex(0x333333);
    _labName.font = FontPFRegular(14.0f);
    
    _labPhone = [[UILabel alloc] init];
    _labPhone.textColor = UIColorFromHex(0x333333);
    _labPhone.font = FontPFRegular(12.0f);
    
    _labAddress = [[UILabel alloc] init];
    _labAddress.numberOfLines = 2;
    _labAddress.textColor = UIColorFromHex(0x333333);
    _labAddress.font = FontPFRegular(12.0f);
    
    _labDefault = [[UILabel alloc] init];
    _labDefault.text = @" 默认 ";
    _labDefault.layer.borderWidth = 1;
    _labDefault.layer.borderColor = UIColorFromHex(0xb4292d).CGColor;
    _labDefault.textColor = UIColorFromHex(0xb4292d);
    _labDefault.font = FontPFRegular(12.0f);
    [_labDefault setRoundWithCorner:2.0f];
    
    [self addSubview:_labDefault];
    [self addSubview:_labName];
    [self addSubview:_labPhone];
    [self addSubview:_labAddress];
    [self addSubview:_imgvArrow];
    
    [_labName makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self).offset(16.0f);
        make.bottom.equalTo(self.centerY);
    }];
    
    [_labDefault makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(_labName);
        make.top.equalTo(_labName.bottom).offset(2);
    }];
    
    [_labPhone makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.trailing).multipliedBy(0.25);
        make.bottom.equalTo(_labName);
    }];
    
    [_labAddress makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.lessThanOrEqualTo(_imgvArrow.leading).offset(-5);
        make.leading.equalTo(_labPhone);
        make.top.equalTo(_labPhone.bottom);
    }];
    
    [_imgvArrow makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self).offset(-CoordXSizeScale(18));
        make.size.equalTo(_imgvArrow.intrinsicContentSize);
        make.centerY.equalTo(self);
    }];
}

- (UILabel *)labDefault
{
    if (_labDefault == nil) {
        
    }
    return _labDefault;
}

- (void)setAddress:(AddressGoodsDM *)address
{
    _address = address;
    _labName.text = address.name;
    _labPhone.text = address.tel;
    _labAddress.text = address.full_name;
    _labDefault.hidden = !address.is_top;
}

- (void)setHideArrow:(BOOL)hideArrow
{
    _imgvArrow.hidden = hideArrow;
}
@end
