//
//  ProductAttributeCell.m
//  HWTou
//
//  Created by 彭鹏 on 2017/5/8.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "ProductAttributeCell.h"
#import "ProductAttributeDM.h"
#import "XQNumCalculateView.h"
#import "PublicHeader.h"

#define ProductStockMaxNumber  99

@interface ProductAttributeCell ()
{
    UIButton    *_btnAttr;
}
@end

@implementation ProductAttributeCell

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
    _btnAttr = [[UIButton alloc] init];
    _btnAttr.titleLabel.font = [ProductAttributeCell fontAttribute];
    [_btnAttr setTitleColor:UIColorFromHex(0x333333) forState:UIControlStateNormal];
    [_btnAttr setTitleColor:UIColorFromHex(0xb4292d) forState:UIControlStateSelected];
    [_btnAttr setTitleColor:UIColorFromHex(0xd0d0d0) forState:UIControlStateDisabled];
    [_btnAttr addTarget:self action:@selector(actionAttribute:) forControlEvents:UIControlEventTouchUpInside];
    
    _btnAttr.layer.borderColor = UIColorFromHex(0x7f7f7f).CGColor;
    _btnAttr.layer.borderWidth = Single_Line_Width;
    _btnAttr.layer.cornerRadius = 2.5f;
    
    [self.contentView addSubview:_btnAttr];
    
    [_btnAttr mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
}

- (void)setDmAttribute:(ProductAttributeDM *)dmAttribute
{
    _dmAttribute = dmAttribute;
    [_btnAttr setTitle:dmAttribute.value_name forState:UIControlStateNormal];
    _btnAttr.selected = (dmAttribute.state == ProductAttrStateSelected);
    [self setAttributeBorderColor];
}

+ (UIFont *)fontAttribute
{
    return FontPFRegular(14.0f);
}

- (void)actionAttribute:(UIButton *)button
{
    button.selected = !button.isSelected;
    [self setAttributeBorderColor];
    if ([self.delegage respondsToSelector:@selector(productAttributeCell:didSelectItem:)]) {
        [self.delegage productAttributeCell:self didSelectItem:button.isSelected];
    }
}

- (void)setAttributeBorderColor
{
    UIColor *color = _btnAttr.selected ? UIColorFromHex(0xb4292d) : UIColorFromHex(0x7f7f7f);
    _btnAttr.layer.borderColor = color.CGColor;
}
@end

@interface ProductAttrStockCell ()

@property (nonatomic, strong) XQNumCalculateView *vCalculate;

@end

@implementation ProductAttrStockCell

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
    _vCalculate = [[XQNumCalculateView alloc] init];
    _vCalculate.numViewBorderColor = UIColorFromHex(0x7f7f7f);
    _vCalculate.numColor = UIColorFromHex(0x333333);
    _vCalculate.numLabelTextFont = FontPFLight(13.0f);
    _vCalculate.calBtnDisabledTextColor = [UIColor colorWithWhite:0.8 alpha:1];
    _vCalculate.maxNum = ProductStockMaxNumber + 1;
    
    _vCalculate.calBtnTextColor = UIColorFromHex(0x333333);
    _vCalculate.calBtnTextFont = FontPFLight(15.0f);
    
    [self.contentView addSubview:_vCalculate];
    
    [_vCalculate mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
}

- (void)setChangeBlock:(ProductNumberChangeBlock)changeBlock
{
    _changeBlock = changeBlock;
    
    WeakObj(self);
    _vCalculate.changeBlock = ^(int result) {
        if (result > ProductStockMaxNumber) {
            result = ProductStockMaxNumber;
            selfWeak.vCalculate.startNum = ProductStockMaxNumber;
            [HUDProgressTool showOnlyText:@"数量已达上线"];
        } else {
            !selfWeak.changeBlock ?: selfWeak.changeBlock(result);
        }
    };
}

- (void)setStartNum:(NSInteger)startNum
{
    if (startNum <= 0) {
        startNum = 1;
    }
    _startNum = startNum;
    _vCalculate.startNum = (int)startNum;
}

@end

@interface ProductAttrHeaderView ()
{
    UILabel    *_labTitle;
}
@end

@implementation ProductAttrHeaderView

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
    _labTitle = [BasisUITool getLabelWithTextColor:UIColorFromHex(0x333333) size:15.0f];
    
    [self addSubview:_labTitle];
    [_labTitle makeConstraints:^(MASConstraintMaker *make) {
        make.leading.centerY.equalTo(self);
    }];
}

- (void)setTitle:(NSString *)title
{
    _title = title;
    _labTitle.text = title;
}

@end
