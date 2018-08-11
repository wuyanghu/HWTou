//
//  NTESSessionHistoryViewController.m
//  NIM
//
//  Created by emily on 30/01/2018.
//  Copyright © 2018 Netease. All rights reserved.
//

#import "NTESSessionHistoryViewController.h"
#import "NIMContactSelectViewController.h"
#import "NIMKitMediaFetcher.h"
#import "NTESessionMessageDataProvider.h"
#import "NTESSessionHistoryConfig.h"
#import "NIMNormalTeamCardViewController.h"
#import "NTESSessionCardViewController.h"
#import "NIMAdvancedTeamCardViewController.h"
#import "NTESRobotCardViewController.h"
#import "UIActionSheet+NTESBlock.h"
#import "NTESSessionRemoteHistoryViewController.h"
#import "NTESSessionLocalHistoryViewController.h"
#import "NTESBundleSetting.h"
#import "NSDictionary+NTESJson.h"
#import "NTESTimerHolder.h"
#import "NTESCustomSysNotificationSender.h"
#import "NTESChartletAttachment.h"
#import "NTESSessionMsgConverter.h"
#import "NTESJanKenPonAttachment.h"
#import "NTESFileTransSelectViewController.h"
#import "NTESWhiteboardViewController.h"
#import "NTESRedPacketManager.h"
#import "NTESAudioChatViewController.h"
#import "Reachability.h"
#import "NTESSnapchatAttachment.h"
#import "NTESTeamMeetingCallerInfo.h"
#import "NTESVideoChatViewController.h"
#import "NTESTeamMeetingViewController.h"
#import "UIAlertView+NTESBlock.h"

@import MobileCoreServices;
@import AVFoundation;

@interface NTESSessionHistoryViewController ()
<UIImagePickerControllerDelegate,
UINavigationControllerDelegate,
NIMMediaManagerDelegate,
NIMContactSelectDelegate,
NIMSystemNotificationManagerDelegate,
NTESTimerHolderDelegate>

@property(nonatomic, strong) UIImagePickerController *imagePicker;
@property(nonatomic, strong) UIView *currentSingleSnapView;
@property(nonatomic, strong) NIMKitMediaFetcher *mediaFetcher;
@property(nonatomic, strong) NTESSessionHistoryConfig *sessionConfig;
@property(nonatomic, strong) NTESTimerHolder *titleTimer;
@property(nonatomic, strong) NTESCustomSysNotificationSender *notificationSender;
@property(nonatomic, strong) NIMMessage *firstMsg;
@property(nonatomic, assign) BOOL shouldResetMsg;
@property (nonatomic,weak)    id<NIMSessionInteractor> interactor;

@end

@implementation NTESSessionHistoryViewController

- (void)dealloc {
    [[NIMSDK sharedSDK].systemNotificationManager removeDelegate:self];
}

- (instancetype)initWithSession:(NIMSession *)session andSearchMsg:(NIMMessage *)msg {
    if (self = [super initWithSession:session]) {
        _firstMsg = msg;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configNav];
    BOOL disableCommandTyping = self.disableCommandTyping || (self.session.sessionType == NIMSessionTypeP2P &&[[NIMSDK sharedSDK].userManager isUserInBlackList:self.session.sessionId]);
    if (!disableCommandTyping) {
        _titleTimer = [[NTESTimerHolder alloc] init];
        [[NIMSDK sharedSDK].systemNotificationManager addDelegate:self];
    }
    self.notificationSender = [NTESCustomSysNotificationSender new];
    self.shouldResetMsg = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NIMSDK sharedSDK].mediaManager stopRecord];
    [[NIMSDK sharedSDK].mediaManager stopPlay];
}


