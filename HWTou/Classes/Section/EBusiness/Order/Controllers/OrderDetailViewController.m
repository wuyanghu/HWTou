//
//  OrderDetailViewController.m
//  HWTou
//
//  Created by 彭鹏 on 2017/3/19.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "OrderDetailViewController.h"
#import "OrderDetailView.h"
#import "PublicHeader.h"

@interface OrderDetailViewController ()

@property (nonatomic, strong) OrderDetailView *vOrderDetail;

@end

@implementation OrderDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self createUI];
}

- (void)createUI
{
    self.title = @"订单详情";
    self.vOrderDetail = [[OrderDetailView alloc] init];
    [self.view addSubview:self.vOrderDetail];
    self.vOrderDetail.dmOrder = self.dmOrder;
    
    [self.vOrderDetail makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

- (BOOL)isShowCloseButton
{
    return YES;
}

@end
