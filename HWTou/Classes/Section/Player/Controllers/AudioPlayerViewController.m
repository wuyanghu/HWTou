//
//  AudioPlayerViewController.m
//  HWTou
//
//  Created by Reyna on 2017/11/16.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "AudioPlayerViewController.h"
#import "AudioPlayerHeaderView.h"
#import "PlayerNavBarView.h"
#import "RadioRequest.h"
#import "RadioSessionReq.h"
#import "PublicHeader.h"
#import "PlayerCommentViewModel.h"
#import "PlayerDetailViewModel.h"
#import "AudioPlayerInfoCell.h"
#import "AudioPlayerCommentCell.h"
#import "AudioPlayerFooterView.h"
#import "CollectSessionReq.h"
#import "RadioProgramViewController.h"
#import "BalloonFlyView.h"
#import "PlayerHistoryManager.h"
#import "MainTabBarPlayerBtn.h"
#import "SocialThirdController.h"
#import "PersonInfoCardView.h"
#import "PersonHomeReq.h"
#import "AudioPlayerView.h"
#import "PlayHighInfoViewModel.h"
#import "HighInfoViewController.h"
#import "HighInfoPlayInstance.h"
#import "IflyMscManager.h"
#import "ReplyInputView.h"
#import "ReplyVideoPlayerViewController.h"
#import "PYPhotoBrowser.h"
#import "SetRedPacketCardView.h"
#import "RedPacketRequest.h"
#import <Pingpp.h>
#import "GetRedPacketViewModel.h"
#import "GetRedPacketCardView.h"
#import "IPAddrTool.h"
#import "SetMoneySupCardView.h"
#import "RedPacketIsHaveTipView.h"

@interface AudioPlayerViewController () <PlayerNavBarDelegate, AudioPlayerCommentDelegate, PraiseChannelDelegate, AudioPlayerFooterViewDelegate, AudioPlayerHeaderViewDelegate, UITableViewDelegate, UITableViewDataSource, PersonInfoCardViewDelegate, ReplyInputViewDelegate, RedPacketCardViewDelegate, SetMoneySupCardViewDelegate, RedPacketIsHaveTipViewDelegate>
{
    NSTimer *_BMGTimer;
    NSInteger praiseAnimationInterval;
}
@property (nonatomic, strong) PlayerNavBarView *navBar;
@property (nonatomic, strong) UITableView *tableView;//列表视图
@property (nonatomic, strong) AudioPlayerHeaderView *headerView;//头部视图
@property (nonatomic, strong) UIView *replyBackView;//评论背景层
@property (nonatomic, strong) ReplyInputView *replyInputView;//评论输入视图

@property (nonatomic, strong) PlayerCommentViewModel *commentVM;
@property (nonatomic, strong) PlayerDetailViewModel *detailVM;

@property (nonatomic, strong) AudioPlayerView *audioPlayerView;
@property (nonatomic, strong) UIView *maskView;
@property (nonatomic, strong) UIButton *playBtn;
@property (nonatomic, strong) AudioPlayerFooterView * footerView;
@property (nonatomic, assign) NSInteger currentBMGIndex;
@property (nonatomic, strong) PersonInfoCardView *cardView;//用户信息卡片
@property (nonatomic, strong) RedPacketIsHaveTipView *redPacketTipView;//红包查询TipView

@property (nonatomic, assign) BOOL isDisplaySetRedOrSetMoneyUpCardView;//是否展示发红包或打赏View

@property (nonatomic,strong) HighInfoPlayInstance * playInstance;
@end

@implementation AudioPlayerViewController

#pragma mark - Api

- (void)reloadDataWithHistoryModel:(PlayerHistoryModel *)model {
    self.historyModel = model;
    
    [[PlayerHistoryManager sharedInstance] writeNewestPlayerHistoryModel:model];
    [self dataRequest];
}

#pragma mark - Life

- (instancetype)init {
    self = [super init];
    if (self) {
        praiseAnimationInterval = 15;
    }
    return self;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    NSArray * viewControllers = self.navigationController.viewControllers;
    if ([viewControllers.lastObject isKindOfClass:[AudioPlayerViewController class]]) {
        if (self.historyModel.flag == 3) {
            //    设为YES则保持常亮，不自动锁屏，默认为NO会自动锁屏
            [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
        }
        
        [[self class] cancelPreviousPerformRequestsWithTarget:self selector:@selector(praiseAnimation) object:nil];
        
        [self.detailVM stopTimer];
    }
    
    [self.redPacketTipView stopLookingForRedPacket];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[IQKeyboardManager sharedManager] setShouldResignOnTouchOutside:YES];
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    [self.footerView setIsCollected:_detailVM.isCollected];//成功之后刷新 收藏按钮
    if (self.historyModel.flag == 3) {
        //    设为YES则保持常亮，不自动锁屏，默认为NO会自动锁屏
        [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
    }else{
        [self.playInstance handleDelloc];
    }
    
    [self.redPacketTipView startLookingForRedPacket];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [[IQKeyboardManager sharedManager] setEnable:NO];
    //监听键盘的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrameNotify:) name:UIKeyboardWillChangeFrameNotification object:nil];
}
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [[IQKeyboardManager sharedManager] setEnable:YES];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navBar.delegate = self;
    
    [self closeChatPush];
    
    [[PlayerHistoryManager sharedInstance] writeNewestPlayerHistoryModel:self.historyModel];
    
    [self dataRequest];
    [self praiseAnimation];
}

- (void)dealloc{
    
}

