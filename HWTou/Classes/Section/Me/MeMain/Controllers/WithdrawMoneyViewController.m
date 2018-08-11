//
//  WithdrawMoneyViewController.m
//  HWTou
//
//  Created by Reyna on 2018/2/6.
//  Copyright © 2018年 LieMi. All rights reserved.
//

#import "WithdrawMoneyViewController.h"
#import "WithdrawAccountViewController.h"
#import "PublicHeader.h"
#import "MoneyInfoRequest.h"
#import "MoneyAccountModel.h"
#import "WithdrawMoneySuccessViewController.h"
#import "UINavigationItem+Margin.h"
#import "ComWebViewController.h"

@interface WithdrawMoneyViewController () <WithdrawAccountInfoDelegate>

@property (weak, nonatomic) IBOutlet UILabel *balanceLab; //余额提示
@property (weak, nonatomic) IBOutlet UILabel *accountLab; //账户信息
@property (weak, nonatomic) IBOutlet UITextField *moneyTF; //提现金额
@property (nonatomic, strong) WithdrawAccountInfoModel *model;

@property (nonatomic, strong) MoneyAccountModel *accountModel;

@end

@implementation WithdrawMoneyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setTitle:@"提现"];
    UIBarButtonItem *rightItem = [UIBarButtonItem itemWithImageName:@"tx_btn_rule" hltImageName:nil target:self action:@selector(txBtnAction)];
    [self.navigationItem setRightBarButtonItem:rightItem fixedSpace:6];
    
    [self isBindAlipayAccountRequest];
    [self userAccountRequest];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [[IQKeyboardManager sharedManager] setShouldResignOnTouchOutside:YES];
}

#pragma mark - Request

- (void)isBindAlipayAccountRequest {
    [MoneyInfoRequest isAlipayAccountWithSuccess:^(NSDictionary *response) {
        if ([[response objectForKey:@"status"] intValue] == 200) {
            
            if ([[response objectForKey:@"data"] intValue] == 1) {
                //绑定了支付宝
                [self getAlipayAccountRequest];
            }
        }else {
            [HUDProgressTool showErrorWithText:[response objectForKey:@"msg"]];
        }
    } failure:^(NSError *error) {
        [HUDProgressTool showErrorWithText:ReqErrCode_Custom_ErrorInfo];
    }];
}

- (void)getAlipayAccountRequest {
    [MoneyInfoRequest getAlipayAccountWithSuccess:^(NSDictionary *response) {
        if ([[response objectForKey:@"status"] intValue] == 200) {
            
            NSDictionary *dataDic = [response objectForKey:@"data"];
            WithdrawAccountInfoModel *m = [[WithdrawAccountInfoModel alloc] init];
            [m bindWithDic:dataDic];
            self.model = m;
            self.accountLab.text = self.model.accountString;
        }else {
            [HUDProgressTool showErrorWithText:[response objectForKey:@"msg"]];
        }
    } failure:^(NSError *error) {
        [HUDProgressTool showErrorWithText:ReqErrCode_Custom_ErrorInfo];
    }];
}

- (void)userAccountRequest {
    
    NSInteger uid = [AccountManager shared].account.uid;
    [MoneyInfoRequest getUserAccountWithUid:uid success:^(NSDictionary *response) {
        
        if ([[response objectForKey:@"status"] intValue] == 200) {
            
            NSDictionary *dataDic =[response objectForKey:@"data"];
            [self.accountModel bindWithDic:dataDic];
            self.balanceLab.text = [NSString stringWithFormat:@"可提现余额¥%@元",self.accountModel.balance];
        }else {
            [HUDProgressTool showErrorWithText:[response objectForKey:@"msg"]];
        }
    } failure:^(NSError *error) {
        [HUDProgressTool showErrorWithText:ReqErrCode_Custom_ErrorInfo];
    }];
}

- (void)applyRequest {
    
    NSString *money = _moneyTF.text;
    [MoneyInfoRequest recordFinanceWithFinancialType:2 financialDesc:@"提现" money:money account:self.model.accountString channel:1 success:^(NSDictionary *response) {
        
         if ([[response objectForKey:@"status"] intValue] == 200) {
            
             [HUDProgressTool dismiss];
             WithdrawMoneySuccessViewController *vc = [[WithdrawMoneySuccessViewController alloc] init];
             vc.moneyString = money;
             [self.navigationController pushViewController:vc animated:YES];
         }else {
             [HUDProgressTool showErrorWithText:[response objectForKey:@"msg"]];
         }
        
    } failure:^(NSError *error) {
        [HUDProgressTool showErrorWithText:ReqErrCode_Custom_ErrorInfo];
    }];
}

#pragma mark - Sup

- (void)goWithdrawAccountVC {
    
    WithdrawAccountViewController *vc = [[WithdrawAccountViewController alloc] init];
    vc.delegate = self;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - Action

- (IBAction)applyWithdrawAction:(id)sender {
    
    if (!_model) {
        [self goWithdrawAccountVC];
        return;
    }
    if (!_moneyTF.text || [_moneyTF.text isEqualToString:@""]) {
        [HUDProgressTool showOnlyText:@"提现金额不能为空"];
        return;
    }
    if ([_moneyTF.text doubleValue] <= 30.00) {
        [HUDProgressTool showOnlyText:@"提现金额不能低于30元"];
        return;
    }
    [HUDProgressTool showIndicatorWithText:@"提现申请中..."];
    [self applyRequest];
}

- (IBAction)accountBtnAction:(id)sender {
    
    [self goWithdrawAccountVC];
}

- (void)txBtnAction {
    
    NSString *urlString = [NSString stringWithFormat:@"%@",kApiWithdrawRuleUrlHost];
    ComWebViewController *webVC = [[ComWebViewController alloc] init];
    webVC.title = @"钱包规则";
    webVC.webUrl = urlString;
    [self.navigationController pushViewController:webVC animated:YES];
}

#pragma mark - WithdrawAccountDelegate

- (void)didCommitAccountInfoModel:(WithdrawAccountInfoModel *)model {
    self.model = model;
    
    self.accountLab.text = model.accountString;
}

#pragma mark - TFDelegate

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
                    NSArray *arr = [_moneyTF.text componentsSeparatedByString:@"."];
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
- (IBAction)moneyValueChanged:(UITextField *)sender {
    
    if ([_moneyTF.text doubleValue] > [self.accountModel.balance doubleValue]) {
        [HUDProgressTool showOnlyText:@"提现金额超出余额上限"];
        _moneyTF.text = @"";
    }
}

#pragma mark - Get

- (MoneyAccountModel *)accountModel {
    if (!_accountModel) {
        _accountModel = [[MoneyAccountModel alloc] init];
    }
    return _accountModel;
}

#pragma mark -

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
