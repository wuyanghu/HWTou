//
//  SetPayPswdViewController.m
//  HWTou
//
//  Created by robinson on 2018/4/12.
//  Copyright © 2018年 LieMi. All rights reserved.
//

#import "SetPayPswdViewController.h"
#import "AccountManager.h"
#import "WCLPassWordView.h"
#import "MuteRequest.h"

@interface SetPayPswdViewController ()<WCLPassWordViewDelegate>
@property (weak, nonatomic) IBOutlet WCLPassWordView *setPayPswdView;
@property (weak, nonatomic) IBOutlet WCLPassWordView *surePayPswdView;

@end

@implementation SetPayPswdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setTitle:@"设置密码"];
    
    self.setPayPswdView.delegate = self;
    self.surePayPswdView.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)getCodeAction:(id)sender {
    if (self.setPayPswdView.textStore.length == 6 && self.setPayPswdView.textStore.length == 6 && [self.setPayPswdView.textStore isEqualToString:self.surePayPswdView.textStore]) {
        SetPayPwdParam * param = [SetPayPwdParam new];
        param.pwdF = self.setPayPswdView.textStore;
        param.pwdS = self.surePayPswdView.textStore;
        
        [MuteRequest setPayPwd:param Success:^(AnswerLsDict *response) {
            if (response.status == 200) {
                [self.view makeToast:@"密码设置成功" duration:2.0f position:CSToastPositionCenter];
                [self.navigationController popToRootViewControllerAnimated:YES];
            }else{
                [self.view makeToast:response.msg duration:2.0f position:CSToastPositionCenter];
            }
        } failure:^(NSError *error) {
            [self.view makeToast:@"网络繁忙" duration:2.0f position:CSToastPositionCenter];
        }];
    }else{
        [self.view makeToast:@"密码输入不正确" duration:2.0f position:CSToastPositionCenter];
    }
}

#pragma mark - WCLPassWordViewDelegate
/**
 *  监听输入的改变
 */
- (void)passWordDidChange:(WCLPassWordView *)passWord {
    NSLog(@"======密码改变：%@",passWord.textStore);
}

/**
 *  监听输入的完成时
 */
- (void)passWordCompleteInput:(WCLPassWordView *)passWord {
    if (self.setPayPswdView == passWord) {
        [self.surePayPswdView becomeFirstResponder];
    }else if (self.surePayPswdView == passWord) {
        if (self.setPayPswdView.textStore.length == 6 && self.setPayPswdView.textStore.length == 6 && [self.setPayPswdView.textStore isEqualToString:self.surePayPswdView.textStore]) {
            NSLog(@"+++++++密码输入完成");
            [passWord resignFirstResponder];
        }else{
            [self.view makeToast:@"密码输入不正确" duration:2.0f position:CSToastPositionCenter];
        }
    }
    
}

/**
 *  监听开始输入
 */
- (void)passWordBeginInput:(WCLPassWordView *)passWord {
    NSLog(@"-------密码开始输入");
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
