//
//  MakeCopperViewController.m
//  HWTou
//
//  Created by 张维扬 on 2017/8/10.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "MakeCopperViewController.h"
#import "PublicHeader.h"
#import "MakeCopperView.h"
@interface MakeCopperViewController ()
@property (nonatomic, strong) MakeCopperView *copperView;
@end

@implementation MakeCopperViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setTitle:@"铜钱花"];
    [self createUI];
    
    
}

- (void)createUI
{
    _copperView = [[MakeCopperView alloc] init];
    [self.view addSubview:_copperView];
    [_copperView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
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
