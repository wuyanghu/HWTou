//
//  ConsumpGoldExtractView.m
//  HWTou
//
//  Created by 彭鹏 on 2017/7/11.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "ConsumpGoldExtractView.h"
#import "ConsumptionGoldReq.h"
#import "PersonalInfoDM.h"
#import "PublicHeader.h"

@interface ConsumpGoldExtractView () <UITextFieldDelegate>
{
    UITextField *_tfName;
    UITextField *_tfCard;
    UITextField *_tfMoney;
    UILabel     *_labBalance;
    UIButton    *_btnNextStep;
}

@end

@implementation ConsumpGoldExtractView

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
    self.backgroundColor = UIColorFromHex(0xf4f4f4);
    
    UIView *vInputBG = [[UIView alloc] init];
    vInputBG.backgroundColor = [UIColor whiteColor];
    
    UILabel *labName = [BasisUITool getLabelWithTextColor:UIColorFromHex(0x555555) size:15.0f];
    labName.text = @"持卡人";
    
    UILabel *labCard = [BasisUITool getLabelWithTextColor:UIColorFromHex(0x555555) size:15.0f];
    labCard.text = @"银行卡号";
    
    UITextField *tfName = [BasisUITool getTextFieldWithTextColor:UIColorFromHex(0x333333) withSize:15 withPlaceholder:@"请输入持卡人姓名" withDelegate:self];
    [tfName addTarget:self action:@selector(textFieldEditingChanged:) forControlEvents:UIControlEventEditingChanged];
    
    UITextField *tfCard = [BasisUITool getTextFieldWithTextColor:UIColorFromHex(0x333333) withSize:15 withPlaceholder:@"请输入银行卡号" withDelegate:self];
    [tfCard addTarget:self action:@selector(textFieldEditingChanged:) forControlEvents:UIControlEventEditingChanged];
    tfCard.keyboardType = UIKeyboardTypeNumberPad;
    _tfName = tfName;
    _tfCard = tfCard;
    
    UIView *vLine1 = [[UIView alloc] init];
    vLine1.backgroundColor = UIColorFromHex(0xf4f4f4);
    
    [self addSubview:vInputBG];
    [vInputBG addSubview:labName];
    [vInputBG addSubview:labCard];
    [vInputBG addSubview:tfName];
    [vInputBG addSubview:tfCard];
    [vInputBG addSubview:vLine1];
    
    [vInputBG makeConstraints:^(MASConstraintMaker *make) {
        make.top.trailing.leading.equalTo(self);
        make.height.equalTo(90);
    }];
    
    [labName makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(13.0f);
        make.centerY.equalTo(vInputBG).multipliedBy(0.5);
        make.width.equalTo(labName.intrinsicContentSize.width);
    }];
    
    [labCard makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(13.0f);
        make.centerY.equalTo(vInputBG).multipliedBy(1.5);
        // 明确labCard宽度，不然tfCard宽度无法确定
        make.width.equalTo(labCard.intrinsicContentSize.width);
    }];
    
    [tfName makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(labName);
        make.leading.equalTo(tfCard);
        make.trailing.equalTo(vInputBG).offset(-15);
    }];
    
    [tfCard makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(labCard);
        make.leading.equalTo(labCard.trailing).offset(10);
        make.trailing.equalTo(vInputBG).offset(-15);
    }];
    
    [vLine1 makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.leading.trailing.equalTo(vInputBG);
        make.height.equalTo(0.8);
    }];
    
    
    UIView *vMoneyBG = [[UIView alloc] init];
    vMoneyBG.backgroundColor = [UIColor whiteColor];
    
    UILabel *labTitle = [BasisUITool getLabelWithTextColor:UIColorFromHex(0x7f7f7f) size:14.0f];
    labTitle.text = @"提现金额";
    
    UILabel *labRMB = [BasisUITool getLabelWithTextColor:UIColorFromHex(0x333333) size:30.0f];
    labRMB.text = @"¥";
    
    UITextField *tfMoney = [BasisUITool getTextFieldWithTextColor:[UIColor blackColor] withSize:24 withPlaceholder:nil withDelegate:self];
    [tfMoney addTarget:self action:@selector(textFieldEditingChanged:) forControlEvents:UIControlEventEditingChanged];
    _tfMoney = tfMoney;
    tfMoney.keyboardType = UIKeyboardTypeDecimalPad;
    
    UIView *vLine = [[UIView alloc] init];
    vLine.backgroundColor = UIColorFromHex(0xc4c4c4);
    
    UILabel *labBalance = [BasisUITool getLabelWithTextColor:UIColorFromHex(0x7f7f7f) size:14.0f];
    labBalance.text = @"可提现金额:0.00元";
    _labBalance = labBalance;
    
    [self addSubview:vMoneyBG];
    [vMoneyBG addSubview:labTitle];
    [vMoneyBG addSubview:labRMB];
    [vMoneyBG addSubview:tfMoney];
    [vMoneyBG addSubview:vLine];
    [vMoneyBG addSubview:labBalance];
    
    [vMoneyBG makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.leading.equalTo(self);
        make.top.equalTo(vInputBG.bottom).offset(10);
        make.bottom.equalTo(labBalance).offset(18.0f);
    }];
    
    [labTitle makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(11.0f);
        make.top.equalTo(13.0f);
    }];
    
    [labRMB makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(13.0f);
        make.top.equalTo(labTitle.bottom).offset(15);
    }];
    
    [tfMoney makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(vLine);
        make.leading.trailing.equalTo(vLine);
    }];
    
    [vLine makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(labRMB.trailing).offset(10);
        make.trailing.equalTo(vMoneyBG).offset(-22);
        make.top.equalTo(labRMB.baseline).offset(2);
        make.height.equalTo(Single_Line_Width);
    }];
    
    [labBalance makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(20.0f);
        make.top.equalTo(vLine.bottom).offset(18.0f);
    }];
    
    UIButton *btnNextStep = [BasisUITool getBtnWithTarget:self action:@selector(actionNextSetup)];
    [btnNextStep setEnabled:NO];
    [btnNextStep setTitle:@"下一步" forState:UIControlStateNormal];
    [btnNextStep setBackgroundImage:[UIImage imageWithColor:UIColorFromHex(CLIENT_BTN_RED_NORMAL_BG)]
                           forState:UIControlStateNormal];
    [btnNextStep setBackgroundImage:[UIImage imageWithColor:UIColorFromHex(CLIENT_BTN_GRAY_DISABLED_BG)]
                           forState:UIControlStateDisabled];
    
    _btnNextStep = btnNextStep;
    [self addSubview:btnNextStep];
    [btnNextStep makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(vMoneyBG.bottom).offset(30);
        make.width.equalTo(self).multipliedBy(0.86);
        make.height.equalTo(@40);
    }];
}

