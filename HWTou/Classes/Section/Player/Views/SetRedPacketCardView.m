//
//  SetRedPacketCardView.m
//  HWTou
//
//  Created by Reyna on 2018/2/28.
//  Copyright © 2018年 LieMi. All rights reserved.
//

#import "SetRedPacketCardView.h"
#import "PublicHeader.h"
#import "UIControl+Event.h"
#import "PayTypeSelectedVC.h"
#import "MoneyInfoRequest.h"
#import "MoneyAccountModel.h"

@interface SetRedPacketCardView () <UITextFieldDelegate> {
    
    CGFloat VIEW_WIDTH;
    CGFloat VIEW_HEIGHT;
    
    UIButton *_sendBtn;
}

@property (nonatomic, strong) UIControl *backImageView;

@property (nonatomic, strong) UITextField *totalPriceTF;
@property (nonatomic, strong) UITextField *numTF;
@property (nonatomic, strong) UILabel *qianLab;
@property (nonatomic, strong) UILabel *displayLab;

@property (nonatomic, strong) UIControl *payTypeBGView;
@property (nonatomic, strong) UIButton *payTypeBtn;//支付方式
@property (nonatomic, assign) int currentPayType;

@property (nonatomic, assign) double balance;//余额

@end

@implementation SetRedPacketCardView

- (instancetype)init {
    if (self = [super init]) {
        
        VIEW_WIDTH = 300.f;
        VIEW_HEIGHT = 361.f;
        _currentPayType = 1;
        [self setupSubviews];
        [self balanceRequest];
    }
    return self;
}

