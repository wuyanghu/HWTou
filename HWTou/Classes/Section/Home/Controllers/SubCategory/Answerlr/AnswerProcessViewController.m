//
//  AnswerProcessViewController.m
//  HWTou
//
//  Created by robinson on 2018/1/30.
//  Copyright © 2018年 LieMi. All rights reserved.
//

#import "AnswerProcessViewController.h"
#import "PublicHeader.h"
#import "AnswerLsRequest.h"
#import "WeedOutView.h"
#import "AutoLifeView.h"
#import "WinView.h"
#import "PersonHomeReq.h"
#import "AnswerlrCountDownViewController.h"
#import "AnswerlrViewController.h"
#import "WinnerListView.h"
#import "AudioUtil.h"
#import "AnswerProgressView.h"
#import "GetAnsNumModel.h"

typedef NS_ENUM(NSInteger,buttonState){
    countDownBtnType,
    errorBtnType,
    lookBtnType,
    rightBtnType,
};

typedef NS_ENUM(NSInteger,answerBtnState) {
    answerABtnType,
    answerBBtnType,
    answerCBtnType,
};

typedef NS_ENUM(NSInteger,selectStateColor) {
    normalBgColor,
    selectBgColor,
    rightBgColor,
    errorBgColor,
};

@interface AnswerProcessViewController ()<ProcessDelegate,WinViewDelegate,WeedOutViewDelegate,UIGestureRecognizerDelegate>
{
    BOOL isAutoSelf;//是否自动复活过(只能复活一次)
}

@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;
@property (weak, nonatomic) IBOutlet UIScrollView *bgScrollView;

@property (weak, nonatomic) IBOutlet UIButton *countDownBtn;
@property (weak, nonatomic) IBOutlet UIButton *errorBtn;
@property (weak, nonatomic) IBOutlet UIButton *lookBtn;
@property (weak, nonatomic) IBOutlet UIButton *rightBtn;

@property (weak, nonatomic) IBOutlet UILabel *onlineNumLabel;

@property (weak, nonatomic) IBOutlet UILabel *questionLabel;
@property (weak, nonatomic) IBOutlet UIButton *answerABtn;
@property (weak, nonatomic) IBOutlet UIButton *anserBBtn;
@property (weak, nonatomic) IBOutlet UIButton *anserCBtn;

@property (weak, nonatomic) IBOutlet AnswerProgressView *progressAView;
@property (weak, nonatomic) IBOutlet AnswerProgressView *progressBView;
@property (weak, nonatomic) IBOutlet AnswerProgressView *progressCView;

@property (weak, nonatomic) IBOutlet UIButton *leftValueBtn;

@property (weak, nonatomic) IBOutlet UILabel *answerCountALabel;
@property (weak, nonatomic) IBOutlet UILabel *answerCountBLabel;
@property (weak, nonatomic) IBOutlet UILabel *answerCountCLabel;

@property (nonatomic,strong) NSArray<UIButton*>* answerBtnArr;
@property (nonatomic,strong) NSArray<AnswerProgressView *>* progressViewArr;

@property (nonatomic,assign) NSInteger selectAnswer;//选中的答案
@property (nonatomic,assign) NSInteger nowProcessNum;//正在进行中的答案
@property (nonatomic,strong) GetAnsNumModel * ansNumModel;

@end

@implementation AnswerProcessViewController

#pragma mark - lifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    // 获取系统自带滑动手势的target对象

    [self setBtnState:countDownBtnType];
    
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
    [[AudioUtil sharedInstance] stopPlaying];

    if (self.navigationController.navigationBarHidden) {
        [self.navigationController setNavigationBarHidden:NO animated:YES];
    }    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (!self.navigationController.navigationBarHidden) {
        [self.navigationController setNavigationBarHidden:YES animated:YES];
    }
    
    self.countDownBtn.layer.borderColor = UIColorFromHex(0xFFBE00).CGColor;
    self.countDownBtn.layer.borderWidth = 5;
    
    [self.bgImageView sd_setImageWithURL:[NSURL URLWithString:self.lrViewModel.activityModel.bgmUrl] placeholderImage:[UIImage imageNamed:@"ccccccc"]];
    
    [self.leftValueBtn setTitle:[NSString stringWithFormat:@"%ld",self.lrViewModel.userInfoModel.lifeValue] forState:UIControlStateNormal];
    [self getUserInfo];//获取个人信息
    
    NSInteger answerNum = [self.lrViewModel calculateAnswerNum];
    if (answerNum != -1) {
        _nowProcessNum = answerNum+1;
        [HUDProgressTool showIndicatorWithText:@"加载中"];
        [self.lrViewModel updateProcessView];
        
        [self onlinePeopleNumRequest];//在线人数
        
    }else{
        NSLog(@"答题结束");
    }
}

