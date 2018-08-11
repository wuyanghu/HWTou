//
//  NTESAudienceLiveViewController.m
//  NIM
//
//  Created by chris on 15/12/16.
//  Copyright © 2015年 Netease. All rights reserved.
//

#import "NTESAudienceLiveViewController.h"
#import "UIImage+NTESColor.h"
#import "UIView+NTES.h"
#import "NSString+NTES.h"
#import "SVProgressHUD.h"
#import "UIView+Toast.h"
#import "NTESLiveManager.h"
#import "NTESDemoLiveroomTask.h"
#import "NSDictionary+NTESJson.h"
#import "UIAlertView+NTESBlock.h"
#import "NTESDemoService.h"
#import "NTESSessionMsgConverter.h"
#import "NTESLiveInnerView.h"
#import "NTESPresentShopView.h"
#import "NTESAudienceConnectView.h"
#import "NTESInteractSelectView.h"
#import "NTESPresentAttachment.h"
#import "NTESLikeAttachment.h"
#import "NTESLiveViewDefine.h"
#import "NTESMicConnector.h"
#import "NTESMicAttachment.h"
#import "NTESLiveAudienceHandler.h"
#import "NTESTimerHolder.h"
#import "NTESDevice.h"
#import "NTESUserUtil.h"
#import "NTESLiveUtil.h"
#import "NTESAudiencePresentViewController.h"
#import "NTESFiterMenuView.h"
#import "SaveRoomInfoModel.h"
#import "RotRequest.h"
#import "AccountManager.h"
#import "NTESCustomKeyDefine.h"
#import "NTESMessageModel.h"
#import "MuteRequest.h"
#import "GetChatInfoModel.h"
#import "SetRedPacketCardView.h"
#import "SetMoneySupCardView.h"
#import "RedPacketRequest.h"
#import "IPAddrTool.h"
#import "HUDProgressTool.h"
#import "NetWorkRequestMacro.h"
#import <Pingpp.h>

#import "NTESAnchorOnlineAttachment.h"
#import "NoticeViewController.h"
#import "IQKeyboardManager.h"
#import "RewardViewController.h"
#import "AudioPlayerView.h"
#import "BgMusicModel.h"
#import "IQKeyboardManager.h"
#import "NTESAnchorGiveARewardAttachment.h"
#import "RadioRequest.h"
#import "DiscloseawardView.h"
#import "NTESAnchorDiscloseAttachment.h"
#import "NTESDataManager.h"
#import "AudienceDiscloseawardView.h"

typedef void(^NTESDisconnectAckHandler)(NSError *);
typedef void(^NTESAgreeMicHandler)(NSError *);

@interface NTESAudienceLiveViewController ()<NIMChatroomManagerDelegate,NTESLiveInnerViewDelegate,
NIMChatManagerDelegate,NIMSystemNotificationManagerDelegate,NIMNetCallManagerDelegate,NTESLiveInnerViewDataSource,
NTESPresentShopViewDelegate,NTESInteractSelectDelegate,NTESAudienceConnectDelegate,NTESLiveAudienceHandlerDelegate,NTESLiveAudienceHandlerDatasource,NTESMenuViewProtocol,RedPacketCardViewDelegate,SetMoneySupCardViewDelegate,WMPlayerDelegate,DiscloseawardViewDelegate>
{
    NSTimeInterval _lastPressLikeTimeInterval;
    NIMNetCallCamera _cameraType;
    NSString *_chatroomId;
}

@property (nonatomic, assign) BOOL isPlaying;

@property (nonatomic, strong) UIView *canvas;

@property (nonatomic, strong) NTESAudienceConnectView *connectingView;

@property (nonatomic, strong) NTESLiveInnerView *innerView;
@property (nonatomic, strong) DiscloseawardView * discloseawardView;
@property (nonatomic, strong) AudienceDiscloseawardView * audienceDiscloseawardView;

@property (nonatomic, strong) NTESLiveAudienceHandler *handler;

@property (nonatomic, copy) NSString *streamUrl;

@property (nonatomic, strong) SaveRoomInfoModel * saveRoomInfoModel;
@property (nonatomic, strong) GetChatInfoModel * chatInfoModel;

@property (nonatomic, assign) BOOL isDisplaySetRedOrSetMoneyUpCardView;//是否展示发红包或打赏View
@property (nonatomic,strong) AudioPlayerView * audioPlayerView;
@property (nonatomic,strong) NSMutableArray * bgMusicArray;
@property (nonatomic,assign) NSInteger currentPlayRow;
@end

@implementation NTESAudienceLiveViewController

NTES_USE_CLEAR_BAR
NTES_FORBID_INTERACTIVE_POP

- (instancetype)initWithChatroomId:(NSString *)chatroomId streamUrl:(NSString *)url roomInfoModel:(SaveRoomInfoModel *) roomInfoModel chatInfoModel:(GetChatInfoModel *) chatInfoModel{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        _chatroomId = chatroomId;
        _streamUrl = url;
        _saveRoomInfoModel = roomInfoModel;
        _chatInfoModel = chatInfoModel;
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    return self;
}

- (void)dealloc{
    [[NIMSDK sharedSDK].chatroomManager removeDelegate:self];
    [[NIMSDK sharedSDK].chatManager removeDelegate:self];
    [UIApplication sharedApplication].idleTimerDisabled = NO;
    [[NTESLiveManager sharedInstance] stop];
    if (self.handler.isWaitingForAgreeConnect) {
        [self onCancelConnect:nil];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [[IQKeyboardManager sharedManager] setEnable:NO];
    
    [self setUp];
    
    DDLogInfo(@"enter live room , room id %@:, current user: %@",_chatroomId,[[NIMSDK sharedSDK].loginManager currentAccount]);
    
    if (_streamUrl) {
        [self startPlay:self.streamUrl inView:self.canvas];
        
        //先切到等待界面
//        [self.innerView switchToWaitingUI];
    }
    
    //进入聊天室
    [self enterChatroom];
    [self getChatMusicList];
    
    [RadioRequest lookChatWithChatId:_rtcId success:^(NSDictionary * dict) {
        
    } failure:^(NSError * error) {
        
    }];
}

- (BOOL)prefersStatusBarHidden{
    return YES;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.view addSubview:self.innerView];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent
                                                animated:NO];
    [self.innerView.redPacketTipView startLookingForRedPacket];
    if (!self.navigationController.navigationBarHidden) {
        [self.navigationController setNavigationBarHidden:YES animated:YES];
    }
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault
                                                animated:NO];
    [self.innerView.redPacketTipView stopLookingForRedPacket];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
//    [self.view endEditing:YES];
}

