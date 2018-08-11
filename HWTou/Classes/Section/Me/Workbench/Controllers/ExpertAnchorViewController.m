//
//  ExpertAnchorViewController.m
//  HWTou
//
//  Created by robinson on 2017/12/8.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "ExpertAnchorViewController.h"
#import "PublicHeader.h"
#import "AccountManager.h"

@interface ExpertAnchorViewController ()<UIWebViewDelegate>

@end

@implementation ExpertAnchorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setTitle:@"我要做主播"];
    
    AccountManager * accountManger = [AccountManager shared];
    NSString * uid = [NSString stringWithFormat:@"%ld",accountManger.account.uid];
    NSString * phoneNumber = accountManger.account.userName;
    
    UIWebView * webView = [[UIWebView alloc] init];
    webView.delegate = self;
    NSString * usrString = [NSString stringWithFormat:@"https://h5.faye.rbson.net/share/#/?uid=%@&phone=%@&nickname=%@",uid,phoneNumber,_detailModel.nickname];
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:usrString]]];
    [self.view addSubview:webView];
    
    [webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
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
