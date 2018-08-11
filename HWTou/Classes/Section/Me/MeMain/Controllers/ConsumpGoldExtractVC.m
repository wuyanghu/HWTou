//
//  ConsumpGoldExtractVC.m
//  HWTou
//
//  Created by 彭鹏 on 2017/7/11.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "ConsumpGoldExtractView.h"
#import "ConsumpGoldExtractVC.h"
#import "PublicHeader.h"

@interface ConsumpGoldExtractVC ()

@property (nonatomic, strong) ConsumpGoldExtractView *vGold;

@end

@implementation ConsumpGoldExtractVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createUI];
}

- (void)createUI
{
    self.title = @"提前花提现";
    self.vGold = [[ConsumpGoldExtractView alloc] init];
    [self.view addSubview:self.vGold];
    [self.vGold makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    self.vGold.dmInfo = self.dmInfo;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
