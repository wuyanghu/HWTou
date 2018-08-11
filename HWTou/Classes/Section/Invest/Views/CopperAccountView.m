//
//  CopperAccountView.m
//  HWTou
//
//  Created by 张维扬 on 2017/8/8.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "CopperAccountView.h"
#import "InvestAccountDM.h"
#import <HWTSDK/HWTAPI.h>
#import "PublicHeader.h"

@implementation CopperAccountView
{
    UIImageView *_bgImgView;
    UILabel *_moneyLabel;
    UILabel *_totalNumLabel;
    
    UILabel *_waitLabel;
    UILabel *_waitNumLabel;
    
    UILabel *_aheadLabel;
    UILabel *_aheadNumLabel;
    
    UILabel *_finishLabel;
    UILabel *_finishNumLabel;
    
    UIView *line1;
    UIView *line2;
    
    UIView *view;
    UILabel *_usedLabel;
    UILabel *_usedNumLabel;
    
    UIButton *_cashBtn;
    UIButton *_topUpBtn;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createUI];
        [self layoutViews];
    }
    return self;
}

- (void)createUI
{
    _bgImgView = [BasisUITool getImageViewWithImage:@"" withIsUserInteraction:NO];
    _bgImgView.backgroundColor = UIColorFromHex(0x0b9af9);
    [self addSubview:_bgImgView];

    _moneyLabel = [BasisUITool getLabelWithTextColor:UIColorFromHex(0xd6d7dc) size:18];
    _moneyLabel.text = @"我的资产(元)";
    _moneyLabel.font = FontPFRegular(18);
    [self addSubview:_moneyLabel];
    _totalNumLabel = [BasisUITool getBoldLabelWithTextColor:[UIColor whiteColor] size:30];
    _totalNumLabel.text = @"0.00";
    _totalNumLabel.font = FontPFRegular(30);
    [self addSubview:_totalNumLabel];
    
    // 待到账收益
    _waitLabel = [BasisUITool getLabelWithTextColor:UIColorFromHex(0xd6d7dc) size:12];
    _waitLabel.text = @"待到账收益";
    _waitLabel.font = FontPFRegular(12);
    [self addSubview:_waitLabel];
    _waitNumLabel = [BasisUITool getLabelWithTextColor:[UIColor whiteColor] size:15];
    _waitNumLabel.text = @"0.00";
    _waitNumLabel.font = FontPFRegular(15);
    [self addSubview:_waitNumLabel];
    // 提前花
    _aheadLabel = [BasisUITool getLabelWithTextColor:UIColorFromHex(0xffd562) size:12];
    _aheadLabel.text = @"提前花";
    _aheadLabel.font = FontPFRegular(12);
    [self addSubview:_aheadLabel];
    _aheadNumLabel = [BasisUITool getLabelWithTextColor:[UIColor whiteColor] size:15];
    _aheadNumLabel.text = @"0.00";
    _aheadNumLabel.font = FontPFRegular(15);
    [self addSubview:_aheadNumLabel];
    // 已到账收益
    _finishLabel = [BasisUITool getLabelWithTextColor:UIColorFromHex(0xd6d7dc) size:12];
    _finishLabel.text = @"已到账收益";
    _finishLabel.font = FontPFRegular(12);
    [self addSubview:_finishLabel];
    _finishNumLabel = [BasisUITool getLabelWithTextColor:[UIColor whiteColor] size:15];
    _finishNumLabel.text = @"0.00";
    _finishNumLabel.font = FontPFRegular(15);
    [self addSubview:_finishNumLabel];

    line1 = [[UIView alloc] init];
    line1.backgroundColor = [UIColor whiteColor];
    [self addSubview:line1];
    
    line2 = [[UIView alloc] init];
    line2.backgroundColor = [UIColor whiteColor];
    [self addSubview:line2];
    
    view = [[UIView alloc] init];
    view.backgroundColor = [UIColor whiteColor];
    [self addSubview:view];
    
    _usedLabel = [BasisUITool getLabelWithTextColor:UIColorFromHex(0x909090) size:12];
    _usedLabel.text = @"可用余额 (元)";
    _usedLabel.font = FontPFRegular(12);
    [view addSubview:_usedLabel];
    
    _usedNumLabel = [BasisUITool getLabelWithTextColor:[UIColor whiteColor] size:16];
    _usedNumLabel.text = @"0.00";
    _usedNumLabel.textColor = UIColorFromHex(0x2b2b2b);
    _usedNumLabel.font = FontPFRegular(16);
    [view addSubview:_usedNumLabel];
    
    _topUpBtn = [BasisUITool getBtnWithTarget:self action:@selector(actionRecharge)];
    [_topUpBtn setTitle:@"充值" forState:UIControlStateNormal];
    [_topUpBtn setTitleColor:UIColorFromHex(0xff5063) forState:UIControlStateNormal];
    [_topUpBtn.layer setBorderWidth:1];
    [_topUpBtn.layer setBorderColor:UIColorFromHex(0xff5063).CGColor];
    [_topUpBtn.layer setCornerRadius:12];
    [view addSubview:_topUpBtn];
    
    _cashBtn = [BasisUITool getBtnWithTarget:self action:@selector(actionCash)];
    [_cashBtn setTitle:@"提现" forState:UIControlStateNormal];
    [_cashBtn setTitleColor:UIColorFromHex(0xff5063) forState:UIControlStateNormal];
    [_cashBtn.layer setBorderWidth:1];
    [_cashBtn.layer setBorderColor:UIColorFromHex(0xff5063).CGColor];
    [_cashBtn.layer setCornerRadius:12];
    [view addSubview:_cashBtn];
    
}

