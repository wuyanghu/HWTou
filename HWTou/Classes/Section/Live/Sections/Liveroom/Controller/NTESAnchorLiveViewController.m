//
//  NTESLiveViewController.m
//  NIM
//
//  Created by chris on 15/12/16.
//  Copyright © 2015年 Netease. All rights reserved.
//

#import "NTESAnchorLiveViewController.h"
#import "UIImage+NTESColor.h"
#import "UIView+NTES.h"
#import "NSString+NTES.h"
#import "SVProgressHUD.h"
#import "UIView+Toast.h"
#import "NTESMediaCapture.h"
#import "NTESLiveManager.h"
#import "NTESDemoLiveroomTask.h"
#import "NSDictionary+NTESJson.h"
#import "UIAlertView+NTESBlock.h"
#import "NTESDemoService.h"
#import "NTESSessionMsgConverter.h"
#import "NTESLiveInnerView.h"
#import "NTESPresentBoxView.h"
#import "NTESPresentAttachment.h"
#import "NTESLikeAttachment.h"
#import "NTESLiveViewDefine.h"
#import "NTESMicConnector.h"
#import "NTESConnectQueueView.h"
#import "NTESMicAttachment.h"
#import "NTESLiveAnchorHandler.h"
#import "NTESTimerHolder.h"
#import "NTESDevice.h"
#import "NTESUserUtil.h"
#import "NTESCustomKeyDefine.h"
#import "NTESMixAudioSettingView.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>
#import <CoreLocation/CoreLocation.h>
#import "NTESLiveUtil.h"
#import "NTESFiterMenuView.h"
#import "NTESVideoQualityView.h"
#import "NTESMirrorView.h"
#import "NTESWaterMarkView.h"

#import "RotRequest.h"
#import "SaveRoomInfoModel.h"
#import "AddSetMusicView.h"
#import "HomeSubCategoryController.h"
#import "AddSetMusic2ViewController.h"
#import "SpecalMusicView.h"
#import "InteractorView.h"
#import "SetRedPacketCardView.h"
#import "SetMoneySupCardView.h"
#import "RedPacketRequest.h"
#import "IPAddrTool.h"
#import "HUDProgressTool.h"
#import "NetWorkRequestMacro.h"
#import <Pingpp.h>

#import "LiveRecordViewController.h"
#import "NTESAnchorOnlineAttachment.h"
#import "GetChatInfoModel.h"

#import "NoticeViewController.h"
#import "RewardViewController.h"
#import "IQKeyboardManager.h"
#import "NTESAnchorGiveARewardAttachment.h"

@implementation NTESFiterStatusModel

@end

typedef void(^NTESDisconnectAckHandler)(NSError *);
typedef void(^NTESAgreeMicHandler)(NSError *);

@interface NTESAnchorLiveViewController ()<NIMChatroomManagerDelegate,NTESLiveInnerViewDelegate,NTESLiveAnchorHandlerDelegate,
NIMChatManagerDelegate,NIMSystemNotificationManagerDelegate,NIMNetCallManagerDelegate,NTESConnectQueueViewDelegate,NTESTimerHolderDelegate,NTESMixAudioSettingViewDelegate,NTESMenuViewProtocol,NTESVideoQualityViewDelegate,NTESMirrorViewDelegate,NTESWaterMarkViewDelegate,AddSetMusicViewDelegate,InteractorViewDelegate>
{
    NTESTimerHolder *_timer;
    NTESDisconnectAckHandler _ackHandler;
}

@property (nonatomic, copy)   NIMChatroom *chatroom;

@property (nonatomic, strong) SaveRoomInfoModel * saveRoomInfoModel;
@property (nonatomic, strong) GetChatInfoModel * getChatInfoModel;

@property (nonatomic, strong) NIMNetCallMeeting *currentMeeting;

@property (nonatomic, strong) NTESMediaCapture  *capture;

@property (nonatomic, strong) UIView *captureView;

@property (nonatomic, strong) NTESLiveInnerView *innerView;
@property (nonatomic,strong) AddSetMusicView * addSetMusicView;
@property (nonatomic,strong) SpecalMusicView * specalMusicView;
@property (nonatomic,strong) InteractorView * interactorView;

@property (nonatomic, strong) NTESLiveAnchorHandler *handler;

@property (nonatomic, strong) NTESMixAudioSettingView *mixAudioSettingView;

@property (nonatomic, strong) NTESVideoQualityView *videoQualityView;

@property (nonatomic, strong) NTESMirrorView *mirrorView;

@property (nonatomic, strong) NTESWaterMarkView *waterMarkView;

@property (nonatomic, weak)   id<NTESAnchorLiveViewControllerDelegate> delegate;

@property (nonatomic, strong) NTESFiterMenuView *filterView;

@property (nonatomic, strong) UIImageView *focusView;

@property (nonatomic) BOOL audioLiving;

@property (nonatomic) BOOL isflashOn;

@property (nonatomic) BOOL isFocusOn;

@property (nonatomic) BOOL isVideoLiving;
@property (nonatomic, assign) BOOL isDisplaySetRedOrSetMoneyUpCardView;//是否展示发红包或打赏View

@end

@implementation NTESAnchorLiveViewController

NTES_USE_CLEAR_BAR
NTES_FORBID_INTERACTIVE_POP

- (instancetype)initWithChatroom:(NIMChatroom *)chatroom currentMeeting:(NIMNetCallMeeting*)currentMeeting capture:(NTESMediaCapture*)capture delegate:(id<NTESAnchorLiveViewControllerDelegate>)delegate{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        _chatroom = chatroom;
        _currentMeeting = currentMeeting;
        self.automaticallyAdjustsScrollViewInsets = NO;
        _handler = [[NTESLiveAnchorHandler alloc] initWithChatroom:chatroom];
        _handler.delegate = self;
        _delegate = delegate;
        _capture = capture;
        
        _isVideoLiving = YES;
        
    }
    return self;
}

- (instancetype)initWithChatroom:(NIMChatroom *)chatroom saveRoomInfoModel:(SaveRoomInfoModel * )saveRoomInfoModel chatInfoModel:(GetChatInfoModel *) chatInfoModel
{
    if (self) {
        _chatroom = chatroom;
        _saveRoomInfoModel = saveRoomInfoModel;
        _getChatInfoModel = chatInfoModel;
        self.automaticallyAdjustsScrollViewInsets = NO;
        _handler = [[NTESLiveAnchorHandler alloc] initWithChatroom:chatroom];
        _handler.delegate = self;
        _capture = [[NTESMediaCapture alloc]init];
    }
    return self;

}

