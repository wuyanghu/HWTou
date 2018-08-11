//
//  OrderMailViewController.m
//  HWTou
//
//  Created by 彭鹏 on 2017/4/11.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "OrderMailViewController.h"
#import "OrderDetailDM.h"
#import "OrderMailView.h"
#import "OrderMailReq.h"
#import "PublicHeader.h"

@interface OrderMailViewController ()

@property (nonatomic, strong) OrderMailView *vMail;

@end

@implementation OrderMailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self createUI];
    [self loadMailData];
}

- (void)createUI
{
    self.title = @"物流跟踪";
    self.vMail = [[OrderMailView alloc] init];
    [self.view addSubview:self.vMail];
    
    [self.vMail makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

- (void)loadMailData
{
    [HUDProgressTool showIndicatorWithText:@"加载中..."];
    
    OrderMailParam *param = [OrderMailParam new];
    param.mail_no = self.dmOrder.mail_no;
    
    [OrderMailReq mailWithParam:param success:^(OrderMailResp *response) {
        if (response.success) {
            self.vMail.dmMail = response.data;
            [HUDProgressTool dismiss];
        } else {
            [HUDProgressTool showOnlyText:response.msg];
        }
    } failure:^(NSError *error) {
        [HUDProgressTool showOnlyText:[error urlErrorCodeDescribe]];
    }];
}

@end