- (void)setDmAccount:(InvestAccountDM *)dmAccount
{
    _dmAccount = dmAccount;
    _totalNumLabel.text = [NSString stringWithFormat:@"%.2f", dmAccount.accountAmountTotal];
    _waitNumLabel.text = [NSString stringWithFormat:@"%.2f", dmAccount.incomeCollecting];
    _finishNumLabel.text = [NSString stringWithFormat:@"%.2f", dmAccount.incomeCollected];
    _usedNumLabel.text = [NSString stringWithFormat:@"%.2f", dmAccount.balanceAvailable];
}

- (void)setGold:(float)gold
{
    _gold = gold;
    _aheadNumLabel.text = [NSString stringWithFormat:@"%.2f", gold];
}

- (void)actionRecharge
{
    [[HWTAPI sharedInstance] jumpToRechargeTableViewControllerFromVC:self.viewController];
}

- (void)actionCash
{
    [[HWTAPI sharedInstance] jumpToCashTableViewControllerFromVC:self.viewController];
}

- (void)layoutViews
{
    [_bgImgView makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.top.equalTo(self);
        make.height.equalTo(CoordYSizeScale(260));
    }];
    
    [_moneyLabel makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_bgImgView.centerX);
        make.top.mas_equalTo(_bgImgView.top).offset(CoordYSizeScale(80));
    }];
    
    [_totalNumLabel makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_bgImgView.centerX);
        make.top.equalTo(_moneyLabel.bottom);
    }];
    
    [_waitLabel makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_bgImgView.centerX);
        make.bottom.equalTo(line1.centerY).offset(-2);
    }];
    
    [_waitNumLabel makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_bgImgView.centerX);
        make.top.equalTo(line1.centerY).offset(2);
    }];
    
    [line1 makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(_bgImgView.leading).offset((kMainScreenWidth - 4) / 3);
        make.bottom.equalTo(_bgImgView.bottom).offset(-30);
        make.size.equalTo(CGSizeMake(1, CoordYSizeScale(55)));
    }];
    
    [_aheadLabel makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_waitLabel.centerY);
        make.trailing.equalTo(line1.trailing).offset(CoordXSizeScale(-43));
    }];
    [_aheadNumLabel makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_aheadLabel.centerX);
        make.centerY.equalTo(_waitNumLabel.centerY);
    }];
    
    [line2 makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(_bgImgView.trailing).offset(-(kMainScreenWidth - 4) / 3);
        make.bottom.equalTo(_bgImgView.bottom).offset(-30);
        make.size.equalTo(CGSizeMake(1, CoordYSizeScale(55)));
    }];
    
    [_finishLabel makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_waitLabel.centerY);
        make.leading.equalTo(line2.leading).offset(CoordXSizeScale(32));
    }];
    [_finishNumLabel makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_finishLabel.centerX);
        make.centerY.equalTo(_waitNumLabel.centerY);
    }];
    
    [view makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(self);
        make.top.equalTo(_bgImgView.bottom);
        make.bottom.equalTo(self.bottom).offset(-10);
    }];
    
    [_usedLabel makeConstraints:^(MASConstraintMaker *make) {
        
        make.leading.equalTo(view.leading).offset(CoordXSizeScale(30));
        make.bottom.equalTo(view.centerY);
    }];
    
    [_usedNumLabel makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_usedLabel.centerX);
        make.top.equalTo(view.centerY).offset(-1);
    }];
    
    [_topUpBtn makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(view.centerY);
        make.trailing.equalTo(view.trailing).offset(-20);
        make.size.equalTo(CGSizeMake(60, 25));
    }];
    
    [_cashBtn makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(view.centerY);
        make.trailing.equalTo(_topUpBtn.leading).offset(-15);
        make.size.equalTo(CGSizeMake(60, 25));
    }];
}

@end