#pragma mark - 弹窗

- (void)showOutView{
    if (self.lrViewModel.isContinueAnswer) {
        //弹出淘汰提示
        WeedOutView * outView = [[[NSBundle mainBundle] loadNibNamed:@"WeedOutView" owner:self options:nil] lastObject];
        outView.outViewDelegate = self;
        [self.bgScrollView addSubview:outView];
        
        [outView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.bgScrollView).offset(80.5);
            make.left.equalTo(self.bgScrollView).offset(15);
            make.bottom.equalTo(self.bgScrollView).offset(-80.5);
            make.right.equalTo(self.bgScrollView).offset(-15);
        }];
    }
    self.lrViewModel.isContinueAnswer = NO;
}

- (void)showAutoLifeView{
    GetUserInfoModel * userInfoModel = self.lrViewModel.userInfoModel;
    if (self.lrViewModel.isContinueAnswer && userInfoModel.lifeValue>0 && ![self isLastAnswer] && !isAutoSelf) {
        isAutoSelf = YES;
        [self updateUserLifeValueRequest];
        userInfoModel.lifeValue--;
        
        [self.leftValueBtn setTitle:[NSString stringWithFormat:@"%ld",self.lrViewModel.userInfoModel.lifeValue] forState:UIControlStateNormal];
        
        AutoLifeView * lifeView = [[[NSBundle mainBundle] loadNibNamed:@"AutoLifeView" owner:self options:nil] lastObject];
        [self.bgScrollView addSubview:lifeView];
    
        [lifeView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.bgScrollView).offset(80.5);
            make.left.equalTo(self.bgScrollView).offset(15);
            make.bottom.equalTo(self.bgScrollView).offset(-80.5);
            make.right.equalTo(self.bgScrollView).offset(-15);
        }];
    }else{
        [self showOutView];
    }
}

- (void)showWinView:(NSString *)money{
    WinView * winView = [[[NSBundle mainBundle] loadNibNamed:@"WinView" owner:self options:nil] lastObject];
    winView.winDelegate = self;
    winView.getMoneyLabel.text = money;
    
    GetUserInfoModel * userInfoModel = self.lrViewModel.userInfoModel;
    [winView.headerImageView sd_setImageWithURL:[NSURL URLWithString:userInfoModel.headUrl]];
    winView.nickNameLabel.text = userInfoModel.nickname;
    [self.bgScrollView addSubview:winView];
    
    [winView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bgScrollView).offset(80.5);
        make.left.equalTo(self.bgScrollView).offset(15);
        make.bottom.equalTo(self.bgScrollView).offset(-80.5);
        make.right.equalTo(self.bgScrollView).offset(-15);
    }];
}

- (void)showWinnerListView{
    WinnerListView * listView = [[[NSBundle mainBundle] loadNibNamed:@"WinnerListView" owner:self options:nil] lastObject];
    [listView setUserModel:self.lrViewModel.winUserModel];
    [self.bgScrollView addSubview:listView];
    
    [listView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bgScrollView).offset(80.5);
        make.left.equalTo(self.bgScrollView).offset(15);
        make.bottom.equalTo(self.bgScrollView).offset(-80.5);
        make.right.equalTo(self.bgScrollView).offset(-15);
    }];
}

#pragma mark - 判断是否是最后一题

- (BOOL)isLastAnswer{
    if (_nowProcessNum == self.lrViewModel.activityModel.quesNum) {
        return YES;
    }
    return NO;
}

#pragma mark - 转换
//把正确答案转成下标
- (NSInteger)getIndexTrueAnswer:(NSString *)trueAnswer{
    if ([trueAnswer isEqualToString:@"A"]) {
        return 0;
    }else if([trueAnswer isEqualToString:@"B"]){
        return 1;
    }else if ([trueAnswer isEqualToString:@"C"]){
        return 2;
    }
    return 0;
}

