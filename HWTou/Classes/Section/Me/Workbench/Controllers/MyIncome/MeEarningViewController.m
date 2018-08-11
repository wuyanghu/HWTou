//
//  MeEarningViewController.m
//  HWTou
//
//  Created by robinson on 2017/12/1.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "MeEarningViewController.h"
#import "MeEarningView.h"
#import "PublicHeader.h"

@interface MeEarningViewController ()
@property (nonatomic,strong) MeEarningView * meEarningView;
@end

@implementation MeEarningViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setTitle:@"我的收益"];
    
    [self.view addSubview:self.meEarningView];
    [self.meEarningView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

- (MeEarningView *)meEarningView{
    if (!_meEarningView) {
        _meEarningView = [[MeEarningView alloc] init];
    }
    return _meEarningView;
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
