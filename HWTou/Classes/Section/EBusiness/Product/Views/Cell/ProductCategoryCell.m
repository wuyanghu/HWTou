//
//  ProductCategoryCell.m
//  HWTou
//
//  Created by 彭鹏 on 2017/3/19.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "ProductCategoryCell.h"
#import "ProductCategoryDM.h"
#import "PublicHeader.h"

@interface ProductCategoryTabCell ()
{
    UILabel     *_labTitle;
    UIView      *_vLine;
}
@end

@implementation ProductCategoryTabCell

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
    _labTitle = [[UILabel alloc] init];
    _labTitle.font = FontPFLight(15.0f);
    _labTitle.textAlignment = NSTextAlignmentCenter;
    
    _vLine = [[UIView alloc] init];
    _vLine.backgroundColor = UIColorFromHex(0xb4292d);
    
    [self addSubview:_labTitle];
    [self addSubview:_vLine];
    
    [_labTitle makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.size.equalTo(self).multipliedBy(0.9);
    }];
    
    [_vLine makeConstraints:^(MASConstraintMaker *make) {
        make.leading.centerY.equalTo(self);
        make.size.equalTo(CGSizeMake(4, 24));
    }];
}

- (void)setDmCategory:(ProductCategoryDM *)dmCategory
{
    _dmCategory = dmCategory;
    _labTitle.text = dmCategory.name;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    if (selected) {
        _vLine.hidden = NO;
        _labTitle.textColor = UIColorFromHex(0xb4292d);
    } else {
        _vLine.hidden = YES;
        _labTitle.textColor = UIColorFromHex(0x333333);
    }
}

@end

@interface ProductCategoryCollCell ()
{
    UILabel     *_labTitle;
    UIImageView *_imgvIcon;
}
@end

@implementation ProductCategoryCollCell

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
    _labTitle = [[UILabel alloc] init];
    _labTitle.textAlignment = NSTextAlignmentCenter;
    _labTitle.numberOfLines = 2;
    _labTitle.font = FontPFLight(13.0f);
    _labTitle.textColor = UIColorFromHex(0x333333);
    
    _imgvIcon = [[UIImageView alloc] init];
    
    [self addSubview:_labTitle];
    [self addSubview:_imgvIcon];
    
    [_labTitle makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_imgvIcon.bottom).offset(CoordXSizeScale(10));
        make.centerX.width.equalTo(self);
    }];
    
    [_imgvIcon makeConstraints:^(MASConstraintMaker *make) {
        make.top.centerX.width.equalTo(self);
        make.height.equalTo(_imgvIcon.width);
    }];
}

- (void)setDmCategory:(ProductCategoryDM *)dmCategory
{
    _dmCategory = dmCategory;
    _labTitle.text = dmCategory.name;
    [_imgvIcon sd_setImageWithURL:[NSURL URLWithString:dmCategory.img_url]];
}

@end
