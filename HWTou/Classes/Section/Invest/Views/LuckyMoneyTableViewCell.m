//
//  LuckyMoneyTableViewCell.m
//  HWTou
//
//  Created by 张维扬 on 2017/8/10.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "LuckyMoneyTableViewCell.h"
#import "PublicHeader.h"
@interface LuckyMoneyTableViewCell ()
{
    UIImageView *_imageV;
    
    UILabel *_repLab;
    UILabel *_moneyLab;
    
    UILabel *_luckyLab;
    UILabel *_conditionLab;
}
@end

@implementation LuckyMoneyTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.contentView.layer.cornerRadius = 8;
        _imageV = [[UIImageView alloc] initWithImage: [UIImage imageNamed: @"Copper_luckyMoney_pink"]];
        [self.contentView addSubview:_imageV];
        
        _repLab = [BasisUITool getLabelWithTextColor:UIColorFromHex(0xffffff) size:9];
        _repLab.text = @"- 代金 -";
        [_imageV addSubview:_repLab];
        
        _moneyLab = [BasisUITool getLabelWithTextColor:UIColorFromHex(0xffffff) size:36];
        _moneyLab.text = @"￥ 20";
        _moneyLab.adjustsFontSizeToFitWidth = YES;
        [_imageV addSubview:_moneyLab];
        
        _luckyLab = [BasisUITool getLabelWithTextColor:UIColorFromHex(0xde776a) size:15];
        _luckyLab.text = @"赚铜钱新手红包";
        [self addSubview:_luckyLab];
        _conditionLab = [BasisUITool getLabelWithTextColor:UIColorFromHex(0x7f7f7f) size:12];
        _conditionLab.numberOfLines = 2;
        _conditionLab.text = @"使用条件: 完成赚铜钱账户注册 \n使用期限: 2017.08.04 - 2017.09.04";
        [self addSubview:_conditionLab];
    }
    return self;
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    [self.contentView makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.leading).offset(CoordXSizeScale(7));
        make.trailing.equalTo(self.trailing).offset(CoordXSizeScale(-7));
        make.top.equalTo(self.top).offset(CoordYSizeScale(5));
        make.bottom.equalTo(self.bottom).offset(CoordYSizeScale(-5));
    }];
    [_imageV makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.equalTo(self.contentView);
        make.width.equalTo(CoordXSizeScale(115));
    }];
    
    [_repLab makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_imageV.centerX);
        make.top.equalTo(_imageV.top).offset(CoordYSizeScale(20));
    }];
    [_moneyLab makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_imageV.centerX);
        make.width.equalTo(_imageV).offset(-8);
        make.top.equalTo(_repLab.bottom).offset(CoordYSizeScale(16));
    }];
    [_luckyLab makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(_imageV.trailing).offset(CoordXSizeScale(10));
        make.top.equalTo(self.top).offset(CoordYSizeScale(27));
    }];
    [_conditionLab makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(_imageV.trailing).offset(CoordXSizeScale(10));
        make.top.equalTo(_luckyLab.bottom).offset(CoordYSizeScale(20));
    }];
}
- (void)setModel:(InvestListResp *)model
{
    if (_model != model) {
        _model = model;
    }
    if ([model.type isEqualToString:@"1"]) {
        _repLab.text = @"- 代金 -";
    }else{
        _repLab.text = @"- 体验金 -";
        _imageV.image = [UIImage imageNamed:@"Copper_luckyMoney_Orange"];
    }
    _moneyLab.text = [NSString stringWithFormat:@"￥%ld", model.price.integerValue];
    _luckyLab.text = model.title;
    _conditionLab.text = [NSString stringWithFormat:@"使用条件: %@\n使用期限: %@ - %@", model.condition, model.start_time, model.end_time];
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
