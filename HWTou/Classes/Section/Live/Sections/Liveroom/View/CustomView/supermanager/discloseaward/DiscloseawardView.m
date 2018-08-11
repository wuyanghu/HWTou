//
//  DiscloseawardView.m
//  HWTou
//
//  Created by robinson on 2018/4/8.
//  Copyright © 2018年 LieMi. All rights reserved.
//

#import "DiscloseawardView.h"
#import "UIView+NTES.h"
#import "NTESMessageModel.h"
#import "UIView+Toast.h"
#import "MoneyInfoRequest.h"
#import "MoneyAccountModel.h"
#import "PublicHeader.h"
#import "UIControl+Event.h"
#import "PayTypeSelectedVC.h"

@interface DiscloseawardView()<UITextFieldDelegate>
@property (nonatomic,strong) NTESMessageModel * messageModel;

@property (nonatomic, assign) NSInteger currentPayType;
@property (nonatomic, assign) double balance;//余额

@property (nonatomic, strong) UIControl *payTypeBGView;
@end

@implementation DiscloseawardView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)awakeFromNib{
    [super awakeFromNib];
    
    _moneyTextField.keyboardType = UIKeyboardTypeDecimalPad;
    _moneyTextField.delegate = self;
    
    [self addTarget:self action:@selector(onTapBackground:) forControlEvents:UIControlEventTouchUpInside];
    
    [self balanceRequest];
}

- (void)initSwitchPayBtn{
    NSMutableAttributedString *attriString = [[NSMutableAttributedString alloc] initWithString:@"使用支付宝付款 更换"];
    [attriString addAttribute:NSForegroundColorAttributeName value:UIColorFromHex(0x8e8f91) range:NSMakeRange(0, 7)];
    [attriString addAttribute:NSForegroundColorAttributeName value:UIColorFromHex(0x6293C0) range:NSMakeRange(8, 2)];
    [self.switchPayBtn setAttributedTitle:attriString forState:UIControlStateNormal];
    _currentPayType = 1;
}

- (void)onTapBackground:(id)sender
{
    [self dismiss];
}

- (void)show:(NTESMessageModel *)messageModel
{
    if (self.ntesTop == self.ntesHeight) {
        [self balanceRequest];
        
        [self initSwitchPayBtn];
        _messageModel = messageModel;
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        [window addSubview:self];
        [UIView animateWithDuration:0.25 animations:^{
            self.ntesTop -= self.ntesHeight;
        }];
    }
}

- (void)dismiss
{
    [UIView animateWithDuration:0.25 animations:^{
        self.ntesTop += self.ntesHeight;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
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

#pragma mark - TFDelegate

- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    if ([textField.text doubleValue] <= _balance) {
        
        NSMutableAttributedString *attriString = [[NSMutableAttributedString alloc] initWithString:@"使用余额付款 更换"];
        [attriString addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0x8e8f91) range:NSMakeRange(0, 6)];
        [attriString addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0x6293C0) range:NSMakeRange(7, 2)];
        [self.switchPayBtn setAttributedTitle:attriString forState:UIControlStateNormal];
        
        _currentPayType = 0;
    }
    else {
        
        NSMutableAttributedString *attriString = [[NSMutableAttributedString alloc] initWithString:@"使用支付宝付款 更换"];
        [attriString addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0x8e8f91) range:NSMakeRange(0, 7)];
        [attriString addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0x6293C0) range:NSMakeRange(8, 2)];
        [self.switchPayBtn setAttributedTitle:attriString forState:UIControlStateNormal];
        
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
                    NSArray *arr = [_moneyTextField.text componentsSeparatedByString:@"."];
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


#pragma mark - action

- (IBAction)cancelAction:(id)sender {
    [self keyboardDown];
    [self dismiss];
}

- (IBAction)sureAction:(id)sender {
    if ([_moneyTextField.text isEqualToString:@""]) {
        [self makeToast:@"金额不能为空" duration:2.0f position:CSToastPositionCenter];
        return;
    }
    [_moneyTextField resignFirstResponder];
    [self dismiss];
    [self.discloseawardViewDelegate discloseawardViewAction:_moneyTextField.text messageModel:_messageModel payType:_currentPayType];
    _moneyTextField.text = @"";
    
}

- (IBAction)switchPayAction:(id)sender {
    [self payTypeAction];
}


#pragma mark - BtnClickBlock

- (void)payTypeAction {
    [self keyboardDown];
    
    if (!_payTypeBGView) {
        _payTypeBGView = [[UIControl alloc] initWithFrame:self.bounds];
        _payTypeBGView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
        [self addSubview:_payTypeBGView];
    }else {
        _payTypeBGView.hidden = NO;
    }
    
    PayTypeSelectedVC *vc = [[PayTypeSelectedVC alloc] initWithTotalPrice:self.moneyTextField.text];
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

- (void)keyboardDown {
    
    if (self.moneyTextField.editing) {
        [self.moneyTextField resignFirstResponder];
    }

}

- (void)backBtnAction {
    
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
    [self.switchPayBtn setAttributedTitle:attriString forState:UIControlStateNormal];
    
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
    [self.switchPayBtn setAttributedTitle:attriString forState:UIControlStateNormal];
    
    _currentPayType = 1;
    [UIView animateWithDuration:0.35 animations:^{
        
        btn.superview.frame = CGRectMake(0, _payTypeBGView.bounds.size.height, _payTypeBGView.bounds.size.width, 165);
    } completion:^(BOOL finished) {
        [btn.superview removeFromSuperview];
        _payTypeBGView.hidden = YES;
    }];
}

@end