#pragma mark - KeyboardNotify
//当键盘改变了frame(位置和尺寸)的时候调用
- (void)keyboardWillChangeFrameNotify:(NSNotification*)notify {
    
    if (_isDisplaySetRedOrSetMoneyUpCardView) {
        
        return;
    }
    // 键盘动画的时间
    CGFloat duration = [notify.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    // 取得键盘最后的frame
    CGRect keyboardFrame = [notify.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat finalY = keyboardFrame.origin.y;
    
    if (finalY == self.view.bounds.size.height) {
        [UIView animateWithDuration:duration animations:^{
            self.replyInputView.frame = CGRectMake(0, finalY - INPUT_DETAIL_HEIGHT, kMainScreenWidth, INPUT_DETAIL_HEIGHT);
        } completion:^(BOOL finished) {
        }];
    }
    else {
        [UIView animateWithDuration:duration animations:^{
                self.replyInputView.frame = CGRectMake(0, finalY - 204, kMainScreenWidth, INPUT_DETAIL_HEIGHT);
            } completion:^(BOOL finished) {
            }];
        
    }
}

#pragma mark - Request
//如果切换话题或广播，关闭聊吧推送
- (void)closeChatPush{
    PlayerHistoryModel *newestPHModel = [[PlayerHistoryManager sharedInstance] readNewestPlayerHistoryModel];
    if (newestPHModel.flag != 3) {//如果不是聊吧，不发送消息
        return;
    }
    
    RecordUserIsOnlineParam * onlineParam = [RecordUserIsOnlineParam new];
    onlineParam.userPhone = [[AccountManager shared] account].userName;
    onlineParam.chatId = [HighInfoPlayInstance sharedInstance].chatId;
    onlineParam.flag = 0;
    
    [RadioRequest recordUserIsOnline:onlineParam success:^(NSDictionary * dict) {
        
    } failure:^(NSError * error) {
        
    }];
}

- (void)getTopComsRequest{
    if (self.historyModel.flag == 3) {
        [self.playInstance setChatId:self.historyModel.rtcId];
        [self.playInstance externalTopComsRequest];
    }
}

- (void)lookRequest {
    
    if (self.historyModel.flag == 1) {
        [RadioRequest lookRadioWithChannelId:self.historyModel.rtcId radioId:self.detailVM.radioId success:^(NSDictionary *response) {
            
        } failure:^(NSError *error) {
            
        }];
    }
    else if (self.historyModel.flag == 2) {
        [RadioRequest lookTopicWithTopicId:self.historyModel.rtcId success:^(NSDictionary *response) {
            
        } failure:^(NSError *error) {
            
        }];
    }else if (self.historyModel.flag == 3){
        [RadioRequest lookChatWithChatId:self.historyModel.rtcId success:^(NSDictionary *response) {
            
        } failure:^(NSError *error) {
            
        }];
    }
}
//点赞动画
- (void)praiseAnimation {
    [[self class] cancelPreviousPerformRequestsWithTarget:self selector:@selector(praiseAnimation) object:nil];
    [self performSelector:@selector(praiseAnimation) withObject:nil afterDelay:praiseAnimationInterval];
    int nowPraiseNum = self.detailVM.praiseNum;//当前点赞数
//    NSLog(@"点赞15秒刷");
    
    if (self.historyModel.flag == 1) {
        [RadioRequest getChannelStateWithChannelId:self.historyModel.rtcId radioId:0 success:^(NSDictionary *response) {
            
            if ([[response objectForKey:@"status"] intValue] == 200) {
                [self.detailVM bindWithDic:response];
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
                AudioPlayerInfoCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
                if (cell) {
                    [cell refreshZanLab];
                }
                
                [self showPraiseAnimation:nowPraiseNum];
            }else{
                [HUDProgressTool showErrorWithText:[response objectForKey:@"msg"]];
            }
        } failure:^(NSError *error) {
            [HUDProgressTool showErrorWithText:ReqErrCode_Custom_ErrorInfo];
        }];
    }
    else if (self.historyModel.flag == 2) {
        [RadioRequest getTopicStateWithTopicId:self.historyModel.rtcId success:^(NSDictionary *response) {
            
            if ([[response objectForKey:@"status"] intValue] == 200) {
                [self.detailVM bindWithDic:response];
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
                AudioPlayerInfoCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
                if (cell) {
                    [cell refreshZanLab];
                }
                
                [self showPraiseAnimation:nowPraiseNum];
            }else{
                [HUDProgressTool showErrorWithText:[response objectForKey:@"msg"]];
            }
        } failure:^(NSError *error) {
            [HUDProgressTool showErrorWithText:ReqErrCode_Custom_ErrorInfo];
        }];
    }else if (self.historyModel.flag == 3){
        [RadioRequest getChatState:self.historyModel.rtcId success:^(NSDictionary *response) {
            if ([[response objectForKey:@"status"] intValue] == 200) {
                [self.detailVM bindWithDic:response];
                self.playInstance.highInfoVM.topComsParam.pagesize = self.detailVM.chatDefNum;
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
                AudioPlayerInfoCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
                if (cell) {
                    [cell refreshZanLab];
                }
                
                [self showPraiseAnimation:nowPraiseNum];
            }else{
                [HUDProgressTool showErrorWithText:[response objectForKey:@"msg"]];
            }
        } failure:^(NSError *error) {
            [HUDProgressTool showErrorWithText:ReqErrCode_Custom_ErrorInfo];
        }];
    }
}

- (void)showPraiseAnimation:(int)nowPraiseNum{
    if (nowPraiseNum == 0) {
        return ;
    }
    
    int praiseNumInter = self.detailVM.praiseNum-nowPraiseNum;
    
    int timeCount = 0;
    while (praiseNumInter != 0) {
        int num = arc4random()%praiseNumInter+1;
        NSLog(@"第%d秒刷了%d个赞",timeCount,num);
        if (timeCount>=praiseAnimationInterval) {
            num = praiseNumInter;
            [self performSelector:@selector(showPraiseCount:) withObject:@(num) afterDelay:timeCount];
            break;
        }
        [self performSelector:@selector(showPraiseCount:) withObject:@(num) afterDelay:timeCount];
        timeCount += 1;
        praiseNumInter = praiseNumInter-num;
    }
}

- (void)showPraiseCount:(NSNumber *)count{
    for (int i = 0;i<[count intValue];i++) {
        BalloonFlyView *vi = [[BalloonFlyView alloc] initWithFrame:CGRectZero];
        [vi showAnimationInView:self.headerView.headerIV];
    }
}


- (void)detailDataRequest {
    
    if (self.historyModel.flag == 1) {
        [RadioRequest getChannelStateWithChannelId:self.historyModel.rtcId radioId:0 success:^(NSDictionary *response) {
            
            if ([[response objectForKey:@"status"] intValue] == 200) {
                [self.detailVM bindWithDic:response];
                [self.tableView reloadData];
            }else{
                [HUDProgressTool showErrorWithText:[response objectForKey:@"msg"]];
            }
        } failure:^(NSError *error) {
            [HUDProgressTool showErrorWithText:ReqErrCode_Custom_ErrorInfo];
        }];
    }
    else if (self.historyModel.flag == 2) {
        [RadioRequest getTopicStateWithTopicId:self.historyModel.rtcId success:^(NSDictionary *response) {
            
            if ([[response objectForKey:@"status"] intValue] == 200) {
                [self.detailVM bindWithDic:response];
                [self.tableView reloadData];
                
            }else{
                [HUDProgressTool showErrorWithText:[response objectForKey:@"msg"]];
            }
        } failure:^(NSError *error) {
            [HUDProgressTool showErrorWithText:ReqErrCode_Custom_ErrorInfo];
        }];
    }else if (self.historyModel.flag == 3){
        [RadioRequest getChatState:self.historyModel.rtcId success:^(NSDictionary *response) {
            if ([[response objectForKey:@"status"] intValue] == 200) {
                [self.detailVM bindWithDic:response];
                self.playInstance.highInfoVM.topComsParam.pagesize = self.detailVM.chatDefNum;
                [self.tableView reloadData];
            }else{
                [HUDProgressTool showErrorWithText:[response objectForKey:@"msg"]];
            }
        } failure:^(NSError *error) {
            [HUDProgressTool showErrorWithText:ReqErrCode_Custom_ErrorInfo];
        }];
    }
}

- (void)dataRequest {
    
    if (self.historyModel.flag == 1) {
        [RadioRequest getChannelStateWithChannelId:(int)self.historyModel.rtcId radioId:0 success:^(NSDictionary *response) {
            
            if ([[response objectForKey:@"status"] intValue] == 200) {
                [self.detailVM bindWithDic:response];
                [self reloadDetailInfoViews];
                [self commentDataRequest:YES];
                [self lookRequest];
            }else{
                [HUDProgressTool showErrorWithText:[response objectForKey:@"msg"]];
            }
        } failure:^(NSError *error) {
            [HUDProgressTool showErrorWithText:ReqErrCode_Custom_ErrorInfo];
        }];
        
    }
    else if (self.historyModel.flag == 2) {
        
        [RadioRequest getTopicStateWithTopicId:self.historyModel.rtcId success:^(NSDictionary *response) {
            if ([[response objectForKey:@"status"] intValue] == 200) {
                [self.detailVM bindWithDic:response];
                [self reloadDetailInfoViews];
                [self commentDataRequest:YES];
                [self lookRequest];
            }else{
                [HUDProgressTool showErrorWithText:[response objectForKey:@"msg"]];
            }
        } failure:^(NSError *error) {
            [HUDProgressTool showErrorWithText:ReqErrCode_Custom_ErrorInfo];
        }];
        
    }else if (self.historyModel.flag == 3){
        
        [RadioRequest getChatState:self.historyModel.rtcId success:^(NSDictionary *response) {
            if ([[response objectForKey:@"status"] intValue] == 200) {
                [self.detailVM bindWithDic:response];
                self.playInstance.highInfoVM.topComsParam.pagesize = self.detailVM.chatDefNum;
                self.playInstance.chatMusicListArray = self.detailVM.chatMusicListArray;
                
                [self reloadDetailInfoViews];
                [self commentDataRequest:YES];
                [self lookRequest];
                
                [self getTopComsRequest];
            }else{
                [HUDProgressTool showErrorWithText:[response objectForKey:@"msg"]];
            }
        } failure:^(NSError *error) {
            [HUDProgressTool showErrorWithText:ReqErrCode_Custom_ErrorInfo];
        }];
        
    }
    
    [self.view addSubview:self.footerView];
    [self.footerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.left.equalTo(self.view);
        make.height.equalTo(50);
        make.bottom.equalTo(self.view);
    }];
    
}

- (void)commentDataRequest:(BOOL)isRefresh {
    
    if (isRefresh) {
        self.commentVM.page = 1;
        [self.tableView.mj_footer resetNoMoreData];
    }
    else {
        self.commentVM.page = self.commentVM.page + 1;
    }
    
    if (self.historyModel.flag == 1) {
        [RadioRequest getChannelCommentWithPage:self.commentVM.page pageSize:self.commentVM.pagesize channelId:self.historyModel.rtcId radioId:self.detailVM.radioId success:^(NSDictionary *response) {
            
            if ([[response objectForKey:@"status"] intValue] == 200) {
                [self.commentVM bindWithDic:response isRefresh:isRefresh];
                [self.tableView reloadData];
                
            }
            if (isRefresh) {
                [self.tableView.mj_header endRefreshing];
            }
            else {
                if (!_commentVM.isMoreData) {
                    [self.tableView.mj_footer endRefreshingWithNoMoreData];
                }
                else {
                    [self.tableView.mj_footer resetNoMoreData];
                }
            }
            
        } failure:^(NSError *error) {
            [HUDProgressTool showErrorWithText:ReqErrCode_Custom_ErrorInfo];
            if (isRefresh) {
                [self.tableView.mj_header endRefreshing];
            }
            else {
                if (!_commentVM.isMoreData) {
                    [self.tableView.mj_footer endRefreshingWithNoMoreData];
                }
                else {
                    [self.tableView.mj_footer resetNoMoreData];
                }
            }
        }];
    }
    else if (self.historyModel.flag == 2) {
        
        [RadioRequest getTopicCommentWithPage:self.commentVM.page pageSize:self.commentVM.pagesize topicId:self.historyModel.rtcId success:^(NSDictionary *response) {
            
            if ([[response objectForKey:@"status"] intValue] == 200) {
                [self.commentVM bindWithDic:response isRefresh:isRefresh];
                [self.tableView reloadData];
                
            }
            if (isRefresh) {
                [self.tableView.mj_header endRefreshing];
            }
            else {
                if (!_commentVM.isMoreData) {
                    [self.tableView.mj_footer endRefreshingWithNoMoreData];
                }
                else {
                    [self.tableView.mj_footer resetNoMoreData];
                }
            }
        } failure:^(NSError *error) {
            [HUDProgressTool showErrorWithText:ReqErrCode_Custom_ErrorInfo];
            if (isRefresh) {
                [self.tableView.mj_header endRefreshing];
            }
            else {
                if (!_commentVM.isMoreData) {
                    [self.tableView.mj_footer endRefreshingWithNoMoreData];
                }
                else {
                    [self.tableView.mj_footer resetNoMoreData];
                }
            }
        }];
    }
    else if (self.historyModel.flag == 3) {
        
        ChatCommentParam * chatParam = [ChatCommentParam new];
        chatParam.page = self.commentVM.page;
        chatParam.pagesize = self.commentVM.pagesize;
        chatParam.chatId = self.historyModel.rtcId;
        if (self.historyModel.isWorkChat) {
            chatParam.manager = @"chatManager";
        }else{
            chatParam.manager = @"0";
        }
        
        [RadioRequest getChatComment:chatParam success:^(NSDictionary *response) {
            
            if ([[response objectForKey:@"status"] intValue] == 200) {
                [self.commentVM bindWithDic:response isRefresh:isRefresh];
                [self.tableView reloadData];
                
            }
            if (isRefresh) {
                [self.tableView.mj_header endRefreshing];
            }
            else {
                if (!_commentVM.isMoreData) {
                    [self.tableView.mj_footer endRefreshingWithNoMoreData];
                }
                else {
                    [self.tableView.mj_footer resetNoMoreData];
                }
            }
        } failure:^(NSError *error) {
            [HUDProgressTool showErrorWithText:ReqErrCode_Custom_ErrorInfo];
            if (isRefresh) {
                [self.tableView.mj_header endRefreshing];
            }
            else {
                if (!_commentVM.isMoreData) {
                    [self.tableView.mj_footer endRefreshingWithNoMoreData];
                }
                else {
                    [self.tableView.mj_footer resetNoMoreData];
                }
            }
        }];
    }
}

- (void)attentionRequestWithUserId:(int)userId {
    
    FocusSomeOneParam * param = [FocusSomeOneParam new];
    param.focusId = [NSString stringWithFormat:@"%d",userId];
    [PersonHomeRequest focusSomeOne:param Success:^(TopicWorkDetailResponse *response) {
        if (response.status == 200) {
            NSInteger state = [response.data[@"state"] integerValue];
            [HUDProgressTool showSuccessWithText:state == 0?@"取消关注成功":@"关注成功"];
            
            [_cardView refreshWithState:state];
        }else{
            [HUDProgressTool showErrorWithText:response.msg];
        }
    } failure:^(NSError *error) {
        [HUDProgressTool showErrorWithText:ReqErrCode_Custom_ErrorInfo];
    }];
}

#pragma mark - UITableViewDataSource & Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 1) {
        return self.commentVM.dataArr.count;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        AudioPlayerInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:[AudioPlayerInfoCell cellReuseIdentifierInfo] forIndexPath:indexPath];
        BOOL isTopic = self.historyModel.flag == 2 ? YES : NO;
        [cell bind:self.detailVM isTopic:isTopic];
        cell.delegate = self;
        return cell;
    }
    AudioPlayerCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:[AudioPlayerCommentCell cellReuseIdentifierInfo] forIndexPath:indexPath];
    PlayerCommentModel *m = [self.commentVM.dataArr objectAtIndex:indexPath.row];
    [cell bind:m historyModel:self.historyModel];
    cell.delegate = self;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        return self.detailVM.infoCellHeight;
    }
    PlayerCommentModel *m = [self.commentVM.dataArr objectAtIndex:indexPath.row];
    return m.cellTotalHeight;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 10)];
    view.backgroundColor = UIColorFromHex(0xf3f4f6);
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    if (section == 0) {
        return 10.f;
    }
    return 0.01f;
}

