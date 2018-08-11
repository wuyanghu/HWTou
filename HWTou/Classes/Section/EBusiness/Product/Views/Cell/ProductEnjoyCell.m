//
//  ProductEnjoyCell.m
//  HWTou
//
//  Created by 彭鹏 on 2017/3/19.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "XQNumCalculateView.h"
#import "ProductEnjoyCell.h"
#import "OrderDetailDM.h"
#import "ProductCartDM.h"
#import "ProductCollectDM.h"
#import "PublicHeader.h"

@interface ProductEnjoyCell ()
{
@protected
    UILabel     *_labTitle;
    UILabel     *_labDetail;
    UILabel     *_labPrice;
    UILabel     *_labNumber;
    UIView      *_vSeparator;
    UIImageView *_imgvIcon;
}

@end

@implementation ProductEnjoyCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createUI];
        [self layoutViews];
    }
    return self;
}

- (void)createUI
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    _imgvIcon = [[UIImageView alloc] init];
    
    _labTitle = [[UILabel alloc] init];
    _labTitle.textColor = UIColorFromHex(0x333333);
    _labTitle.font = FontPFRegular(14.0f);
    
    _labPrice = [[UILabel alloc] init];
    _labPrice.textColor = UIColorFromHex(0x333333);
    _labPrice.font = FontPFRegular(13.0f);
    
    _labNumber = [[UILabel alloc] init];
    _labNumber.textColor = UIColorFromHex(0x333333);
    _labNumber.font = FontPFRegular(12.0f);
    
    _labDetail = [[UILabel alloc] init];
    _labDetail.textColor = UIColorFromHex(0x7f7f7f);
    _labDetail.font = FontPFRegular(12.0f);
}

- (void)layoutViews
{
    [self addSubview:_imgvIcon];
    [self addSubview:_labTitle];
    [self addSubview:_labDetail];
    [self addSubview:_labPrice];
    [self addSubview:_labNumber];
    
    _vSeparator = [[UIView alloc] init];
    _vSeparator.backgroundColor = [UIColor colorWithWhite:0.85 alpha:1];
    
    [self addSubview:_vSeparator];
    [_vSeparator makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self);
        make.bottom.equalTo(self).offset(-Single_Line_Adjust_Offset);
        make.leading.equalTo(_imgvIcon);
        make.height.equalTo(Single_Line_Width);
    }];
    
    [_imgvIcon makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.leading.equalTo(self).offset(self.leftSpace);
        make.height.equalTo(self).multipliedBy(0.76);
        make.width.equalTo(_imgvIcon.height);
    }];
    
    [_labTitle makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.lessThanOrEqualTo(_labNumber.leading).offset(-6);
        make.leading.equalTo(_labDetail);
        make.top.equalTo(_imgvIcon).offset(5);
    }];
    
    [_labDetail makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.centerY);
        make.leading.equalTo(_imgvIcon.trailing).offset(10);
        make.trailing.equalTo(_labTitle);
    }];
    
    [_labPrice makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(_labDetail);
        make.bottom.equalTo(_imgvIcon).offset(-2);
    }];
    
    [_labNumber makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self).offset(-18);
        make.centerY.equalTo(_labTitle);
    }];
}

- (void)setHideSeparator:(BOOL)hideSeparator
{
    _vSeparator.hidden = hideSeparator;
}

- (CGFloat)leftSpace
{
    return 15.0f;
}

- (void)setCartProduct:(ProductCartDM *)cartProduct
{
    _cartProduct = cartProduct;
    [_imgvIcon sd_setImageWithURL:[NSURL URLWithString:cartProduct.img_url]];
    _labNumber.text = [NSString stringWithFormat:@"x%d", cartProduct.num];
    _labTitle.text = cartProduct.title;
    _labPrice.text = cartProduct.strPrice;
    _labDetail.text = cartProduct.value_names;
}

- (void)setOrderProduct:(OrderProductDM *)orderProduct
{
    _orderProduct = orderProduct;
    _labTitle.text = orderProduct.title;
    [_imgvIcon sd_setImageWithURL:[NSURL URLWithString:orderProduct.img_url]];
    _labNumber.text = [NSString stringWithFormat:@"x%d", (int)orderProduct.num];
    _labPrice.text = [NSString stringWithFormat:@"¥%.2f", orderProduct.price];
    _labDetail.text = orderProduct.miv.value_names;
}

