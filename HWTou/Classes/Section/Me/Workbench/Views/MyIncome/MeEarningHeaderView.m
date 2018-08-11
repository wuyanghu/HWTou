//
//  MeEarningHeaderView.m
//  HWTou
//
//  Created by robinson on 2017/12/1.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "MeEarningHeaderView.h"
#import "PublicHeader.h"

@implementation MeEarningHeaderView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        [self drawView];
    }
    return self;
}

- (void)drawView{
    
    UIView * bgView = [[UIView alloc] init];
    bgView.backgroundColor = [UIColor whiteColor];
    [self addSubview:bgView];
    
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(10);
        make.right.equalTo(self).offset(-10);
        make.top.equalTo(self).offset(20);
        make.height.equalTo(186);
    }];
    
    UILabel * totalIncomeLabel = [BasisUITool getLabelWithTextColor:UIColorFromHex(0x8E8F91) size:12];
    totalIncomeLabel.textAlignment = NSTextAlignmentCenter;
    totalIncomeLabel.text = @"当日收益金额(元)";
    [self addSubview:totalIncomeLabel];
    
    [self addSubview:self.totalIncomeLabel];
    
    UIView * lineView = [[UIView alloc] init];
    lineView.backgroundColor = UIColorFromHex(0x8E8F91);
    [self addSubview:lineView];
    
    UILabel * canExtractIncome = [BasisUITool getLabelWithTextColor:UIColorFromHex(0x8E8F91) size:12];
    canExtractIncome.textAlignment = NSTextAlignmentCenter;
    canExtractIncome.text = @"总收益金额(元)";
    [self addSubview:canExtractIncome];
    
    [self addSubview:self.canExtractIncome];
    
    [totalIncomeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(60);
        make.left.equalTo(self).offset(40);
        make.height.equalTo(12);
        make.right.equalTo(self.mas_centerX).offset(-40);
    }];
    
    [self.totalIncomeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(totalIncomeLabel.mas_bottom).offset(16);
        make.centerX.equalTo(totalIncomeLabel);
        make.height.equalTo(18);
    }];
    
    [canExtractIncome mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.height.equalTo(totalIncomeLabel);
        make.left.equalTo(self.mas_centerX).offset(40);
        make.right.equalTo(self).offset(-40);
    }];
    
    [self.canExtractIncome mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.height.equalTo(self.totalIncomeLabel);
        make.centerX.equalTo(canExtractIncome);
    }];
    
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(totalIncomeLabel);
        make.bottom.equalTo(self.totalIncomeLabel);
        make.centerX.equalTo(self);
        make.width.equalTo(1);
    }];
    
    UIButton * withdrawBtn = [BasisUITool getBtnWithTarget:self action:@selector(buttonSelected:)];
    [withdrawBtn setBackgroundImage:[UIImage imageNamed:@"sy_btn_tx"] forState:UIControlStateNormal];
    [self addSubview:withdrawBtn];
    
    [withdrawBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(15);
        make.right.equalTo(self).offset(-15);
        make.height.equalTo(40);
        make.top.equalTo(self.totalIncomeLabel.mas_bottom).offset(40);
    }];
    
    UILabel * incomeRecord = [BasisUITool getLabelWithTextColor:UIColorFromHex(0x8E8F91) size:14];
    incomeRecord.backgroundColor = [UIColor whiteColor];
    incomeRecord.textAlignment = NSTextAlignmentCenter;
    incomeRecord.text = @"收益记录";
    [self addSubview:incomeRecord];
    
    [incomeRecord mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bgView.mas_bottom).offset(15);
        make.bottom.equalTo(self).offset(-1);
        make.width.equalTo(self);
    }];
    
    
}

- (void)setViewModel:(MoneyEarningViewModel *)viewModel{
    _viewModel = viewModel;
    self.canExtractIncome.text = viewModel.todayTips;
    self.totalIncomeLabel.text = viewModel.allTips;
}

- (void)buttonSelected:(UIButton *)button{
    [Navigation showMyWalletViewController:[UIApplication topViewController]];
}

- (UILabel *)canExtractIncome{
    if (!_canExtractIncome) {
        _canExtractIncome = [BasisUITool getLabelWithTextColor:UIColorFromHex(0xFF6767) size:18];
    }
    return _canExtractIncome;
}

- (UILabel *)totalIncomeLabel{
    if (!_totalIncomeLabel) {
        _totalIncomeLabel = [BasisUITool getLabelWithTextColor:UIColorFromHex(0xFF6767) size:18];
    }
    return _totalIncomeLabel;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

@implementation MeEarningTitleHeaderView
- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        UIView * bgView = [[UIView alloc] init];
        bgView.backgroundColor = [UIColor whiteColor];
        [self addSubview:bgView];
        
        [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.width.equalTo(self);
            make.top.equalTo(self).offset(0.5);
            make.bottom.equalTo(self).offset(-0.5);
        }];
        
        [self addSubview:self.titleLabel];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(10);
            make.centerY.equalTo(self);
            make.height.equalTo(8);
        }];
        
//        self.titleLabel.text = @"2017-10-23 星期二";
    }
    return self;
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [BasisUITool getLabelWithTextColor:UIColorFromHex(0x8E8F91) size:10];
    }
    return _titleLabel;
}
@end
