//
//  ProductListCell.m
//  HWTou
//
//  Created by 彭鹏 on 2017/3/19.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "ProductListCell.h"
#import "ProductDetailDM.h"
#import "PublicHeader.h"

@interface ProductListCell ()
{
    UIImageView     *_imgvIcon;
    UILabel         *_labTitle;
    UILabel         *_labPrice;
}

@end

@implementation ProductListCell

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
    
    _imgvIcon = [[UIImageView alloc] init];
    _imgvIcon.contentMode = UIViewContentModeScaleToFill;
    
    _labTitle = [[UILabel alloc] init];
    _labTitle.textColor = UIColorFromHex(0x333333);
    _labTitle.font = FontPFRegular(14.0f);
    _labTitle.textAlignment = NSTextAlignmentCenter;
    
    _labPrice = [[UILabel alloc] init];
    _labPrice.textColor = UIColorFromHex(0xb4292d);
    _labPrice.font = FontPFRegular(14.0f);
    
    [self addSubview:_imgvIcon];
    [self addSubview:_labTitle];
    [self addSubview:_labPrice];
    
    [_imgvIcon makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(5.0f);
        make.width.equalTo(self).multipliedBy(0.95);
        make.height.equalTo(_imgvIcon.width).multipliedBy(0.8);
    }];
    
    [_labPrice makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.bottom.equalTo(self).offset(CoordXSizeScale(-10));
    }];
    
    [_labTitle makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.bottom.equalTo(_labPrice.top);
        make.width.equalTo(self).multipliedBy(0.8);
    }];
}

- (void)setProduct:(ProductDetailDM *)product
{
    _product = product;
    [_imgvIcon sd_setImageWithURL:[NSURL URLWithString:product.img_url]];
    _labPrice.text = product.strPrice;
    _labTitle.text = product.title;
}

- (void)drawRect:(CGRect)rect
{
    //获取绘图上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //创建一个矩形，它的下方右方内缩固定的偏移量
    CGRect drawingRect = CGRectMake(CGRectGetMinX(self.bounds), CGRectGetMinY(self.bounds),
                                    CGRectGetWidth(self.bounds) - Single_Line_Adjust_Offset,
                                    CGRectGetHeight(self.bounds) - Single_Line_Adjust_Offset);
    
    //设置笔触颜色
    CGContextSetStrokeColorWithColor(context, UIColorFromHex(0xc4c4c4).CGColor);
    
    //设置笔触宽度
    CGContextSetLineWidth(context, Single_Line_Width);
    
    //创建并设置路径(单元格下方和右侧的线条)
    
    CGContextBeginPath(context);
    
    CGContextMoveToPoint(context, CGRectGetMinX(drawingRect), CGRectGetMaxY(drawingRect));
    CGContextAddLineToPoint(context, CGRectGetMaxX(drawingRect), CGRectGetMaxY(drawingRect));
    CGContextAddLineToPoint(context, CGRectGetMaxX(drawingRect), CGRectGetMinY(drawingRect));
    
    //绘制路径
    CGContextStrokePath(context);
}

@end