#pragma mark - Sup

- (void)showUserInfoCardWithUserId:(int)userId {
    
    UserInfoParam * homeParam = [[UserInfoParam alloc] init];
    BOOL isSelf = NO;
    if ([AccountManager shared].account.uid == userId) {
        homeParam.uid = 0;
        isSelf = YES;
    }
    else {
        homeParam.uid = userId;
        isSelf = NO;
    }
    
    [HUDProgressTool showIndicatorWithText:@""];
    //个人资料
    [PersonHomeRequest getUserInfo:homeParam Success:^(PersonHomeResponse *response) {
        
        [HUDProgressTool dismiss];
        
        _cardView = [[PersonInfoCardView alloc] initWithUserModel:response.data isSelf:isSelf userId:userId];
        _cardView.delegate = self;
        [_cardView show];
        
    } failure:^(NSError *error) {
        [HUDProgressTool showErrorWithText:ReqErrCode_Custom_ErrorInfo];
    }];
}

- (void)reloadDetailInfoViews {
    
    [self.headerView bind:self.detailVM playing:self.historyModel.playing flag:self.historyModel.flag];
    
    if (self.detailVM.bmgsArr.count > 1) {
        _BMGTimer = [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(exchangeBMG) userInfo:nil repeats:YES];
    }
    
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
    
    if (self.historyModel.flag == 1 || self.historyModel.flag == 2) {
        if ([self.detailVM.playingUrl isEqualToString:@""]){
            self.audioPlayerView.hidden = YES;
        }else{
            self.audioPlayerView.hidden = NO;
        }
    }
    
    if ([self.detailVM.playingUrl isEqualToString:@""]) {
//        self.audioPlayerView.hidden = YES;
        if (self.historyModel.flag == 1) {
            [HUDProgressTool showOnlyText:@"找不到播放地址了 >.<"];
        }
    }
    else {
//        self.audioPlayerView.hidden = NO;
//        self.audioPlayer.urlPath = self.detailVM.playingUrl;
//        [self playBtn];
//
//        if (self.historyModel.isPause == NO) {
//            [self changeAudioSteamerState];
//        }
        [self.audioPlayerView setURLString:self.detailVM.playingUrl];
    }
    
    [self.footerView setIsCollected:self.detailVM.isCollected];
}