- (void)textFieldEditingChanged:(UITextField *)textField
{
    if (textField == _tfMoney) {
        [self updateBalanceText];
    }
    double money = [_tfMoney.text doubleValue];
    if (IsStrEmpty(_tfName.text) || IsStrEmpty(_tfCard.text) ||
        IsStrEmpty(_tfMoney.text) || money <= 0 || money > self.dmInfo.gold_enable) {
        [_btnNextStep setEnabled:NO];
        return;
    }
    [_btnNextStep setEnabled:YES];
}

- (void)setDmInfo:(PersonalInfoDM *)dmInfo
{
    _dmInfo = dmInfo;
    _tfName.text = dmInfo.acct_name;
    _tfCard.text = dmInfo.card_no;
    [self updateBalanceText];
}

- (void)updateBalanceText
{
    double money = [_tfMoney.text doubleValue];
    if (money > self.dmInfo.gold_enable) {
        _labBalance.text = @"金额已超过可提余额";
        _labBalance.textColor = UIColorFromHex(0xb4292d);
    } else {
        _labBalance.textColor = UIColorFromHex(0x7f7f7f);
        _labBalance.text = [NSString stringWithFormat:@"可提现金额:%.2f元", self.dmInfo.gold_enable];
    }
}

- (void)actionNextSetup
{
    [HUDProgressTool showIndicatorWithText:nil];
    ConsumpExtractParam *param = [ConsumpExtractParam new];
    param.acct_name = _tfName.text;
    param.card_no = _tfCard.text;
    param.money = [_tfMoney.text doubleValue];
    [ConsumptionGoldReq extractWithParam:param success:^(BaseResponse *response) {
        [HUDProgressTool showOnlyText:response.msg];
        if (response.success) {
            self.dmInfo.gold_enable -= param.money;
            [self.viewController.navigationController popViewControllerAnimated:YES];
        }
    } failure:^(NSError *error) {
        [HUDProgressTool showOnlyText:[error urlErrorCodeDescribe]];
    }];
}
@end