#pragma mark - 新的一题
- (void)newTopicStart{
    [[AudioUtil sharedInstance] playReplyVoiceWithVoicePath:self.lrViewModel.questionBankInfoModel.voiceIntroduce];
    
    if (self.lrViewModel.isContinueAnswer) {
        [self setBtnStateEnable:YES];//设置按钮状态，可点击
        [self setBtnState:countDownBtnType];
    }else{
        [self setBtnStateEnable:NO];//设置按钮状态，可点击
        [self setBtnState:lookBtnType];//只能围观
    }
    
    _selectAnswer = -1;
    
    //展示选项按钮
    GetQuestionBankInfoModel * infoModel = self.lrViewModel.questionBankInfoModel;
    self.questionLabel.text = infoModel.quesTitle;
    NSArray * quesOptionArr = infoModel.quesOptionArr;
    for (int i= 0;i<quesOptionArr.count;i++) {
        QuesOptionsModel * optionsModel = quesOptionArr[i];
        NSString * title = [NSString stringWithFormat:@"%@ %@",optionsModel.k,optionsModel.v];
        UIButton * optionBtn = self.answerBtnArr[i];
        [optionBtn setTitle:title forState:UIControlStateNormal];
        [self setBtnBgColor:normalBgColor button:optionBtn];
        
        AnswerProgressView * progressView = self.progressViewArr[i];
        [self setProgressViewColor:normalBgColor view:progressView];
        progressView.progress = 1;
    }
    
}

#pragma mark - UIGestureRecognizerDelegate

- (void)handleNavigationTransition:(UIPanGestureRecognizer *)panGestureRecognizer{
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    return YES;
}

#pragma mark - ProcessDelegate

//展示结果
- (void)showResult{
    [self getAnsNum];
}

- (void)showAnswerResult{
    [self setShowCountLabelHide:NO];
    [self setBtnStateEnable:NO];

    
    GetQuestionBankInfoModel * infoModel = self.lrViewModel.questionBankInfoModel;
    
    if (_selectAnswer>=0 && _selectAnswer<infoModel.quesOptionArr.count) {
        NSString * k = [infoModel.quesOptionArr[_selectAnswer] k];
        UIButton * optionBtn = self.answerBtnArr[_selectAnswer];
        AnswerProgressView * optionView = self.progressViewArr[_selectAnswer];
        
        if ([self.ansNumModel.rightAnswer isEqualToString:k]) {//正确
            [self setBtnState:rightBtnType];
            [self setBtnBgColor:rightBgColor button:optionBtn];
            [self setProgressViewColor:rightBgColor view:optionView];
        }else{//错误
            [self setBtnState:errorBtnType];
            [self setBtnBgColor:errorBgColor button:optionBtn];
            [self setProgressViewColor:errorBgColor view:optionView];
            
            NSInteger indexTrueAnwser = [self getIndexTrueAnswer:self.ansNumModel.rightAnswer];
            UIButton * rightBtn = self.answerBtnArr[indexTrueAnwser];
            AnswerProgressView * rightBtnView = self.progressViewArr[indexTrueAnwser];
            [self setBtnBgColor:rightBgColor button:rightBtn];
            [self setProgressViewColor:rightBgColor view:rightBtnView];
            
            [self showAutoLifeView];
            
        }
    }else{
        [self setBtnState:lookBtnType];//没选就围观
        
        NSInteger indexTrueAnwser = [self getIndexTrueAnswer:self.ansNumModel.rightAnswer];
        UIButton * optionBtn = self.answerBtnArr[indexTrueAnwser];
        [self setBtnBgColor:rightBgColor button:optionBtn];
        
        
        AnswerProgressView * optionView = self.progressViewArr[indexTrueAnwser];
        [self setProgressViewColor:rightBgColor view:optionView];
        
        [self showAutoLifeView];
        
    }
    
    NSArray * quesOptionArr = self.lrViewModel.questionBankInfoModel.quesOptionArr;
    for (int i= 0;i<quesOptionArr.count;i++) {
        UIButton * optionBtn = self.answerBtnArr[i];
        [optionBtn setBackgroundColor:[UIColor clearColor]];
    }
    
    self.progressAView.progress = [self.ansNumModel getPercentage:ansAnumType];
    self.progressBView.progress = [self.ansNumModel getPercentage:ansBnumType];
    self.progressCView.progress = [self.ansNumModel getPercentage:ansCnumType];
}