#pragma mark - NIMChatManagerDelegate
- (void)willSendMessage:(NIMMessage *)message
{
    switch (message.messageType) {
        case NIMMessageTypeText:
        case NIMMessageTypeImage:
            [self.innerView addMessages:@[message]];
            break;
        case NIMMessageTypeCustom:
        {
            NIMCustomObject *object = message.messageObject;
            id<NIMCustomAttachment> attachment = object.attachment;
            if ([attachment isKindOfClass:[NTESPresentAttachment class]]) {
                [self.innerView addPresentMessages:@[message]];
            }
        }
            break;
        default:
            break;
    }
}

- (void)onRecvMessages:(NSArray *)messages
{
    for (NIMMessage *message in messages) {
        if (![message.session.sessionId isEqualToString:_chatroomId]
            && message.session.sessionType == NIMSessionTypeChatroom) {
            //不属于这个聊天室的消息
            return;
        }
        switch (message.messageType) {
            case NIMMessageTypeText:
            case NIMMessageTypeImage:
            case NIMMessageTypeAudio:
            case NIMMessageTypeVideo:
            case NIMMessageTypeLocation:
                [self.innerView addMessages:@[message]];
                break;
            case NIMMessageTypeCustom:
            {
                NIMCustomObject *object = message.messageObject;
                id<NIMCustomAttachment> attachment = object.attachment;
                if ([attachment isKindOfClass:[NTESPresentAttachment class]]) {
                    [self.innerView addPresentMessages:@[message]];
                }
                else if ([attachment isKindOfClass:[NTESLikeAttachment class]]) {
                    [self.innerView fireLike];
                }
                else if ([attachment isKindOfClass:[NTESMicConnectedAttachment class]] || [attachment isKindOfClass:[NTESDisConnectedAttachment class]]) {
                    [self.handler dealWithBypassMessage:message];
                }else if ([attachment isKindOfClass:[NTESAnchorOnlineAttachment class]]){
                    [self didStartLive];
                }else if ([attachment isKindOfClass:[NTESAnchorGiveARewardAttachment class]]){
                    NTESAnchorGiveARewardAttachment * giveAttachment = object.attachment;
                    NSLog(@"打赏 %@",giveAttachment.money);
                    [self requestOnline];
                }else if ([attachment isKindOfClass:[NTESAnchorDiscloseAttachment class]]){
                    NTESAnchorDiscloseAttachment * giveAttachment = object.attachment;
                    [self.audienceDiscloseawardView show:giveAttachment];
                }
            }
                break;
            case NIMMessageTypeNotification:{
                [self.handler dealWithNotificationMessage:message];
            }
                break;
            default:
                break;
        }
    }
}

#pragma mark - NIMSystemNotificationManagerDelegate
- (void)onReceiveCustomSystemNotification:(NIMCustomSystemNotification *)notification
{
    NSString *content  = notification.content;
    NSDictionary *dict = [content jsonObject];
    NTESLiveCustomNotificationType type = [dict jsonInteger:@"command"];
    switch (type) {
        case NTESLiveCustomNotificationTypeAgreeConnectMic:
        case NTESLiveCustomNotificationTypeForceDisconnect:
            [self.handler dealWithBypassCustomNotification:notification];
            break;
        default:
            break;
    }
}

#pragma mark - NIMNetCallManagerDelegate
- (void)onUserJoined:(NSString *)uid
             meeting:(NIMNetCallMeeting *)meeting
{
    DDLogInfo(@"on user joined uid %@",uid);
}

- (void)onUserLeft:(NSString *)uid
           meeting:(NIMNetCallMeeting *)meeting
{
    DDLogInfo(@"on user left %@",uid);
    DDLogInfo(@"current on mic user is %@",[NTESLiveManager sharedInstance].connectorOnMic.uid);
    //如果是遇到主播退出了的情况，则自己默默退出去
//    [self.view makeToast:@"连接已断开" duration:2.0 position:CSToastPositionCenter];
    [[NIMAVChatSDK sharedSDK].netCallManager leaveMeeting:self.handler.currentMeeting];
    [NTESLiveManager sharedInstance].connectorOnMic = nil;
    [self stopLive];
}

- (void)onMeetingError:(NSError *)error
               meeting:(NIMNetCallMeeting *)meeting
{
    DDLogError(@"on meeting error: %zd",error);
    [self.view.window makeToast:[NSString stringWithFormat:@"互动直播失败 code: %zd",error.code] duration:2.0 position:CSToastPositionCenter];
    [NTESLiveManager sharedInstance].connectorOnMic = nil;
    
    [self.innerView switchToPlayingUI];
    [self requestPlayStream];
}

- (void)onRemoteYUVReady:(NSData *)yuvData
                   width:(NSUInteger)width
                  height:(NSUInteger)height
                    from:(NSString *)user
{
    [self.innerView updateRemoteView:yuvData width:width height:height];
}

- (void)onCameraTypeSwitchCompleted:(NIMNetCallCamera)cameraType
{
    
}


#pragma mark - NTESLiveAudienceHandlerDelegate
- (void)didUpdateUserOnMic
{
    if(![[NTESLiveManager sharedInstance].connectorOnMic.uid isEqualToString:[[NIMSDK sharedSDK].loginManager currentAccount]]
       && self.player.playbackState == NELPMoviePlaybackStatePlaying)
    {
        //即普通连麦观众,并且是正在推拉流的状态,则整个UI更新一把
        [self.innerView switchToPlayingUI];
    }
    else
    {
        //其他情况下更新名字就可以了
        [self.innerView updateUserOnMic];
    }
}

- (void)willStartByPassing:(NTESPlayerShutdownCompletion)completion
{
    DDLogInfo(@"will start by passing");
    [self.player.view removeFromSuperview];
    [self shutdown:^{
        completion();
    }];
    [UIApplication sharedApplication].idleTimerDisabled = YES;
}

- (void)joinMeetingError:(NSError *)error
{
    DDLogInfo(@"join meeting error %zd",error.code);
    [self.view makeToast:[NSString stringWithFormat:@"与主播连麦失败, code: %zd",error.code]];
    [self didStopByPassing];
}

- (void)didStartByPassing
{
    DDLogInfo(@"did start by passing");
    NTESMicConnector *connector = [NTESMicConnector me:_chatroomId];
    [self.innerView switchToBypassingUI:connector];
    [self.connectingView dismiss];
    self.connectingView = nil;
    self.isPlaying = NO;
}

- (void)didStopByPassing
{
    DDLogInfo(@"did stop by passing");
    [NTESLiveManager sharedInstance].connectorOnMic = nil;
    [self.innerView switchToPlayingUI];
    [self requestPlayStream];
}

- (void)didUpdateLiveType:(NTESLiveType)type
{
    //说明主播重新进来了，这种情况下，刷下type就好了。
    DDLogInfo(@"on receive anchor update live type notification: %zd",type);
    [NTESLiveManager sharedInstance].type = type;
    if (type == NTESLiveTypeInvalid) {
        //发出全局播放结束通知
        [self shutdown:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:NTESLivePlayerPlaybackFinishedNotification object:nil userInfo:@{NELivePlayerPlaybackDidFinishReasonUserInfoKey:@(NELPMovieFinishReasonPlaybackEnded)}];
    }
}