- (void)configNav {
    UIButton *enterTeamCard = [UIButton buttonWithType:UIButtonTypeCustom];
    [enterTeamCard addTarget:self action:@selector(enterTeamCard:) forControlEvents:UIControlEventTouchUpInside];
    [enterTeamCard setImage:[UIImage imageNamed:@"icon_session_info_normal"] forState:UIControlStateNormal];
    [enterTeamCard setImage:[UIImage imageNamed:@"icon_session_info_pressed"] forState:UIControlStateHighlighted];
    [enterTeamCard sizeToFit];
    UIBarButtonItem *enterTeamCardItem = [[UIBarButtonItem alloc] initWithCustomView:enterTeamCard];
    
    UIButton *infoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [infoBtn addTarget:self action:@selector(enterPersonInfoCard:) forControlEvents:UIControlEventTouchUpInside];
    [infoBtn setImage:[UIImage imageNamed:@"icon_session_info_normal"] forState:UIControlStateNormal];
    [infoBtn setImage:[UIImage imageNamed:@"icon_session_info_pressed"] forState:UIControlStateHighlighted];
    [infoBtn sizeToFit];
    UIBarButtonItem *enterUInfoItem = [[UIBarButtonItem alloc] initWithCustomView:infoBtn];
    
    UIButton *robotInfoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [robotInfoBtn addTarget:self action:@selector(enterRobotInfoCard:) forControlEvents:UIControlEventTouchUpInside];
    [robotInfoBtn setImage:[UIImage imageNamed:@"icon_robot_card_normal"] forState:UIControlStateNormal];
    [robotInfoBtn setImage:[UIImage imageNamed:@"icon_robot_card_pressed"] forState:UIControlStateHighlighted];
    [robotInfoBtn sizeToFit];
    UIBarButtonItem *robotInfoButtonItem = [[UIBarButtonItem alloc] initWithCustomView:robotInfoBtn];
    
    
    if (self.session.sessionType == NIMSessionTypeTeam)
    {
        self.navigationItem.rightBarButtonItems  = @[enterTeamCardItem];
    }
    else if(self.session.sessionType == NIMSessionTypeP2P)
    {
        if ([self.session.sessionId isEqualToString:[[NIMSDK sharedSDK].loginManager currentAccount]])
        {
            self.navigationItem.rightBarButtonItems = @[];
        }
        else if([[NIMSDK sharedSDK].robotManager isValidRobot:self.session.sessionId])
        {
            self.navigationItem.rightBarButtonItems = @[robotInfoButtonItem];
        }
        else
        {
            self.navigationItem.rightBarButtonItems = @[enterUInfoItem];
        }
    }
}

#pragma mark - navigationBar

- (void)enterTeamCard:(id)sender{
    NIMTeam *team = [[NIMSDK sharedSDK].teamManager teamById:self.session.sessionId];
    UIViewController *vc;
    if (team.type == NIMTeamTypeNormal) {
        vc = [[NIMNormalTeamCardViewController alloc] initWithTeam:team];
    }else if(team.type == NIMTeamTypeAdvanced){
        vc = [[NIMAdvancedTeamCardViewController alloc] initWithTeam:team];
    }
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)enterPersonInfoCard:(id)sender{
    NTESSessionCardViewController *vc = [[NTESSessionCardViewController alloc] initWithSession:self.session];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)enterRobotInfoCard:(id)sender{
    NTESRobotCardViewController *vc = [[NTESRobotCardViewController alloc] initWithUserId:self.session.sessionId];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 消息收发接口
- (void)sendMessage:(NIMMessage *)message {
    if (self.shouldResetMsg) {
        self.shouldResetMsg = NO;
//        [self.interactor resetMessages:^(NSError *error) {
//            [self.interactor sendMessage:message];
//        }];
        [self.interactor sendMessage:message];
    }
    else {
        [self.interactor sendMessage:message];
    }
}

#pragma mark - NIMSystemNotificationManagerDelegate
- (void)onReceiveCustomSystemNotification:(NIMCustomSystemNotification *)notification
{
    if (!notification.sendToOnlineUsersOnly) {
        return;
    }
    NSData *data = [[notification content] dataUsingEncoding:NSUTF8StringEncoding];
    if (data) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data
                                                             options:0
                                                               error:nil];
        if ([dict jsonInteger:NTESNotifyID] == NTESCommandTyping && self.session.sessionType == NIMSessionTypeP2P && [notification.sender isEqualToString:self.session.sessionId])
        {
            [self refreshSessionTitle:@"正在输入..."];
            [_titleTimer startTimer:5
                           delegate:self
                            repeats:NO];
        }
    }
}

