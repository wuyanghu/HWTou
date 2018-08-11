//
//  PayTypeSelectedVC.m
//  HWTou
//
//  Created by Reyna on 2018/3/9.
//  Copyright © 2018年 LieMi. All rights reserved.
//

#import "PayTypeSelectedVC.h"
#import "PublicHeader.h"
#import "MoneyInfoRequest.h"
#import "AccountManager.h"
#import "MoneyAccountModel.h"

@interface PayTypeSelectedVC ()

@property (weak, nonatomic) IBOutlet UILabel *userAccountLab;

@property (nonatomic, strong) NSString *totalPrice;
@end

@implementation PayTypeSelectedVC

- (instancetype)initWithTotalPrice:(NSString *)totalPrice {
    self = [super init];
    if (self) {
        _totalPrice = totalPrice;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self userAccountRequest];
}

- (void)userAccountRequest {
    
    NSInteger uid = [AccountManager shared].account.uid;
    [MoneyInfoRequest getUserAccountWithUid:uid success:^(NSDictionary *response) {
        
        if ([[response objectForKey:@"status"] intValue] == 200) {
            
            NSDictionary *dataDic =[response objectForKey:@"data"];
            MoneyAccountModel *accountModel = [[MoneyAccountModel alloc] init];
            [accountModel bindWithDic:dataDic];
            
            if ([accountModel.balance doubleValue] < [_totalPrice doubleValue]) {
                self.userAccountLab.text = [NSString stringWithFormat:@"余额不足，剩余%@元",accountModel.balance];
                _balanceBtn.userInteractionEnabled = NO;
            }
            else {
                self.userAccountLab.text = [NSString stringWithFormat:@"剩余%@元",accountModel.balance];
                _balanceBtn.userInteractionEnabled = YES;
            }
        }else {
            [HUDProgressTool showErrorWithText:[response objectForKey:@"msg"]];
        }
    } failure:^(NSError *error) {
        [HUDProgressTool showErrorWithText:ReqErrCode_Custom_ErrorInfo];
    }];
}

#pragma mark -

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
