//
//  WorkBenchViewController.m
//  HWTou
//
//  Created by robinson on 2017/11/24.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "WorkBenchViewController.h"
#import "ExpertAnchorViewController.h"
#import "WorkBenchView.h"
#import "PublicHeader.h"
#import "TopicRotViewController.h"
#import "MeEarningViewController.h"
#import "BuildTopicViewController.h"
#import "MeChatViewController.h"
#import "HistoryTopViewController.h"
#import "ComFloorEvent.h"
//#import "LiveRecordViewController.h"
#import "MuteListViewController.h"

@interface WorkBenchViewController ()<WorkBenchViewDelegate>

@end

@implementation WorkBenchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setTitle:@"工作台"];
    
    WorkBenchView * workBenchView = [[WorkBenchView alloc] initWithFrame:CGRectZero workType:_workType detailModel:self.detailModel];
    workBenchView.workBenchViewDelegate = self;
    [self.view addSubview:workBenchView];
    
    [workBenchView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)didSelectRowAtIndexPath:(NSIndexPath *)indexPath workType:(WorkType)workType title:(NSString *)title{
    if ([title isEqualToString:@"我的话题"]) {//我的话题
        TopicRotViewController * topicRotViewController = [[TopicRotViewController alloc] init];
        topicRotViewController.topicType = TopicMeType;
        [self.navigationController pushViewController:topicRotViewController animated:YES];
    }else if ([title isEqualToString:@"创建话题"]){//创建话题
        BuildTopicViewController * buildTopicVC = [[BuildTopicViewController alloc] init];
        [self.navigationController pushViewController:buildTopicVC animated:YES];
    }else if ([title isEqualToString:@"我的聊吧"]) {
        MeChatViewController * mechatVC = [[MeChatViewController alloc] init];
        mechatVC.isSuperManager = NO;
        [self.navigationController pushViewController:mechatVC animated:YES];
    }else if ([title isEqualToString:@"管理聊吧"]){
        MeChatViewController * mechatVC = [[MeChatViewController alloc] init];
        mechatVC.isSuperManager = YES;
        [self.navigationController pushViewController:mechatVC animated:YES];
    }else if ([title isEqualToString:@"永久禁言"]){
        MuteListViewController * muteVC = [[MuteListViewController alloc] initWithNibName:@"MuteListViewController" bundle:nil];
        [self.navigationController pushViewController:muteVC animated:YES];
    }else if ([title isEqualToString:@"直播记录"]){
//        LiveRecordViewController * recordVC = [[LiveRecordViewController alloc] initWithNibName:@"LiveRecordViewController" bundle:nil];
//        [self.navigationController pushViewController:recordVC animated:YES];
    }else if ([title isEqualToString:@"申请主播"]){
        [Navigation showExpertAnchorHtml5:self detailModel:_detailModel];
    }else if ([title isEqualToString:@"我的收益"]){
        MeEarningViewController * earningVC = [[MeEarningViewController alloc] init];
        [self.navigationController pushViewController:earningVC animated:YES];
    }else if ([title isEqualToString:@"聊吧主播使用手册"]) {
        FloorItemDM * itemDM = [FloorItemDM new];
        itemDM.type = FloorEventParam;
        itemDM.title = @"聊吧主播使用手册";
        itemDM.param = kApiLiaoBaInstructionsUrlHost;
        [ComFloorEvent handleEventWithFloor:itemDM];
    }
}


- (TopicWorkDetailModel *)detailModel{
    if (!_detailModel) {
        _detailModel = [TopicWorkDetailModel new];
    }
    return _detailModel;
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