- (void)onNTESTimerFired:(NTESTimerHolder *)holder {
    [self refreshSessionTitle:self.sessionTitle];
}


#pragma mark - Getter

- (id<NIMSessionConfig>)sessionConfig {
    if (!_sessionConfig) {
        _sessionConfig = [[NTESSessionHistoryConfig alloc] initWithSession:self.session andFirstMsg:self.firstMsg];
    }
    return _sessionConfig;
}

- (NSString *)sessionTitle {
    if ([self.session.sessionId isEqualToString:[NIMSDK sharedSDK].loginManager.currentAccount]) {
        return  @"我的电脑";
    }
    return [super sessionTitle];
}

- (NSString *)sessionSubTitle {
    return @"";
}

- (void)onTextChanged:(id)sender {
    [self.notificationSender sendTypingState:self.session];
}

- (void)onSelectChartlet:(NSString *)chartletId
                 catalog:(NSString *)catalogId {
    NTESChartletAttachment *attachment = [[NTESChartletAttachment alloc] init];
    attachment.chartletId = chartletId;
    attachment.chartletCatalog = catalogId;
    [self sendMessage:[NTESSessionMsgConverter msgWithChartletAttachment:attachment]];
}

#pragma mark - 石头剪子布
- (void)onTapMediaItemJanKenPon:(NIMMediaItem *)item
{
    NTESJanKenPonAttachment *attachment = [[NTESJanKenPonAttachment alloc] init];
    attachment.value = arc4random() % 3 + 1;
    [self sendMessage:[NTESSessionMsgConverter msgWithJenKenPon:attachment]];
}

#pragma mark - 实时语音
- (void)onTapMediaItemAudioChat:(NIMMediaItem *)item
{
    if ([self checkRTSCondition]) {
        //由于音视频聊天里头有音频和视频聊天界面的切换，直接用present的话页面过渡会不太自然，这里还是用push，然后做出present的效果
        NTESAudioChatViewController *vc = [[NTESAudioChatViewController alloc] initWithCallee:self.session.sessionId];
        CATransition *transition = [CATransition animation];
        transition.duration = 0.25;
        transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
        transition.type = kCATransitionPush;
        transition.subtype = kCATransitionFromTop;
        [self.navigationController.view.layer addAnimation:transition forKey:nil];
        self.navigationController.navigationBarHidden = YES;
        [self.navigationController pushViewController:vc animated:NO];
    }
}

#pragma mark - 视频聊天
- (void)onTapMediaItemVideoChat:(NIMMediaItem *)item
{
    if ([self checkRTSCondition]) {
        //由于音视频聊天里头有音频和视频聊天界面的切换，直接用present的话页面过渡会不太自然，这里还是用push，然后做出present的效果
        NTESVideoChatViewController *vc = [[NTESVideoChatViewController alloc] initWithCallee:self.session.sessionId];
        CATransition *transition = [CATransition animation];
        transition.duration = 0.25;
        transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
        transition.type = kCATransitionPush;
        transition.subtype = kCATransitionFromTop;
        [self.navigationController.view.layer addAnimation:transition forKey:nil];
        self.navigationController.navigationBarHidden = YES;
        [self.navigationController pushViewController:vc animated:NO];
    }
}