#pragma mark - HighInfoPlayInstance回调

- (void)highInfoRefreshHeaderView:(HistoryTopModel *)topModel{
    [self.headerView bindHighInfoView:topModel];
}

- (void)voiceReplyViewClick:(HistoryTopModel *)topModel{
    if (topModel.comUrl) {
        [self.audioPlayerView setURLString:topModel.comUrl];
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
    }
}

#pragma mark - AudioPlayerHeaderViewDelegate

- (void)programClick{
    RadioProgramViewController * programViewController = [[RadioProgramViewController alloc] init];
    programViewController.channelId = self.historyModel.rtcId;
    [self.navigationController pushViewController:programViewController animated:YES];
}

- (void)hignInfoClick{
    HighInfoViewController * highinfoVC = [[HighInfoViewController alloc] init];
    highinfoVC.chatId = self.historyModel.rtcId;
    highinfoVC.isWorkChat = self.historyModel.isWorkChat;
    highinfoVC.playInstance = self.playInstance;
    [self.navigationController pushViewController:highinfoVC animated:YES];
}

#pragma mark - PraiseChannelDelegate

- (void)contentImgBtnAction:(NSArray *)imgsArr index:(NSInteger)index {
    if (!IsArrEmpty(imgsArr)) {
        PYPhotoBrowseView *photoBroseView = [[PYPhotoBrowseView alloc] init];
        [photoBroseView setShowDuration:0.f];
        [photoBroseView setHiddenDuration:0.f];
        
        [photoBroseView setImagesURL:imgsArr];// 2.1 设置图片源URL(NSString)数组
        [photoBroseView setCurrentIndex:index];// 2.2 设置初始化图片下标（即当前点击第几张图片）
        [photoBroseView show];// 3.显示(浏览)
    }
}

- (void)imgBtnActionWithUserId:(int)userId {
    
    [self showUserInfoCardWithUserId:userId];
}

- (void)praiseChannelAction {
    
    if ([AccountManager isNeedLogin]) {
        [AccountManager showLoginView];
        return;
    }
    
    BalloonFlyView *vi = [[BalloonFlyView alloc] initWithFrame:CGRectZero];
    [vi showAnimationInView:self.headerView.headerIV];
    
    if (self.historyModel.flag == 1) {
        [RadioRequest goodActionForRadioWithChannelId:self.historyModel.rtcId success:^(NSDictionary *response) {
            if ([[response objectForKey:@"status"] intValue] == 200) {
                [self detailDataRequest];
                
            }else{
                [HUDProgressTool showErrorWithText:[response objectForKey:@"msg"]];
            }
        } failure:^(NSError *error) {
            [HUDProgressTool showErrorWithText:ReqErrCode_Custom_ErrorInfo];
        }];
    }
    else if (self.historyModel.flag == 2) {
        [RadioRequest praiseTopicWithTopicId:self.historyModel.rtcId success:^(NSDictionary *response) {
            if ([[response objectForKey:@"status"] intValue] == 200) {
                [self detailDataRequest];
                
            }else{
                [HUDProgressTool showErrorWithText:[response objectForKey:@"msg"]];
            }
        } failure:^(NSError *error) {
            [HUDProgressTool showErrorWithText:ReqErrCode_Custom_ErrorInfo];
        }];
    }else if (self.historyModel.flag == 3){
        [RadioRequest praiseChatWithChatId:self.historyModel.rtcId success:^(NSDictionary *response) {
            if ([[response objectForKey:@"status"] intValue] == 200) {
                [self detailDataRequest];
                
            }else{
                [HUDProgressTool showErrorWithText:[response objectForKey:@"msg"]];
            }
        } failure:^(NSError *error) {
            [HUDProgressTool showErrorWithText:ReqErrCode_Custom_ErrorInfo];
        }];
    }
}

#pragma mark - AudioPlayerCommentDelegate

- (void)moreBtnAction:(PlayerCommentModel *)model {
    
    [Navigation showSubCommentViewController:self model:model PlayerHistoryModel:self.historyModel playerDetailViewModel:self.detailVM];
}

- (void)replyBtnActionWithToUid:(PlayerCommentModel *)model{
    
    if ([AccountManager isNeedLogin]) {
        [AccountManager showLoginView];
        return;
    }
    
    [self.replyInputView setModel:model];
    self.replyBackView.hidden = NO;
    [self.replyInputView resignEditing:YES];
}

- (void)zanBtnActionWithCommentId:(int)commentId {

    if ([AccountManager isNeedLogin]) {
        [AccountManager showLoginView];
        return;
    }
    
    [RadioRequest praiseCommentWithCommentId:commentId success:^(NSDictionary *response) {
        if ([[response objectForKey:@"status"] intValue] == 200) {
            NSString * state = [[[response objectForKey:@"data"] objectForKey:@"state"] stringValue];
            NSDictionary * dict = @{@"0":@"取消点赞成功",@"1":@"点赞成功"};
            [HUDProgressTool showSuccessWithText:dict[state]];
            [self commentDataRequest:YES];
        }else{
            [HUDProgressTool showErrorWithText:[response objectForKey:@"msg"]];
        }
    } failure:^(NSError *error) {
        [HUDProgressTool showErrorWithText:ReqErrCode_Custom_ErrorInfo];
    }];
}

- (void)deleteBtnActionWithCommentId:(int)commentId {
    if (self.historyModel.flag == 1) {
        [RadioRequest deleteChannelCommentWithChannelId:self.historyModel.rtcId commentId:commentId radioId:0 success:^(NSDictionary *response) {
            
            if ([[response objectForKey:@"status"] intValue] == 200) {
                NSString * state = [NSString stringWithFormat:@"%@",[response objectForKey:@"data"]];
                [HUDProgressTool showSuccessWithText:state];
                [self commentDataRequest:YES];
                
            }else{
                [HUDProgressTool showErrorWithText:[response objectForKey:@"msg"]];
            }
        } failure:^(NSError *error) {
            [HUDProgressTool showErrorWithText:ReqErrCode_Custom_ErrorInfo];
        }];
    }
    else if (self.historyModel.flag == 2){
        [RadioRequest deleteTopicCommentWithTopicId:self.historyModel.rtcId commentId:commentId success:^(NSDictionary *response) {
            
            if ([[response objectForKey:@"status"] intValue] == 200) {
                NSString * state = [NSString stringWithFormat:@"%@",[response objectForKey:@"data"]];
                [HUDProgressTool showSuccessWithText:state];
                [self commentDataRequest:YES];
                
            }else{
                [HUDProgressTool showErrorWithText:[response objectForKey:@"msg"]];
            }
        } failure:^(NSError *error) {
            [HUDProgressTool showErrorWithText:ReqErrCode_Custom_ErrorInfo];
        }];
        
    }else if (self.historyModel.flag == 3){
        
        [RadioRequest delChatCommentWithChatId:self.historyModel.rtcId commentId:commentId success:^(NSDictionary *response) {
            
            if ([[response objectForKey:@"status"] intValue] == 200) {
                NSString * state = [NSString stringWithFormat:@"%@",[response objectForKey:@"data"]];
                [HUDProgressTool showSuccessWithText:state];
                [self commentDataRequest:YES];
                
            }else{
                [HUDProgressTool showErrorWithText:[response objectForKey:@"msg"]];
            }
        } failure:^(NSError *error) {
            [HUDProgressTool showErrorWithText:ReqErrCode_Custom_ErrorInfo];
        }];
    }
}