- (void)dealloc{
    
    [[NIMSDK sharedSDK].chatroomManager removeDelegate:self];
    [[NIMSDK sharedSDK].chatManager removeDelegate:self];
    [UIApplication sharedApplication].idleTimerDisabled = NO;
    [[NTESLiveManager sharedInstance] stop];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [NTESLiveManager sharedInstance].orientation = self.orientation;
    [[NIMAVChatSDK sharedSDK].netCallManager setVideoCaptureOrientation:[NTESLiveManager sharedInstance].orientation];
    [self setUp];

    DDLogInfo(@"enter live room , live room type %zd, current user: %@",[NTESLiveManager sharedInstance].type,[[NIMSDK sharedSDK].loginManager currentAccount]);
    
    //视频直播
    if (_isVideoLiving) {
        [NTESLiveManager sharedInstance].type = NTESLiveTypeVideo;
        [_capture switchContainerToView:self.captureView];
        [self.innerView switchToPlayingUI];
        [self.view addSubview:self.innerView];
        [self.innerView updateBeautify:self.filterModel.filterIndex];
        [self.innerView updateQualityButton:[NTESLiveManager sharedInstance].liveQuality == NTESLiveQualityHigh];
    }
    //语音直播
    else
    {
        [self.innerView switchToPlayingUI];
        [self.view addSubview:self.innerView];
        
        [self addSystem:_getChatInfoModel.chatContent];
        
        __weak typeof(self) wself = self;
        NTESMediaCaptureRequest *request = [[NTESMediaCaptureRequest alloc] init];
        request.url = self.chatroom.broadcastUrl;
        request.roomId = self.chatroom.roomId;
        request.container = self.captureView;
        request.type = (NIMNetCallMediaType)[NTESLiveManager sharedInstance].type;
        request.meetingName = _saveRoomInfoModel.roomName;
        
        [self.capture startVideoPreview:request
                                handler:^(NIMNetCallMeeting * _Nonnull currentMeeting, NSError * _Nonnull error) {
                                    [wself.view addSubview:wself.innerView];
                                    wself.currentMeeting = currentMeeting;
                                    if (error) {
                                        DDLogInfo(@"start error by privacy");
                                        //横屏模式下 UIAlertView 问题较多 建议使用 UIAlertViewController
                                        if ([[[UIDevice currentDevice] systemVersion] floatValue] < 8.0) {
                                            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"直播失败，请检查网络和权限重新开启" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                                            [alert showAlertWithCompletionHandler:^(NSInteger index) {
                                                [wself dismissViewControllerAnimated:YES completion:nil];
                                            }];
                                        }
                                        else
                                        {
                                            UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:@"" message:@"直播失败，请检查网络和权限重新开启" preferredStyle:UIAlertControllerStyleAlert];
                                            [alertVc addAction:[UIAlertAction actionWithTitle:@"确定" style: UIAlertActionStyleDefault handler:nil]];
                                            [wself presentViewController:alertVc animated:YES completion:nil];
                                        }

                                    }
                                }];
    }
}

- (void)viewDidLayoutSubviews
{
}

- (BOOL)prefersStatusBarHidden{
    return YES;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent
                                                animated:NO];
    [self.innerView.redPacketTipView startLookingForRedPacket];
    [[IQKeyboardManager sharedManager] setEnable:NO];
    if (!self.navigationController.navigationBarHidden) {
        [self.navigationController setNavigationBarHidden:YES animated:YES];
    }
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault
                                                animated:NO];
    [self.addSetMusicView dismiss];
    [self.innerView.redPacketTipView stopLookingForRedPacket];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
//    [self.view endEditing:YES];
    
    
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self.view];
    
    //判断是否进行手动对焦显示
    [self doManualFocusWithPointInView:point];
}

#pragma mark - NIMChatManagerDelegate
- (void)willSendMessage:(NIMMessage *)message
{
    switch (message.messageType) {
        case NIMMessageTypeText:
        case NIMMessageTypeImage:
            [self.innerView addMessages:@[message]];
            break;
        default:
            break;
    }
}