- (void)didUpdateMute:(NTESLiveMuteType)type{
    [self.innerView updateMuteView:type];
}

- (void)didStopLive:(NSString *)userId{
    
    if ([userId isEqualToString:[NSString stringWithFormat:@"%ld",_saveRoomInfoModel.userId]]) {
        [self.view makeToast:@"直播已经结束" duration:2.0 position:CSToastPositionCenter];
        [self stopLive];
    }
}

- (void)didStartLive{
    self.innerView.isLive = YES;
    [self requestPlayStream];
    [self.audioPlayerView pause];
}

- (void)stopLive{
    
    [self.player stop];
    self.isPlaying = NO;
    self.innerView.isLive = NO;
    _streamUrl = nil;
    [self.innerView switchToPlayingUI];
    [self.audioPlayerView play];
}

-(void)didUpdateLiveOrientation:(NIMVideoOrientation)orientation
{
    //旋转controller
    if ( [NTESLiveManager sharedInstance].orientation != orientation)
    {
        NTESAudiencePresentViewController *vc = [[NTESAudiencePresentViewController alloc]init];
        [NTESLiveManager sharedInstance].orientation = orientation;
        
        //需要清掉界面，防止界面异常
        if (self.connectingView) {
            [self.connectingView dismiss];
            self.connectingView = nil;
        }

        [self presentViewController:vc animated:NO completion:^{
            dispatch_after(0, dispatch_get_main_queue(), ^{
                [vc dismissViewControllerAnimated:NO completion:nil];
            });

        }];

    }
    
}

#pragma mark - NTESPresentShopViewDelegate
- (void)didSelectPresent:(NTESPresent *)present
{
    NIMMessage *message = [NTESSessionMsgConverter msgWithPresent:present];
    NIMSession *session = [NIMSession session:_chatroomId type:NIMSessionTypeChatroom];
    [[NIMSDK sharedSDK].chatManager sendMessage:message toSession:session error:nil];
}

#pragma mark - NIMChatroomManagerDelegate
- (void)chatroom:(NSString *)roomId beKicked:(NIMChatroomKickReason)reason
{
    if ([roomId isEqualToString:_chatroomId]) {
        NSString *toast = [NSString stringWithFormat:@"你被踢出聊天室"];
        DDLogInfo(@"chatroom be kicked, roomId:%@  rease:%zd",roomId,reason);
        [[NIMSDK sharedSDK].chatroomManager exitChatroom:roomId completion:nil];
        [self.view.window makeToast:toast duration:2.0 position:CSToastPositionCenter];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)chatroom:(NSString *)roomId connectionStateChanged:(NIMChatroomConnectionState)state;
{
    DDLogInfo(@"chatroom connection state changed roomId : %@  state:%zd",roomId,state);
    if (state == NIMChatroomConnectionStateEnterOK) {
        //获取连麦队列状态
        [self requestMicQueue];
    }
}

#pragma mark - Private

- (void)addSystem:(NSString *)text{
    NIMMessage *message = [NTESSessionMsgConverter msgWithText:text];
    [self willSendMessage:message];
}

//是否有直播
- (BOOL)isLive{
    return _streamUrl != nil?YES:NO;
}

- (void)setUp
{
    [UIApplication sharedApplication].idleTimerDisabled = YES;
    self.view.backgroundColor = UIColorFromRGB(0xdfe2e6);
    [self.view addSubview:self.canvas];
    [[NIMSDK sharedSDK].chatroomManager addDelegate:self];
    [[NIMSDK sharedSDK].chatManager addDelegate:self];
    [[NIMSDK sharedSDK].systemNotificationManager addDelegate:self];
    [[NIMAVChatSDK sharedSDK].netCallManager addDelegate:self];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playerDidPlay:) name:NTESLivePlayerFirstVideoDisplayedNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playerDidPlay:) name:NTESLivePlayerFirstAudioDisplayedNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playbackFinshed:) name:NTESLivePlayerPlaybackFinishedNotification object:nil];
}

- (void)changeKeyBoardHeight
{
    UIWindow *keyboardWindow = nil;
    for (UIWindow *testWindow in [[UIApplication sharedApplication] windows]) {
        if(![[testWindow class] isEqual:[UIWindow class]]) {
            keyboardWindow = testWindow;
            break;
        }
    }
    
    for (__strong UIView *possibleKeyboard in [keyboardWindow subviews]) {
        if ([possibleKeyboard isKindOfClass:NSClassFromString(@"UIInputSetContainerView")]) {
            for (__strong UIView *possibleKeyboardSubview in [possibleKeyboard subviews]) {
                if ([possibleKeyboardSubview isKindOfClass:NSClassFromString(@"UIInputSetHostView")]) {
                    possibleKeyboardSubview.ntesHeight = 0;
                }
            }
        }
    }
}

- (void)enterChatroom
{
    __weak typeof(self) wself = self;
    NIMChatroomEnterRequest *request = [[NIMChatroomEnterRequest alloc] init];
    request.roomId = _chatroomId;
    [[NIMSDK sharedSDK].chatroomManager enterChatroom:request completion:^(NSError * _Nullable error, NIMChatroom * _Nullable chatroom, NIMChatroomMember * _Nullable me) {
        if (!error) {
            [[NTESLiveManager sharedInstance] cacheMyInfo:me roomId:request.roomId];
            [[NTESLiveManager sharedInstance] cacheChatroom:chatroom];

            wself.handler = [[NTESLiveAudienceHandler alloc] initWithChatroom:chatroom roomInfoModel:_saveRoomInfoModel];
            wself.handler.delegate = self;
            wself.handler.datasource = self;
            [wself.innerView refreshChatroom:chatroom isMuteUser:_chatInfoModel.isMuteUser];
            [wself.innerView switchToPlayingUI];
            
            [wself addSystem:_chatInfoModel.chatContent];
        }
        else
        {
            DDLogError(@"enter chat room error, code : %zd, room id : %@",error.code,request.roomId);
            [wself.view makeToast:@"直播间进入失败，请确认ID是否正确" duration:2.0 position:CSToastPositionCenter];
        }
    }];
}

#pragma mark - 背景音乐操作

- (void)playNextBgMusic{
    _currentPlayRow = (_currentPlayRow+1)%self.bgMusicArray.count;
    [self playCurrentMusic];
}

- (void)playCurrentMusic{
    BgMusicModel * bgMusicModel = self.bgMusicArray[_currentPlayRow];
    if ([bgMusicModel.mUrl isEqualToString:self.audioPlayerView.URLString]) {
        [self.audioPlayerView play];
    }else{
        [self.audioPlayerView setURLString:bgMusicModel.mUrl];
    }
    
}

#pragma mark - 网络请求

