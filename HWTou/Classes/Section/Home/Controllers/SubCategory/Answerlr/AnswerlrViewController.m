//
//  AnswerlrViewController.m
//  HWTou
//
//  Created by robinson on 2018/1/30.
//  Copyright © 2018年 LieMi. All rights reserved.
//

#import "AnswerlrViewController.h"
#import "PublicHeader.h"
#import "AnswerlrCountDownViewController.h"
#import "AnswerProcessViewController.h"
#import "AnswerLsRequest.h"
#import "AnswerlrViewModel.h"
#import "HomePageViewController.h"
#import "InviteMyFriendViewController.h"
#import "ComWebViewController.h"

@interface AnswerlrViewController ()<AnswerlrViewModelDelegate,UIGestureRecognizerDelegate>
{
    BOOL isNextActity;//是否有下一场
}
@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (weak, nonatomic) IBOutlet UILabel *activityProcessLabel;//活动进行中
@property (weak, nonatomic) IBOutlet UIButton *clickWatchBtn;//点击观看

@property (weak, nonatomic) IBOutlet UILabel *nextPeriodStartTimeLabel;//下期开始时间
@property (weak, nonatomic) IBOutlet UILabel *nowTimeLabel;//时间
@property (weak, nonatomic) IBOutlet UILabel *bonusLabel;//奖金
//@property (strong, nonatomic) IBOutlet UIView *lineView;//线条
@property (weak, nonatomic) IBOutlet UIView *lineBgView;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;//头像
@property (weak, nonatomic) IBOutlet UILabel *nickNameLabel;//昵称
@property (weak, nonatomic) IBOutlet UILabel *totalBalanceLabel;//累计金额
@property (weak, nonatomic) IBOutlet UILabel *withdrawLabel;//可提现

@property (weak, nonatomic) IBOutlet UIButton *gainMoreBtn;
@property (weak, nonatomic) IBOutlet UIButton *lifeValueBtn;//生命值


@end

@implementation AnswerlrViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
//    self.view.backgroundColor = UIColorFromHex(0x4F4BE0);
#ifdef __IPHONE_11_0
    if ([_scrollView respondsToSelector:@selector(setContentInsetAdjustmentBehavior:)]) {
        _scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
#endif
    
    self.gainMoreBtn.layer.borderColor = UIColorFromHex(0xE5E3E6).CGColor;
    self.gainMoreBtn.layer.borderWidth = 2;
    
    [self getUserInfo];
    
    // 获取系统自带滑动手势的target对象
    id target = self.navigationController.interactivePopGestureRecognizer.delegate;
    // 创建全屏滑动手势，调用系统自带滑动手势的target的action方法
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:target action:@selector(handleNavigationTransition:)];
    pan.delegate = self;
    [self.view addGestureRecognizer:pan];
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    
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
    
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    NSArray * viewcontrollers = self.navigationController.viewControllers;
    if (viewcontrollers == nil) {
        [self.viewModel stopTime];
        [self.viewModel destroyVar];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (!self.navigationController.navigationBarHidden) {
        [self.navigationController setNavigationBarHidden:YES animated:YES];
    }
    
    [self updateActivityView];
    if (isNextActity) {
        isNextActity = NO;
        [self nextActivity];
        [self getUserInfo];
    }
}

#pragma mark  - 网络请求

- (void)getUserInfo{
    [AnswerLsRequest getUserInfo:[BaseParam new] Success:^(AnswerLsDict *response) {
        if (response.status == 200) {
            [self.viewModel bindGetUserInfoModel:response.data];
            [self updateUserInfoView];
        }
    } failure:^(NSError *error) {
        
    }];
}

