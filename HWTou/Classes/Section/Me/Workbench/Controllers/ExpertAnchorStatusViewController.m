//
//  ExpertAnchorStatusViewController.m
//  HWTou
//
//  Created by robinson on 2017/12/18.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "ExpertAnchorStatusViewController.h"

@interface ExpertAnchorStatusViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;
@property (weak, nonatomic) IBOutlet UIButton *reApplyBtn;

@end

@implementation ExpertAnchorStatusViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:@"我要做主播"];
    // Do any additional setup after loading the view from its nib.
    
    if (_checkStatus == 0) {
        _bgImageView.image = [UIImage imageNamed:@"tj_img_tj"];
        _reApplyBtn.hidden = YES;
    }else if(_checkStatus == 2){
        _bgImageView.image = [UIImage imageNamed:@"wtg_img_wtg"];
        _reApplyBtn.hidden = NO;
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)reApplyClick:(id)sender {
    _statusVCBlock();
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
