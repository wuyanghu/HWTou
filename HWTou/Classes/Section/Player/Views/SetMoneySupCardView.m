//
//  SetMoneySupCardView.m
//  HWTou
//
//  Created by Reyna on 2018/3/9.
//  Copyright © 2018年 LieMi. All rights reserved.
//

#import "SetMoneySupCardView.h"
#import "PublicHeader.h"
#import "UIControl+Event.h"
#import "ComCarouselView.h"
#import "PayTypeSelectedVC.h"
#import "MoneyInfoRequest.h"
#import "MoneyAccountModel.h"

@interface SetMoneySupCardView () <UITextFieldDelegate> {
    
    CGFloat VIEW_WIDTH;
    CGFloat VIEW_HEIGHT;
}

@property (nonatomic, strong) UIControl *backImageView;
@property (nonatomic, strong) PlayerDetailViewModel *model;

@property (nonatomic, strong) UITextField *totalPriceTF;
@property (nonatomic, strong) UIControl *payTypeBGView;
@property (nonatomic, strong) UIButton *payTypeBtn;//支付方式
@property (nonatomic, assign) int currentPayType;

@property (nonatomic, assign) double balance;//余额

@property (nonatomic, strong) NSMutableArray *btnsArr;
@property (nonatomic, assign) NSInteger currentIndex;

@end

@implementation SetMoneySupCardView

- (instancetype)initWithUserModel:(PlayerDetailViewModel *)model {
    if (self = [super init]) {
        
        self.model = model;
        
        VIEW_WIDTH = 300.f;
        VIEW_HEIGHT = 361.f;
        _currentPayType = 1;
        [self setupSubviews];
        [self balanceRequest];
    }
    return self;
}