- (void)getChatMusicList{
    
    [RotRequest getChatMusicList:_rtcId Success:^(ArrayResponse *response) {
        if (response.status == 200) {
            NSArray * array = response.data;
            for (int i = 0; i<array.count; i++) {
                BgMusicModel * bgMusicModel = [BgMusicModel new];
                [bgMusicModel setValuesForKeysWithDictionary:array[i]];
                [self.bgMusicArray addObject:bgMusicModel];
                
                if (![self isLive]) {
                    _currentPlayRow = 0;
                    [self playCurrentMusic];
                }
            }
        }
    } failure:^(NSError *error) {
        
    }];
}

//禁言用户
- (void)muteUser:(NSInteger)flag messageModel:(NTESMessageModel *)messageModel{
    MuteUserParam * param = [MuteUserParam new];
    param.accId = messageModel.message.from;
    param.roomId = [_chatroomId integerValue];
    param.flag = flag;
    [MuteRequest muteUser:param Success:^(AnswerLsDict *response) {
        
    } failure:^(NSError *error) {
        
    }];
}

- (void)muteAllUser:(NSInteger)flag{
    MuteUserParam * param = [MuteUserParam new];
    param.roomId = [_chatroomId integerValue];
    param.flag = flag;
    [MuteRequest muteAllUser:param Success:^(AnswerLsDict *response) {
        
    } failure:^(NSError *error) {
        
    }];
}
//刷新打赏 在线人数等
- (void)requestOnline{
    GetChatInfoParam * infoParam = [GetChatInfoParam new];
    infoParam.rtcId = _rtcId;
    
    [RotRequest getChatInfo:infoParam Success:^(DictResponse *response) {
        
        if (response.status == 200) {
            if (!_chatInfoModel) {
                _chatInfoModel = [GetChatInfoModel new];
            }
            [_chatInfoModel setValuesForKeysWithDictionary:response.data];
            [self.innerView setChatInfoModel:_chatInfoModel];
        }
    } failure:^(NSError *error) {
        
    }];
}

- (void)requestPlayStream
{
    if (self.player.playbackState == NELPMoviePlaybackStatePlaying) {
        return;
    }
    __weak typeof(self) wself = self;
    
    [self requestOnline];
    
    GetChatInfoParam * infoParam = [GetChatInfoParam new];
    infoParam.rtcId = _saveRoomInfoModel.chatId;
    [RotRequest getRoomInfo:infoParam Success:^(DictResponse *response) {
        
        NSString *me = [[NIMSDK sharedSDK].loginManager currentAccount];
        if ([[NTESLiveManager sharedInstance].connectorOnMic.uid isEqualToString:me]) {
            DDLogDebug(@"already on mic ,ignore requested play stream");
            //请求拉流地址回来后，发现自己已经上麦了，则不需要再开启播放器
            return;
        }
        if (response.status == 200) {
            if (!_saveRoomInfoModel) {
                SaveRoomInfoModel * roomInfoModel = [SaveRoomInfoModel new];
                _saveRoomInfoModel = roomInfoModel;
            }
            [_saveRoomInfoModel setValuesForKeysWithDictionary:response.data];
            [self.innerView setSaveRoomInfoModel:_saveRoomInfoModel];
            [self.handler refreshModel:_saveRoomInfoModel meetingName:_saveRoomInfoModel.roomName];
            //这里拿到的是应用服务器的人数，没有把自己加进去，手动添加。
            [NTESLiveManager sharedInstance].type = NIMNetCallMediaTypeAudio;
            
            [NTESLiveManager sharedInstance].type = _saveRoomInfoModel.avType == 1?NIMNetCallMediaTypeAudio:NIMNetCallMediaTypeVideo;
            [wself startPlay:_saveRoomInfoModel.rtmpPullUrl inView:wself.canvas];
        }else{
            //拉地址没成功，则过5秒重试
            NSTimeInterval delay = 5.f;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [wself requestPlayStream];
            });
        }
    } failure:^(NSError *error) {
        //拉地址没成功，则过5秒重试
        NSTimeInterval delay = 5.f;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [wself requestPlayStream];
        });
    }];

}

- (void)requestMicQueue
{
    DDLogInfo(@"audience request mic queue...");
    __weak typeof(self) weakSelf = self;
    [[NIMSDK sharedSDK].chatroomManager fetchChatroomQueue:_chatroomId completion:^(NSError * _Nullable error, NSArray<NSDictionary<NSString *,NSString *> *> * _Nullable info) {
        if (!error)
        {
            DDLogInfo(@"audience request mic queue result: %@",info);
            [NTESLiveManager sharedInstance].connectorOnMic = nil;
            for (NSDictionary *pair in info) {
                NTESMicConnector *connector = [[NTESMicConnector alloc] initWithDictionary:pair];
                if (connector.state == NTESLiveMicStateConnected) {
                    [NTESLiveManager sharedInstance].connectorOnMic = connector;
                }
            }
            if (![[NTESLiveManager sharedInstance].connectorOnMic.uid isEqualToString:[[NIMSDK sharedSDK].loginManager currentAccount]]) {
                [weakSelf.innerView switchToPlayingUI];
            }
        }
        else
        {
            DDLogDebug(@"fetch chatroom queue error: %@",error);
        }
    }];
}

- (void)shareStreamUrl
{
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = self.streamUrl;
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 8.0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"拉流地址已复制" message:@"在拉流播放器中粘贴地址\n观看直播" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
        [alert show];
    }
    else
    {
        UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:@"拉流地址已复制" message:@"在拉流播放器中粘贴地址\n观看直播" preferredStyle:UIAlertControllerStyleAlert];
        [alertVc addAction:[UIAlertAction actionWithTitle:@"知道了" style: UIAlertActionStyleDefault handler:nil]];
        [self presentViewController:alertVc animated:YES completion:nil];
    }
}

#pragma mark - NTESLiveInnerViewDelegate

- (void)didSendText:(NSString *)text
{
    NIMMessage *message = [NTESSessionMsgConverter msgWithText:text];
    NIMSession *session = [NIMSession session:_chatroomId type:NIMSessionTypeChatroom];
    [[NIMSDK sharedSDK].chatManager sendMessage:message toSession:session error:nil];
}

- (void)didSendImageView:(NSArray *)imageArr{
    for (UIImage * image in imageArr) {
        NIMMessage *message = [NTESSessionMsgConverter msgWithImage:image];
        NIMSession *session = [NIMSession session:_chatroomId type:NIMSessionTypeChatroom];
        [[NIMSDK sharedSDK].chatManager sendMessage:message toSession:session error:nil];
    }
}

