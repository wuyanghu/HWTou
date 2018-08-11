//
//  WithdrawMoneySuccessViewController.m
//  HWTou
//
//  Created by Reyna on 2018/2/8.
//  Copyright © 2018年 LieMi. All rights reserved.
//

#import "WithdrawMoneySuccessViewController.h"
#import "MyWalletViewController.h"

@interface WithdrawMoneySuccessViewController ()

@property (weak, nonatomic) IBOutlet UILabel *moneyLab;


@end

@implementation WithdrawMoneySuccessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"结果详情";
    
    self.moneyLab.text = [NSString stringWithFormat:@"¥%@",self.moneyString];
}

#pragma mark - Action

- (IBAction)finishBtnAction:(id)sender {
    
    for (int i=0; i<self.navigationController.viewControllers.count; i++) {
        UIViewController *vc = [self.navigationController.viewControllers objectAtIndex:i];
        if ([vc isKindOfClass:[MyWalletViewController class]]) {
            [self.navigationController popToViewController:vc animated:YES];
            return;
        }
    }
}

#pragma mark -

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