- (void)onRecvMessages:(NSArray *)messages
{
    for (NIMMessage *message in messages) {
        if (![message.session.sessionId isEqualToString:self.chatroom.roomId]
            && message.session.sessionType == NIMSessionTypeChatroom) {
            //不属于这个聊天室的消息
            return;
        }
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
                else if ([attachment isKindOfClass:[NTESLikeAttachment class]]) {
                    [self.innerView fireLike];
                }else if([attachment isKindOfClass:[NTESAnchorGiveARewardAttachment class]]){
                    NTESAnchorGiveARewardAttachment * rewardAttachment = object.attachment;
                    [self getChatInfo];
                    [self.view makeToast:[NSString stringWithFormat:@"您有新的打赏消息! %@",rewardAttachment.money] duration:2.0f position:CSToastPositionCenter];
                }
                
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
        case NTESLiveCustomNotificationTypePushMic:
        case NTESLiveCustomNotificationTypePopMic:
        case NTESLiveCustomNotificationTypeRejectAgree:
        case NTESLiveCustomNotificationTypeStopLive:
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
    NTESMicConnector *connector = [[NTESLiveManager sharedInstance] findConnector:uid];
    if (connector) {
        connector.state = NTESLiveMicStateConnected;
        [NTESLiveManager sharedInstance].connectorOnMic = connector;
        
        //将连麦者的GLView扔到右下角，并显示名字
        [self.innerView switchToBypassStreamingUI:connector];
        
        //发送全局已连麦通知
        [self sendConnectedNotify:connector];
        
        //修改服务器队列
        NTESQueuePushData *data = [[NTESQueuePushData alloc] init];
        data.roomId = self.chatroom.roomId;
        data.ext = [@{@"style":@(connector.type),
                      @"state":@(NTESLiveMicStateConnected),
                      @"info":@{
                              @"nick" : connector.nick.length? connector.nick : connector.uid,
                              @"avatar":connector.avatar.length? connector.avatar : @"avatar_default"}} jsonBody];
        data.uid = uid;
        
        IsMicParam * micParam = [IsMicParam new];
        micParam.flag = 1;
        micParam.roomId = [self.chatroom.roomId integerValue];
        micParam.chatId = _saveRoomInfoModel.chatId;
        micParam.anchorId = _saveRoomInfoModel.userId;
        [RotRequest isMic:micParam Success:^(ArrayResponse *response) {
            
        } failure:^(NSError *error) {
            
        }];
    }
}

- (void)onUserLeft:(NSString *)uid
           meeting:(NIMNetCallMeeting *)meeting
{
    DDLogInfo(@"on user left %@",uid);
    DDLogInfo(@"current on mic user is %@",[NTESLiveManager sharedInstance].connectorOnMic.uid);
    
    NTESMicConnector *connectorOnMic = [NTESLiveManager sharedInstance].connectorOnMic;
    if (!connectorOnMic) {
        DDLogError(@"error: on mic user is empty!");
        return;
    }
    //修改服务器队列
    NTESQueuePopData *data = [[NTESQueuePopData alloc] init];
    data.roomId = self.chatroom.roomId;
    data.uid    = connectorOnMic.uid;
    
    IsMicParam * micParam = [IsMicParam new];
    micParam.flag = 2;
    micParam.roomId = [self.chatroom.roomId integerValue];
    micParam.chatId = _saveRoomInfoModel.chatId;
    micParam.anchorId = _saveRoomInfoModel.userId;
    [RotRequest isMic:micParam Success:^(ArrayResponse *response) {
        
    } failure:^(NSError *error) {
        
    }];
    
    //修正内存队列
    [[NTESLiveManager sharedInstance] removeConnectors:uid];
    [NTESLiveManager sharedInstance].connectorOnMic = nil;
    [self.innerView updateConnectorCount:[[NTESLiveManager sharedInstance] connectors:NTESLiveMicStateWaiting].count];
    
    //可能是强制要求对面离开，这个时候肯定记录了回调，尝试回调
    if (_ackHandler) {
        _ackHandler(nil);
        _ackHandler = nil;
        _timer = nil;
    }
    
    //发送全局连麦者断开的通知
    [self sendDisconnectedNotify:connectorOnMic];
    
    //切回没有小窗口的画面
    [self.innerView switchToPlayingUI];
}

- (void)onMeetingError:(NSError *)error
               meeting:(NIMNetCallMeeting *)meeting
{
    DDLogError(@"on meeting error: %zd",error);
    [self.view.window makeToast:[NSString stringWithFormat:@"互动直播失败 code: %zd",error.code] duration:2.0 position:CSToastPositionCenter];
    [NTESLiveManager sharedInstance].connectorOnMic = nil;
    [self.capture stopLiveStream];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)onRemoteYUVReady:(NSData *)yuvData
                   width:(NSUInteger)width
                  height:(NSUInteger)height
                    from:(NSString *)user
{
    [self.innerView updateRemoteView:yuvData width:width height:height];
}

-(void)onCameraTypeSwitchCompleted:(NIMNetCallCamera)cameraType
{
    if (cameraType == NIMNetCallCameraBack) {
        // 镜像关闭
        [self.mirrorView setMirrorDisabled];
        [self.innerView updateMirrorButton:NO];
    }
    else
    {
        //镜像重置
        [self.mirrorView resetMirror];
        
        //闪光灯关闭 - 设置button图片
        _isflashOn = NO;
        [self.innerView updateflashButton:NO];
        
        //手动对焦关闭
        _isFocusOn = NO;
        [self.innerView updateFocusButton:NO];
        self.focusView.hidden = YES;
    }
    
    [self.innerView resetZoomSlider];
}

-(void)onCameraOrientationSwitchCompleted:(NIMVideoOrientation)orientation
{
    [self.capture onCameraOrientationSwitchCompleted:orientation];
}

- (void)onNetStatus:(NIMNetCallNetStatus)status user:(NSString *)user
{
    if ([user isEqualToString:[[NIMSDK sharedSDK].loginManager currentAccount]]) {
        [self.innerView updateNetStatus:status];
    }
}


#pragma mark - NTESLiveAnchorHandlerDelegate
- (void)didUpdateConnectors
{
    NSLog(@"更新连麦");
    [self.interactorView refreshWithQueue:[[NTESLiveManager sharedInstance] connectors: NTESLiveMicStateWaiting] isNotice:YES];
}

- (void)didDisconConnectors{
    [self.interactorView refreshWithQueue:[[NTESLiveManager sharedInstance] connectors: NTESLiveMicStateWaiting] isNotice:NO];
}

- (void)superManagerDisConnect{
    [self doExitLive];
    
    LiveRecordViewController * recordVC = [[LiveRecordViewController alloc] initWithNibName:@"LiveRecordViewController" bundle:nil];
    recordVC.getChatRecordsParam.anchorId = _saveRoomInfoModel.userId;
    [self.navigationController pushViewController:recordVC animated:YES];
}

- (void)didUpdateUserOnMic
{
    [self.innerView updateUserOnMic];
}

#pragma mark - NIMChatroomManagerDelegate
- (void)chatroom:(NSString *)roomId beKicked:(NIMChatroomKickReason)reason
{
    if ([roomId isEqualToString:self.chatroom.roomId]) {
        NSString *toast = [NSString stringWithFormat:@"你被踢出聊天室"];
        DDLogInfo(@"chatroom be kicked, roomId:%@  rease:%zd",roomId,reason);
        [self.capture stopLiveStream];
        [[NIMSDK sharedSDK].chatroomManager exitChatroom:roomId completion:nil];
        [self.view.window makeToast:toast duration:2.0 position:CSToastPositionCenter];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)chatroom:(NSString *)roomId connectionStateChanged:(NIMChatroomConnectionState)state;
{
    DDLogInfo(@"chatroom connection state changed roomId : %@  state : %zd",roomId,state);
}

#pragma mark - Private

- (void)setUp
{
    [UIApplication sharedApplication].idleTimerDisabled = YES;
    self.view.backgroundColor = UIColorFromRGB(0xdfe2e6);
    [self.view addSubview:self.captureView];
    [self.view addSubview:self.focusView];

    [[NIMSDK sharedSDK].chatroomManager addDelegate:self];
    [[NIMSDK sharedSDK].chatManager addDelegate:self];
    [[NIMSDK sharedSDK].systemNotificationManager addDelegate:self];
    [[NIMAVChatSDK sharedSDK].netCallManager addDelegate:self];
}

- (void)setRtcId:(NSInteger)rtcId{
    _rtcId = rtcId;
//    self.innerView.rtcId = rtcId;
}

- (void)addSystem:(NSString *)text{
    NIMMessage *message = [NTESSessionMsgConverter msgWithText:text];
    [self willSendMessage:message];
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
    detailVM.name = @"";
    detailVM.avater = @"";
    
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
                        
                        NTESAnchorLiveViewController *__weak weakSelf = self;
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
    
    [RedPacketRequest createTipRTCWithRtcId:_rtcId rtcUid:[_chatroom.roomId integerValue] flag:3 tipMoney:totalPrice success:^(NSDictionary *response) {
        if ([[response objectForKey:@"status"] intValue] == 200) {
            NSString *tipRId = [[response objectForKey:@"data"] objectForKey:@"tipRId"];
            
            NSString *ipAddr = [IPAddrTool getIPAddress:YES];
            
            if (payType == 1) {
                
                [RedPacketRequest chargeTipMoneyWithTipRId:tipRId chargeType:1 ip:ipAddr success:^(NSDictionary *response) {
                    
                    if ([[response objectForKey:@"status"] intValue] == 200) {
                        NSString *chargeId = [[response objectForKey:@"data"] objectForKey:@"chargeId"];
                        NSString *charge = [[response objectForKey:@"data"] objectForKey:@"charge"];
                        
                        NTESAnchorLiveViewController *__weak weakSelf = self;
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



#pragma mark - NTESLiveInnerViewDelegate

- (void)superAction:(SuperManagerMoreType)type{
    if (type == redType) {
        [self redPacketAction];
    }
}

- (void)didSendText:(NSString *)text
{
    NIMMessage *message = [NTESSessionMsgConverter msgWithText:text];
    NIMSession *session = [NIMSession session:self.chatroom.roomId type:NIMSessionTypeChatroom];
    [[NIMSDK sharedSDK].chatManager sendMessage:message toSession:session error:nil];
}

- (void)didSendImageView:(NSArray *)imageArr{
    for (UIImage * image in imageArr) {
        NIMMessage *message = [NTESSessionMsgConverter msgWithImage:image];
        NIMSession *session = [NIMSession session:self.chatroom.roomId type:NIMSessionTypeChatroom];
        [[NIMSDK sharedSDK].chatManager sendMessage:message toSession:session error:nil];
    }
}

- (void)onActionType:(NTESLiveActionType)type sender:(id)sender
{
    switch (type) {
        case NTESLiveActionTypeLive:{
            if (!self.capture.isLiveStream) {
                NTESLiveManager * liveManager = [NTESLiveManager sharedInstance];
                
                SaveRoomInfoParam * saveRoomInfoParam = [SaveRoomInfoParam new];
                saveRoomInfoParam.rtcId = _rtcId;
                saveRoomInfoParam.acType = 1;
                saveRoomInfoParam.roomName = liveManager.meetingName;
                
                [RotRequest saveRoomInfo:saveRoomInfoParam Success:^(DictResponse *response) {
                    if (response.status == 200) {
                        [self startLiveRequest];
                    }else{
                        [self.view makeToast:response.msg duration:2.0f position:CSToastPositionCenter];
                    }
                } failure:^(NSError *error) {
                    [self.view makeToast:@"网络繁忙" duration:2.0f position:CSToastPositionCenter];
                }];
            }
        }
            break;
        case NTESLiveActionTypePresent:{
            NTESPresentBoxView *box = [[NTESPresentBoxView alloc] initWithFrame:self.view.bounds];
            [box show];
            break;
        }
        case NTESLiveActionTypeCamera:
            [self.capture switchCamera];
            break;

        case NTESLiveActionTypeInteract:{
            NSLog(@"点击连麦");
            
            [self.interactorView refreshWithQueue:[[NTESLiveManager sharedInstance] connectors: NTESLiveMicStateWaiting] isNotice:NO];
            [self.interactorView show];
        }
            break;
        case NTESLiveActionTypeBeautify:{
            [self.filterView show];
            
        }
            break;
        case NTESLiveActionTypeMixAudio:{
            NSLog(@"背景音");
            [self.addSetMusicView show];
        }
            break;
        case NTESLiveActionTypeSnapshot:{
            [self snapshotFromLocalVideo];
        }
            break;
        case NTESLiveActionTypeShare:{
            [self shareStreamUrl];
        }
            break;
        case NTESLiveActionTypeQuality:{
            [self.videoQualityView show];
        }
            break;
        case NTESLiveActionTypeNotice:{
            NoticeViewController * noticeVC = [[NoticeViewController alloc] initWithNibName:@"NoticeViewController" bundle:nil];
            noticeVC.getChatInfoModel = _getChatInfoModel;
            [self.navigationController pushViewController:noticeVC animated:YES];
        }
            break;
        case NTESLiveActionTypeGiftList:{
            NSLog(@"打赏列表");
            RewardViewController * rewardVC = [[RewardViewController alloc] initWithNibName:@"RewardViewController" bundle:nil];
            rewardVC.getChatInfoModel = _getChatInfoModel;
            rewardVC.saveRoomInfoModel = _saveRoomInfoModel;
            [self.navigationController pushViewController:rewardVC animated:YES];
        }
            break;
        case NTESLiveActionTypeSpecalAudio:{
            NSLog(@"特效音");
            GetChatBmgParam * bmgParam = [GetChatBmgParam new];
            bmgParam.flag = 2;
            [RotRequest getChatBmg:bmgParam Success:^(ArrayResponse *response) {
                if (response.status == 200) {
                    self.specalMusicView.dataArr = response.data;
                    [self.specalMusicView show];
                }
            } failure:^(NSError *error) {
                
            }];
        }
            break;
        case NTESLiveActionTypeMirror:{
            if ([self.capture isCameraBack]) {
                [_mirrorView setMirrorDisabled];
                [self.view makeToast:@"后置摄像头模式，无法使用镜像" duration:1.0 position:CSToastPositionCenter];
            }
            else
            {
                [self.mirrorView show];
            }
        }
            break;
        case NTESLiveActionTypeWaterMark:{
            [self.waterMarkView show];
        }
            break;
        case NTESLiveActionTypeFlash:{
            NSString * toast ;
            if ([self.capture isCameraBack]) {
                _isflashOn = !_isflashOn;
                [[NIMAVChatSDK sharedSDK].netCallManager setCameraFlash:_isflashOn];
                toast = _isflashOn ? @"闪光灯已打开" : @"闪光灯已关闭";
                UIButton * button = (UIButton *)sender;
                [button setImage: [UIImage imageNamed:_isflashOn ? @"icon_flash_on_n" :@"icon_flash_off_n"] forState:UIControlStateNormal];
            }
            else
            {
                toast = @"前置摄像头模式，无法使用闪光灯";
            }
            [self.view makeToast:toast duration:1.0 position:CSToastPositionCenter];
        }
            break;
        case NTESLiveActionTypeFocus:
        {
            NSString * toast ;
            if ([self.capture isCameraBack]) {
                _isFocusOn = !_isFocusOn;
                self.focusView.hidden = YES;
                toast = _isFocusOn ? @"手动对焦已打开" : @"手动对焦已关闭，启动自动对焦模式";
                if (!_isFocusOn) {
                    [[NIMAVChatSDK sharedSDK].netCallManager setFocusMode:NIMNetCallFocusModeAuto];
                }
                UIButton * button = (UIButton *)sender;
                [button setImage:[UIImage imageNamed:_isFocusOn ? @"icon_focus_on_n" : @"icon_focus_off_n"] forState:UIControlStateNormal];
                [button setImage:[UIImage imageNamed:_isFocusOn ? @"icon_focus_on_p" : @"icon_focus_off_p"] forState:UIControlStateHighlighted];
            }
            else
            {
                toast = @"前置摄像头模式，无法手动调焦";
            }
            
            [self.view makeToast:toast duration:1.0 position:CSToastPositionCenter];

        }
            break;
        case NTESRefreshOnlineInfo:{
            NSLog(@"在线人数刷新");
            [self getChatInfo];
        }
            break;
        default:
            break;
    }
}

-(void)onTapChatView:(CGPoint)point
{
    [self doManualFocusWithPointInView:point];
}

#pragma mark - NTESVideoQualityViewDelegate

- (void)onVideoQualitySelected:(NTESLiveQuality)type
{
    NIMNetCallVideoQuality q;

    switch (type) {
        case NTESLiveQualityNormal:
            q = NIMNetCallVideoQualityDefault;
            break;
        case NTESLiveQualityHigh:
            q = NIMNetCallVideoQuality540pLevel;
            break;
        default:
            q = [NTESUserUtil defaultVideoQuality];
            break;
    }

    BOOL success = [[NIMAVChatSDK sharedSDK].netCallManager switchVideoQuality:q];
    DDLogInfo(@"switch video quality: %zd success %zd",type,success);
    if (success) {
        [NTESLiveManager sharedInstance].liveQuality = type;
    }else{
        [self.view makeToast:@"分辨率切换失败"];
    }
    
    NIMNetCallNetStatus status = [[NIMAVChatSDK sharedSDK].netCallManager netStatus:[NIMSDK sharedSDK].loginManager.currentAccount];
    [self.innerView updateNetStatus:status];
    
    [self.videoQualityView dismiss];
    [self.innerView updateQualityButton:type == NTESLiveQualityHigh];
    [self.innerView resetZoomSlider];
    
    //重置水印状态
    [self.innerView updateWaterMarkButton:NO];
    [self.waterMarkView reset];
    
    //重置闪光灯状态
    _isflashOn = NO;
    [self.innerView updateflashButton:NO];
}

-(void)onVideoQualityViewCancelButtonPressed
{
    [self.videoQualityView dismiss];
}

#pragma mark - NTESConnectQueueViewDelegate
- (void)onSelectMicConnector:(NTESMicConnector *)connector
{
    if (connector.state == NTESLiveMicStateWaiting) {
        __weak typeof(self) weakSelf = self;
        NSString *mic = [NTESLiveManager sharedInstance].connectorOnMic.uid;
        [SVProgressHUD show];
        if (mic) {
            [self forceDisconnectedUser:mic handler:^(NSError *error) {
                if (error) {
                    [SVProgressHUD dismiss];
                    [weakSelf.view makeToast:@"切换连麦失败，请重试" duration:2.0 position:CSToastPositionCenter];
                }
                else
                {
                    [weakSelf agreeMicConnector:connector handler:^(NSError *error) {
                        [SVProgressHUD dismiss];
                    }];
                }
            }];
        }
        else
        {
            [self agreeMicConnector:connector handler:^(NSError *error) {
                [SVProgressHUD dismiss];
            }];
        }
    }
}

- (void)onCloseLiving{
    
    if (!((NIMNetCallMediaType)[NTESLiveManager sharedInstance].type == NTESLiveTypeAudio&&!self.audioLiving)) {
        
        UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:@"结束直播" message:@"当前正在直播中，确定结束直播？" preferredStyle:UIAlertControllerStyleAlert];
        [alertVc addAction:[UIAlertAction actionWithTitle:@"取消" style: UIAlertActionStyleDefault handler:nil]];
        [alertVc addAction:[UIAlertAction actionWithTitle:@"结束直播" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self doExitLive];
            LiveRecordViewController * recordVC = [[LiveRecordViewController alloc] initWithNibName:@"LiveRecordViewController" bundle:nil];
            recordVC.getChatRecordsParam.anchorId = _saveRoomInfoModel.userId;
            [self.navigationController pushViewController:recordVC animated:YES];
        }]];
        [self presentViewController:alertVc animated:YES completion:nil];
        
    }
    else
    {
        [self doExitLive];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)doExitLive
{
    [self startOrEndPullStream:2];
    
    [NTESLiveManager sharedInstance].type = NTESLiveTypeInvalid;
    NIMChatroomUpdateRequest *request = [[NIMChatroomUpdateRequest alloc] init];
    NSString *update = [@{
                          NTESCMType  : @([NTESLiveManager sharedInstance].type),
                          NTESCMMeetingName: @""
                          } jsonBody];
    request.roomId = self.chatroom.roomId;
    request.updateInfo = @{@(NIMChatroomUpdateTagExt) : update};
    request.needNotify = YES;
    request.notifyExt  = update;
    [[NIMSDK sharedSDK].chatroomManager updateChatroomInfo:request completion:nil];
    [[NIMSDK sharedSDK].chatroomManager exitChatroom:self.chatroom.roomId completion:nil];
    [[NIMAVChatSDK sharedSDK].netCallManager leaveMeeting:self.currentMeeting];
    [[NTESLiveManager sharedInstance] removeAllConnectors];
    
    if (_isVideoLiving) {
        if (_delegate && [_delegate respondsToSelector:@selector(onCloseLiveView)]) {
            [_delegate onCloseLiveView];
        }
    }
//    [self dismissViewControllerAnimated:NO completion:nil];
    
}

- (void)onCloseBypassing
{
    if (![[NTESDevice currentDevice] canConnectInternet]) {
        [self.view makeToast:@"当前无网络,请稍后重试" duration:2.0 position:CSToastPositionCenter];
        return;
    }
    
    //可能这个时候都没连上,或者连上了在说话
    NTESMicConnector *connector = [[NTESLiveManager sharedInstance] connectors:NTESLiveMicStateConnecting].firstObject;
    NSString *uid = connector? connector.uid : [NTESLiveManager sharedInstance].connectorOnMic.uid;
    
    DDLogInfo(@"anchor close by passing");
    
    if (connector)
    {
        DDLogInfo(@"anchor close when user is connecting uid: %@",uid);
        //还没有进入房间的情况
        [[NTESLiveManager sharedInstance] removeConnectors:uid];
        [self.innerView switchToPlayingUI];
        [self forceDisconnectedUser:uid handler:nil];
    }
    else
    {
        //进入房间了，就等等到那个人真的走了
        DDLogInfo(@"anchor close when user is connected uid: %@",uid);
        
        [SVProgressHUD show];
        [self forceDisconnectedUser:uid handler:^(NSError *error) {
            [SVProgressHUD dismiss];
            if (error)
            {
                DDLogError(@"on close bypassing error: force disconnect user error %zd",error.code);
            }
            else
            {
                [self.innerView switchToPlayingUI];
            }
        }];
    }
}

#pragma mark - NTESMixAudioSettingViewDelegate
- (void)didSelectMixAuido:(NSURL *)url
               sendVolume:(CGFloat)sendVolume
           playbackVolume:(CGFloat)playbackVolume
{
    NIMNetCallAudioFileMixTask *task = [[NIMNetCallAudioFileMixTask alloc] initWithFileURL:url];
    task.sendVolume = sendVolume;
    task.playbackVolume = playbackVolume;
    [[NIMAVChatSDK sharedSDK].netCallManager startAudioMix:task];
}

- (void)didPauseMixAudio
{
    [[NIMAVChatSDK sharedSDK].netCallManager pauseAudioMix];
}

- (void)didResumeMixAudio
{
    [[NIMAVChatSDK sharedSDK].netCallManager resumeAudioMix];
}

- (void)didUpdateMixAuido:(CGFloat)sendVolume
           playbackVolume:(CGFloat)playbackVolume
{
    NIMNetCallAudioFileMixTask *task = [NIMAVChatSDK sharedSDK].netCallManager.currentAudioMixTask;
    if (task) {
        task.sendVolume = sendVolume;
        task.playbackVolume = playbackVolume;
        [[NIMAVChatSDK sharedSDK].netCallManager updateAudioMix:task];
    }
}

#pragma mark - NTESMenuViewProtocol
- (void)menuView:(NTESFiterMenuView *)menu didSelect:(NSInteger)index
{
    [[NIMAVChatSDK sharedSDK].netCallManager selectBeautifyType:(NIMNetCallFilterType)[NTESLiveUtil changeToLiveType:index]];
}

- (void)menuView:(NTESFiterMenuView *)menu contrastDidChanged:(CGFloat)value
{
    [[NIMAVChatSDK sharedSDK].netCallManager setContrastFilterIntensity:value];
}

- (void)menuView:(NTESFiterMenuView *)menu smoothDidChanged:(CGFloat)value
{
    [[NIMAVChatSDK sharedSDK].netCallManager setSmoothFilterIntensity:value];
}

-(void)onFilterViewCancelButtonPressed
{
    [self.filterView dismiss];
}

-(void)onFilterViewConfirmButtonPressed
{
    [self.filterView dismiss];
    [self.innerView updateBeautify:self.filterView.selectedIndex];
}

#pragma mark - NTESMirrorViewDelegate

-(void)onPreviewMirror:(BOOL)isOn
{
    if ([self.capture isCameraBack]) {
        [self.view makeToast:@"后置摄像头模式，无法使用镜像" duration:2.0 position:CSToastPositionCenter];
        self.mirrorView.isPreviewMirrorOn = NO;
        return;
    }
    self.mirrorView.isPreviewMirrorOn = isOn;
    [[NIMAVChatSDK sharedSDK].netCallManager setPreViewMirror:isOn];
}

-(void)onCodeMirror:(BOOL)isOn
{
    if ([self.capture isCameraBack]) {
        [self.view makeToast:@"后置摄像头模式，无法使用镜像" duration:2.0 position:CSToastPositionCenter];
        self.mirrorView.isCodeMirrirOn = NO;
        return;
    }
    self.mirrorView.isCodeMirrirOn = isOn;
    [[NIMAVChatSDK sharedSDK].netCallManager setCodeMirror:isOn];
}

- (void)onMirrorCancelButtonPressed
{
    [self.mirrorView dismiss];
}

-(void)onMirrorConfirmButtonPressedWithPreviewMirror:(BOOL)isPreviewMirrorOn CodeMirror:(BOOL)isCodeMirrorOn
{
    [self.mirrorView dismiss];
    [self.innerView updateMirrorButton:isPreviewMirrorOn||isCodeMirrorOn];
}

#pragma mark - NTESWaterMarkViewDelegate

-(void)onWaterMarkCancelButtonPressed
{
    [self.waterMarkView dismiss];
}

-(void)onWaterMarkTypeSelected:(NTESWaterMarkType)type
{
    UIImage *image = [UIImage imageNamed:@"icon_waterMark"];

    CGRect rect ;
    
    CGFloat topOffset = 30 ;
    
    if ([NTESLiveManager sharedInstance].liveQuality == NTESLiveQualityNormal) {
        rect = CGRectMake(10, 10 + topOffset, 110/1.5, 40/1.5);
    }
    else
    {
        rect = CGRectMake(10, 10 + topOffset * 1.5, 110, 40);
    }

    switch (type) {
        case NTESWaterMarkTypeNone:
            [[NIMAVChatSDK sharedSDK].netCallManager cleanWaterMark];
            break;
            
        case NTESWaterMarkTypeNormal:
            
            [[NIMAVChatSDK sharedSDK].netCallManager cleanWaterMark];
            [[NIMAVChatSDK sharedSDK].netCallManager addWaterMark:image rect:rect location:NIMNetCallWaterMarkLocationRightUp];
            break;
            
        case NTESWaterMarkTypeDynamic:
        {
            NSMutableArray *array = [NSMutableArray array];
            for (NSInteger i = 0; i < 23; i++) {
                NSString *str = [NSString stringWithFormat:@"水印_%ld.png",(long)i];
                UIImage* image = [UIImage imageNamed:[[[NSBundle mainBundle] bundlePath]stringByAppendingPathComponent:str]];
                [array addObject:image];
            }

            [[NIMAVChatSDK sharedSDK].netCallManager cleanWaterMark];
            [[NIMAVChatSDK sharedSDK].netCallManager addDynamicWaterMarks:array fpsCount:4 loop:YES rect:rect location:NIMNetCallWaterMarkLocationRightUp];
        }
            break;
        default:
            break;
    }
    
    [self.innerView updateWaterMarkButton:type != NTESWaterMarkTypeNone];
    
}

#pragma mark - NTESTimerHolderDelegate
- (void)onNTESTimerFired:(NTESTimerHolder *)holder
{
    if (_ackHandler) {
        NSError *error = [NSError errorWithDomain:NIMRemoteErrorDomain code:NIMRemoteErrorCodeTimeoutError userInfo:nil];
        _ackHandler(error);
    }
    _ackHandler = nil;
}

#pragma mark - InteractorViewDelegate

- (void)openOrCloseInteractor:(switchType)type{
    if (type == onType) {
        [self isOpenMic:onType];
    }else{
        [self isOpenMic:offType];
    }
}

- (void)newInteractMsg{
    [self.view makeToast:@"您有新的连麦申请!" duration:2.0f position:CSToastPositionCenter];
}


#pragma mark - AddSetMusicViewDelegate

- (void)addSetMusicAction{
    
    [RotRequest getChatLabels:^(ArrayResponse *response) {
        if (response.status == 200) {
            [self.addSetMusicView dismiss];
            
            AddSetMusic2ViewController * setMusicVC = [[AddSetMusic2ViewController alloc] init];
            setMusicVC.dataArr = response.data;
            [self.navigationController pushViewController:setMusicVC animated:YES];
        }
    } failure:^(NSError *error) {

    }];
    
}


#pragma mark - Private
- (void)forceDisconnectedUser:(NSString *)uid handler:(NTESDisconnectAckHandler)handler
{
    if (!uid.length) {
        DDLogError(@"force disconnect error : no user id!");
        handler(nil);
        return;
    }
    if (!_ackHandler) {
        //如果 _ackHandler 有值， 说明有一条强制请求已经发出去了，这个时候只要替换掉回调就可以了。
        DDLogInfo(@"send custom notification force disconnect to user %@",uid);
        NIMCustomSystemNotification *notification = [NTESSessionCustomNotificationConverter notificationWithForceDisconnect:self.chatroom.roomId];
        NIMSession *session = [NIMSession session:uid type:NIMSessionTypeP2P];
        [[NIMSDK sharedSDK].systemNotificationManager sendCustomNotification:notification toSession:session completion:nil];
        _timer = [[NTESTimerHolder alloc] init];
        [_timer startTimer:10.0 delegate:self repeats:NO];
    }
    _ackHandler = handler;
}

- (void)agreeMicConnector:(NTESMicConnector *)connector handler:(NTESAgreeMicHandler)handler
{
    __weak typeof(self) weakSelf = self;
    NIMCustomSystemNotification *notification = [NTESSessionCustomNotificationConverter notificationWithAgreeMic:self.chatroom.roomId style:connector.type];
    NIMSession *session = [NIMSession session:connector.uid type:NIMSessionTypeP2P];
    DDLogError(@"anchor: agree mic: %@",connector.uid);
    [[NIMSDK sharedSDK].systemNotificationManager sendCustomNotification:notification toSession:session completion:^(NSError * _Nullable error) {
        if (!error) {
            connector.state = NTESLiveMicStateConnecting;
            [[NTESLiveManager sharedInstance] updateConnectors:connector];
            //显示连接中的图案
            [weakSelf.innerView switchToBypassLoadingUI:connector];
            //刷新等待列表人数
            [self.interactorView refreshWithQueue:[[NTESLiveManager sharedInstance] connectors: NTESLiveMicStateWaiting] isNotice:NO];
        }else{
            DDLogError(@"notification with agree mic error: %@",error);
            [weakSelf.view makeToast:@"选择失败，请重试" duration:2.0 position:CSToastPositionCenter];
        }
        if (handler) {
            handler(error);
        }
    }];
}

- (void)sendConnectedNotify:(NTESMicConnector *)connector
{
    NIMMessage *message = [NTESSessionMsgConverter msgWithConnectedMic:connector];
    NIMSession *session = [NIMSession session:self.chatroom.roomId type:NIMSessionTypeChatroom];
    [[NIMSDK sharedSDK].chatManager sendMessage:message toSession:session error:nil];
}

- (void)sendDisconnectedNotify:(NTESMicConnector *)connector
{
    NIMMessage *message = [NTESSessionMsgConverter msgWithDisconnectedMic:connector];
    NIMSession *session = [NIMSession session:self.chatroom.roomId type:NIMSessionTypeChatroom];
    [[NIMSDK sharedSDK].chatManager sendMessage:message toSession:session error:nil];
}

- (void)shareStreamUrl
{
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    
    NSDictionary * dic = [NTESLiveUtil dictByJsonString:self.chatroom.ext];
    NSString * pullUrl = [dic objectForKey:@"pullUrl"];
    if (pullUrl) {
        pasteboard.string = pullUrl;
    }
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

- (void)snapshotFromLocalVideo
{
    __weak typeof(self) weakself = self;
    
    [[NIMAVChatSDK sharedSDK].netCallManager snapshotFromLocalVideoCompletion:^(UIImage * _Nonnull image) {
        if (image) {
            //保存到相册
            if ([weakself isCanUsePhotos]) {
               UIImageWriteToSavedPhotosAlbum(image, weakself,  @selector(image:didFinishSavingWithError:contextInfo:), nil);
            }
            else
            {
                [weakself.view makeToast:@"截图保存失败，没有相册权限" duration:1.0 position:CSToastPositionCenter ];
            }
        }
        else
        {
            [weakself.view makeToast:@"截图失败" duration:1.0 position:CSToastPositionCenter];
        }
    }];
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo: (void *) contextInfo;
{
    if(!error)
    {
        [self.view makeToast:@"截图已保存" duration:1.0 position:CSToastPositionCenter];
    }
    else
    {
        [self.view makeToast:@"截图失败" duration:1.0 position:CSToastPositionCenter];
    }
}

- (BOOL)isCanUsePhotos {
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 8.0) {
        ALAuthorizationStatus author =[ALAssetsLibrary authorizationStatus];
        if (author == kCLAuthorizationStatusRestricted || author == kCLAuthorizationStatusDenied) {
            //无权限
            return NO;
        }
    }
    else {
        PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
        if (status == PHAuthorizationStatusRestricted ||
            status == PHAuthorizationStatusDenied) {
            //无权限
            return NO;
        }
    }
    return YES;
}

- (void)doManualFocusWithPointInView:(CGPoint)point
{
    CGFloat actionViewHeight = [self.innerView getActionViewHeight];
    BOOL pointsInRect = point.y < self.view.ntesHeight - actionViewHeight;
    //后置摄像头允许对焦
    if ((NIMNetCallMediaType)[NTESLiveManager sharedInstance].type == NTESLiveTypeVideo && [self.capture isCameraBack] && _isFocusOn && pointsInRect ) {
        // 代执行的延迟消失数量
        static int delayCount = 0;
        
        // 焦点显示
        self.focusView.center = CGPointMake(point.x, point.y);
        [self.view bringSubviewToFront:self.focusView];
        self.focusView.hidden = NO;
        
        CGPoint devicePoint = CGPointMake(self.focusView.center.x/self.innerView.frame.size.width, self.focusView.center.y/self.innerView.frame.size.height);
        //对焦
        [[NIMAVChatSDK sharedSDK].netCallManager changeNMCVideoPreViewManualFocusPoint:devicePoint];
        
        delayCount++;
        //3秒自动消失
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (!self.focusView.hidden && delayCount == 1) {
                self.focusView.hidden = YES;
            }
            delayCount--;
        });
    }
}

- (void)updateBeautify:(NSInteger)selectedIndex
{
    [self.innerView updateBeautify:selectedIndex != 0];
}

#pragma mark - Get
- (UIView *)captureView
{
    if (!_captureView) {
//        CGFloat bottom = 44.f;
            _captureView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.ntesWidth, self.view.ntesHeight )];
        _captureView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _captureView.clipsToBounds = YES;
    }
    return _captureView;
}

- (InteractorView *)interactorView{
    if (!_interactorView) {
        _interactorView = [[[NSBundle mainBundle] loadNibNamed:@"InteractorView" owner:self options:nil] lastObject];
        _interactorView.frame = CGRectMake(0, self.view.ntesHeight, self.view.ntesWidth, self.view.ntesHeight);
        _interactorView.interactorDelegate = self;
    }
    return _interactorView;
}

- (SpecalMusicView *)specalMusicView{
    if (!_specalMusicView) {
        _specalMusicView = [[[NSBundle mainBundle] loadNibNamed:@"SpecalMusicView" owner:self options:nil] lastObject];
        _specalMusicView.frame = CGRectMake(0, self.view.ntesHeight, self.view.ntesWidth, self.view.ntesHeight);
        _specalMusicView.specalDelegate = self;
    }
    return _specalMusicView;
}

- (NTESLiveInnerView *)innerView
{
    if (!_innerView) {
        _innerView = [[NTESLiveInnerView alloc] initWithChatroom:self.chatroom.roomId frame:self.view.bounds];
        [_innerView refreshChatroom:self.chatroom isMuteUser:NO];
        _innerView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _innerView.delegate = self;
        _innerView.chatInfoModel = _getChatInfoModel;
        _innerView.saveRoomInfoModel = _saveRoomInfoModel;
        _innerView.rtcId = _rtcId;
    }
    return _innerView;
}

- (AddSetMusicView *)addSetMusicView{
    if (!_addSetMusicView) {
        _addSetMusicView = [[[NSBundle mainBundle] loadNibNamed:@"AddSetMusicView" owner:self options:nil] lastObject];
        _addSetMusicView.frame = CGRectMake(0, self.view.ntesHeight, self.view.ntesWidth, self.view.ntesHeight);
        _addSetMusicView.addDelegate = self;
    }
    return _addSetMusicView;
}

- (NTESMixAudioSettingView *)mixAudioSettingView
{
    //因为每次打开混音界面其实需要记住之前的状态，这里直接retain住
    if (!_mixAudioSettingView) {
        _mixAudioSettingView = [[NTESMixAudioSettingView alloc] initWithFrame:self.view.bounds];
        _mixAudioSettingView.delegate = self;
    }
    return _mixAudioSettingView;
}


- (NTESVideoQualityView *)videoQualityView
{
    if (!_videoQualityView) {
        _videoQualityView = [[NTESVideoQualityView alloc]initWithFrame:self.view.bounds quality:[NTESLiveManager sharedInstance].liveQuality];
        _videoQualityView.delegate =self;
    }
    return _videoQualityView;
}

- (NTESMirrorView *)mirrorView
{
    if (!_mirrorView) {
        _mirrorView = [[NTESMirrorView alloc]initWithFrame:self.view.bounds];
        _mirrorView.delegate =self;
    }
    return _mirrorView;
}

- (NTESWaterMarkView *)waterMarkView
{
    if (!_waterMarkView) {
        _waterMarkView = [[NTESWaterMarkView alloc]initWithFrame:self.view.bounds];
        _waterMarkView.delegate =self;
    }
    return _waterMarkView;
}

-(UIImageView *)focusView
{
    if (!_focusView) {
        _focusView = [[UIImageView alloc]init];
        _focusView.image = [UIImage imageNamed:@"icon_focus_frame"];
        [_focusView sizeToFit];
        _focusView.hidden = YES;
    }
    return _focusView;
}

-(NTESFiterMenuView *)filterView
{
    if (!_filterView) {
        _filterView = [[NTESFiterMenuView alloc]initWithFrame:self.view.bounds];
        _filterView.selectedIndex = self.filterModel.filterIndex;
        _filterView.smoothValue = self.filterModel.smoothValue;
        _filterView.constrastValue = self.filterModel.constrastValue;

        _filterView.delegate = self;
    }
    return _filterView;
}

#pragma mark - 网络请求
- (void)startLiveRequest{
    PullStreamParam * param = [PullStreamParam new];
    param.uid = _saveRoomInfoModel.userId;
    param.cid = _saveRoomInfoModel.cid;
    param.rtcId = _saveRoomInfoModel.chatId;
    param.flag = 1;
    [RotRequest pullStream:param Success:^(ArrayResponse *response) {
        if (response.status == 200) {
            __weak typeof(self) weakSelf = self;
            [self.capture startLiveStreamHandler:^(NIMNetCallMeeting * _Nonnull meeting, NSError * _Nonnull error) {
                if (error) {
                    [weakSelf.view makeToast:@"直播初始化失败"];
                    [weakSelf.innerView switchToPlayingUI];
                    DDLogError(@"start error:%@",error);
                }else
                {
                    [self getChatInfo];
                    
                    NIMMessage *message = [NTESSessionMsgConverter msgWithAnchorOnline];
                    NIMSession *session = [NIMSession session:_chatroom.roomId type:NIMSessionTypeChatroom];
                    [[NIMSDK sharedSDK].chatManager sendMessage:message toSession:session error:nil];//直播通知上线
                    
                    //将服务器连麦请求队列清空
                    [[NIMSDK sharedSDK].chatroomManager dropChatroomQueue:weakSelf.chatroom.roomId completion:nil];
                    //发一个全局断开连麦的通知给观众，表示之前的连麦都无效了
                    [self sendDisconnectedNotify:nil];
                    weakSelf.audioLiving = YES;
                    weakSelf.currentMeeting = meeting;
                    [weakSelf.innerView switchToPlayingUI];
                }
            }];
        }else{
            [self.view makeToast:response.msg duration:2.0f position:CSToastPositionCenter];
        }
    } failure:^(NSError *error) {
        
    }];
}


- (void)getChatInfo{
    GetChatInfoParam * infoParam = [GetChatInfoParam new];
    infoParam.rtcId = _rtcId;
    
    [RotRequest getChatInfo:infoParam Success:^(DictResponse *response) {
        
        if (response.status == 200) {
            if (!_getChatInfoModel) {
                _getChatInfoModel = [GetChatInfoModel new];
            }
            [_getChatInfoModel setValuesForKeysWithDictionary:response.data];
            [self.innerView setChatInfoModel:_getChatInfoModel];
        }
    } failure:^(NSError *error) {
        
    }];
}
        
- (void)isOpenMic:(switchType)type{
    IsOpenMicParam * isOpenMicParam = [IsOpenMicParam new];
    if (type == onType) {
        isOpenMicParam.flag = 1;
    }else{
        isOpenMicParam.flag = 2;
    }
    isOpenMicParam.chatId = _saveRoomInfoModel.chatId;
    [RotRequest isOpenMic:isOpenMicParam Success:^(DictResponse *response) {
        
    } failure:^(NSError *error) {
        
    }];
}

- (void)startOrEndPullStream:(NSInteger)flag{
    PullStreamParam * param = [PullStreamParam new];
    param.uid = _saveRoomInfoModel.userId;
    param.cid = _saveRoomInfoModel.cid;
    param.rtcId = _saveRoomInfoModel.chatId;
    param.flag = flag;
    [RotRequest pullStream:param Success:^(ArrayResponse *response) {
        
    } failure:^(NSError *error) {
        
    }];
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