- (void)userInfoActionWithUserId:(int)userId {
    
    [self showUserInfoCardWithUserId:userId];
}

- (void)topBtnAction:(PlayerCommentModel *)model{
    TopComParam * topComParam = [TopComParam new];
    topComParam.chatId = self.historyModel.rtcId;
    topComParam.comId = model.parentCommentId;
    topComParam.comUid = model.parentUid;

    [RadioRequest setTopCom:topComParam success:^(NSDictionary * response){
        if ([[response objectForKey:@"status"] intValue] == 200){
            [self commentDataRequest:YES];
        }else{
            [HUDProgressTool showErrorWithText:[response objectForKey:@"msg"]];
        }
    } failure:^(NSError * error) {
        [HUDProgressTool showErrorWithText:ReqErrCode_Custom_ErrorInfo];
    }];
}

- (void)videoBtnAction:(NSString *)videoUrl {
    ReplyVideoPlayerViewController *vc = [[ReplyVideoPlayerViewController alloc] init];
    vc.player = [[AVPlayer alloc] initWithURL:[NSURL URLWithString:videoUrl]];
    [self presentViewController:vc animated:YES completion:^{
        [vc.player play];
        [[AudioPlayerView sharedInstance] pauseForPlayVoiceReply];
    }];
}

- (void)imgBtnAction:(NSArray *)imgsArr index:(NSInteger)index {
    if (!IsArrEmpty(imgsArr)) {
        PYPhotoBrowseView *photoBroseView = [[PYPhotoBrowseView alloc] init];
        [photoBroseView setShowDuration:0.f];
        [photoBroseView setHiddenDuration:0.f];
        
        [photoBroseView setImagesURL:imgsArr];// 2.1 设置图片源URL(NSString)数组
        [photoBroseView setCurrentIndex:index];// 2.2 设置初始化图片下标（即当前点击第几张图片）
        [photoBroseView show];// 3.显示(浏览)
    }
}

- (void)getRedPacketWithCommentModel:(PlayerCommentModel *)commentModel {
    
    if ([AccountManager isNeedLogin]) {
        [AccountManager showLoginView];
        return;
    }
    
    GetRedPacketCardView *view = [[GetRedPacketCardView alloc] initWithModel:commentModel rtcId:self.historyModel.rtcId];
    __weak typeof(self) weakSelf = self;
    view.refreshBlock = ^{
        [weakSelf commentDataRequest:YES];
        [weakSelf.redPacketTipView fireLookingForRedPacket];
    };
    [view show];
}

#pragma mark - RedPacketCardViewDelegate

- (void)setRedPacketActionWithTotalPirce:(int)totalPrice num:(int)num payType:(int)payType {
    
    [RedPacketRequest createRedEnvelopeWithText:@"恭喜发财，大吉大利" fromTo:0 redType:2 redMoney:totalPrice redNum:num rtcId:self.historyModel.rtcId flag:self.historyModel.flag success:^(NSDictionary *response) {
        if ([[response objectForKey:@"status"] intValue] == 200) {
            NSString *redRId = [[response objectForKey:@"data"] objectForKey:@"redRId"];
            
            NSString *ipAddr = [IPAddrTool getIPAddress:YES];
            
            if (payType == 1) {
                //支付宝支付
                
                [RedPacketRequest chargeRedMoneyWithRedRId:redRId chargeType:1 ip:ipAddr success:^(NSDictionary *response) {
                    
                    if ([[response objectForKey:@"status"] intValue] == 200) {
                        NSString *chargeId = [[response objectForKey:@"data"] objectForKey:@"chargeId"];
                        NSString *charge = [[response objectForKey:@"data"] objectForKey:@"charge"];
                        
                        AudioPlayerViewController *__weak weakSelf = self;
                        [Pingpp createPayment:charge
                               viewController:weakSelf
                                 appURLScheme:@"HWTou"
                               withCompletion:^(NSString *result, PingppError *error) {
                                   if ([result isEqualToString:@"success"]) {
                                       // 支付成功
                                       
                                       [RedPacketRequest sendRedEnvelopeWithRedRId:redRId chargeId:chargeId chargeType:1 success:^(NSDictionary *response) {
                                           
                                           if ([[response objectForKey:@"status"] intValue] == 200) {
                                               [self commentDataRequest:YES];
                                               [HUDProgressTool showSuccessWithText:@"发红包成功"];
                                           }
                                           else {
                                               [HUDProgressTool showErrorWithText:[response objectForKey:@"msg"]];
                                           }
                                       } failure:^(NSError *error) {
                                           [HUDProgressTool showErrorWithText:ReqErrCode_Custom_ErrorInfo];
                                       }];
                                       
                                   } else {
                                       // 支付失败或取消
                                       
                                       NSLog(@"Error: code=%lu msg=%@", error.code, [error getMsg]);
                                       //                                   [HUDProgressTool showSuccessWithText:@"支付失败或取消"];
                                   }
                               }];
                    }
                    else {
                        [HUDProgressTool showErrorWithText:[response objectForKey:@"msg"]];
                    }
                } failure:^(NSError *error) {
                    [HUDProgressTool showErrorWithText:ReqErrCode_Custom_ErrorInfo];
                }];
            }
            else if (payType == 0) {
                //余额支付
                
                [RedPacketRequest sendRedEnvelopeWithRedRId:redRId chargeId:@"" chargeType:0 success:^(NSDictionary *response) {
                    
                    if ([[response objectForKey:@"status"] intValue] == 200) {
                        [self commentDataRequest:YES];
                        [HUDProgressTool showSuccessWithText:@"发红包成功"];
                    }
                    else {
                        [HUDProgressTool showErrorWithText:[response objectForKey:@"msg"]];
                    }
                } failure:^(NSError *error) {
                    [HUDProgressTool showErrorWithText:ReqErrCode_Custom_ErrorInfo];
                }];
            }
        }
        else {
            [HUDProgressTool showErrorWithText:[response objectForKey:@"msg"]];
        }
        
    } failure:^(NSError *error) {
        [HUDProgressTool showErrorWithText:ReqErrCode_Custom_ErrorInfo];
    }];
}

#pragma mark - SetMoneySupCardViewDelegate

