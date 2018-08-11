//
//  ProductDetailCell.m
//  HWTou
//
//  Created by 彭鹏 on 2017/4/16.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "ProductDetailCell.h"
#import "ProductDetailDM.h"
#import "PublicHeader.h"

@implementation ProductDetailCell

@end

@interface ProductBasisInfoCell ()
{
    UILabel     *_labTitle;
    UILabel     *_labPrice;
    UILabel     *_labRemark;
}
@end

@implementation ProductBasisInfoCell

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
    _labTitle  = [BasisUITool getLabelWithTextColor:UIColorFromHex(0x333333) size:15.0f];
    _labRemark = [BasisUITool getLabelWithTextColor:UIColorFromHex(0x333333) size:13.0f];
    _labPrice  = [BasisUITool getLabelWithTextColor:UIColorFromHex(0xb4292d) size:15.0f];
    _labTitle.preferredMaxLayoutWidth = kMainScreenWidth;
    _labRemark.preferredMaxLayoutWidth = kMainScreenWidth;
    _labPrice.preferredMaxLayoutWidth = kMainScreenWidth;
    _labTitle.textAlignment = NSTextAlignmentCenter;
    _labRemark.textAlignment = NSTextAlignmentCenter;
    _labTitle.numberOfLines = 0;
    _labRemark.numberOfLines = 0;
    
    [self.contentView addSubview:_labTitle];
    [self.contentView addSubview:_labRemark];
    [self.contentView addSubview:_labPrice];
    
    [_labTitle makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView);
        make.width.equalTo(self.contentView).multipliedBy(0.9);
        make.top.equalTo(self.contentView).offset(25.0f);
    }];
    
    [_labRemark makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView);
        make.width.equalTo(self.contentView).multipliedBy(0.9);
        make.top.equalTo(_labTitle.bottom).offset(4.0f);
    }];
    
    [_labPrice makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_labRemark.bottom).offset(6.0f);
        make.centerX.equalTo(self.contentView);
        make.bottom.equalTo(self.contentView.bottom).offset(-25);
    }];
}

- (void)setDmProduct:(ProductDetailDM *)dmProduct
{
    _dmProduct = dmProduct;
    _labTitle.text = dmProduct.title;
    _labPrice.text = dmProduct.strPrice;
    _labRemark.text = dmProduct.remark;
}
@end

@interface ProductDetailAttCell ()
{
    UILabel         *_labTitle;
    UILabel         *_labNumber;
    UIImageView     *_imgvArrow;
}
@end

@implementation ProductDetailAttCell

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

    _labTitle = [BasisUITool getLabelWithTextColor:UIColorFromHex(0x333333) size:15.0f];
    _labTitle.text = @"规格数量选择";
    
    _labNumber = [BasisUITool getLabelWithTextColor:UIColorFromHex(0x7f7f7f) size:12.0f];
    
    _imgvArrow = [[UIImageView alloc] init];
    _imgvArrow.image = [UIImage imageNamed:@"public_cell_arrow"];
    
    [self.contentView addSubview:_labTitle];
    [self.contentView addSubview:_labNumber];
    [self.contentView addSubview:_imgvArrow];
    
    [_labTitle makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.leading.equalTo(self.contentView).offset(15);
        make.trailing.lessThanOrEqualTo(_labNumber.leading).offset(-10);
    }];
    
    [_imgvArrow makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.size.equalTo(_imgvArrow.intrinsicContentSize);
        make.trailing.equalTo(self.contentView).offset(-15);
    }];
    
    [_labNumber makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_imgvArrow);
        make.trailing.equalTo(_imgvArrow.leading).offset(-6);
    }];
}

- (void)setNumber:(NSInteger)number
{
    _number = number;
    [self setupData];
}

- (void)setTitle:(NSString *)title
{
    _title = title;
    [self setupData];
}

- (void)setupData
{
    if (self.title.length > 0) {
        _labTitle.text = [NSString stringWithFormat:@"已选择: %@", self.title];
    } else {
        _labTitle.text = @"规格数量选择";
    }
    
    if (self.title.length > 0 && self.number > 0) {
        _labNumber.text = [NSString stringWithFormat:@"x%d", (int)self.number];
    } else {
        _labNumber.text = @"";
    }
}
@end

@interface ProductCommentAllCell ()
{
    UILabel         *_labTitle;
    UILabel         *_labShowAll;
    UIImageView     *_imgvArrow;
}
@end

@implementation ProductCommentAllCell

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
    _labTitle = [BasisUITool getLabelWithTextColor:UIColorFromHex(0x333333) size:15.0f];
    _labTitle.text = @"评论";
    
    _labShowAll = [BasisUITool getLabelWithTextColor:UIColorFromHex(0x7f7f7f) size:12.0f];
    _labShowAll.text = @"查看全部";
    
    UIView *vLine = [[UIView alloc] init];
    vLine.backgroundColor = UIColorFromHex(0xf4f4f4);
    
    _imgvArrow = [[UIImageView alloc] init];
    _imgvArrow.image = [UIImage imageNamed:@"public_cell_arrow"];
    
    [self.contentView addSubview:_labTitle];
    [self.contentView addSubview:_imgvArrow];
    [self.contentView addSubview:_labShowAll];
    [self.contentView addSubview:vLine];
    
    [_labTitle makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.leading.equalTo(self.contentView).offset(15);
    }];
    
    [_imgvArrow makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.trailing.equalTo(self.contentView).offset(-15);
    }];
    
    [_labShowAll makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_imgvArrow);
        make.trailing.equalTo(_imgvArrow.leading).offset(-6);
    }];
    
    [vLine makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(_labTitle);
        make.bottom.trailing.equalTo(self.contentView);
        make.height.equalTo(Single_Line_Width);
    }];
}

@end