- (void)setCollectProduct:(ProductCollectDM *)collectProduct
{
    _collectProduct = collectProduct;
    _labTitle.text = collectProduct.title;
    [_imgvIcon sd_setImageWithURL:[NSURL URLWithString:collectProduct.img_url]
                 placeholderImage:ImageNamed(PUBLIC_IMG_DEFAULT)];
    
    _labPrice.text = [NSString stringWithFormat:@"¥%.2f", collectProduct.price];;
    
}

@end

@interface ProductCartCell ()
{
    UIButton    *_btnCheck;
}
@end

@implementation ProductCartCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupViews];
    }
    return self;
}

- (void)setupViews
{
    _btnCheck = [[UIButton alloc] init];
    [_btnCheck setImage:[UIImage imageNamed:@"com_radio_nor"] forState:UIControlStateNormal];
    [_btnCheck setImage:[UIImage imageNamed:@"com_radio_sel"] forState:UIControlStateSelected];
    [_btnCheck addTarget:self action:@selector(actionSelect:) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:_btnCheck];
    
    [_btnCheck makeConstraints:^(MASConstraintMaker *make) {
        make.leading.centerY.height.equalTo(self);
        make.width.equalTo(CoordXSizeScale(50));
    }];
}

- (void)actionSelect:(UIButton *)button
{
    button.selected = !button.isSelected;
    if ([self.delegate respondsToSelector:@selector(cartCell:didSelectItem:)]) {
        [self.delegate cartCell:self didSelectItem:button.selected];
    }
}

- (CGFloat)leftSpace
{
    return CoordXSizeScale(50);
}

- (void)setCartProduct:(ProductCartDM *)cartProduct
{
    [super setCartProduct:cartProduct];
    _btnCheck.selected = cartProduct.selected;
}
@end

@interface ProductCartEditCell ()
{
    XQNumCalculateView  *_vCalculate;
}
@end

@implementation ProductCartEditCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupEditView];
    }
    return self;
}

- (void)setupEditView
{
    _labNumber.hidden = YES;
    
    _vCalculate = [[XQNumCalculateView alloc] init];
    _vCalculate.numViewBorderColor = UIColorFromHex(0x7f7f7f);
    _vCalculate.calBtnDisabledTextColor = [UIColor colorWithWhite:0.8 alpha:1];
    _vCalculate.numColor = UIColorFromHex(0x333333);
    _vCalculate.numLabelTextFont = FontPFLight(13.0f);
    
    _vCalculate.calBtnTextColor = UIColorFromHex(0x333333);
    _vCalculate.calBtnTextFont = FontPFLight(14.0f);
    
    [self addSubview:_vCalculate];
    [_vCalculate makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(_labNumber);
        make.bottom.equalTo(_imgvIcon);
        make.size.equalTo(CGSizeMake(100, 25));
    }];
    
    WeakObj(self)
    _vCalculate.changeBlock = ^(int result) {
        selfWeak.cartProduct.num = result;
    };
}

- (void)setCartProduct:(ProductCartDM *)cartProduct
{
    [super setCartProduct:cartProduct];
    _vCalculate.maxNum = (int)cartProduct.stock;
    _vCalculate.startNum = cartProduct.num;
}

@end

@interface ProductRefundCell ()
{
    UIButton    *_btnRefund;
}
@end

@implementation ProductRefundCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViews];
    }
    return self;
}

- (void)setupViews
{
    _btnRefund = [[UIButton alloc] init];
    _btnRefund.titleLabel.font = FontPFRegular(14.0f);
    [_btnRefund setTitle:@"退款" forState:UIControlStateNormal];
    [_btnRefund setTitleColor:UIColorFromHex(0x7f7f7f) forState:UIControlStateNormal];
    [_btnRefund setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    [_btnRefund addTarget:self action:@selector(actionRefund) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:_btnRefund];
    
    [_btnRefund makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self).offset(-12.0f);
        make.bottom.equalTo(self).offset(-6.0f);
    }];
}

- (void)actionRefund
{
    if ([self.delegate respondsToSelector:@selector(onRefundEventOrder:)]) {
        [self.delegate onRefundEventOrder:self.orderProduct];
    }
}

@end

@implementation ProductCollectCell : ProductEnjoyCell

- (instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        _labNumber.hidden = YES;
        
    }
    
    return self;
    
}

@end
