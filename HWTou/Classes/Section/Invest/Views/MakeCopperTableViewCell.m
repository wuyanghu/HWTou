//
//  MakeCopperTableViewCell.m
//  HWTou
//
//  Created by 张维扬 on 2017/8/10.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "MakeCopperTableViewCell.h"
#import "InvestProductDM.h"
#import "PublicHeader.h"
#import "CycleView.h"

@interface MakeCopperTableViewCell ()
{
    UIView *_lineV1;
    UIView *_lineV2;
    UIView *_erectV;
    UIView *_backV;
    
    UILabel *_titleLab;
    
    UILabel *_markLab1;
    UILabel *_markLab2;
    
    UIImageView *_aheadIMG;
    
    UILabel *_expectLab;
    UILabel *_expectNumLab;
    UILabel *_totalLab;
    UILabel *_totalNumLab;
    
    UILabel *_rateLab;
    UILabel *_attrLab;
    
    CycleView *_cycleView;
}
@end

@implementation MakeCopperTableViewCell

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
    
    _lineV1 = [[UIView alloc] init];
    _lineV1.backgroundColor = UIColorFromHex(0xf4f4f4);
    [self addSubview:_lineV1];
    [_lineV1 makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.top.equalTo(self);
        make.height.equalTo(1);
    }];
    
    _titleLab = [BasisUITool getLabelWithTextColor:UIColorFromHex(0x333333) size:16];
    _titleLab.text = @"新手专享标";
    [self addSubview:_titleLab];
    [_titleLab makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_lineV1.bottom).offset(CoordYSizeScale(10));
        make.leading.equalTo(self.leading).offset(CoordXSizeScale(10));
    }];
    
    _markLab1 = [BasisUITool getLabelWithTextColor:[UIColor whiteColor] size:10];
    _markLab1.backgroundColor = UIColorFromHex(0xfe5850);
    _markLab1.layer.cornerRadius = 3;
    _markLab1.layer.masksToBounds = YES;
    _markLab1.textAlignment = NSTextAlignmentCenter;
    _markLab1.adjustsFontSizeToFitWidth = YES;
    [self addSubview:_markLab1];
    _markLab1.text = @"花";
    _markLab2 = [BasisUITool getLabelWithTextColor:[UIColor whiteColor] size:10];
    _markLab2.backgroundColor = UIColorFromHex(0x2388d9);
    _markLab2.layer.cornerRadius = 3;
    _markLab2.layer.masksToBounds = YES;
    _markLab2.textAlignment = NSTextAlignmentCenter;
    _markLab2.text = @"押";
    _markLab2.preferredMaxLayoutWidth = 1;
    _markLab2.adjustsFontSizeToFitWidth = YES;
    [self addSubview:_markLab2];
    [_markLab1 makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(_markLab2.leading).offset(CoordXSizeScale(-10));
        make.centerY.equalTo(_titleLab.centerY);
        make.size.equalTo(CGSizeMake(CoordXSizeScale(17), CoordXSizeScale(17)));
    }];
    [_markLab2 makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_titleLab.centerY);
        make.trailing.equalTo(self.trailing).offset(CoordYSizeScale(-10));
        make.size.equalTo(CGSizeMake(CoordXSizeScale(17), CoordXSizeScale(17)));
    }];
    
    _lineV2 = [[UIView alloc] init];
    _lineV2.backgroundColor = UIColorFromHex(0xf4f4f4);
    [self addSubview:_lineV2];
    [_lineV2 makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_lineV1.bottom).equalTo(CoordYSizeScale(36));
        make.leading.trailing.equalTo(self);
        make.height.equalTo(1);
    }];
    
    _erectV = [[UIView alloc] init];
    _erectV.backgroundColor = UIColorFromHex(0xf4f4f4);
    [self addSubview:_erectV];
    [_erectV makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_lineV2.bottom).equalTo(CoordYSizeScale(40));
        make.centerX.equalTo(self.centerX);
        make.width.equalTo(1);
        make.height.equalTo(CoordYSizeScale(47));
    }];
    
    _attrLab = [BasisUITool getLabelWithTextColor:UIColorFromHex(0xfe5850) size:20];
    _attrLab.text = @"7.00% + 1.00%";
    _attrLab.numberOfLines = 1;
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:_attrLab.text];
    [attStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:30.0f] range:NSMakeRange(0, 1)];
    _attrLab.attributedText = attStr;
    _attrLab.adjustsFontSizeToFitWidth = YES;
    [self addSubview:_attrLab];
    [_attrLab makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(_erectV.leading).offset(CoordXSizeScale(-18));
        make.top.equalTo(_lineV2.bottom).offset(CoordYSizeScale(40));
        make.width.equalTo(CoordXSizeScale(138));
    }];
    
    _aheadIMG = [BasisUITool getImageViewWithImage:@"ahead_money" withIsUserInteraction:NO];
    [self addSubview:_aheadIMG];
    [_aheadIMG makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_attrLab.top).offset(CoordYSizeScale(-1));
        make.trailing.equalTo(_erectV.leading).offset(CoordXSizeScale(-14));
    }];
    
    _rateLab = [BasisUITool getLabelWithTextColor:UIColorFromHex(0x909090) size:9];
    _rateLab.text = @"预期年利化率";
    [self addSubview:_rateLab];
    [_rateLab makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_attrLab.bottom).offset(CoordYSizeScale(5));
        make.leading.equalTo(_attrLab.leading);
    }];
    
    _expectLab = [BasisUITool getLabelWithTextColor:UIColorFromHex(0x909090) size:9];
    _expectLab.text = @"项目期限";
    [self addSubview:_expectLab];
    _expectNumLab = [BasisUITool getLabelWithTextColor:UIColorFromHex(0x333333) size:12];
    _expectNumLab.text = @"3个月";
    [self addSubview:_expectNumLab];
    [_expectLab makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(_erectV.trailing).equalTo(CoordXSizeScale(15));
        make.top.equalTo(_erectV.top).offset(CoordYSizeScale(10));
    }];
    [_expectNumLab makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_expectLab.centerY);
        make.leading.equalTo(_expectLab.trailing).offset(CoordXSizeScale(10));
    }];
    
    _totalLab = [BasisUITool getLabelWithTextColor:UIColorFromHex(0x909090) size:9];
    _totalLab.text = @"项目总额";
    [self addSubview:_totalLab];
    _totalNumLab = [BasisUITool getLabelWithTextColor:UIColorFromHex(0x333333) size:12];
    _totalNumLab.text = @"57000元";
    [self addSubview:_totalNumLab];
    
    [_totalLab makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_expectLab.centerX);
        make.top.equalTo(_expectLab.bottom).offset(CoordXSizeScale(10));
    }];
    [_totalNumLab makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_totalLab.centerY);
        make.leading.equalTo(_totalLab.trailing).offset(CoordXSizeScale(10));
    }];

    _cycleView = [[CycleView alloc] init];
    _cycleView.cusRadius = (CoordXSizeScale(50) - CoordXSizeScale(2)) /2;
    _cycleView.cusLineWidth = CoordXSizeScale(2);
    _cycleView.backgroundColor = [UIColor whiteColor];
    _cycleView.foreGroundColor = UIColorFromHex(0xfe5850);
    _cycleView.cusBackGroundColor = UIColorFromHex(0xd6d7dc);
    _cycleView.label.text = [NSString stringWithFormat:@"50%%"];
    [_cycleView setEndAngle:75];
    [self addSubview:_cycleView];
    [_cycleView makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self.trailing).offset(CoordXSizeScale(-10));
        make.bottom.equalTo(self.bottom).offset(CoordYSizeScale(-28));
        make.size.equalTo(CGSizeMake(CoordXSizeScale(50), CoordXSizeScale(50)));
    }];
    
    _backV = [[UIView alloc] init];
    _backV.backgroundColor = UIColorFromHex(0xf4f4f4);
    [self addSubview:_backV];
    [_backV makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(self);
        make.bottom.equalTo(self.bottom);
        make.height.equalTo(CoordYSizeScale(10));
    }];
}

- (void)setDmProduct:(InvestProductDM *)dmProduct
{
    _dmProduct = dmProduct;
    _titleLab.text = dmProduct.name;
    _expectNumLab.text = [NSString stringWithFormat:@"%@月", dmProduct.timeLimit];
    _totalNumLab.text = [NSString stringWithFormat:@"%@元", dmProduct.amountBorrow];
    _attrLab.text = [NSString stringWithFormat:@"%.2f%%", dmProduct.rateYear.floatValue];
    
    _cycleView.label.text = [NSString stringWithFormat:@"%@%%", dmProduct.progressPercentage];
    [_cycleView setEndAngle:[dmProduct.progressPercentage intValue]];
}

@end