#pragma mark - 群组会议
- (void)onTapMediaItemTeamMeeting:(NIMMediaItem *)item
{
    if ([self checkRTSCondition])
    {
        NIMTeam *team = [[NIMSDK sharedSDK].teamManager teamById:self.session.sessionId];
        NSString *currentUserID = [[[NIMSDK sharedSDK] loginManager] currentAccount];
        NIMContactTeamMemberSelectConfig *config = [[NIMContactTeamMemberSelectConfig alloc] init];
        config.teamId = team.teamId;
        config.filterIds = @[currentUserID];
        config.needMutiSelected = YES;
        config.maxSelectMemberCount = 8;
        config.showSelectDetail = YES;
        NIMContactSelectViewController *vc = [[NIMContactSelectViewController alloc] initWithConfig:config];
        __weak typeof(self) weakSelf = self;
        vc.finshBlock = ^(NSArray * memeber){
            NSString *me = [NIMSDK sharedSDK].loginManager.currentAccount;
            NTESTeamMeetingCallerInfo *info = [[NTESTeamMeetingCallerInfo alloc] init];
            info.members = [@[me] arrayByAddingObjectsFromArray:memeber];
            info.teamId = team.teamId;
            NTESTeamMeetingViewController *vc = [[NTESTeamMeetingViewController alloc] initWithCallerInfo:info];
            [weakSelf presentViewController:vc animated:NO completion:nil];
        };;
        [vc show];
    }
}

#pragma mark - 文件传输
- (void)onTapMediaItemFileTrans:(NIMMediaItem *)item
{
    NTESFileTransSelectViewController *vc = [[NTESFileTransSelectViewController alloc]
                                             initWithNibName:nil bundle:nil];
    if (self.shouldResetMsg) {
        self.shouldResetMsg = NO;
        __weak typeof(self) wself = self;
//        [self.interactor resetMessages:^(NSError *error) {
//            [wself pushToMediaItemVC:vc];
//        }];
        [wself pushToMediaItemVC:vc];
    }
    else {
        [self pushToMediaItemVC:vc];
    }
    
}

