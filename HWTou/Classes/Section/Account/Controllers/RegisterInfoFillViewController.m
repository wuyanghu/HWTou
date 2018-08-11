//
//  RegisterInfoFillViewController.m
//  HWTou
//  注册信息填入界面
//  Created by robinson on 2017/11/13.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "RegisterInfoFillViewController.h"
#import "RegisterInfoFillView.h"
#import "PublicHeader.h"

@interface RegisterInfoFillViewController ()<RegisterInfoFillViewDelegate>

@end

@implementation RegisterInfoFillViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setTitle:@"信息填写"];
    
    [self.view addSubview:self.registerInfoFillView];
    [self.registerInfoFillView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - getter
- (RegisterInfoFillView *)registerInfoFillView{
    if (!_registerInfoFillView) {
        _registerInfoFillView = [[RegisterInfoFillView alloc] init];
        [_registerInfoFillView setRegisterInfoFillViewDelegate:self];
    }
    return _registerInfoFillView;
}

- (void)skipToHomePage{
    
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIF_LOGINSUCCESS
                                                        object:nil];
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