- (void)setMoneySupActionWithTotalPirce:(int)totalPrice payType:(int)payType {
    
    [RedPacketRequest createTipRTCWithRtcId:self.historyModel.rtcId rtcUid:[self.detailVM.createBy intValue] flag:self.historyModel.flag tipMoney:totalPrice success:^(NSDictionary *response) {
        if ([[response objectForKey:@"status"] intValue] == 200) {
            NSString *tipRId = [[response objectForKey:@"data"] objectForKey:@"tipRId"];
            
            NSString *ipAddr = [IPAddrTool getIPAddress:YES];
            
            if (payType == 1) {
                
                [RedPacketRequest chargeTipMoneyWithTipRId:tipRId chargeType:1 ip:ipAddr success:^(NSDictionary *response) {
                    
                    if ([[response objectForKey:@"status"] intValue] == 200) {
                        NSString *chargeId = [[response objectForKey:@"data"] objectForKey:@"chargeId"];
                        NSString *charge = [[response objectForKey:@"data"] objectForKey:@"charge"];
                        
                        AudioPlayerViewController *__weak weakSelf = self;
                        [Pingpp createPayment:charge
                               viewController:weakSelf
                                 appURLScheme:@"HWTou"
                               withCompletion:^(NSString *result, PingppError *error) {
                                   if ([result isEqualToString:@"success"]) {
                                       // 支付成功
                                       
                                       [RedPacketRequest sendTipRTCWithChargeId:chargeId tipRId:tipRId chargeType:1 success:^(NSDictionary *response) {
                                           
                                           if ([[response objectForKey:@"status"] intValue] == 200) {
                                               [HUDProgressTool showSuccessWithText:@"打赏成功"];
                                           }
                                           else {
                                               [HUDProgressTool showErrorWithText:[response objectForKey:@"msg"]];
                                           }
                                       } failure:^(NSError *error) {
                                           [HUDProgressTool showErrorWithText:ReqErrCode_Custom_ErrorInfo];
                                       }];
                                       
                                   } else {
                                       // 支付失败或取消
                                       
                                       NSLog(@"Error: code=%lu msg=%@", error.code, [error getMsg]);
                                       //                                   [HUDProgressTool showSuccessWithText:@"支付失败或取消"];
                                   }
                               }];
                    }
                    else {
                        [HUDProgressTool showErrorWithText:[response objectForKey:@"msg"]];
                    }
                    
                } failure:^(NSError *error) {
                    [HUDProgressTool showErrorWithText:ReqErrCode_Custom_ErrorInfo];
                }];
            }
            else if (payType == 0) {
                //余额支付，直接发送打赏
                
                [RedPacketRequest sendTipRTCWithChargeId:@"" tipRId:tipRId chargeType:0 success:^(NSDictionary *response) {
                    
                    if ([[response objectForKey:@"status"] intValue] == 200) {
                        [HUDProgressTool showSuccessWithText:@"打赏成功"];
                    }
                    else {
                        [HUDProgressTool showErrorWithText:[response objectForKey:@"msg"]];
                    }
                } failure:^(NSError *error) {
                    [HUDProgressTool showErrorWithText:ReqErrCode_Custom_ErrorInfo];
                }];
            }
        }
        else {
            [HUDProgressTool showErrorWithText:[response objectForKey:@"msg"]];
        }
        
    } failure:^(NSError *error) {
        [HUDProgressTool showErrorWithText:ReqErrCode_Custom_ErrorInfo];
    }];
}

#pragma mark - RedPacketIsHaveTipViewDelegate
- (void)tipBtnActionWithRedRId:(NSString *)redRId nickName:(NSString *)nickName avater:(NSString *)avater {
    
    if ([AccountManager isNeedLogin]) {
        [AccountManager showLoginView];
        return;
    }
    
    PlayerCommentModel *commentModel = [[PlayerCommentModel alloc] init];
    commentModel.avater = avater;
    commentModel.nickName = nickName;
    commentModel.commentText = redRId;
    commentModel.redState = 0;
    
    GetRedPacketCardView *view = [[GetRedPacketCardView alloc] initWithModel:commentModel rtcId:self.historyModel.rtcId];
    __weak typeof(self) weakSelf = self;
    view.refreshBlock = ^{
        [weakSelf commentDataRequest:YES];
        [weakSelf.redPacketTipView fireLookingForRedPacket];
    };
    [view show];
}

#pragma mark - AudioPlayerFooterViewDelegate

- (void)redPacketAction {

    SetRedPacketCardView *vi = [[SetRedPacketCardView alloc] init];
    vi.delegate = self;
    vi.dismissBlock = ^{
        _isDisplaySetRedOrSetMoneyUpCardView = NO;
    };
    [vi show];
    _isDisplaySetRedOrSetMoneyUpCardView = YES;
}

- (void)moneySupAction {
    
    SetMoneySupCardView *vi = [[SetMoneySupCardView alloc] initWithUserModel:self.detailVM];
    vi.delegate = self;
    vi.dismissBlock = ^{
        _isDisplaySetRedOrSetMoneyUpCardView = NO;
    };
    [vi show];
    _isDisplaySetRedOrSetMoneyUpCardView = YES;
}

- (void)userCollect {
    
    if (self.historyModel.flag == 1) {
        CollectChannelParam * param = [CollectChannelParam new];
        param.channelId = self.historyModel.rtcId;
        [CollectSessionReq getCollectChannel:param Success:^(CollectChannelResponse *response) {
            if (response.status == 200) {
                NSString * state = [response.data[@"state"] stringValue];
                NSDictionary * dict = @{@"0":@"取消收藏成功",@"1":@"收藏成功"};
                [HUDProgressTool showSuccessWithText:dict[state]];
                [self.footerView setIsCollected:[state intValue]];//成功之后刷新 收藏按钮
                _detailVM.isCollected = [state intValue];
            }else{
                [HUDProgressTool showErrorWithText:response.msg];
            }
        } failure:^(NSError *error) {
            [HUDProgressTool showErrorWithText:ReqErrCode_Custom_ErrorInfo];
        }];
    }else if (self.historyModel.flag == 2){
        CollectTopicParam * param = [CollectTopicParam new];
        param.topicId = self.historyModel.rtcId;
        [CollectSessionReq collectTopic:param Success:^(CollectChannelResponse *response) {
            if (response.status == 200) {
                NSString * state = [response.data[@"state"] stringValue];
                NSDictionary * dict = @{@"0":@"取消收藏成功",@"1":@"收藏成功"};
                [HUDProgressTool showSuccessWithText:dict[state]];
                [self.footerView setIsCollected:[state intValue]];//成功之后刷新 收藏按钮
                _detailVM.isCollected = [state intValue];
            }else{
                [HUDProgressTool showErrorWithText:response.msg];
            }
        } failure:^(NSError *error) {
            [HUDProgressTool showErrorWithText:ReqErrCode_Custom_ErrorInfo];
        }];
    }else if (self.historyModel.flag == 3){
        
        CollectChatParam * param = [CollectChatParam new];
        param.chatId = self.historyModel.rtcId;
        [CollectSessionReq collectChat:param Success:^(CollectChannelResponse *response) {
            if (response.status == 200) {
                NSString * state = [response.data[@"state"] stringValue];
                NSDictionary * dict = @{@"0":@"取消收藏成功",@"1":@"收藏成功"};
                [HUDProgressTool showSuccessWithText:dict[state]];
                [self.footerView setIsCollected:[state intValue]];//成功之后刷新 收藏按钮
                _detailVM.isCollected = [state intValue];
            }else{
                [HUDProgressTool showErrorWithText:response.msg];
            }
        } failure:^(NSError *error) {
            [HUDProgressTool showErrorWithText:ReqErrCode_Custom_ErrorInfo];
        }];
        
    }
}

- (void)showCommentText:(PlayerCommentModel *)playerCommentModel{
    if (playerCommentModel) {//回复
        [HUDProgressTool showSuccessWithText:@"回复成功"];
    }else{//评论
        [HUDProgressTool showSuccessWithText:@"评论成功"];
    }
}

- (void)userComment:(NSString *)conent playerCommentModel:(PlayerCommentModel *)playerCommentModel{
    
    if (self.historyModel.flag == 1) {
        [RadioSessionReq commentChannelWithChannelId:(int)self.historyModel.rtcId uid:self.detailVM.rtcId toUid:playerCommentModel.parentUid commentText:conent commentUrl:@"" location:@"" parentId:playerCommentModel.parentCommentId preCommentId:playerCommentModel.parentCommentId commentFlag:0 success:^(BaseResponse *response) {
            if (response.status == 200) {
                [self showCommentText:playerCommentModel];
                [self commentDataRequest:YES];
                [self.footerView commentFinish];
            }else{
                [HUDProgressTool showErrorWithText:response.msg];
            }
        } failure:^(NSError *error) {
            [HUDProgressTool showErrorWithText:ReqErrCode_Custom_ErrorInfo];
        }];
    }
    else if (self.historyModel.flag == 2) {
//        [[IflyMscManager sharedInstance] textToVoice:conent textToVoiceBlock:^(NSString *voiceUrl) {
//            NSLog(@"%@",voiceUrl);
//            [self.audioPlayerView setURLString:voiceUrl];
//        }];
//
//        NSString * toUrl = @"FayeVoice/FayeVoice.wav";
//        [[IflyMscManager sharedInstance] voiceToText:toUrl voiceToTextBlock:^(NSString *text) {
//            NSLog(@"%@",text);
//        }];
        [RadioSessionReq commentTopic:(int)self.historyModel.rtcId uid:[self.detailVM.createBy integerValue] toUid:playerCommentModel.parentUid commentText:conent commentUrl:@"" location:@"" parentId:playerCommentModel.parentCommentId preCommentId:playerCommentModel.parentCommentId commentFlag:0 success:^(BaseResponse *response) {
            if (response.status == 200) {
                [self showCommentText:playerCommentModel];
                [self commentDataRequest:YES];
                [self.footerView commentFinish];
            }else{
                [HUDProgressTool showErrorWithText:response.msg];
            }
        } failure:^(NSError *error) {
            [HUDProgressTool showErrorWithText:ReqErrCode_Custom_ErrorInfo];
        }];
    }else if (self.historyModel.flag == 3){

        [RadioSessionReq commentChat:self.historyModel.isWorkChat?1:0 chatId:(int)self.historyModel.rtcId uid:self.historyModel.rtcId toUid:playerCommentModel.parentUid commentText:conent commentUrl:@"" location:@"" parentId:playerCommentModel.parentCommentId preCommentId:playerCommentModel.parentCommentId commentFlag:0 success:^(BaseResponse *response) {
            if (response.status == 200) {
                [self showCommentText:playerCommentModel];
                [self commentDataRequest:YES];
                [self.footerView commentFinish];
            }else{
                [HUDProgressTool showErrorWithText:response.msg];
            }
        } failure:^(NSError *error) {
            [HUDProgressTool showErrorWithText:ReqErrCode_Custom_ErrorInfo];
        }];

    }
}

