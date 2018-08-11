//
//  PayDetailViewController.m
//  HWTou
//
//  Created by 彭鹏 on 2017/3/19.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "PayDetailViewController.h"
#import "OrderDetailReq.h"
#import "PayDetailView.h"
#import "PublicHeader.h"

@interface PayDetailViewController ()

@property (nonatomic, strong) PayDetailView *vPayDetail;

@end

@implementation PayDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self createUI];
    
    [self loadData];
}

- (void)createUI
{
    self.title = @"付款结果";
    self.vPayDetail = [[PayDetailView alloc] init];
    [self.view addSubview:self.vPayDetail];
    [self.vPayDetail makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

- (void)loadData
{
    [HUDProgressTool showIndicatorWithText:nil];
    OrderComParam *param = [[OrderComParam alloc] init];
    param.mpid = self.mpid;
    
    [OrderDetailReq detailWithParam:param success:^(OrderDetailResp *response) {
        self.vPayDetail.dmOrder = response.data;
        [HUDProgressTool dismiss];
    } failure:^(NSError *error) {
        [HUDProgressTool showOnlyText:[error urlErrorCodeDescribe]];
    }];
}

@end