- (void)pushToMediaItemVC:(NTESFileTransSelectViewController *)vc {
    __weak typeof(self) wself = self;
    vc.completionBlock = ^void(id sender,NSString *ext){
        if ([sender isKindOfClass:[NSString class]]) {
            [wself sendMessage:[NTESSessionMsgConverter msgWithFilePath:sender]];
        }else if ([sender isKindOfClass:[NSData class]]){
            [wself sendMessage:[NTESSessionMsgConverter msgWithFileData:sender extension:ext]];
        }
    };
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 阅后即焚
- (void)onTapMediaItemSnapChat:(NIMMediaItem *)item
{
    UIActionSheet *sheet;
    BOOL isCamraAvailable = [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
    if (isCamraAvailable) {
        sheet = [[UIActionSheet alloc] initWithTitle:@"请选择" delegate:nil cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"从相册中选取",@"拍照",nil];
    }else{
        sheet = [[UIActionSheet alloc] initWithTitle:@"请选择" delegate:nil cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"从相册中选取",nil];
    }
    __weak typeof(self) wself = self;
    [sheet showInView:self.view completionHandler:^(NSInteger index) {
        switch (index) {
            case 0:{
                //相册
                [wself.mediaFetcher fetchPhotoFromLibrary:^(NSArray *images, NSString *path, PHAssetMediaType type){
                    if (images.count) {
                        [wself sendSnapchatMessage:images.firstObject];
                    }
                    if (path) {
                        [wself sendSnapchatMessagePath:path];
                    }
                }];
                
            }
                break;
            case 1:{
                //相机
                [wself.mediaFetcher fetchMediaFromCamera:^(NSString *path, UIImage *image) {
                    if (image) {
                        [wself sendSnapchatMessage:image];
                    }
                }];
            }
                break;
            default:
                return;
        }
    }];
}

- (void)sendSnapchatMessagePath:(NSString *)path
{
    NTESSnapchatAttachment *attachment = [[NTESSnapchatAttachment alloc] init];
    [attachment setImageFilePath:path];
    [self sendMessage:[NTESSessionMsgConverter msgWithSnapchatAttachment:attachment]];
}

- (void)sendSnapchatMessage:(UIImage *)image
{
    NTESSnapchatAttachment *attachment = [[NTESSnapchatAttachment alloc] init];
    [attachment setImage:image];
    [self sendMessage:[NTESSessionMsgConverter msgWithSnapchatAttachment:attachment]];
}

#pragma mark - 白板
- (void)onTapMediaItemWhiteBoard:(NIMMediaItem *)item
{
    NTESWhiteboardViewController *vc = [[NTESWhiteboardViewController alloc] initWithSessionID:nil
                                                                                        peerID:self.session.sessionId
                                                                                         types:NIMRTSServiceReliableTransfer | NIMRTSServiceAudio
                                                                                          info:@"白板演示"];
    [self presentViewController:vc animated:NO completion:nil];
}

#pragma mark - 提示消息
- (void)onTapMediaItemTip:(NIMMediaItem *)item
{
    UIAlertView *alert =[[UIAlertView alloc] initWithTitle:nil message:@"输入提醒" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alert showAlertWithCompletionHandler:^(NSInteger index) {
        switch (index) {
            case 1:{
                UITextField *textField = [alert textFieldAtIndex:0];
                NIMMessage *message = [NTESSessionMsgConverter msgWithTip:textField.text];
                [self sendMessage:message];
                
            }
                break;
            default:
                break;
        }
    }];
}

#pragma mark - 红包
- (void)onTapMediaItemRedPacket:(NIMMediaItem *)item
{
    [[NTESRedPacketManager sharedManager] sendRedPacket:self.session];
}


#pragma mark - 辅助方法
- (void)sendImageMessagePath:(NSString *)path
{
    
    [self sendSnapchatMessagePath:path];
}


- (BOOL)checkRTSCondition
{
    BOOL result = YES;
    
    if (![[Reachability reachabilityForInternetConnection] isReachable])
    {
        [self.view makeToast:@"请检查网络" duration:2.0 position:CSToastPositionCenter];
        result = NO;
    }
    NSString *currentAccount = [[NIMSDK sharedSDK].loginManager currentAccount];
    if (self.session.sessionType == NIMSessionTypeP2P && [currentAccount isEqualToString:self.session.sessionId])
    {
        [self.view makeToast:@"不能和自己通话哦" duration:2.0 position:CSToastPositionCenter];
        result = NO;
    }
    if (self.session.sessionType == NIMSessionTypeTeam)
    {
        NIMTeam *team = [[NIMSDK sharedSDK].teamManager teamById:self.session.sessionId];
        NSInteger memberNumber = team.memberNumber;
        if (memberNumber < 2)
        {
            [self.view makeToast:@"无法发起，群人数少于2人" duration:2.0 position:CSToastPositionCenter];
            result = NO;
        }
    }
    return result;
}

- (NSDictionary *)cellActions
{
    static NSDictionary *actions = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        actions = @{@(NIMMessageTypeImage) :    @"showImage:",
                    @(NIMMessageTypeVideo) :    @"showVideo:",
                    @(NIMMessageTypeLocation) : @"showLocation:",
                    @(NIMMessageTypeFile)  :    @"showFile:",
                    @(NIMMessageTypeCustom):    @"showCustom:"};
    });
    return actions;
}

- (NIMKitMediaFetcher *)mediaFetcher
{
    if (!_mediaFetcher) {
        _mediaFetcher = [[NIMKitMediaFetcher alloc] init];
        _mediaFetcher.limit = 1;
        _mediaFetcher.mediaTypes = @[(NSString *)kUTTypeImage];;;
    }
    return _mediaFetcher;
}

- (void)didPullUpMessageData {
    __weak typeof(self) wself = self;
//    [self.interactor pullUpMessages:^(NSArray *messages, NSError *error) {
//        [self.tableView reloadData];
//        if ([wself.interactor shouldHandleReceipt] && messages.count) {
//            [wself.interactor checkReceipt];
//        }
//    }];

}

@end