- (void)userCommentWithVoice:(NSString *)vidString playerCommentModel:(PlayerCommentModel *)playerCommentModel {
    
    double delayInSeconds = 2.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        if (self.historyModel.flag == 1) {
            [RadioSessionReq commentChannelWithChannelId:(int)self.historyModel.rtcId uid:self.detailVM.rtcId toUid:playerCommentModel.parentUid commentText:@"" commentUrl:vidString location:@"" parentId:playerCommentModel.parentCommentId preCommentId:playerCommentModel.parentCommentId commentFlag:1 success:^(BaseResponse *response) {
                if (response.status == 200) {
                    [self showCommentText:playerCommentModel];
                    [self commentDataRequest:YES];
                    [self.footerView commentFinish];
                }else{
                    [HUDProgressTool showErrorWithText:response.msg];
                }
            } failure:^(NSError *error) {
                [HUDProgressTool showErrorWithText:ReqErrCode_Custom_ErrorInfo];
            }];
        }
        else if (self.historyModel.flag == 2) {
            [RadioSessionReq commentTopic:(int)self.historyModel.rtcId uid:[self.detailVM.createBy integerValue] toUid:playerCommentModel.parentUid commentText:@"" commentUrl:vidString location:@"" parentId:playerCommentModel.parentCommentId preCommentId:playerCommentModel.parentCommentId commentFlag:1 success:^(BaseResponse *response) {
                if (response.status == 200) {
                    [self showCommentText:playerCommentModel];
                    [self commentDataRequest:YES];
                    [self.footerView commentFinish];
                }else{
                    [HUDProgressTool showErrorWithText:response.msg];
                }
            } failure:^(NSError *error) {
                [HUDProgressTool showErrorWithText:ReqErrCode_Custom_ErrorInfo];
            }];
        }
        else if (self.historyModel.flag == 3){
            
            [RadioSessionReq commentChat:self.historyModel.isWorkChat?1:0 chatId:(int)self.historyModel.rtcId uid:self.historyModel.rtcId toUid:playerCommentModel.parentUid commentText:@"" commentUrl:vidString location:@"" parentId:playerCommentModel.parentCommentId preCommentId:playerCommentModel.parentCommentId commentFlag:1 success:^(BaseResponse *response) {
                if (response.status == 200) {
                    [self showCommentText:playerCommentModel];
                    [self commentDataRequest:YES];
                    [self.footerView commentFinish];
                }else{
                    [HUDProgressTool showErrorWithText:response.msg];
                }
            } failure:^(NSError *error) {
                [HUDProgressTool showErrorWithText:ReqErrCode_Custom_ErrorInfo];
            }];
        }
    });
}

- (void)userSwithCommentType {
    
//    if ([AccountManager isNeedLogin]) {
//        [AccountManager showLoginView];
//        return;
//    }
    
    self.replyBackView.hidden = NO;
    [self.replyInputView resignEditing:YES];
}

#pragma mark - ReplyInputViewDelegate

- (void)cancelBtnAction {
    
    [UIView animateWithDuration:0.225 animations:^{
        self.replyInputView.frame = CGRectMake(0, kMainScreenHeight, kMainScreenWidth, INPUT_DETAIL_HEIGHT);
    } completion:^(BOOL finished) {
        self.replyBackView.hidden = YES;
    }];
}

- (void)publishBtnAction:(NSString *)conent location:(NSString *)locationStr data:(NSString *)data replyFlag:(int)replyFlag commentModel:(PlayerCommentModel *)playerCommentModel {
   
    if (self.historyModel.flag == 1) {
        [RadioSessionReq commentChannelWithChannelId:(int)self.historyModel.rtcId uid:self.detailVM.rtcId toUid:playerCommentModel.parentUid commentText:conent commentUrl:data location:locationStr parentId:playerCommentModel.parentCommentId preCommentId:playerCommentModel.parentCommentId commentFlag:replyFlag success:^(BaseResponse *response) {
            if (response.status == 200) {
                [self showCommentText:playerCommentModel];
                [self commentDataRequest:YES];
                [self.footerView commentFinish];
            }else{
                [HUDProgressTool showErrorWithText:response.msg];
            }
        } failure:^(NSError *error) {
            [HUDProgressTool showErrorWithText:ReqErrCode_Custom_ErrorInfo];
        }];
    }
    else if (self.historyModel.flag == 2) {
        [RadioSessionReq commentTopic:(int)self.historyModel.rtcId uid:[self.detailVM.createBy integerValue] toUid:playerCommentModel.parentUid commentText:conent commentUrl:data location:locationStr parentId:playerCommentModel.parentCommentId preCommentId:playerCommentModel.parentCommentId commentFlag:replyFlag success:^(BaseResponse *response) {
            if (response.status == 200) {
                [self showCommentText:playerCommentModel];
                [self commentDataRequest:YES];
                [self.footerView commentFinish];
            }else{
                [HUDProgressTool showErrorWithText:response.msg];
            }
        } failure:^(NSError *error) {
            [HUDProgressTool showErrorWithText:ReqErrCode_Custom_ErrorInfo];
        }];
    }else if (self.historyModel.flag == 3){
        
        [RadioSessionReq commentChat:self.historyModel.isWorkChat?1:0 chatId:(int)self.historyModel.rtcId uid:self.historyModel.rtcId toUid:playerCommentModel.parentUid commentText:conent commentUrl:data location:locationStr parentId:playerCommentModel.parentCommentId preCommentId:playerCommentModel.parentCommentId commentFlag:replyFlag success:^(BaseResponse *response) {
            if (response.status == 200) {
                [self showCommentText:playerCommentModel];
                [self commentDataRequest:YES];
                [self.footerView commentFinish];
            }else{
                [HUDProgressTool showErrorWithText:response.msg];
            }
        } failure:^(NSError *error) {
            [HUDProgressTool showErrorWithText:ReqErrCode_Custom_ErrorInfo];
        }];
    }
}

- (void)swithCommentTypeAction {
    
    [UIView animateWithDuration:0.225 animations:^{
        self.replyInputView.frame = CGRectMake(0, kMainScreenHeight, kMainScreenWidth, INPUT_DETAIL_HEIGHT);
    } completion:^(BOOL finished) {
        self.replyBackView.hidden = YES;
    }];
}

#pragma mark - NavBarDelegate

