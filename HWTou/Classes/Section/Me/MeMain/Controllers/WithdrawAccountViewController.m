//
//  WithdrawAccountViewController.m
//  HWTou
//
//  Created by Reyna on 2018/2/6.
//  Copyright © 2018年 LieMi. All rights reserved.
//

#import "WithdrawAccountViewController.h"
#import "PublicHeader.h"
#import "MoneyInfoRequest.h"

@interface WithdrawAccountViewController ()
@property (weak, nonatomic) IBOutlet UITextField *nameTF;
@property (weak, nonatomic) IBOutlet UITextField *idCardTF;
@property (weak, nonatomic) IBOutlet UITextField *accountTF;

@end

@implementation WithdrawAccountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setTitle:@"完善信息"];
    
    [self isBindAlipayAccountRequest];
}

#pragma mark - Request

- (void)isBindAlipayAccountRequest {
    [MoneyInfoRequest isAlipayAccountWithSuccess:^(NSDictionary *response) {
        if ([[response objectForKey:@"status"] intValue] == 200) {
            
            if ([[response objectForKey:@"data"] intValue] == 1) {
                //绑定了支付宝
                [self getAlipayAccountRequest];
                _nameTF.enabled = NO;
                _idCardTF.enabled = NO;
                _accountTF.enabled = NO;
            }else {
                _nameTF.placeholder = @"请输入真实姓名";
                _idCardTF.placeholder = @"请输入身份证号";
                _accountTF.placeholder = @"请输入支付宝账号";
                _nameTF.enabled = YES;
                _idCardTF.enabled = YES;
                _accountTF.enabled = YES;
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
            _nameTF.placeholder = m.tureNameString;
            _idCardTF.placeholder = m.idCardString;
            _accountTF.placeholder = m.accountString;
        }else {
            [HUDProgressTool showErrorWithText:[response objectForKey:@"msg"]];
        }
    } failure:^(NSError *error) {
        [HUDProgressTool showErrorWithText:ReqErrCode_Custom_ErrorInfo];
    }];
}

- (void)addAlipayAccountRequest {
    
    WithdrawAccountInfoModel *m = [[WithdrawAccountInfoModel alloc] init];
    m.tureNameString = _nameTF.text;
    m.idCardString = _idCardTF.text;
    m.accountString = _accountTF.text;
    
    [MoneyInfoRequest addAlipayAccountWithAccount:_accountTF.text idCard:_idCardTF.text realName:_nameTF.text success:^(NSDictionary *response) {
        if ([[response objectForKey:@"status"] intValue] == 200) {
            
            _nameTF.placeholder = m.tureNameString;
            _idCardTF.placeholder = m.idCardString;
            _accountTF.placeholder = m.accountString;
            _nameTF.enabled = NO;
            _idCardTF.enabled = NO;
            _accountTF.enabled = NO;
            [HUDProgressTool showSuccessWithText:@"成功"];
            if (self.delegate) {
                [self.delegate didCommitAccountInfoModel:m];
            }
            [self.navigationController popViewControllerAnimated:YES];
            
        }else {
            [HUDProgressTool showErrorWithText:[response objectForKey:@"msg"]];
        }
    } failure:^(NSError *error) {
        [HUDProgressTool showErrorWithText:ReqErrCode_Custom_ErrorInfo];
    }];
}

#pragma mark - Action

- (IBAction)commitBtnAction:(id)sender {
    
    if (!_nameTF.enabled) {
        [HUDProgressTool showOnlyText:@"信息不可修改"];
        return;
    }
    if ([_nameTF.text isEqualToString:@""]) {
        [HUDProgressTool showOnlyText:@"请输入真实姓名"];
        return;
    }
    if ([_idCardTF.text isEqualToString:@""]) {
        [HUDProgressTool showOnlyText:@"请输入身份信息"];
        return;
    }
    if ([_accountTF.text isEqualToString:@""]) {
        [HUDProgressTool showOnlyText:@"请输入帐号信息"];
        return;
    }
    
    [HUDProgressTool showIndicatorWithText:@"提交中"];
    [self addAlipayAccountRequest];
}

#pragma mark - TFDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    return YES;
}

#pragma mark -

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