//下一场活动
- (void)nextActivity{
    
    GetActivityParam * activityParam = [GetActivityParam new];
    activityParam.specId = self.viewModel.selectSpecModel.specId;

    [AnswerLsRequest getActivity:activityParam Success:^(AnswerLsDict *response) {
        if (response.status == 200) {
            [self.viewModel bindGetActivityModel:response.data];
            [self updateActivityView];
        }else{

        }
    } failure:^(NSError *error) {
        
    }];
}
//退出活动
- (void)exitActivity{
    GetActivityParam * param = [GetActivityParam new];
    param.specId = self.viewModel.selectSpecModel.specId;
    
    [AnswerLsRequest exitActivity:param Success:^(AnswerLsDict *response) {
        
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark - AnswerlrViewModelDelegate
//活动未开始
- (void)nextView{
    [self showNextActivityView];
}

////活动正在进行
- (void)lookView{
    [self showActivityProcessView];
}
//活动结束
- (void)activityFinish{
    [self showActivityEndView];
    isNextActity = YES;
    
}

- (void)countdownView:(NSString *)time{
    [self showNextActivityView];
}
//进入答题
- (void)pushProcessViewController{
    NSArray * viewControllers = self.navigationController.viewControllers;
    for (UIViewController * viewController in viewControllers) {
        if ([viewController isKindOfClass:[AnswerProcessViewController class]]) {
            return;
        }
    }
    
    AnswerProcessViewController * processVC = [[AnswerProcessViewController alloc] initWithNibName:@"AnswerProcessViewController" bundle:nil];
    processVC.lrViewModel = self.viewModel;
    [self.navigationController pushViewController:processVC animated:YES];
}

//进入倒计时
- (void)pushCountdownViewController{
    NSArray * viewControllers = self.navigationController.viewControllers;
    for (UIViewController * viewController in viewControllers) {
        if ([viewController isKindOfClass:[AnswerlrCountDownViewController class]]) {
            return;
        }
    }
    //如果不包含，则跳入
    AnswerlrCountDownViewController * contDownVC = [[AnswerlrCountDownViewController alloc] initWithNibName:@"AnswerlrCountDownViewController" bundle:nil];
    contDownVC.viewModel = self.viewModel;
    [self.navigationController pushViewController:contDownVC animated:YES];
    
}

#pragma mark - UIGestureRecognizerDelegate

- (void)handleNavigationTransition:(UIPanGestureRecognizer *)panGestureRecognizer{
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    return YES;
}

#pragma mark - 更新UI

- (void)updateActivityView{
    GetActivityModel * activityModel = self.viewModel.activityModel;
    self.nowTimeLabel.text = [self.viewModel getDayString];
    self.bonusLabel.text = [NSString stringWithFormat:@"¥%.2f 奖金",activityModel.actReward];
    
    self.titleLabel.text = activityModel.actTitle;
    
    [self.bgImageView sd_setImageWithURL:[NSURL URLWithString:self.viewModel.selectSpecModel.bgmUrl] placeholderImage:[UIImage imageNamed:@"ccccccc"]];
}

- (void)updateUserInfoView{
    GetUserInfoModel * userInModel = self.viewModel.userInfoModel;
    [self.headerImageView sd_setImageWithURL:[NSURL URLWithString:userInModel.headUrl]];
    self.nickNameLabel.text = userInModel.nickname;
    self.withdrawLabel.text = [NSString stringWithFormat:@"可提现 %@元",userInModel.balance];
    self.totalBalanceLabel.text = [NSString stringWithFormat:@"¥%@",userInModel.qAward];
    
    [self.lifeValueBtn setTitle:[NSString stringWithFormat:@"%ld",userInModel.lifeValue] forState:UIControlStateNormal];
}

#pragma mark - 页面操作

- (void)showActivityEndView{
    self.activityProcessLabel.hidden = NO;
    
    self.activityProcessLabel.text = @"暂无活动";
    
    self.clickWatchBtn.hidden = YES;
    self.nextPeriodStartTimeLabel.hidden = YES;
    self.nowTimeLabel.hidden = YES;
    self.bonusLabel.hidden = YES;
    self.lineBgView.hidden = YES;
}

//活动正在进行
- (void)showActivityProcessView{
    
    self.activityProcessLabel.hidden = NO;
    self.clickWatchBtn.hidden = NO;
    
    self.activityProcessLabel.text = @"活动正在进行中";
    
    self.nextPeriodStartTimeLabel.hidden = YES;
    self.nowTimeLabel.hidden = YES;
    self.bonusLabel.hidden = YES;
    self.lineBgView.hidden = YES;
}
//下一场活动未开始
- (void)showNextActivityView{
    self.activityProcessLabel.hidden = YES;
    self.clickWatchBtn.hidden = YES;
    
    self.nextPeriodStartTimeLabel.hidden = NO;
    self.nowTimeLabel.hidden = NO;
    self.bonusLabel.hidden = NO;
    self.lineBgView.hidden = NO;
    
}

#pragma mark - 点击事件

- (IBAction)inviteAction:(id)sender {
    InviteMyFriendViewController * frientVC = [[InviteMyFriendViewController alloc] init];
    [self.navigationController pushViewController:frientVC animated:YES];
}

- (IBAction)gainMoreAction:(id)sender {
    [Navigation showAnswerShareViewController:self title:self.viewModel.selectSpecModel.name webLink:kApiMoreplayingUrlHost];
}

- (IBAction)knowPlayAction:(id)sender {
    ComWebViewController *webVC = [[ComWebViewController alloc] init];
    NSString *urlString = [NSString stringWithFormat:@"%@?type=1",kApiActivityRuleUrlHost];
    webVC.webUrl = urlString;
    [self.navigationController pushViewController:webVC animated:YES];
}

- (IBAction)lookAction:(id)sender {
    if ([self.viewModel isDownTime]) {
        [self pushCountdownViewController];
    }else{
        self.viewModel.isContinueAnswer = NO;
        [self pushProcessViewController];
    }
    
}

- (IBAction)popViewAction:(id)sender {
    [self popView];
}

- (void)popView{
    [self exitActivity];
    if (self.navigationController.navigationBarHidden) {
        [self.navigationController setNavigationBarHidden:NO animated:YES];
    }
    // 开启返回手势
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)goWalletVCAction:(id)sender {
    [Navigation showMyWalletViewController:self];
}


#pragma mark - setter

- (void)setViewModel:(AnswerlrViewModel *)viewModel{
    _viewModel = viewModel;
    _viewModel.answerlrDeleate = self;
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
