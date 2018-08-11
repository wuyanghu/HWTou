//
//  ProductDetailToolView.m
//  HWTou
//
//  Created by 彭鹏 on 2017/4/16.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "ProductDetailToolView.h"
#import "WZLBadgeImport.h"
#import "PublicHeader.h"

@interface ProductDetailToolView ()
{
    UILabel     *_labPageNum;
    UIButton    *_btnCollect;
    UIButton    *_btnChoice;
    UIView      *_vSpeciMask;
    UIImageView *_imgvCart;
}
@end

@implementation ProductDetailToolView

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
    self.backgroundColor = UIColorFromHex(0xfafafa);
    
    UIView *vLineH = [[UIView alloc] init];
    vLineH.backgroundColor = UIColorFromHex(0xc4c4c4);
    
    UIView *vLineV1 = [[UIView alloc] init];
    vLineV1.backgroundColor = UIColorFromHex(0xc4c4c4);
    
    UIView *vLineV2 = [[UIView alloc] init];
    vLineV2.backgroundColor = UIColorFromHex(0xc4c4c4);
    
    _btnCollect = [[UIButton alloc] init];
    _btnCollect.tag = DetailActionCollect;
    [_btnCollect setImage:[UIImage imageNamed:@"shop_detail_collect"] forState:UIControlStateNormal];
    [_btnCollect setImage:[UIImage imageNamed:@"shop_detail_collect_sel"] forState:UIControlStateSelected];
    [_btnCollect addTarget:self action:@selector(actionButton:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *btnShopCar = [[UIButton alloc] init];
    btnShopCar.tag = DetailActionCartList;
    [btnShopCar setImage:[UIImage imageNamed:@"shop_detail_car"] forState:UIControlStateNormal];
    [btnShopCar addTarget:self action:@selector(actionButton:) forControlEvents:UIControlEventTouchUpInside];
    
    _imgvCart = [[UIImageView alloc] init];
    _imgvCart.image = [UIImage imageNamed:@"shop_detail_car"];
    
    UIButton *btnJoinCar = [[UIButton alloc] init];
    btnJoinCar.tag = DetailActionCartAdd;
    btnJoinCar.titleLabel.font = FontPFRegular(14.0f);
    [btnJoinCar setTitle:@"加入购物车" forState:UIControlStateNormal];
    [btnJoinCar setTitleColor:UIColorFromHex(0x333333) forState:UIControlStateNormal];
    [btnJoinCar addTarget:self action:@selector(actionButton:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *btnBuy = [[UIButton alloc] init];
    btnBuy.tag = DetailActionNowBuy;
    [btnBuy setTitle:@"立即购买" forState:UIControlStateNormal];
    [btnBuy setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btnBuy.backgroundColor = UIColorFromHex(0xb4292d);
    btnBuy.titleLabel.font = FontPFRegular(14.0f);
    [btnBuy addTarget:self action:@selector(actionButton:) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:vLineH];
    [self addSubview:vLineV1];
    [self addSubview:vLineV2];
    [self addSubview:btnBuy];
    [self addSubview:btnShopCar];
    [self addSubview:btnJoinCar];
    [self addSubview:_btnCollect];
    [self addSubview:_imgvCart];
    
    // 分割线
    [vLineH makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.top.equalTo(self);
        make.height.equalTo(Single_Line_Width);
    }];
    
    [vLineV1 makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.top.equalTo(self);
        make.centerX.equalTo(_btnCollect.trailing);
        make.width.equalTo(Single_Line_Width);
    }];
    
    [vLineV2 makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.top.width.equalTo(vLineV1);
        make.centerX.equalTo(btnShopCar.trailing);
    }];
    
    [btnBuy makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.centerY.height.equalTo(self);
        make.width.equalTo(self).multipliedBy(0.33);
    }];
    
    [btnJoinCar makeConstraints:^(MASConstraintMaker *make) {
        make.size.centerY.equalTo(btnBuy);
        make.trailing.equalTo(btnBuy.leading);
    }];
    
    [_btnCollect makeConstraints:^(MASConstraintMaker *make) {
        make.leading.top.bottom.equalTo(self);
        make.trailing.equalTo(btnShopCar.leading);
    }];
    
    [btnShopCar makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self);
        make.width.equalTo(_btnCollect);
        make.trailing.equalTo(btnJoinCar.leading);
    }];
    
    [_imgvCart makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(btnShopCar);
    }];
}

- (void)actionButton:(UIButton *)button
{
    if ([self.delegate respondsToSelector:@selector(productDetailAction:)]) {
        [self.delegate productDetailAction:button.tag];
    }
}

- (void)setCollect:(BOOL)collect
{
    _btnCollect.selected = collect;
}

- (void)setCartNumber:(NSInteger)num
{
    _cartNumber = num;
    if (num > 0) {
        [_imgvCart setBadgeBgColor:UIColorFromHex(0xb4292d)];
        [_imgvCart showBadgeWithStyle:WBadgeStyleNumber value:num animationType:WBadgeAnimTypeNone];
    } else {
        [_imgvCart clearBadge];
    }
}

@end