- (void)playerNavBackBtnAction {
    
    if (_BMGTimer) {
        [_BMGTimer invalidate];
        _BMGTimer = nil;
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)playerNavShareBtnAction {
    
    NSString *urlstring;
    if (self.historyModel.flag == 1) {
        urlstring = kApiRadioShareUrlHost;
    }else if (self.historyModel.flag == 2){
        urlstring = kApiTopicShareUrlHost;
    }else if(self.historyModel.flag == 3){
        urlstring = kApiChatdetailShareUrlHost;
    }
    
    NSInteger userUid = [AccountManager shared].account.uid;

    if (self.historyModel.flag == 1) {
        NSString *urlPath = [NSString stringWithFormat:@"?channelId=%d&radioId=0&token=manager&uid=%ld",self.historyModel.rtcId,userUid];
        urlstring = [urlstring stringByAppendingString:urlPath];
    }else if(self.historyModel.flag == 2) {
        NSString *urlPath = [NSString stringWithFormat:@"?topicId=%d&token=manager&uid=%ld",self.historyModel.rtcId,userUid];
        urlstring = [urlstring stringByAppendingString:urlPath];
    }else if (self.historyModel.flag == 3){
        NSString *urlPath = [NSString stringWithFormat:@"?chatId=%d&uid=%ld",self.historyModel.rtcId,userUid];
        urlstring = [urlstring stringByAppendingString:urlPath];
    }
    
    NSString *title = self.detailVM.title;
    NSString *content = self.historyModel.flag == 1 ? self.historyModel.playing : self.detailVM.content;
    if (content.length > 100) {
        content = [content substringToIndex:100];
    }
//    UIImage * thumbnail = self.headerView.headerIV.image == nil?[UIImage imageNamed:@"share_icon"]:self.headerView.headerIV.image;
    [SocialThirdController shareWebLink:urlstring title:title content:content thumbnail:[UIImage imageNamed:@"share_icon"] completed:^(BOOL success, NSString *errMsg) {
        if (success) {
            [HUDProgressTool showOnlyText:@"已分享"];
        } else {
            [HUDProgressTool showOnlyText:errMsg];
        }
    }];
}

#pragma mark - PersonInfoCardViewDelegate

- (void)mePageActionWithUserId:(int)userId isSelf:(BOOL)isSelf {
    [Navigation showPersonalHomePageViewController:self attendType:isSelf ? editDataButtonType : dynamicButtonType uid:userId];
}

- (void)attentionActionWithUserId:(int)userId isCancel:(BOOL)isCancel {
    
    if (isCancel) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"取消关注" message:@"确定要取消关注该用户？" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            [self attentionRequestWithUserId:userId];
        }];
        UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alert addAction:okAction];
        [alert addAction:cancleAction];
        [self presentViewController:alert animated:YES completion:^{
            
        }];
    }
    else {
        [self attentionRequestWithUserId:userId];
    }
}

#pragma mark - Timer

- (void)exchangeBMG {

    _currentBMGIndex = _currentBMGIndex + 1;
    NSURL *url = [NSURL URLWithString:[self.detailVM.bmgsArr objectAtIndex:_currentBMGIndex]];
    if (_currentBMGIndex >= self.detailVM.bmgsArr.count - 1) {
        _currentBMGIndex = -1;
    }
    [UIView transitionWithView:self.headerView.headerIV duration:1 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
        [self.headerView.headerIV sd_setImageWithURL:url];
    } completion:nil];
}

#pragma mark - Get

- (HighInfoPlayInstance *)playInstance{
    if (!_playInstance) {
        HighInfoPlayInstance * playInstance = [HighInfoPlayInstance sharedInstance];
        WeakObj(self);
        playInstance.highBlock = ^(HistoryTopModel *topModel) {
            [selfWeak highInfoRefreshHeaderView:topModel];
            [selfWeak voiceReplyViewClick:topModel];
        };
        
        playInstance.highRefreshViewBlock = ^(HistoryTopModel *topModel) {
            [selfWeak highInfoRefreshHeaderView:topModel];
        };
        
        [playInstance dataInit:self.historyModel.rtcId];
        
        _playInstance = playInstance;
    }
    return _playInstance;
}

- (PlayerNavBarView *)navBar {
    if (!_navBar) {
        _navBar = [[PlayerNavBarView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 64)];
        [self.view addSubview:_navBar];
    }
    return _navBar;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight-50) style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.tableHeaderView = [self headerView];
#ifdef __IPHONE_11_0
        if ([_tableView respondsToSelector:@selector(setContentInsetAdjustmentBehavior:)]) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
#endif
        [self.view addSubview:_tableView];
        [self.view bringSubviewToFront:self.redPacketTipView];
        [self.view bringSubviewToFront:self.navBar];
        [_tableView registerNib:[UINib nibWithNibName:@"AudioPlayerInfoCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:[AudioPlayerInfoCell cellReuseIdentifierInfo]];
        [_tableView registerNib:[UINib nibWithNibName:@"AudioPlayerCommentCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:[AudioPlayerCommentCell cellReuseIdentifierInfo]];
        
        __weak typeof(self) weakSelf = self;
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [weakSelf commentDataRequest:YES];
        }];
        _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            [weakSelf commentDataRequest:NO];
        }];
    }
    return _tableView;
}

- (AudioPlayerHeaderView *)headerView {
    if (!_headerView) {
        _headerView = [[AudioPlayerHeaderView alloc] initWithFrame:CGRectZero progressBarHidden:self.historyModel.flag == 2 ? NO : YES];
        _headerView.headerViewDelegate = self;
        [_headerView addSubview:self.audioPlayerView];
    }
    return _headerView;
}

- (AudioPlayerFooterView *)footerView{
    if (!_footerView) {
        if (self.historyModel.flag == 2) {
            _footerView = [[AudioPlayerFooterView alloc] initWithIsHaveMoneySup:YES];
        }
        else {
            _footerView = [[AudioPlayerFooterView alloc] initWithIsHaveMoneySup:NO];
        }
        _footerView.footerViewDelegate = self;
    }
    return _footerView;
}

- (PlayerCommentViewModel *)commentVM {
    if (!_commentVM) {
        _commentVM = [[PlayerCommentViewModel alloc] init];
        _commentVM.page = 1;
        _commentVM.pagesize = 10;
    }
    return _commentVM;
}

- (PlayerDetailViewModel *)detailVM {
    if (!_detailVM) {
        _detailVM = [[PlayerDetailViewModel alloc] init];
    }
    return _detailVM;
}

- (AudioPlayerView *)audioPlayerView {
    if (!_audioPlayerView) {
        _audioPlayerView = [AudioPlayerView sharedInstance];
        _audioPlayerView.isNeedSeekToZero = self.historyModel.flag == 3 ? NO : YES;
        _audioPlayerView.isDisplayProgressBar = self.historyModel.flag == 2 ? YES : NO;
    }
    return _audioPlayerView;
}

- (UIView *)replyBackView {
    if (!_replyBackView) {
        _replyBackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight)];
        _replyBackView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
        [self.view addSubview:_replyBackView];
    }
    return _replyBackView;
}

- (ReplyInputView *)replyInputView {
    if (!_replyInputView) {
        _replyInputView = [[ReplyInputView alloc] initWithFrame:CGRectMake(0, kMainScreenHeight, kMainScreenWidth, INPUT_DETAIL_HEIGHT)];
        [_replyInputView setModel:nil];
        _replyInputView.replyInputViewDelegate = self;
        [self.replyBackView addSubview:_replyInputView];
    }
    return _replyInputView;
}

- (RedPacketIsHaveTipView *)redPacketTipView {
    if (!_redPacketTipView) {
        _redPacketTipView = [[RedPacketIsHaveTipView alloc] initWithFrame:CGRectMake(kMainScreenWidth - 112, kMainScreenHeight - 49 - 159, 112, 159)];
        _redPacketTipView.delegate = self;
        [self.view addSubview:_redPacketTipView];
        [self.view bringSubviewToFront:_redPacketTipView];
        [_redPacketTipView setRtcId:self.historyModel.rtcId];
    }
    return _redPacketTipView;
}

#pragma mark -

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