- (void)setupSubviews {
    
    UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, VIEW_WIDTH, VIEW_HEIGHT + 81 + 34)];
    [self addSubview:backgroundView];
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 34, VIEW_WIDTH, VIEW_HEIGHT)];
    bgView.backgroundColor = [UIColor whiteColor];
    bgView.layer.cornerRadius = 15.f;
    bgView.layer.masksToBounds = YES;
    [backgroundView addSubview:bgView];
    
    UIImageView *headerIV = [[UIImageView alloc] initWithFrame:CGRectMake(115, 0, 70, 70)];
    [headerIV sd_setImageWithURL:[NSURL URLWithString:self.model.avater]];
    headerIV.layer.cornerRadius = 35.f;
    headerIV.layer.masksToBounds = YES;
    [backgroundView addSubview:headerIV];
    
    UILabel *nameLab = [[UILabel alloc] initWithFrame:CGRectMake(30, 46, VIEW_WIDTH - 60, 18)];
    nameLab.text = self.model.name;
    nameLab.textAlignment = NSTextAlignmentCenter;
    nameLab.font = SYSTEM_FONT(17);
    nameLab.textColor = UIColorFromHex(0xad0021);
    [bgView addSubview:nameLab];
    
    UILabel *tipLab = [[UILabel alloc] initWithFrame:CGRectMake(10, 67, VIEW_WIDTH - 20, 18)];
    tipLab.text = @"点赞是美意，打赏是鼓励";
    tipLab.textAlignment = NSTextAlignmentCenter;
    tipLab.font = SYSTEM_FONT(17);
    tipLab.textColor = UIColorFromHex(0x8E8F91);
    [bgView addSubview:tipLab];
    
    NSArray *moneyArray = @[@"0.66",@"1",@"6.66",@"8.88",@"66",@"88"];
    _btnsArr = [NSMutableArray array];
    _currentIndex = 0;
    for (int i=0; i<moneyArray.count; i++) {

        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(15 + 95 * (i%3), 125 + 40 * (i/3), 80, 30);
        [btn.titleLabel setFont:SYSTEM_FONT(12)];
        [btn setTitle:[NSString stringWithFormat:@"%@元",moneyArray[i]] forState:UIControlStateNormal];
        btn.layer.cornerRadius = 10.f;
        btn.layer.borderWidth = 2.f;
        btn.layer.borderColor = [UIColorFromHex(0xFDC622) CGColor];
        if (i == 0) {
            btn.backgroundColor = UIColorFromHex(0xFDC622);
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }
        else {
            btn.backgroundColor = [UIColor whiteColor];
            [btn setTitleColor:UIColorFromHex(0xFDC622) forState:UIControlStateNormal];
        }
        btn.tag = 100 + i;
        [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        [bgView addSubview:btn];
        
        [_btnsArr addObject:btn];
    }
    
    UIView *tfBGV = [[UIView alloc] initWithFrame:CGRectMake(15, 217, VIEW_WIDTH - 30, 30)];
    tfBGV.backgroundColor = UIColorFromHex(0xf2f2f2);
    [bgView addSubview:tfBGV];
    
    _totalPriceTF = [[UITextField alloc] initWithFrame:CGRectMake(10, 0, VIEW_WIDTH - 50, 30)];
    _totalPriceTF.placeholder = @"请输入您想打赏的金额";
    _totalPriceTF.font = SYSTEM_FONT(12);
    _totalPriceTF.delegate = self;
    [_totalPriceTF addTarget:self action:@selector(totalPriceTFValueChanged:) forControlEvents:UIControlEventEditingChanged];
    _totalPriceTF.borderStyle = UITextBorderStyleNone;
    _totalPriceTF.backgroundColor = UIColorFromHex(0xf2f2f2);
    _totalPriceTF.keyboardType = UIKeyboardTypeDecimalPad;
    _totalPriceTF.returnKeyType = UIReturnKeyDone;
    [tfBGV addSubview:_totalPriceTF];
    
    UIButton *sendMoneySupBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    sendMoneySupBtn.frame = CGRectMake(28, 246, 244, 100);
    [sendMoneySupBtn setBackgroundImage:[UIImage imageNamed:@"lk_btn_dsSet"] forState:UIControlStateNormal];
    [sendMoneySupBtn addTarget:self action:@selector(sendMoneySupAction:) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:sendMoneySupBtn];
    
    _payTypeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _payTypeBtn.frame = CGRectMake((VIEW_WIDTH - 244)/2.0, 316, 244, 20);
    [_payTypeBtn.titleLabel setFont:SYSTEM_FONT(14)];
    NSMutableAttributedString *attriString = [[NSMutableAttributedString alloc] initWithString:@"使用支付宝付款 更换"];
    [attriString addAttribute:NSForegroundColorAttributeName value:UIColorFromHex(0x8e8f91) range:NSMakeRange(0, 7)];
    [attriString addAttribute:NSForegroundColorAttributeName value:UIColorFromHex(0x6293C0) range:NSMakeRange(8, 2)];
    
    [_payTypeBtn setAttributedTitle:attriString forState:UIControlStateNormal];
    [_payTypeBtn addTarget:self action:@selector(payTypeAction:) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:_payTypeBtn];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake((VIEW_WIDTH - 1.5)/2.0, VIEW_HEIGHT + 34, 1.5, 30)];
    lineView.backgroundColor = [UIColor whiteColor];
    [backgroundView addSubview:lineView];
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake((VIEW_WIDTH - 51)/2.0, VIEW_HEIGHT + 34 + 30, 51, 51);
    [backBtn setBackgroundImage:[UIImage imageNamed:@"card_btn_cancel"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    [backgroundView addSubview:backBtn];
    
    self.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin;
    
    self.layer.cornerRadius = 10.0f;
    self.clipsToBounds = YES;
}

- (void)balanceRequest {
    NSInteger uid = [AccountManager shared].account.uid;
    [MoneyInfoRequest getUserAccountWithUid:uid success:^(NSDictionary *response) {
        
        if ([[response objectForKey:@"status"] intValue] == 200) {
            
            NSDictionary *dataDic =[response objectForKey:@"data"];
            MoneyAccountModel *accountModel = [[MoneyAccountModel alloc] init];
            [accountModel bindWithDic:dataDic];
            
            _balance = [accountModel.balance doubleValue];
            
            if (_balance >= 0.66) {
                NSMutableAttributedString *attriString = [[NSMutableAttributedString alloc] initWithString:@"使用余额付款 更换"];
                [attriString addAttribute:NSForegroundColorAttributeName value:UIColorFromHex(0x8e8f91) range:NSMakeRange(0, 6)];
                [attriString addAttribute:NSForegroundColorAttributeName value:UIColorFromHex(0x6293C0) range:NSMakeRange(7, 2)];
                [_payTypeBtn setAttributedTitle:attriString forState:UIControlStateNormal];
                
                _currentPayType = 0;
            }
            else {
                NSMutableAttributedString *attriString = [[NSMutableAttributedString alloc] initWithString:@"使用支付宝付款 更换"];
                [attriString addAttribute:NSForegroundColorAttributeName value:UIColorFromHex(0x8e8f91) range:NSMakeRange(0, 7)];
                [attriString addAttribute:NSForegroundColorAttributeName value:UIColorFromHex(0x6293C0) range:NSMakeRange(8, 2)];
                [_payTypeBtn setAttributedTitle:attriString forState:UIControlStateNormal];
                
                _currentPayType = 1;
            }
        }
    } failure:^(NSError *error) {
        [HUDProgressTool showErrorWithText:ReqErrCode_Custom_ErrorInfo];
    }];
}


#pragma mark - BtnClickBlock

- (void)payTypeAction:(UIButton *)btn {
    
    if (!_payTypeBGView) {
        _payTypeBGView = [[UIControl alloc] initWithFrame:self.backImageView.bounds];
        _payTypeBGView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
        [self.backImageView.superview addSubview:_payTypeBGView];
    }else {
        _payTypeBGView.hidden = NO;
    }
    
    PayTypeSelectedVC *vc = [[PayTypeSelectedVC alloc] initWithTotalPrice:_totalPriceTF.text];
    vc.view.frame = CGRectMake(0, _payTypeBGView.bounds.size.height, _payTypeBGView.bounds.size.width, 165);
    [_payTypeBGView addSubview:vc.view];
    
    [vc.cancelBtn addTarget:self action:@selector(backBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [vc.balanceBtn addTarget:self action:@selector(balanceBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [vc.alipayBtn addTarget:self action:@selector(alipayBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [UIView animateWithDuration:0.35 animations:^{
        vc.view.frame = CGRectMake(0, _payTypeBGView.bounds.size.height - 165, _payTypeBGView.bounds.size.width, 165);
    } completion:^(BOOL finished) {
        
    }];
}

- (void)btnAction:(UIButton *)btn {
    
    if (_currentIndex != btn.tag - 100) {
        
        UIButton *oldBtn = [_btnsArr objectAtIndex:_currentIndex];
        oldBtn.backgroundColor = [UIColor whiteColor];
        [oldBtn setTitleColor:UIColorFromHex(0xFDC622) forState:UIControlStateNormal];
        
        btn.backgroundColor = UIColorFromHex(0xFDC622);
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _currentIndex = btn.tag - 100;
    }
    
    NSArray *moneyArray = @[@"0.66",@"1",@"6.66",@"8.88",@"66",@"88"];
    double total = [[moneyArray objectAtIndex:_currentIndex] doubleValue];
    if (total <= _balance) {
        
        NSMutableAttributedString *attriString = [[NSMutableAttributedString alloc] initWithString:@"使用余额付款 更换"];
        [attriString addAttribute:NSForegroundColorAttributeName value:UIColorFromHex(0x8e8f91) range:NSMakeRange(0, 6)];
        [attriString addAttribute:NSForegroundColorAttributeName value:UIColorFromHex(0x6293C0) range:NSMakeRange(7, 2)];
        [_payTypeBtn setAttributedTitle:attriString forState:UIControlStateNormal];
        
        _currentPayType = 0;
    }
    else {
        
        NSMutableAttributedString *attriString = [[NSMutableAttributedString alloc] initWithString:@"使用支付宝付款 更换"];
        [attriString addAttribute:NSForegroundColorAttributeName value:UIColorFromHex(0x8e8f91) range:NSMakeRange(0, 7)];
        [attriString addAttribute:NSForegroundColorAttributeName value:UIColorFromHex(0x6293C0) range:NSMakeRange(8, 2)];
        [_payTypeBtn setAttributedTitle:attriString forState:UIControlStateNormal];
        
        _currentPayType = 1;
    }
}

- (void)sendMoneySupAction:(UIButton *)btn {
 
    if ([self isFitMoneySupPriceRule]) {
        
        if (_delegate) {
            
            int totalPrice = 0;
            if (_totalPriceTF.text.length > 0) {
                totalPrice = [_totalPriceTF.text doubleValue] * 100;
            }
            else {
                NSArray *moneyArray = @[@"0.66",@"1",@"6.66",@"8.88",@"66",@"88"];
                totalPrice = [[moneyArray objectAtIndex:_currentIndex] doubleValue] * 100;
            }
            
            [_delegate setMoneySupActionWithTotalPirce:totalPrice payType:_currentPayType];
        }
        
        [self dismiss];
    }
}

- (void)backAction {
    
    [self dismiss];
}

- (void)backBtnAction:(UIButton *)btn {
    
    [UIView animateWithDuration:0.35 animations:^{
        
        btn.superview.frame = CGRectMake(0, _payTypeBGView.bounds.size.height, _payTypeBGView.bounds.size.width, 165);
    } completion:^(BOOL finished) {
        [btn.superview removeFromSuperview];
        _payTypeBGView.hidden = YES;
    }];
}

- (void)balanceBtnAction:(UIButton *)btn {
    
    NSMutableAttributedString *attriString = [[NSMutableAttributedString alloc] initWithString:@"使用余额付款 更换"];
    [attriString addAttribute:NSForegroundColorAttributeName value:UIColorFromHex(0x8e8f91) range:NSMakeRange(0, 6)];
    [attriString addAttribute:NSForegroundColorAttributeName value:UIColorFromHex(0x6293C0) range:NSMakeRange(7, 2)];
    [_payTypeBtn setAttributedTitle:attriString forState:UIControlStateNormal];
    
    _currentPayType = 0;
    [UIView animateWithDuration:0.35 animations:^{
        
        btn.superview.frame = CGRectMake(0, _payTypeBGView.bounds.size.height, _payTypeBGView.bounds.size.width, 165);
    } completion:^(BOOL finished) {
        [btn.superview removeFromSuperview];
        _payTypeBGView.hidden = YES;
    }];
}

- (void)alipayBtnAction:(UIButton *)btn {
    
    NSMutableAttributedString *attriString = [[NSMutableAttributedString alloc] initWithString:@"使用支付宝付款 更换"];
    [attriString addAttribute:NSForegroundColorAttributeName value:UIColorFromHex(0x8e8f91) range:NSMakeRange(0, 7)];
    [attriString addAttribute:NSForegroundColorAttributeName value:UIColorFromHex(0x6293C0) range:NSMakeRange(8, 2)];
    [_payTypeBtn setAttributedTitle:attriString forState:UIControlStateNormal];
    
    _currentPayType = 1;
    [UIView animateWithDuration:0.35 animations:^{
        
        btn.superview.frame = CGRectMake(0, _payTypeBGView.bounds.size.height, _payTypeBGView.bounds.size.width, 165);
    } completion:^(BOOL finished) {
        [btn.superview removeFromSuperview];
        _payTypeBGView.hidden = YES;
    }];
}

- (void)totalPriceTFValueChanged:(UITextField *)tf {
    
    if ([tf.text doubleValue] > 2000.00) {
        [HUDProgressTool showOnlyText:@"打赏不可以超过2000元哦～"];
    }
    if ([tf.text doubleValue] < 0.10) {
        [HUDProgressTool showOnlyText:@"打赏不可以低于0.1元哦～"];
    }
    
    if (tf.text.length > 0) {
        [self isSelectedDefaultMoneySup:NO];
    }else {
        [self isSelectedDefaultMoneySup:YES];
    }
}

#pragma mark - TFDelegate

- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    if ([textField.text doubleValue] <= _balance) {
        
        NSMutableAttributedString *attriString = [[NSMutableAttributedString alloc] initWithString:@"使用余额付款 更换"];
        [attriString addAttribute:NSForegroundColorAttributeName value:UIColorFromHex(0x8e8f91) range:NSMakeRange(0, 6)];
        [attriString addAttribute:NSForegroundColorAttributeName value:UIColorFromHex(0x6293C0) range:NSMakeRange(7, 2)];
        [_payTypeBtn setAttributedTitle:attriString forState:UIControlStateNormal];
        
        _currentPayType = 0;
    }
    else {
        
        NSMutableAttributedString *attriString = [[NSMutableAttributedString alloc] initWithString:@"使用支付宝付款 更换"];
        [attriString addAttribute:NSForegroundColorAttributeName value:UIColorFromHex(0x8e8f91) range:NSMakeRange(0, 7)];
        [attriString addAttribute:NSForegroundColorAttributeName value:UIColorFromHex(0x6293C0) range:NSMakeRange(8, 2)];
        [_payTypeBtn setAttributedTitle:attriString forState:UIControlStateNormal];
        
        _currentPayType = 1;
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    BOOL isHaveDian = YES;
    if ([textField.text rangeOfString:@"."].location == NSNotFound) {
        isHaveDian = NO;
    }
    if ([string length] > 0)
    {
        unichar single = [string characterAtIndex:0];//当前输入的字符
        if ((single >= '0' && single <= '9') || single == '.') {
            if (single == '.') {
                if(!isHaveDian) {
                    isHaveDian = YES;
                    return YES;
                }else{
                    [textField.text stringByReplacingCharactersInRange:range withString:@""];
                    return NO;
                }
            }else{
                if (isHaveDian) {
                    NSArray *arr = [_totalPriceTF.text componentsSeparatedByString:@"."];
                    if (arr.count > 1) {
                        NSString *botStr = [arr objectAtIndex:1];
                        
                        return botStr.length > 1 ? NO : YES;
                    }
                    else {
                        return YES;
                    }
                }else{
                    //                    return _moneyTF.text.length > 2 ? NO : YES;
                    return YES;
                }
            }
            
        }else{
            [textField.text stringByReplacingCharactersInRange:range withString:@""];
            return NO;
        }
    }
    else {
        
        return YES;
    }
}

#pragma mark - isSelectedDefault

- (void)isSelectedDefaultMoneySup:(BOOL)isDefault {

    if (isDefault) {
        
        if (_currentIndex == -1) {
            
            _currentIndex = 0;
            
            UIButton *btn = [_btnsArr objectAtIndex:0];
            btn.backgroundColor = UIColorFromHex(0xFDC622);
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }
    }
    else {
        if (_currentIndex != -1) {
            UIButton *oldBtn = [_btnsArr objectAtIndex:_currentIndex];
            oldBtn.backgroundColor = [UIColor whiteColor];
            [oldBtn setTitleColor:UIColorFromHex(0xFDC622) forState:UIControlStateNormal];
            
            _currentIndex = -1;
        } 
    }
}

#pragma mark - Custom

- (BOOL)isFitMoneySupPriceRule {
    if (_totalPriceTF.text.length > 0) {
        if ([_totalPriceTF.text doubleValue] >= 0.10 && [_totalPriceTF.text doubleValue] <= 2000.00) {
            return YES;
        }
        else {
            [HUDProgressTool showOnlyText:@"您输入的打赏金额有误哦～"];
            return NO;
        }
    }
    return YES;
}

- (void)show {
    
    UIViewController *topVC = [self appRootViewController];
    
    topVC.view.backgroundColor = [UIColor whiteColor];
    
    self.frame = CGRectMake((kMainScreenWidth - VIEW_WIDTH) * 0.5, (kMainScreenHeight - VIEW_HEIGHT - 81 - 34) * 0.5 + kMainScreenHeight, VIEW_WIDTH, VIEW_HEIGHT + 81 + 34);
    
    [topVC.view addSubview:self];
}

- (void)dismiss {
    
    [self keyboardDown];
    
    [self removeFromSuperview];
    
    if (self.dismissBlock) {
        self.dismissBlock();
    }
}

- (void)keyboardDown {
    
    if (_totalPriceTF.editing) {
        [_totalPriceTF resignFirstResponder];
    }
}

- (UIViewController *)appRootViewController {
    
    UIViewController *appRootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    UIViewController *topVC = appRootVC;
    while (topVC.presentedViewController) {
        topVC = topVC.presentedViewController;
    }
    return topVC;
}


- (void)removeFromSuperview {
    
    CGRect afterFrame = CGRectMake((kMainScreenWidth - VIEW_WIDTH) * 0.5, kMainScreenHeight + (kMainScreenHeight - VIEW_HEIGHT - 81 - 34) * 0.5, VIEW_WIDTH, VIEW_HEIGHT + 81 + 34);
    
    [UIView animateWithDuration:0.15f delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.frame = afterFrame;
        self.backImageView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];
        
    } completion:^(BOOL finished) {
        [super removeFromSuperview];
        
        [self.backImageView removeFromSuperview];
        self.backImageView = nil;
    }];
    
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
    if (newSuperview == nil) {
        return;
    }
    UIViewController *topVC = [self appRootViewController];
    
    if (!self.backImageView) {
        self.backImageView = [[UIControl alloc] initWithFrame:topVC.view.bounds];
        self.backImageView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.0];
        self.backImageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        __weak typeof(self) weakSelf = self;
        [self.backImageView addEvent:UIControlEventTouchDown callback:^{
            [weakSelf keyboardDown];
        }];
    }
    [topVC.view addSubview:self.backImageView];
    
    CGRect afterFrame = CGRectMake((kMainScreenWidth - VIEW_WIDTH) * 0.5, (kMainScreenHeight - VIEW_HEIGHT - 81 - 34) * 0.5, VIEW_WIDTH, VIEW_HEIGHT + 81 + 34);
    [UIView animateWithDuration:0.15f delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.transform = CGAffineTransformMakeRotation(0);
        self.frame = afterFrame;
        self.backImageView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
    } completion:^(BOOL finished) {
    }];
    
    
    [super willMoveToSuperview:newSuperview];
}

@end

