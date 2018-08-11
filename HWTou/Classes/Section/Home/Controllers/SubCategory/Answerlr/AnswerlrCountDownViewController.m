//
//  AnswerlrCountDownViewController.m
//  HWTou
//
//  Created by robinson on 2018/1/30.
//  Copyright © 2018年 LieMi. All rights reserved.
//

#import "AnswerlrCountDownViewController.h"
#import "PublicHeader.h"
#import "WeedOutView.h"
#import "AutoLifeView.h"
#import "AnswerProcessViewController.h"
#import "AnswerLsRequest.h"
#import "AudioUtil.h"

@interface AnswerlrCountDownViewController ()<CountDownDeleagete,UIGestureRecognizerDelegate>
@property (weak, nonatomic) IBOutlet UILabel *countDownLabel;
@property (weak, nonatomic) IBOutlet UIButton *lifeValueBtn;
@property (weak, nonatomic) IBOutlet UILabel *onlinePeopleNum;

@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;

@end

@implementation AnswerlrCountDownViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
//    self.view.backgroundColor = UIColorFromHex(0x4F4BE0);
    
    [self onlinePeopleNumRequest];
    
    [self.lifeValueBtn setTitle:[NSString stringWithFormat:@"%ld",self.viewModel.userInfoModel.lifeValue] forState:UIControlStateNormal];
    
    // 获取系统自带滑动手势的target对象
    id target = self.navigationController.interactivePopGestureRecognizer.delegate;
    // 创建全屏滑动手势，调用系统自带滑动手势的target的action方法
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:target action:@selector(handleNavigationTransition:)];
    pan.delegate = self;
    [self.view addGestureRecognizer:pan];
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(hadEnterBackGround) name:UIApplicationDidEnterBackgroundNotification object:nil];//进后台
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hadEnterForegroundGround) name:UIApplicationWillEnterForegroundNotification object:nil];//进前台
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (self.navigationController.navigationBarHidden) {
        [self.navigationController setNavigationBarHidden:NO animated:YES];
    }
    [[AudioUtil sharedInstance] stopPlaying];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (!self.navigationController.navigationBarHidden) {
        [self.navigationController setNavigationBarHidden:YES animated:YES];
    }
    [self.bgImageView sd_setImageWithURL:[NSURL URLWithString:self.viewModel.activityModel.bgmUrl] placeholderImage:[UIImage imageNamed:@"ccccccc"]];
    
    [[AudioUtil sharedInstance] playReplyVoiceWithVoicePath:self.viewModel.activityModel.listenUrl];
}

- (void)dealloc{
    NSLog(@"dealloc");
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - home控制
- (void)hadEnterBackGround{
    NSLog(@"进后台");
    [[AudioUtil sharedInstance] stopPlaying];
}

- (void)hadEnterForegroundGround{
    NSLog(@"进前台");
    if (self.viewModel.activityModel.listenUrl) {
        [[AudioUtil sharedInstance] playReplyVoiceWithVoicePath:self.viewModel.activityModel.listenUrl];
    }
}

#pragma mark - action

- (void)popView{
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)popViewAction:(id)sender {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"警告" message:@"活动马上就要开始，小心错过哦！" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * okAction = [UIAlertAction actionWithTitle:@"确定退出" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        [self popView];
    }];
    
    UIAlertAction * cancleAction = [UIAlertAction actionWithTitle:@"继续答题" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alert addAction:okAction];
    [alert addAction:cancleAction];
    
    [self presentViewController:alert animated:YES completion:nil];
    
}

- (IBAction)shareAction:(id)sender {
    [Navigation showAnswerShareViewController:self title:self.viewModel.selectSpecModel.name webLink:kApiSuccessUrlHost];
}

#pragma mark - UIGestureRecognizerDelegate

- (void)handleNavigationTransition:(UIPanGestureRecognizer *)panGestureRecognizer{
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    return YES;
}

#pragma mark - 网络请求

- (void)onlinePeopleNumRequest{
    GetActivityParam * param = [GetActivityParam new];
    param.specId = self.viewModel.selectSpecModel.specId;
    [AnswerLsRequest getOnlineNum:param Success:^(AnswerLsInt *response) {
        if (response.status == 200) {
            self.onlinePeopleNum.text = [NSString stringWithFormat:@"%ld",response.data];
        }
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark - CountDownDeleagete
- (void)countdownView:(NSString *)time{
    self.countDownLabel.text = time;
}

- (void)updateOnlineNum{
    [self onlinePeopleNumRequest];
}

#pragma mark  - setter
- (void)setViewModel:(AnswerlrViewModel *)viewModel{
    _viewModel = viewModel;
    _viewModel.downDelegate = self;
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