- (void)setupSubviews {
    
    UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, VIEW_WIDTH, VIEW_HEIGHT + 81)];
    [self addSubview:backgroundView];
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, VIEW_WIDTH, VIEW_HEIGHT)];
    bgView.backgroundColor = [UIColor whiteColor];
    bgView.layer.cornerRadius = 10.f;
    bgView.layer.masksToBounds = YES;
    [backgroundView addSubview:bgView];
    
    UILabel *priceLab = [[UILabel alloc]initWithFrame:CGRectMake(30, 48, 60, 20)];
    priceLab.text = @"总金额";
    priceLab.font = SYSTEM_FONT(17);
    priceLab.textColor = UIColorFromHex(0x2b2b2b);
    [bgView addSubview:priceLab];
    
    UILabel *numLab = [[UILabel alloc]initWithFrame:CGRectMake(30, 113, 60, 20)];
    numLab.text = @"红包数";
    numLab.font = SYSTEM_FONT(17);
    numLab.textColor = UIColorFromHex(0x2b2b2b);
    [bgView addSubview:numLab];
    
    UILabel *yuanLab = [[UILabel alloc]initWithFrame:CGRectMake(VIEW_WIDTH - 48, 48, 18, 20)];
    yuanLab.text = @"元";
    yuanLab.font = SYSTEM_FONT(17);
    yuanLab.textColor = UIColorFromHex(0x2b2b2b);
    [bgView addSubview:yuanLab];
    
    UILabel *geLab = [[UILabel alloc]initWithFrame:CGRectMake(VIEW_WIDTH - 48, 113, 18, 20)];
    geLab.text = @"个";
    geLab.font = SYSTEM_FONT(17);
    geLab.textColor = UIColorFromHex(0x2b2b2b);
    [bgView addSubview:geLab];
    
    _totalPriceTF = [[UITextField alloc] initWithFrame:CGRectMake(153, 35, 91, 44)];
    _totalPriceTF.placeholder = @"0.00";
    _totalPriceTF.textAlignment = NSTextAlignmentCenter;
    _totalPriceTF.delegate = self;
    [_totalPriceTF addTarget:self action:@selector(totalPriceTFValueChanged:) forControlEvents:UIControlEventEditingChanged];
    _totalPriceTF.borderStyle = UITextBorderStyleNone;
    _totalPriceTF.backgroundColor = UIColorFromHex(0xf2f2f2);
    _totalPriceTF.keyboardType = UIKeyboardTypeDecimalPad;
    _totalPriceTF.returnKeyType = UIReturnKeyDone;
    [bgView addSubview:_totalPriceTF];
    
    _numTF = [[UITextField alloc] initWithFrame:CGRectMake(153, 99, 91, 44)];
    _numTF.textAlignment = NSTextAlignmentCenter;
    _numTF.placeholder = @"填写个数";
    [_numTF addTarget:self action:@selector(numTFValueChanged:) forControlEvents:UIControlEventEditingChanged];
    _numTF.borderStyle = UITextBorderStyleNone;
    _numTF.backgroundColor = UIColorFromHex(0xf2f2f2);
    _numTF.keyboardType = UIKeyboardTypeNumberPad;
    _numTF.returnKeyType = UIReturnKeyDone;
    [bgView addSubview:_numTF];
    
    _qianLab = [[UILabel alloc]initWithFrame:CGRectMake(82, 194, 24, 24)];
    _qianLab.text = @"￥";
    _qianLab.font = SYSTEM_FONT(24);
    _qianLab.textColor = UIColorFromHex(0x2b2b2b);
    [bgView addSubview:_qianLab];
    
    _displayLab = [[UILabel alloc]initWithFrame:CGRectMake(105, 193, 115, 55)];
    _displayLab.text = @"0.00";
    _displayLab.font = SYSTEM_FONT(55);
    _displayLab.textColor = UIColorFromHex(0x2b2b2b);
    [bgView addSubview:_displayLab];
    
    _sendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _sendBtn.frame = CGRectMake((VIEW_WIDTH - 244)/2.0, VIEW_HEIGHT - 100 - 15, 244, 100);
    _sendBtn.userInteractionEnabled = NO;
    [_sendBtn setBackgroundImage:[UIImage imageNamed:@"lk_btn_sjhb"] forState:UIControlStateNormal];
    _sendBtn.layer.cornerRadius = 15.f;
    [_sendBtn addTarget:self action:@selector(redPacketAction:) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:_sendBtn];
    
    _payTypeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _payTypeBtn.frame = CGRectMake((VIEW_WIDTH - 244)/2.0, VIEW_HEIGHT - 15 - 25, 244, 20);
    [_payTypeBtn.titleLabel setFont:SYSTEM_FONT(14)];
    NSMutableAttributedString *attriString = [[NSMutableAttributedString alloc] initWithString:@"使用支付宝付款 更换"];
    [attriString addAttribute:NSForegroundColorAttributeName value:UIColorFromHex(0x8e8f91) range:NSMakeRange(0, 7)];
    [attriString addAttribute:NSForegroundColorAttributeName value:UIColorFromHex(0x6293C0) range:NSMakeRange(8, 2)];
    
    [_payTypeBtn setAttributedTitle:attriString forState:UIControlStateNormal];
    [_payTypeBtn addTarget:self action:@selector(payTypeAction:) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:_payTypeBtn];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake((VIEW_WIDTH - 1.5)/2.0, VIEW_HEIGHT, 1.5, 30)];
    lineView.backgroundColor = [UIColor whiteColor];
    [backgroundView addSubview:lineView];
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake((VIEW_WIDTH - 51)/2.0, VIEW_HEIGHT + 30, 51, 51);
    [backBtn setBackgroundImage:[UIImage imageNamed:@"card_btn_cancel"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [backgroundView addSubview:backBtn];
    
    self.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin;
    
    self.layer.cornerRadius = 10.0f;
    self.clipsToBounds = YES;
}

#pragma mark - Request

- (void)balanceRequest {
    NSInteger uid = [AccountManager shared].account.uid;
    [MoneyInfoRequest getUserAccountWithUid:uid success:^(NSDictionary *response) {
        
        if ([[response objectForKey:@"status"] intValue] == 200) {
            
            NSDictionary *dataDic =[response objectForKey:@"data"];
            MoneyAccountModel *accountModel = [[MoneyAccountModel alloc] init];
            [accountModel bindWithDic:dataDic];
            
            _balance = [accountModel.balance doubleValue];
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

- (void)redPacketAction:(UIButton *)btn {
    
    int total = [_totalPriceTF.text doubleValue] * 100;
    if (self.delegate) {
        [self.delegate setRedPacketActionWithTotalPirce:total num:[_numTF.text intValue] payType:_currentPayType];
    }
    [self dismiss];
}

- (void)backBtnAction {
    
    [self dismiss];
}

- (void)totalPriceTFValueChanged:(UITextField *)tf {
    
    _displayLab.text = tf.text.length > 0 ? tf.text : @"0.00";
    CGRect rect = [_displayLab.text boundingRectWithSize:CGSizeMake(MAXFLOAT, 60) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:55]} context:nil];
    if (rect.size.width + 24 <= VIEW_WIDTH) {
        _qianLab.frame = CGRectMake((VIEW_WIDTH - rect.size.width - 24)/2.0, 194, 24, 24);
        _displayLab.frame = CGRectMake((VIEW_WIDTH - rect.size.width - 24)/2.0 + 24, 193, rect.size.width, 55);
    }
    else {
        _qianLab.frame = CGRectMake(0, 194, 24, 24);
        _displayLab.frame = CGRectMake(24, 193, 276, 55);
    }
    
    if ([tf.text doubleValue] > 500.00) {
        [HUDProgressTool showOnlyText:@"红包不可以超过500元哦～"];
    }
    if ([tf.text doubleValue] < 0.10) {
        [HUDProgressTool showOnlyText:@"红包不可以低于0.1元哦～"];
    }
    if (tf.text.length > 0 && _numTF.text.length > 0) {
        if ([tf.text doubleValue]/([_numTF.text intValue] * 1.0) < 0.10) {
            [HUDProgressTool showOnlyText:@"单个红包不可以低于0.1元哦～"];
        }
    }
    
    if ([self isFitRedPacketPriceAndNumRule]) {
        [_sendBtn setBackgroundImage:[UIImage imageNamed:@"tk_btn_wchg"] forState:UIControlStateNormal];
        _sendBtn.userInteractionEnabled = YES;
    }
    else {
        [_sendBtn setBackgroundImage:[UIImage imageNamed:@"lk_btn_sjhb"] forState:UIControlStateNormal];
        _sendBtn.userInteractionEnabled = NO;
    }
}

- (void)numTFValueChanged:(UITextField *)tf {
    if ([tf.text integerValue] < 1) {
        [HUDProgressTool showOnlyText:@"红包数量不可以少于1个哦～"];
    }
    if ([tf.text integerValue] > 100) {
        [HUDProgressTool showOnlyText:@"红包数量不可以多于100个哦～"];
    }
    if (_totalPriceTF.text.length > 0 && _numTF.text.length > 0) {
        if ([_totalPriceTF.text doubleValue]/([_numTF.text intValue] * 1.0) < 0.10) {
            [HUDProgressTool showOnlyText:@"单个红包不可以低于0.1元哦～"];
        }
    }
    
    if ([self isFitRedPacketPriceAndNumRule]) {
        [_sendBtn setBackgroundImage:[UIImage imageNamed:@"tk_btn_wchg"] forState:UIControlStateNormal];
        _sendBtn.userInteractionEnabled = YES;
    }
    else {
        [_sendBtn setBackgroundImage:[UIImage imageNamed:@"lk_btn_sjhb"] forState:UIControlStateNormal];
        _sendBtn.userInteractionEnabled = NO;
    }
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

#pragma mark - Custom

- (BOOL)isFitRedPacketPriceAndNumRule {
    
    if (_totalPriceTF.text.length > 0 && _numTF.text.length > 0) {
        if ([_totalPriceTF.text doubleValue] >= 0.10 && [_totalPriceTF.text doubleValue] <= 500.00 && [_numTF.text integerValue] > 0 && [_numTF.text integerValue] < 101 && [_totalPriceTF.text doubleValue]/([_numTF.text intValue] * 1.0) >= 0.10) {
            
            return YES;
        }
    }
    return NO;
}

- (void)show {
    
    UIViewController *topVC = [self appRootViewController];
    
    topVC.view.backgroundColor = [UIColor whiteColor];
    
    self.frame = CGRectMake((kMainScreenWidth - VIEW_WIDTH) * 0.5, (kMainScreenHeight - VIEW_HEIGHT - 81) * 0.5 + kMainScreenHeight, VIEW_WIDTH, VIEW_HEIGHT + 81);
    
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
    if (_numTF.editing) {
        [_numTF resignFirstResponder];
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
    
    CGRect afterFrame = CGRectMake((kMainScreenWidth - VIEW_WIDTH) * 0.5, kMainScreenHeight + (kMainScreenHeight - VIEW_HEIGHT - 81) * 0.5, VIEW_WIDTH, VIEW_HEIGHT + 81);
    
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
    
    CGRect afterFrame = CGRectMake((kMainScreenWidth - VIEW_WIDTH) * 0.5, (kMainScreenHeight - VIEW_HEIGHT - 81) * 0.5, VIEW_WIDTH, VIEW_HEIGHT + 81);
    [UIView animateWithDuration:0.15f delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.transform = CGAffineTransformMakeRotation(0);
        self.frame = afterFrame;
        self.backImageView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
    } completion:^(BOOL finished) {
    }];
    
    
    [super willMoveToSuperview:newSuperview];
}


@end
