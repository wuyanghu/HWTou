//
//  LiveRecordDetailViewController.m
//  HWTou
//
//  Created by robinson on 2018/3/27.
//  Copyright © 2018年 LieMi. All rights reserved.
//

#import "LiveRecordDetailViewController.h"
#import "PublicHeader.h"

@interface LiveRecordDetailViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;
@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
@property (weak, nonatomic) IBOutlet UILabel *nickNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *rewardLabel;
@property (weak, nonatomic) IBOutlet UILabel *onlineLabel;
@property (weak, nonatomic) IBOutlet UILabel *liveTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *commentNumLabel;

@end

@implementation LiveRecordDetailViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setTitle:@"直播详情"];
    
//    [self.bgImageView sd_setImageWithURL:[NSURL URLWithString:_getChatRecordsModel.chatAvater] placeholderImage:[UIImage imageNamed:@"zb_img_bg"]];
    [self.bgImageView sd_setImageWithURL:[NSURL URLWithString:_getChatRecordsModel.chatAvater]];
    [self.headerImageView sd_setImageWithURL:[NSURL URLWithString:_getChatRecordsModel.avater]];
    self.nickNameLabel.text = _getChatRecordsModel.nickName;
    self.rewardLabel.text = _getChatRecordsModel.tipMoney;
    self.onlineLabel.text = [NSString stringWithFormat:@"%ld",_getChatRecordsModel.onlineNum];
    self.liveTimeLabel.text = _getChatRecordsModel.duration;
    self.commentNumLabel.text = [NSString stringWithFormat:@"%ld",_getChatRecordsModel.commentNum];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - action

- (IBAction)popAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
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