//展示题目
- (void)showTopic:(NSInteger)rank{
    [self onlinePeopleNumRequest];
    
    [self setShowCountLabelHide:YES];
    
    _nowProcessNum = rank+1;
    [self getQuestionBankInfoRequest:_nowProcessNum];
}

- (void)countDownTime:(NSInteger)count{
    [self.countDownBtn setTitle:[NSString stringWithFormat:@"%ld",count] forState:UIControlStateNormal];
}

- (void)answerResult{
    
    if (self.lrViewModel.isContinueAnswer) {
        [self getMoney];//答题结束，获取奖金
    }else{
        [self getWinUser];//围观着展示
    }
    
    [self performSelector:@selector(popView) withObject:nil afterDelay:30.0f];
}

- (void)updateOnlineNum{
    [self onlinePeopleNumRequest];
}

#pragma mark - WeedOutViewDelegate

- (void)inviteMyFriend{
    [Navigation showAnswerShareViewController:self title:self.lrViewModel.selectSpecModel.name webLink:kApiMoreplayingUrlHost];
}

#pragma mark - WinViewDelegate

- (void)finishAnswerAction{
    [self getWinUser];
}

- (void)shareWinViewAction{
    [Navigation showAnswerShareViewController:self title:self.lrViewModel.selectSpecModel.name webLink:kApiSuccessUrlHost];
}

#pragma mark - 网络请求

- (void)updateStatus{
    UpdateStatusParam * param = [UpdateStatusParam new];
    param.specId = self.lrViewModel.selectSpecModel.specId;
    param.actId = self.lrViewModel.activityModel.actId;
    
    [AnswerLsRequest updateStatus:param Success:^(AnswerLsDict *response) {
        
    } failure:^(NSError *error) {
        
    }];
}

- (void)exitActivity{
    GetActivityParam * param = [GetActivityParam new];
    param.specId = self.lrViewModel.selectSpecModel.specId;
    
    [AnswerLsRequest exitActivity:param Success:^(AnswerLsDict *response) {
        
    } failure:^(NSError *error) {
        
    }];
}

- (void)getWinUser{
    GetMoneyParam * param = [GetMoneyParam new];
    param.actId = self.lrViewModel.activityModel.actId;
    [AnswerLsRequest getWinUser:param Success:^(AnswerLsDict *response) {
        if (response.status == 200) {
            [self.lrViewModel bindGetWinUserModel:response.data];
            [self showWinnerListView];
        }
    } failure:^(NSError *error) {
        
    }];
}

- (void)getUserInfo{
    [AnswerLsRequest getUserInfo:[BaseParam new] Success:^(AnswerLsDict *response) {
        if (response.status == 200) {
            [self.lrViewModel bindGetUserInfoModel:response.data];
        }
    } failure:^(NSError *error) {
        
    }];
}

//获取奖励金
- (void)getMoney{
    GetMoneyParam * param = [GetMoneyParam new];
    param.actId = self.lrViewModel.activityModel.actId;
    [AnswerLsRequest getMoney:param Success:^(AnswerLsDouble *response) {
        if (response.status == 200) {
            [self showWinView:response.data];
        }
    } failure:^(NSError *error) {
        
    }];
}

//用户回答
- (void)addUserAns:(NSString *)answer{
    AddUserAnsParam * ansParam = [AddUserAnsParam new];
    ansParam.quesId = self.lrViewModel.questionBankInfoModel.quesId;
    ansParam.answer = answer;

    [AnswerLsRequest addUserAns:ansParam Success:^(AnswerLsDict *response) {
        
    } failure:^(NSError *error) {
        
    }];
}

