//
//  HomeSubHotController.m
//  HWTou
//
//  Created by Reyna on 2017/11/21.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "HomeSubHotController.h"
#import "RotView.h"
#import "PublicHeader.h"

@interface HomeSubHotController ()
@property (nonatomic,strong) RotView * rotView;
@end

@implementation HomeSubHotController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.rotView];
    [self.rotView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [self.rotView refreshData];
}

- (RotView *)rotView{
    if (!_rotView) {
        _rotView = [[RotView alloc] init];
    }
    return _rotView;
}

#pragma mark -

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