- (void)onActionType:(NTESLiveActionType)type sender:(id)sender
{
    switch (type) {
        case NTESLiveActionTypeLike:
        {
            NSTimeInterval frequencyTimestamp = 1.0; //赞最多一秒发一次
            NSTimeInterval now = [NSDate date].timeIntervalSince1970;
            if ( now - _lastPressLikeTimeInterval > frequencyTimestamp) {
                _lastPressLikeTimeInterval = now;
                NIMMessage *message = [NTESSessionMsgConverter msgWithLike];
                NIMSession *session = [NIMSession session:_chatroomId type:NIMSessionTypeChatroom];
                [[NIMSDK sharedSDK].chatManager sendMessage:message toSession:session error:nil];
            }
        }
            break;
        case NTESLiveActionTypePresent:{
            NTESPresentShopView *shop = [[NTESPresentShopView alloc] initWithFrame:self.view.bounds];
            shop.delegate = self;
            [shop show];
        }
            break;
        case NTESLiveActionTypeCamera:{
            if (_cameraType == NIMNetCallCameraFront) {
                _cameraType = NIMNetCallCameraBack;
            }else{
                _cameraType = NIMNetCallCameraFront;
            }
            [[NIMAVChatSDK sharedSDK].netCallManager switchCamera:_cameraType];
        }
            break;
        case NTESLiveActionTypeInteract:
            if ([NTESLiveManager sharedInstance].role == NTESLiveRoleAudience)
            {
                if (self.connectingView) {
                    //说明正在请求连接
                    [self.connectingView show];
                }
                else
                {
                    NTESInteractSelectView *interact = [[NTESInteractSelectView alloc] initWithFrame:self.view.bounds];
                    interact.delegate = self;
                    if ([NTESLiveManager sharedInstance].type == NIMNetCallMediaTypeVideo) {
                        interact.types = @[@(NIMNetCallMediaTypeVideo),@(NIMNetCallMediaTypeAudio)];
                    }else{
                        interact.types = @[@(NIMNetCallMediaTypeAudio)];
                    }
                    [interact show];
                }
            }
            break;
            
        case NTESLiveActionTypeShare:{
            [self shareStreamUrl];
        }
            break;
        case NTESLiveActionTypeGift:{
            [self moneySupAction];
        }
            break;
        case NTESLiveActionTypeRed:{
            [self redPacketAction];
        }
            break;
        case NTESNoLiveFooterViewTypePlay:{
            [self.audioPlayerView play];
        }
            break;
        case NTESNoLiveFooterViewTypePause:{
            [self.audioPlayerView pause];
        }
            break;
        case NTESLiveFooterViewTypePlay:{
            [self.player play];
        }
            break;
        case NTESLiveFooterViewTypePause:{
            [self.player pause];
        }
            break;
        case NTESLiveActionTypeNotice:{
            NoticeViewController * noticeVC = [[NoticeViewController alloc] initWithNibName:@"NoticeViewController" bundle:nil];
            noticeVC.getChatInfoModel = _chatInfoModel;
            [self.navigationController pushViewController:noticeVC animated:YES];
        }
            break;
        case NTESLiveActionTypeGiftList:{
            NSLog(@"打赏列表");
            RewardViewController * rewardVC = [[RewardViewController alloc] initWithNibName:@"RewardViewController" bundle:nil];
            rewardVC.getChatInfoModel = _chatInfoModel;
            rewardVC.saveRoomInfoModel = _saveRoomInfoModel;
            [self.navigationController pushViewController:rewardVC animated:YES];
        }
            break;
        case NTESLiveActionTypeAttend:{
            NSLog(@"关注");
        }
            break;
        case NTESRefreshOnlineInfo:{
            NSLog(@"在线人数刷新");
            [self requestOnline];
        }
            break;
        default:
            break;
    }
}

- (void)onClosePlaying
{
    if (self.player.playbackState == NELPMoviePlaybackStatePlaying || self.handler.currentMeeting) {
        if ([[[UIDevice currentDevice] systemVersion] floatValue] < 8.0) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"确定离开直播间吗？" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"离开", nil];
            [alert showAlertWithCompletionHandler:^(NSInteger index) {
                switch (index) {
                    case 1:{
                        [self doExitLive];
                        break;
                    }
                    default:
                        break;
                }
            }];
        }
        else
        {
            UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:@"" message:@"确定离开直播间吗？" preferredStyle:UIAlertControllerStyleAlert];
            [alertVc addAction:[UIAlertAction actionWithTitle:@"取消" style: UIAlertActionStyleDefault handler:nil]];
            [alertVc addAction:[UIAlertAction actionWithTitle:@"离开" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self doExitLive];
            }]];
            [self presentViewController:alertVc animated:YES completion:nil];
        }
    }
    else
    {
        [self doExitLive];
    }
}

- (void)doExitLive
{
    [self.audioPlayerView pause];
    [[NIMSDK sharedSDK].chatroomManager exitChatroom:_chatroomId completion:nil];
    [[NIMAVChatSDK sharedSDK].netCallManager leaveMeeting:self.handler.currentMeeting];
    [SVProgressHUD showWithStatus:@"关闭中" maskType:SVProgressHUDMaskTypeClear];
    __weak typeof(self) weakSelf = self;
    [self shutdown:^{
        [SVProgressHUD dismiss];
        [weakSelf dismissViewControllerAnimated:YES completion:nil];
    }];
    
}

- (void)onCloseBypassing
{
    DDLogInfo(@"audience close by passing");
    if (![[NTESDevice currentDevice] canConnectInternet]) {
        [self.view makeToast:@"当前无网络,请稍后重试" duration:2.0 position:CSToastPositionCenter];
        return;
    }
    [NTESLiveManager sharedInstance].connectorOnMic = nil;
    [self.innerView switchToPlayingUI];
    [self requestPlayStream];
    [[NIMAVChatSDK sharedSDK].netCallManager leaveMeeting:self.handler.currentMeeting];
}

- (void)superAction:(SuperManagerMoreType)type{
    if (type == allMuteType) {
        UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:@"全员禁言" message:@"确定开启全员禁言？" preferredStyle:UIAlertControllerStyleAlert];
        [alertVc addAction:[UIAlertAction actionWithTitle:@"取消" style: UIAlertActionStyleDefault handler:nil]];
        [alertVc addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self muteAllUser:1];
            self.innerView.anchorMoreFooterView.isAllReliseMute = !self.innerView.anchorMoreFooterView.isAllReliseMute;
        }]];
        [self presentViewController:alertVc animated:YES completion:nil];
    }else if (type == allRelieveMuteType){
        [self muteAllUser:2];
        self.innerView.anchorMoreFooterView.isAllReliseMute = !self.innerView.anchorMoreFooterView.isAllReliseMute;
    }else if (type == stopLiveType){
        if (self.innerView.isLive) {
            UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:@"停止直播" message:@"直播正在直播中确定立即停止直播？" preferredStyle:UIAlertControllerStyleAlert];
            [alertVc addAction:[UIAlertAction actionWithTitle:@"取消" style: UIAlertActionStyleDefault handler:nil]];
            [alertVc addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                NIMCustomSystemNotification *notification = [NTESSessionCustomNotificationConverter notificationWithStopLive:_chatroomId];
                NIMSession *session = [NIMSession session:[NSString stringWithFormat:@"%ld",_saveRoomInfoModel.userId] type:NIMSessionTypeP2P];
                [[NIMSDK sharedSDK].systemNotificationManager sendCustomNotification:notification toSession:session completion:nil];
                
                PullStreamParam * param = [PullStreamParam new];
                param.uid = _saveRoomInfoModel.userId;
                param.cid = _saveRoomInfoModel.cid;
                param.flag = 2;
                param.rtcId = _saveRoomInfoModel.chatId;
                [RotRequest pullStream:param Success:^(ArrayResponse *response) {
                    
                } failure:^(NSError *error) {
                    
                }];
            }]];
            [self presentViewController:alertVc animated:YES completion:nil];
        }else{
            [self.view makeToast:@"直播未开始" duration:2.0 position:CSToastPositionCenter];
        }
        
    }
}