//A,B,C各选项人数统计
- (void)getAnsNum{
    GetAnsNumParam * param = [GetAnsNumParam new];
    param.rank = _nowProcessNum;
    param.quesId = self.lrViewModel.questionBankInfoModel.quesId;
    [AnswerLsRequest getAnsNum:param Success:^(AnswerLsDict *response) {
        if (response.status == 200) {
            [self.ansNumModel setValuesForKeysWithDictionary:response.data];
            
            self.answerCountALabel.text = [NSString stringWithFormat:@"%ld",self.ansNumModel.ansANum];
            self.answerCountBLabel.text = [NSString stringWithFormat:@"%ld",self.ansNumModel.ansBNum];
            self.answerCountCLabel.text = [NSString stringWithFormat:@"%ld",self.ansNumModel.ansCNum];
            [self showAnswerResult];
        }
    } failure:^(NSError *error) {
        
    }];
}
//题目选项信息
- (void)getQuestionBankInfoRequest:(NSInteger)rank{
    GetQuestionBankInfoParam * bankInfoParam = [GetQuestionBankInfoParam new];
    bankInfoParam.actId = self.lrViewModel.activityModel.actId;
    bankInfoParam.rank = rank;
    WeakObj(self);
    [AnswerLsRequest getQuestionBankInfo:bankInfoParam Success:^(AnswerLsDict *response) {
        if (response.status == 200) {
            [selfWeak.lrViewModel bindGetQuestionBankInfoModel:response.data];
            [selfWeak newTopicStart];
        }
        [HUDProgressTool dismiss];
    } failure:^(NSError *error) {
        [HUDProgressTool dismiss];
    }];
}
//生命值
- (void)updateUserLifeValueRequest{
    UpdateUserLifeValueParam * param = [UpdateUserLifeValueParam new];
    param.toId = self.lrViewModel.activityModel.actId;
    [PersonHomeRequest updateUserLifeValue:param Success:^(BaseResponse *response) {
        
    } failure:^(NSError *error) {
        
    }];
}
//在线人数
- (void)onlinePeopleNumRequest{
    GetActivityParam * param = [GetActivityParam new];
    param.specId = self.lrViewModel.selectSpecModel.specId;
    [AnswerLsRequest getOnlineNum:param Success:^(AnswerLsInt *response) {
        if (response.status == 200) {
            self.onlineNumLabel.text = [NSString stringWithFormat:@"%ld",response.data];
        }
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark - action

- (IBAction)answerAAction:(id)sender {
    _selectAnswer = 0;
    [self setAnswerBtnSelectState:answerABtnType];
    [self addUserAns:@"A"];
}

- (IBAction)answerBAction:(id)sender {
    _selectAnswer = 1;
    [self setAnswerBtnSelectState:answerBBtnType];
    [self addUserAns:@"B"];
}

- (IBAction)answerCAction:(id)sender {
    _selectAnswer = 2;
    [self setAnswerBtnSelectState:answerCBtnType];
    [self addUserAns:@"C"];
}

- (IBAction)shareAction:(id)sender {
    [Navigation showAnswerShareViewController:self title:self.lrViewModel.selectSpecModel.name webLink:kApiSuccessUrlHost];
}

- (void)popView{
//    if ([self.lrViewModel calculateAnswerNum] == -1) {//退出页面的时候更新状态
//        [self updateStatus];
//    }
    self.lrViewModel.isContinueAnswer = NO;
    
    NSArray * viewControllers = self.navigationController.viewControllers;
    UIViewController * answerlrVC = viewControllers[1];
    [self.navigationController popToViewController:answerlrVC animated:YES];
}

- (IBAction)popViewAction:(id)sender {
//    BOOL isContainDownVC = NO;
//    BOOL isContainLrVC = NO;
//    NSArray * viewControllers = self.navigationController.viewControllers;
//    for (UIViewController * vc in viewControllers) {
//        if ([vc isKindOfClass:[AnswerlrCountDownViewController class]]) {
//            isContainDownVC = YES;
//        }else if ([vc isKindOfClass:[AnswerlrViewController class]]){
//            isContainLrVC = YES;
//        }
//    }
    NSInteger answerNum = [self.lrViewModel calculateAnswerNum];
    if (answerNum == -1 || !self.lrViewModel.isContinueAnswer) {
        [self popView];
        return;
    }
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"警告" message:@"你正在答题，退出后就只能围观了哦！" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * okAction = [UIAlertAction actionWithTitle:@"确定退出" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
//        [self exitActivity];
        [self popView];
    }];
    
    UIAlertAction * cancleAction = [UIAlertAction actionWithTitle:@"继续答题" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alert addAction:okAction];
    [alert addAction:cancleAction];
    
    [self presentViewController:alert animated:YES completion:nil];
}


#pragma mark - 设置状态

- (void)setBtnState:(buttonState)state{
    self.countDownBtn.hidden = state==countDownBtnType?NO:YES;
    self.errorBtn.hidden = state==errorBtnType?NO:YES;
    self.rightBtn.hidden = state==rightBtnType?NO:YES;
    self.lookBtn.hidden = state==lookBtnType?NO:YES;
}

//设置选中状态
- (void)setAnswerBtnSelectState:(answerBtnState)state{
    UIColor * normalColor = UIColorFromHex(0xE7E4E7);//未选中颜色
    UIColor * selectColor = UIColorFromHex(0x4F4BE0);//选中颜色
    [self.answerABtn setBackgroundColor:state==answerABtnType?selectColor:normalColor];
    [self.anserBBtn setBackgroundColor:state==answerBBtnType?selectColor:normalColor];
    [self.anserCBtn setBackgroundColor:state==answerCBtnType?selectColor:normalColor];
    
    UIColor * whiteColor = [UIColor whiteColor];
    UIColor * blackColor = UIColorFromHex(0x515151);
    
    [self.answerABtn setTitleColor:state==answerABtnType?whiteColor:blackColor forState:UIControlStateNormal];
    [self.anserBBtn setTitleColor:state==answerBBtnType?whiteColor:blackColor forState:UIControlStateNormal];
    [self.anserCBtn setTitleColor:state==answerCBtnType?whiteColor:blackColor forState:UIControlStateNormal];
    
    [self setBtnStateEnable:NO];
}

//设置按钮是否可点击
- (void)setBtnStateEnable:(BOOL)isEnable{
    self.answerABtn.enabled = isEnable;
    self.anserBBtn.enabled = isEnable;
    self.anserCBtn.enabled = isEnable;
}
//设置按钮是否展示
- (void)setShowCountLabelHide:(BOOL)isHide{
    self.answerCountALabel.hidden = isHide;
    self.answerCountBLabel.hidden = isHide;
    self.answerCountCLabel.hidden = isHide;
}

//设置按钮颜色
- (void)setBtnBgColor:(selectStateColor)color button:(UIButton *)button{
    
    UIColor * whiteColor = [UIColor whiteColor];
    UIColor * blackColor = UIColorFromHex(0x515151);
    if (color == normalBgColor) {
        [button setTitleColor:blackColor forState:UIControlStateNormal];
    }else if(color == selectBgColor){
        [button setTitleColor:whiteColor forState:UIControlStateNormal];
    }else if (color == rightBgColor){
        [button setTitleColor:blackColor forState:UIControlStateNormal];
    }else if (color == errorBgColor){
        [button setTitleColor:blackColor forState:UIControlStateNormal];
    }
    [button setBackgroundColor:[UIColor clearColor]];
}

- (void)setProgressViewColor:(selectStateColor)color view:(AnswerProgressView *)view{
    UIColor * normalColor = UIColorFromHex(0xE7E4E7);//未选中颜色
    UIColor * selectColor = UIColorFromHex(0x4F4BE0);//选中颜色
    UIColor * rightColor = UIColorFromHex(0x54D6D6);//正确答案颜色
    UIColor * errorColor = UIColorFromHex(0xFE98BD);//错误答案颜色
    
    if (color == normalBgColor) {
        [view setProgressColor:normalColor];
    }else if(color == selectBgColor){
        [view setProgressColor:selectColor];
    }else if (color == rightBgColor){
        [view setProgressColor:rightColor];
    }else if (color == errorBgColor){
        [view setProgressColor:errorColor];
    }
}

#pragma mark  - setter
- (void)setLrViewModel:(AnswerlrViewModel *)lrViewModel{
    _lrViewModel = lrViewModel;
    _lrViewModel.processDelegate = self;
}

- (NSArray<AnswerProgressView *> *)progressViewArr{
    if (!_progressViewArr) {
        _progressViewArr = @[self.progressAView,self.progressBView,self.progressCView];
    }
    return _progressViewArr;
}

- (NSArray<UIButton *> *)answerBtnArr{
    if (!_answerBtnArr) {
        _answerBtnArr = @[self.answerABtn,self.anserBBtn,self.anserCBtn];
    }
    return _answerBtnArr;
}

- (GetAnsNumModel *)ansNumModel{
    if (!_ansNumModel) {
        _ansNumModel = [GetAnsNumModel new];
    }
    return _ansNumModel;
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