- (void)superManagerWork:(superManagerViewType)type messageModel:(NTESMessageModel *)messageModel{
    switch (type) {
        case tcType:{
                [self kickMemberAtIndexPath:messageModel];
        }
            break;
        case jyType:{
            [self muteUser:1 messageModel:messageModel];
        }
            break;
        case yjjyType:{
            [self muteUser:2 messageModel:messageModel];
        }
            break;
        case bljlType:{
            [self.discloseawardView show:messageModel];
        }
            break;
        default:
            break;
    }
}

#pragma mark - 红包礼物

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
    PlayerDetailViewModel * detailVM = [PlayerDetailViewModel new];
    detailVM.name = _chatInfoModel.nickname;
    detailVM.avater = _chatInfoModel.avater;
    
    SetMoneySupCardView *vi = [[SetMoneySupCardView alloc] initWithUserModel:detailVM];
    vi.delegate = self;
    vi.dismissBlock = ^{
        _isDisplaySetRedOrSetMoneyUpCardView = NO;
    };
    [vi show];
    _isDisplaySetRedOrSetMoneyUpCardView = YES;
}

- (void)setRedPacketActionWithTotalPirce:(int)totalPrice num:(int)num payType:(int)payType {
    
    [RedPacketRequest createRedEnvelopeWithText:@"恭喜发财，大吉大利" fromTo:0 redType:2 redMoney:totalPrice redNum:num rtcId:_rtcId flag:3 success:^(NSDictionary *response) {
        if ([[response objectForKey:@"status"] intValue] == 200) {
            NSString *redRId = [[response objectForKey:@"data"] objectForKey:@"redRId"];
            
            NSString *ipAddr = [IPAddrTool getIPAddress:YES];
            
            if (payType == 1) {
                //支付宝支付
                
                [RedPacketRequest chargeRedMoneyWithRedRId:redRId chargeType:1 ip:ipAddr success:^(NSDictionary *response) {
                    
                    if ([[response objectForKey:@"status"] intValue] == 200) {
                        NSString *chargeId = [[response objectForKey:@"data"] objectForKey:@"chargeId"];
                        NSString *charge = [[response objectForKey:@"data"] objectForKey:@"charge"];
                        
                        NTESAudienceLiveViewController *__weak weakSelf = self;
                        [Pingpp createPayment:charge
                               viewController:weakSelf
                                 appURLScheme:@"HWTou"
                               withCompletion:^(NSString *result, PingppError *error) {
                                   if ([result isEqualToString:@"success"]) {
                                       // 支付成功
                                       
                                       [RedPacketRequest sendRedEnvelopeWithRedRId:redRId chargeId:chargeId chargeType:1 success:^(NSDictionary *response) {
                                           
                                           if ([[response objectForKey:@"status"] intValue] == 200) {
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

- (void)setMoneySupActionWithTotalPirce:(int)totalPrice payType:(int)payType {
    if (!self.innerView.isLive) {
        [self.view makeToast:@"暂无主播，无法打赏" duration:2.0 position:CSToastPositionCenter];
        return;
    }
    [RedPacketRequest createTipRTCWithRtcId:_rtcId rtcUid:_saveRoomInfoModel.userId flag:3 tipMoney:totalPrice success:^(NSDictionary *response) {
        if ([[response objectForKey:@"status"] intValue] == 200) {
            NSString *tipRId = [[response objectForKey:@"data"] objectForKey:@"tipRId"];
            
            NSString *ipAddr = [IPAddrTool getIPAddress:YES];
            
            if (payType == 1) {
                
                [RedPacketRequest chargeTipMoneyWithTipRId:tipRId chargeType:1 ip:ipAddr success:^(NSDictionary *response) {
                    
                    if ([[response objectForKey:@"status"] intValue] == 200) {
                        NSString *chargeId = [[response objectForKey:@"data"] objectForKey:@"chargeId"];
                        NSString *charge = [[response objectForKey:@"data"] objectForKey:@"charge"];
                        
                        NTESAudienceLiveViewController *__weak weakSelf = self;
                        [Pingpp createPayment:charge
                               viewController:weakSelf
                                 appURLScheme:@"HWTou"
                               withCompletion:^(NSString *result, PingppError *error) {
                                   if ([result isEqualToString:@"success"]) {
                                       // 支付成功
                                       
                                       [RedPacketRequest sendTipRTCWithChargeId:chargeId tipRId:tipRId chargeType:1 success:^(NSDictionary *response) {
                                           
                                           if ([[response objectForKey:@"status"] intValue] == 200) {
                                               [HUDProgressTool showSuccessWithText:@"打赏成功"];
                                               [self sendGiveARewardMsg:totalPrice];
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
                        [self sendGiveARewardMsg:totalPrice];
                    }
                    else {
                        NSString * msg = [response objectForKey:@"msg"];
                        if ([msg isKindOfClass:[NSNull class]]) {
                            msg = @"";
                        }
                        [HUDProgressTool showErrorWithText:msg];
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

- (void)sendGiveARewardMsg:(double)money{
    NIMMessage *message = [NTESSessionMsgConverter msgWithAnchorGiveAReward:[NSString stringWithFormat:@"+%.2f",money/100]];
    NIMSession *session = [NIMSession session:_chatroomId type:NIMSessionTypeChatroom];
    [[NIMSDK sharedSDK].chatManager sendMessage:message toSession:session error:nil];
}

#pragma mark - WMPlayerDelegate
//播放
- (void)playerClickedPlayButton {

}
//暂停
- (void)playerClickedPauseButton {

}

- (void)playerReadyToPlayWithStatus:(WMPlayerState)state {
    
}
//播放完成
- (void)playerFinishedPlay {
    NSLog(@"播放结束");
    [self playNextBgMusic];
}

- (void)playerFailedPlayWithStatus:(WMPlayerState)state {
    
}


#pragma mark - 管理员操作

//踢出房间
- (void)kickMemberAtIndexPath:(NTESMessageModel *)messageModel
{
    NIMChatroomMemberKickRequest *request = [[NIMChatroomMemberKickRequest alloc] init];
    request.roomId = _chatroomId;
    request.userId = messageModel.message.from;
    __weak typeof(self) weakSelf = self;
    [[NIMSDK sharedSDK].chatroomManager kickMember:request completion:^(NSError *error) {
        if (!error)
        {
            NSString *toast = @"踢出成功";
            [weakSelf.view makeToast:toast duration:2.0 position:CSToastPositionCenter];
            
            ChatOutUserParam * param = [ChatOutUserParam new];
            param.chatId = _saveRoomInfoModel.chatId;
            param.accId = request.userId;
            [RotRequest getChatOutUser:param Success:^(DictResponse *response) {
                
            } failure:^(NSError *error) {
                
            }];
        }
        else
        {
            NSString *toast = [NSString stringWithFormat:@"操作失败 code:%zd",error.code];
            [weakSelf.view makeToast:toast duration:2.0 position:CSToastPositionCenter];
        }
    }];
}

#pragma mark - NTESInteractSelectDelegate
- (void)onSelectInteractType:(NIMNetCallMediaType)type
{
    __weak typeof(self) weakSelf = self;
    [NTESUserUtil requestMediaCapturerAccess:type handler:^(NSError *error){
        if (error) {
            DDLogInfo(@"start error by privacy");
            if ([[[UIDevice currentDevice] systemVersion] floatValue] < 8.0) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"申请连麦失败，请检查网络和权限重新开启" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
            }
            else
            {
                UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:@"" message:@"申请连麦失败，请检查网络和权限重新开启" preferredStyle:UIAlertControllerStyleAlert];
                [alertVc addAction:[UIAlertAction actionWithTitle:@"确定" style: UIAlertActionStyleDefault handler:nil]];
                [self presentViewController:alertVc animated:YES completion:nil];
            }
        }
        else
        {
            weakSelf.connectingView = [[NTESAudienceConnectView alloc] initWithFrame:self.view.bounds];
            weakSelf.connectingView.delegate = weakSelf;
            weakSelf.connectingView.roomId = _chatroomId;
            weakSelf.connectingView.type = type;
            [weakSelf.connectingView show];
            
            NIMChatroomMember *me = [[NTESLiveManager sharedInstance] myInfo:_chatroomId];
            NIMChatroom *chatroom = [[NTESLiveManager sharedInstance] roomInfo:_chatroomId];
            NTESQueuePushData *data = [[NTESQueuePushData alloc] init];
            data.roomId = _chatroomId;
            data.ext = [@{@"style":@(type),
                          @"state":@(NTESLiveMicStateWaiting),
                          @"info":@{
                                  @"nick" : me.roomNickname.length? me.roomNickname : me.userId,
                                  @"avatar":me.roomAvatar.length? me.roomAvatar : @"avatar_default"}} jsonBody];
            data.uid = me.userId;
            
            
            IsMicParam * micParam = [IsMicParam new];
            micParam.flag = 1;
            micParam.roomId = [_chatroomId integerValue];
            micParam.chatId = _saveRoomInfoModel.chatId;
            micParam.anchorId = _saveRoomInfoModel.userId;
            
            [RotRequest isMic:micParam Success:^(ArrayResponse *response) {
                if (response.status == 200) {
                    //发一条自定义通知告诉主播我进队列了，主播最多同一时间接到100条通知，不用担心主播会被撑爆
                    NIMCustomSystemNotification *notification = [NTESSessionCustomNotificationConverter notificationWithPushMic:chatroom.roomId style:type];
                    NIMSession *session = [NIMSession session:[NSString stringWithFormat:@"%ld",_saveRoomInfoModel.userId] type:NIMSessionTypeP2P];
                    [[NIMSDK sharedSDK].systemNotificationManager sendCustomNotification:notification toSession:session completion:^(NSError * _Nullable error) {
                        if (error) {
                            [weakSelf.view makeToast:@"申请失败,请重试" duration:2.0 position:CSToastPositionCenter];
                            weakSelf.handler.isWaitingForAgreeConnect = NO;
                            [weakSelf.connectingView dismiss];
                            weakSelf.connectingView = nil;
                        }else{
                            //把自己加入的互动直播方式存起来
                            [NTESLiveManager sharedInstance].bypassType  = type;
                            //标记自己正在请求连麦
                            weakSelf.handler.isWaitingForAgreeConnect = YES;
                        }
                    }];
                }else{
                    [weakSelf.view makeToast:response.msg duration:2.0 position:CSToastPositionCenter];
                    [weakSelf.connectingView dismiss];
                    weakSelf.connectingView = nil;
                }
            } failure:^(NSError *error) {
                [weakSelf.view makeToast:@"连麦请求失败，请重试" duration:2.0 position:CSToastPositionCenter];
                [weakSelf.connectingView dismiss];
                weakSelf.connectingView = nil;
            }];
        }
    }];
}

#pragma mark - NTESAudienceConnectDelegate
- (void)onCancelConnect:(id)sender
{
    DDLogInfo(@"cancel connect");
    NTESQueuePopData *data = [[NTESQueuePopData alloc] init];
    data.roomId = _chatroomId;
    data.uid = [[NIMSDK sharedSDK].loginManager currentAccount];
    IsMicParam * micParam = [IsMicParam new];
    micParam.flag = 2;
    micParam.roomId = [_chatroomId integerValue];
    micParam.chatId = _saveRoomInfoModel.chatId;
    micParam.anchorId = _saveRoomInfoModel.userId;
    [RotRequest isMic:micParam Success:^(ArrayResponse *response) {
        
    } failure:^(NSError *error) {
        
    }];
    
    //标记自己不再请求连麦
    self.handler.isWaitingForAgreeConnect = NO;
    self.connectingView = nil;
    
    //发一条自定义通知告诉主播我退出队列了，主播最多同一时间接到100条通知，不用担心主播会被撑爆
    NIMCustomSystemNotification *notification = [NTESSessionCustomNotificationConverter notificationWithPopMic:_chatroomId];
    NIMSession *session = [NIMSession session:[NSString stringWithFormat:@"%ld",_saveRoomInfoModel.userId] type:NIMSessionTypeP2P];
    [[NIMSDK sharedSDK].systemNotificationManager sendCustomNotification:notification toSession:session completion:nil];
}

#pragma mark - Notification

- (void)playerDidPlay:(NSNotification *)notification
{
    DDLogInfo(@"player %@ did play",self.player);
    [self.innerView switchToPlayingUI];

    for (UIView * view in self.canvas.subviews) {
        if ([view isKindOfClass:NSClassFromString(@"IJKSDLGLView")]) {
            view.contentMode = UIViewContentModeScaleAspectFill;
            break;
        }
    }
    self.isPlaying = YES;
}

- (void)playbackFinshed:(NSNotification *)notification
{
    switch ([[[notification userInfo] valueForKey:NELivePlayerPlaybackDidFinishReasonUserInfoKey] intValue])
    {
        case NELPMovieFinishReasonPlaybackEnded:{
            [self stopLive];
        }
            break;
        case NELPMovieFinishReasonPlaybackError:
            [self stopLive];
            break;
        case NELPMovieFinishReasonUserExited:
            break;
        default:
            break;
    }
}

#pragma mark - NTESLiveInnerViewDataSource
- (id<NELivePlayer>)currentPlayer
{
    return self.player;
}

#pragma mark - DiscloseawardViewDelegate

- (void)discloseawardViewAction:(NSString *)text messageModel:(NTESMessageModel *)messageModel payType:(NSInteger)payType{
    [RedPacketRequest createRewardRTC:_rtcId toUid:[messageModel.message.from intValue] flag:3 rewardMoney:[text doubleValue]*100 success:^(NSDictionary *response) {
        if ([[response objectForKey:@"status"] intValue] == 200) {
            NSString *tipRId = [[response objectForKey:@"data"] objectForKey:@"rewardRId"];
            
            NSString *ipAddr = [IPAddrTool getIPAddress:YES];
            
            if (payType == 1) {
                [RedPacketRequest chargeRewardMoney:tipRId chargeType:1 ip:ipAddr success:^(NSDictionary *response) {
                    
                    if ([[response objectForKey:@"status"] intValue] == 200) {
                        NSString *chargeId = [[response objectForKey:@"data"] objectForKey:@"chargeId"];
                        NSString *charge = [[response objectForKey:@"data"] objectForKey:@"charge"];
                        
                        NTESAudienceLiveViewController *__weak weakSelf = self;
                        [Pingpp createPayment:charge
                               viewController:weakSelf
                                 appURLScheme:@"HWTou"
                               withCompletion:^(NSString *result, PingppError *error) {
                                   if ([result isEqualToString:@"success"]) {
                                       // 支付成功
                                       
                                       [RedPacketRequest sendTipRTCWithChargeId:chargeId tipRId:tipRId chargeType:1 success:^(NSDictionary *response) {
                                           
                                           if ([[response objectForKey:@"status"] intValue] == 200) {
                                               [HUDProgressTool showSuccessWithText:@"爆料成功"];
                                               [self sendBLAward:text messageModel:messageModel];
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
                [RedPacketRequest sendRewardRTC:@"" rewardRId:tipRId chargeType:0 success:^(NSDictionary *response) {
                    
                    if ([[response objectForKey:@"status"] intValue] == 200) {
                        [HUDProgressTool showSuccessWithText:@"爆料成功"];
                        [self sendBLAward:text messageModel:messageModel];
                    }
                    else {
                        NSString * msg = [response objectForKey:@"msg"];
                        if ([msg isKindOfClass:[NSNull class]]) {
                            msg = @"";
                        }
                        [HUDProgressTool showErrorWithText:msg];
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

- (void)sendBLAward:(NSString *)text messageModel:(NTESMessageModel *)messageModel{
    NTESDataUser * user = [messageModel getDataUser];
    NIMMessage *message = [NTESSessionMsgConverter msgWithAnchorDisclose:text nickName:user.showName];
    NIMSession *session = [NIMSession session:_chatroomId type:NIMSessionTypeChatroom];
    [[NIMSDK sharedSDK].chatManager sendMessage:message toSession:session error:nil];
}

#pragma mark - Get

- (NSMutableArray *)bgMusicArray{
    if (!_bgMusicArray) {
        _bgMusicArray = [[NSMutableArray alloc] init];
    }
    return _bgMusicArray;
}

- (AudioPlayerView *)audioPlayerView{
    if (!_audioPlayerView) {
        _audioPlayerView = [AudioPlayerView sharedInstance];
        _audioPlayerView.isNeedSeekToZero = YES;
        _audioPlayerView.delegate = self;
    }
    return _audioPlayerView;
}

- (UIView *)canvas
{
    if (!_canvas) {
        _canvas = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.ntesWidth, self.view.ntesHeight )];
        _canvas.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _canvas.contentMode = UIViewContentModeScaleAspectFill;
        _canvas.clipsToBounds = YES;
    }
    return _canvas;
}

- (NTESLiveInnerView *)innerView
{
    if (!_innerView) {
        _innerView = [[NTESLiveInnerView alloc] initWithChatroom:_chatroomId frame:self.view.bounds];
        _innerView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _innerView.delegate = self;
        _innerView.dataSource = self;
        _innerView.isLive = [self isLive];
        _innerView.isSuperManager = _saveRoomInfoModel.isSuperManager;
        _innerView.chatInfoModel = _chatInfoModel;
        _innerView.saveRoomInfoModel = _saveRoomInfoModel;
    }
    return _innerView;
}

- (DiscloseawardView *)discloseawardView{
    if (!_discloseawardView) {
        _discloseawardView = [[[NSBundle mainBundle] loadNibNamed:@"DiscloseawardView" owner:self options:nil] lastObject];
        _discloseawardView.frame = CGRectMake(0, self.view.ntesHeight, self.view.ntesWidth, self.view.ntesHeight);
        _discloseawardView.discloseawardViewDelegate = self;
    }
    return _discloseawardView;
}

- (AudienceDiscloseawardView *)audienceDiscloseawardView{
    if (!_audienceDiscloseawardView) {
        _audienceDiscloseawardView = [[[NSBundle mainBundle] loadNibNamed:@"AudienceDiscloseawardView" owner:self options:nil] lastObject];
        _audienceDiscloseawardView.frame = CGRectMake(0, self.view.ntesHeight, self.view.ntesWidth, self.view.ntesHeight);
    }
    return _audienceDiscloseawardView;
}

- (void)setRtcId:(NSInteger)rtcId{
    _rtcId = rtcId;
    self.innerView.rtcId = rtcId;
}

#pragma mark - Rotate supportedInterfaceOrientations

-(BOOL)shouldAutorotate
{
    return NO;
}

-(UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    if ((NIMNetCallMediaType)[NTESLiveManager sharedInstance].type == NTESLiveTypeVideo&&[NTESLiveManager sharedInstance].orientation == NIMVideoOrientationLandscapeRight) {
        return UIInterfaceOrientationLandscapeRight;
    }
    else
    {
        return UIInterfaceOrientationPortrait;
    }
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    if ((NIMNetCallMediaType)[NTESLiveManager sharedInstance].type == NTESLiveTypeVideo&&[NTESLiveManager sharedInstance].orientation == NIMVideoOrientationLandscapeRight) {
        return UIInterfaceOrientationMaskLandscapeRight;
    }
    else
    {
        return UIInterfaceOrientationMaskPortrait;
    }
}


@end
