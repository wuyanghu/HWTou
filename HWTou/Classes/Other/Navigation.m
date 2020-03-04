//
//  Navigation.m
//  HWTou
//
//  Created by Reyna on 2017/11/27.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "Navigation.h"
#import "AccountManager.h"

/** Root */
#import "CustomNavigationController.h"

/** Record */
#import "AudioRecordViewController.h"
#import "AudioPlayViewController.h"

/** Radio */
#import "AudioPlayerViewController.h"
#import "SubCommentViewController.h"
#import "PlayerHistoryViewController.h"
#import "PlayerHistoryModel.h"
#import "PlayerHistoryManager.h"
#import "PlayerDetailViewModel.h"

/** 资金相关 */
#import "MyWalletViewController.h"
#import "WithdrawMoneyViewController.h"

//个人主页
#import "PersonalHomePageViewController.h"
//banner
#import "HomeBannerListModel.h"
#import "ComFloorEvent.h"

#import "AccountManager.h"
//达人主播
#import "PersonHomeReq.h"
#import "ExpertAnchorStatusViewController.h"
#import "TopicWorkDetailModel.h"
//图文展示
#import "ImageTextViewController.h"
#import "ComWebViewController.h"

#import "AnswerLsRequest.h"
#import "AnswerlrViewModel.h"
#import "PublicHeader.h"
#import "AnswerlrCountDownViewController.h"
#import "AnswerlrViewController.h"
#import "SocialThirdController.h"

//直播
#import "GuessULikeModel.h"
#import "GetChatInfoModel.h"
//#import "NTESAnchorLiveViewController.h"
//#import "NTESDemoService.h"
#import "SVProgressHUD.h"
#import "UIView+Toast.h"
//#import "NTESLiveManager.h"
//#import "NSDictionary+NTESJson.h"
//#import "NTESCustomKeyDefine.h"
//#import "NTESLiveUtil.h"
#import "RotRequest.h"

//#import "NTESBundleSetting.h"
//#import "NTESChatroomManager.h"
//#import "NTESLiveViewController.h"
//#import "NTESAudienceLiveViewController.h"
#import "AccountManager.h"
#import "SaveRoomInfoModel.h"
#import "HUDProgressTool.h"

extern BOOL enteringChatroom = NO;

@interface Navigation()

@end

@implementation Navigation

#pragma mark - 直播
//进行主播
//进入直播
+ (void)joinPushLiveRoom:(UIViewController *)from model:(GuessULikeModel *)model{
//    [NTESLiveManager sharedInstance].type = NIMNetCallMediaTypeAudio;
//    [NTESLiveManager sharedInstance].liveQuality = NTESLiveQualityNormal;
//    [NTESLiveManager sharedInstance].role = NTESLiveRoleAnchor;
//    __weak typeof(from) wself = from;
//    NSString *errorToast = @"进入失败，请重试";
//
//    [SVProgressHUD show];
//
//    NTESLiveManager * liveManager = [NTESLiveManager sharedInstance];
//    [liveManager setMeetingName:[NSUUID UUID].UUIDString];
//    GetChatInfoParam * infoParam = [GetChatInfoParam new];
//    infoParam.rtcId = model.rtcId;
//    [RotRequest getChatInfo:infoParam Success:^(DictResponse *response) {
//        [SVProgressHUD dismiss];
//
//        if (response.status == 200) {
//            GetChatInfoModel * chatInfoModel = [GetChatInfoModel new];
//            [chatInfoModel setValuesForKeysWithDictionary:response.data];
//
//            NIMChatroom *chatroom = [[NIMChatroom alloc] init];
//            chatroom.roomId  = [NSString stringWithFormat:@"%ld",model.roomId];
//            chatroom.name    = chatInfoModel.chatName;
//            chatroom.creator = [[AccountManager shared] account].userName;
//            chatroom.announcement = chatInfoModel.chatContent;
//            chatroom.onlineUserCount = chatInfoModel.lookNum;
//
//            SaveRoomInfoParam * saveRoomInfoParam = [SaveRoomInfoParam new];
//            saveRoomInfoParam.rtcId = model.rtcId;
//            saveRoomInfoParam.acType = 1;
//            saveRoomInfoParam.roomName = liveManager.meetingName;
//
//            [RotRequest saveRoomInfo:saveRoomInfoParam Success:^(DictResponse *response) {
//                if (response.status == 200) {
//                    SaveRoomInfoModel * saveRoomInfoModel = [SaveRoomInfoModel new];
//                    [saveRoomInfoModel setValuesForKeysWithDictionary:response.data];
//                    saveRoomInfoModel.isSuperManager = model.isSuperManager;
//
//                    NSString *liveUrl = saveRoomInfoModel.pushUrl;
//                    NSString *pullUrl = saveRoomInfoModel.rtmpPullUrl;
//
//                    NSDictionary * liveDic = @{@"pushUrl" : liveUrl,
//                                               @"pullUrl": pullUrl};
//                    chatroom.ext = [NTESLiveUtil dataTojsonString:liveDic];
//
//                    if (liveUrl.length) {
//                        chatroom.broadcastUrl = liveUrl;
//                    }
//
//                    NIMChatroomEnterRequest *request = [[NIMChatroomEnterRequest alloc] init];
//                    request.roomId = chatroom.roomId;
//                    request.roomNotifyExt = [@{
//                                               NTESCMType  : @([NTESLiveManager sharedInstance].type),
//                                               NTESCMMeetingName: liveManager.meetingName
//                                               } jsonBody];
//
//                    [[NIMSDK sharedSDK].chatroomManager enterChatroom:request completion:^(NSError *error, NIMChatroom *room, NIMChatroomMember *me) {
//                        [SVProgressHUD dismiss];
//                        if (!error) {
//                            //这里拿到的是应用服务器的人数，没有把自己加进去，手动添加。
//                            chatroom.onlineUserCount++;
//                            //将room的扩展也加进去
//                            chatroom.ext =[NTESLiveUtil jsonString:chatroom.ext addJsonString:request.roomNotifyExt];
//
//                            [[NTESLiveManager sharedInstance] cacheMyInfo:me roomId:request.roomId];
//                            [[NTESLiveManager sharedInstance] cacheChatroom:chatroom];
//
//                            NTESAnchorLiveViewController *vc = [[NTESAnchorLiveViewController alloc]initWithChatroom:chatroom saveRoomInfoModel:saveRoomInfoModel chatInfoModel:chatInfoModel];
//                            vc.rtcId = model.rtcId;
//                            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
//                            [nav setNavigationBarHidden:YES animated:YES];
//                            [from presentViewController:nav animated:YES completion:nil];
//
//                        }
//                        else
//                        {
//                            DDLogError(@"enter chat room error , code : %zd",error.code);
//                            [wself.view makeToast:errorToast duration:2.0 position:CSToastPositionCenter];
//                        }
//                    }];
//                }else{
//                    [wself.view makeToast:response.msg duration:2.0 position:CSToastPositionCenter];
//                }
//            } failure:^(NSError *error) {
//                [wself.view makeToast:@"网络繁忙" duration:2.0 position:CSToastPositionCenter];
//            }];
//
//        }else{
//            [wself.view makeToast:errorToast duration:2.0 position:CSToastPositionCenter];
//        }
//    } failure:^(NSError *error) {
//        [SVProgressHUD dismiss];
//        DDLogError(@"request stream error , code : %zd",error.code);
//        [wself.view makeToast:errorToast duration:2.0 position:CSToastPositionCenter];
//    }];
}

//观看直播
+ (void)lookLiveRoom:(UIViewController *)from model:(GuessULikeModel *)model
{
//    if ([AccountManager isNeedLogin]) {
//        [AccountManager showLoginView];
//        return;
//    }
//
//    [NTESLiveManager sharedInstance].type = NIMNetCallMediaTypeAudio;
//    [NTESLiveManager sharedInstance].liveQuality = NTESLiveQualityNormal;
//    [NTESLiveManager sharedInstance].role = NTESLiveRoleAudience;
//
//    [SVProgressHUD show];
//    __weak typeof(from) wself = from;
//    NSString *errorToast = @"进入失败，请重试";
//
//    GetChatInfoParam * infoParam = [GetChatInfoParam new];
//    infoParam.rtcId = model.rtcId;
//    [RotRequest getChatInfo:infoParam Success:^(DictResponse *response) {
//        [SVProgressHUD dismiss];
//
//        if (response.status == 200) {
//            GetChatInfoModel * chatInfoModel = [GetChatInfoModel new];
//            [chatInfoModel setValuesForKeysWithDictionary:response.data];
//
//            [NTESLiveManager sharedInstance].orientation = NIMVideoOrientationPortrait;
//            [NTESLiveManager sharedInstance].type = NIMNetCallMediaTypeAudio;
//
//            if (chatInfoModel.isAnchor == 1) {//有主播
//                NSLog(@"有直播");
//                GetChatInfoParam * chatInfoParam = [GetChatInfoParam new];
//                chatInfoParam.rtcId = model.rtcId;
//                [RotRequest getRoomInfo:chatInfoParam Success:^(DictResponse *response) {
//                    if (response.status == 200) {
//                        SaveRoomInfoModel * roomInfoModel = [SaveRoomInfoModel new];
//                        [roomInfoModel setValuesForKeysWithDictionary:response.data];
//                        roomInfoModel.isSuperManager = model.isSuperManager;
//                        //这里拿到的是应用服务器的人数，没有把自己加进去，手动添加。
//
//                        NTESAudienceLiveViewController *vc = [[NTESAudienceLiveViewController alloc] initWithChatroomId:[NSString stringWithFormat:@"%ld",model.roomId] streamUrl:roomInfoModel.rtmpPullUrl roomInfoModel:roomInfoModel chatInfoModel:chatInfoModel];
//                        vc.rtcId = model.rtcId;
//                        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
//                        [nav setNavigationBarHidden:YES animated:YES];
//                        [wself presentViewController:nav animated:YES completion:nil];
//                    }
//                } failure:^(NSError *error) {
//                    [wself.view makeToast:errorToast duration:2.0 position:CSToastPositionCenter];
//                }];
//            }else{//没有直播
//                NSLog(@"没有直播");
//                SaveRoomInfoModel * roomInfoModel = [SaveRoomInfoModel new];
//                roomInfoModel.isSuperManager = model.isSuperManager;
//                roomInfoModel.chatId = model.rtcId;
//                NTESAudienceLiveViewController *vc = [[NTESAudienceLiveViewController alloc] initWithChatroomId:[NSString stringWithFormat:@"%ld",model.roomId] streamUrl:nil roomInfoModel:roomInfoModel chatInfoModel:chatInfoModel];
//                vc.rtcId = model.rtcId;
//                UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
//                [nav setNavigationBarHidden:YES animated:YES];
//                [wself presentViewController:nav animated:YES completion:nil];
//
//            }
//
//        }else{
//            [wself.view makeToast:response.msg duration:1.0 position:CSToastPositionCenter];
//        }
//    } failure:^(NSError *error) {
//        [SVProgressHUD dismiss];
//        DDLogError(@"request stream error , code : %zd",error.code);
//        [wself.view makeToast:errorToast duration:1.0 position:CSToastPositionCenter];
//    }];
    
}

//进入聊天室
+ (void)joinChatRoom:(UIViewController *)from model:(GuessULikeModel *)model{
//    if (enteringChatroom) {
//        return;
//    }
//    
//    NIMUser *user = [[NIMSDK sharedSDK].userManager userInfo:[NIMSDK sharedSDK].loginManager.currentAccount];
//    NIMChatroomEnterRequest *request = [[NIMChatroomEnterRequest alloc] init];
//    request.roomId = [NSString stringWithFormat:@"%ld",model.roomId];
//    request.roomNickname = user.userInfo.nickName;
//    request.roomAvatar = user.userInfo.avatarUrl;
//    request.retryCount = [[NTESBundleSetting sharedConfig] chatroomRetryCount];
//    [SVProgressHUD show];
//    enteringChatroom = YES;
//    __weak typeof(from) wself = from;
//    [[[NIMSDK sharedSDK] chatroomManager] enterChatroom:request
//                                             completion:^(NSError *error,NIMChatroom *chatroom,NIMChatroomMember *me) {
//                                                 [SVProgressHUD dismiss];
//                                                 enteringChatroom = NO;
//                                                 if (error == nil)
//                                                 {
//                                                     [[NTESChatroomManager sharedInstance] cacheMyInfo:me roomId:chatroom.roomId];
//                                                     
//                                                     NTESLiveViewController *vc = [[NTESLiveViewController alloc] initWithChatroom:chatroom];
//                                                     [from.navigationController pushViewController:vc animated:YES];
//                                                 }
//                                                 else
//                                                 {
//                                                     NSString *toast = [NSString stringWithFormat:@"进入失败 code:%zd",error.code];
//                                                     [wself.view makeToast:toast duration:2.0 position:CSToastPositionCenter];
//                                                     DDLogError(@"enter room %@ failed %@",chatroom.roomId,error);
//                                                 }
//                                                 
//                                             }];
}

#pragma mark - Record

+ (void)showAudioRecordViewController:(UIViewController *)from {
    AudioRecordViewController *recordVC = [[AudioRecordViewController alloc] init];
//    CustomNavigationController *nav = [[CustomNavigationController alloc] initWithRootViewController:recordVC];
//    [from presentViewController:nav animated:NO completion:nil];
    [from.navigationController pushViewController:recordVC animated:YES];
}

+ (void)showAudioPlayViewController:(UIViewController *)from {
    AudioPlayViewController *playVC = [[AudioPlayViewController alloc] init];
    [from.navigationController pushViewController:playVC animated:YES];
}

#pragma mark - Radio

+ (void)showAudioPlayerViewController:(UIViewController *)from radioModel:(id)model completion:(void (^)())completion {
    
    if ([AccountManager isNeedToken]) {
        [AccountManager showLoginView];
        return;
    }
    
    AudioPlayerViewController *vc = [[AudioPlayerViewController alloc] init];
    if (model) {
        if ([model isKindOfClass:[PlayerHistoryModel class]]) {
            vc.historyModel = (PlayerHistoryModel *)model;
        }
        else {
            PlayerHistoryModel *hm = [[PlayerHistoryModel alloc] init];
            [hm contentSelfWithPlayerModel:model];
            vc.historyModel = hm;
        }
    }
    else {
        PlayerHistoryModel *hisM = [[PlayerHistoryManager sharedInstance] readNewestPlayerHistoryModel];
        vc.historyModel = hisM;
    }
    CustomNavigationController *nav = [[CustomNavigationController alloc] initWithRootViewController:vc];
    [from presentViewController:nav animated:YES completion:completion];
}

+ (void)showAudioPlayerViewController:(UIViewController *)from radioModel:(id)model {
    
    if ([AccountManager isNeedToken]) {
        [AccountManager showLoginView];
        return;
    }
    
    AudioPlayerViewController *vc = [[AudioPlayerViewController alloc] init];
    if (model) {
        if ([model isKindOfClass:[PlayerHistoryModel class]]) {
            vc.historyModel = (PlayerHistoryModel *)model;
            if (vc.historyModel.flag == 3) {
                GuessULikeModel * ulikeModel = [GuessULikeModel new];
                ulikeModel.roomId = vc.historyModel.roomId;
                ulikeModel.rtcId = vc.historyModel.rtcId;
                
                [self lookLiveRoom:from model:ulikeModel];
                return;
            }
        }
        else {
            PlayerHistoryModel *hm = [[PlayerHistoryModel alloc] init];
            [hm contentSelfWithPlayerModel:model];
            vc.historyModel = hm;
        }
    }
    else {
        PlayerHistoryModel *hisM = [[PlayerHistoryManager sharedInstance] readNewestPlayerHistoryModel];
        vc.historyModel = hisM;
    }
    CustomNavigationController *nav = [[CustomNavigationController alloc] initWithRootViewController:vc];
    [from presentViewController:nav animated:YES completion:nil];
}

+ (void)showSubCommentViewController:(UIViewController *)from model:(PlayerCommentModel *)model PlayerHistoryModel:(PlayerHistoryModel *)historyModel playerDetailViewModel:(PlayerDetailViewModel *)playerDetailViewModel{
    
    SubCommentViewController *vc = [[SubCommentViewController alloc] init];
    vc.model = model;
    vc.historyModel = historyModel;
    vc.playerDetailViewModel = playerDetailViewModel;
    [from.navigationController pushViewController:vc animated:YES];
}

+ (void)showPlayerHistoryViewController:(UIViewController *)from {
    
    PlayerHistoryViewController *vc = [[PlayerHistoryViewController alloc] init];
    [from.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 个人主页
+ (void)showPersonalHomePageViewController:(UIViewController *)from attendType:(PersonHomePageButtonType)attendType uid:(NSInteger)uid {
    if ([AccountManager isNeedLogin]) {
        [AccountManager showLoginView];
        return;
    }
    
    if (attendType == editDataButtonType) {
        
        [CollectSessionReq getTopicWorkDetail:[BaseParam new] Success:^(TopicWorkDetailResponse *response) {
            if (response.status == 200) {
                TopicWorkDetailModel * detailModel = [TopicWorkDetailModel new];
                [detailModel setValuesForKeysWithDictionary:response.data];
                PersonalHomePageViewController * pageVC = [[PersonalHomePageViewController alloc] init];
                
                //如果是达人主播，进工作台
                if (detailModel.isTopicM == 1) {//工作台
                    pageVC.isHost = YES;
                }else{//申请达人主播
                    pageVC.isHost = NO;
                }
                
                pageVC.uid = uid;
                pageVC.buttonType = attendType;
                [from.navigationController pushViewController:pageVC animated:YES];
                
            }else {
                [HUDProgressTool showOnlyText:@"获取达人主播状态失败"];
            }
        } failure:^(NSError *error) {
            [HUDProgressTool showErrorWithText:ReqErrCode_Custom_ErrorInfo];
        }];
    }else{
        PersonalHomePageViewController * pageVC = [[PersonalHomePageViewController alloc] init];
        pageVC.uid = uid;
        pageVC.buttonType = attendType;
        pageVC.isHost = NO;
        [from.navigationController pushViewController:pageVC animated:YES];
    }
    
}

#pragma mark - banner页跳转
+ (void)showBanner:(UIViewController *)from bannerModel:(HomeBannerListModel *)bannerModel{
    if (bannerModel.clickType == 1) {
        [self showImageTextViewController:from bannerModel:bannerModel];
    }else if (bannerModel.clickType == 2) {
        if ([bannerModel.linkUrl isEqualToString:@""] || bannerModel.linkUrl == nil) {
            return;
        }
        AccountModel *account = [[AccountManager shared] account];
        
        FloorItemDM * itemDM = [FloorItemDM new];
        itemDM.type = FloorEventParam;
        itemDM.title = bannerModel.title;
        NSString * nickname = [account.nickName stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        itemDM.param = [NSString stringWithFormat:@"%@?uid=%ld&phone=%@&nickname=%@&type=1&token=%@",bannerModel.linkUrl,account.uid,account.userName,nickname,account.token];
        [ComFloorEvent handleEventWithFloor:itemDM];
    }else if(bannerModel.clickType == 3 || bannerModel.clickType == 5 || bannerModel.clickType == 7){
        [self showAudioPlayerViewController:from radioModel:bannerModel];
    }else if (bannerModel.clickType == 11){//答题专场
        [self showAnswerViewController:from bannerModel:bannerModel];
    }
}

#pragma mark - 答题车神

+ (void)showAnswerViewController:(UIViewController *)from bannerModel:(HomeBannerListModel *)bannerModel{
    [self getServeDate:bannerModel.rtcId from:from isBanner:YES];
}

//////倒计时
//获取服务时间
+ (void)getActivity:(NSInteger)specId from:(UIViewController *)from{
    GetActivityParam * activityParam = [GetActivityParam new];
    activityParam.specId = specId;
    AnswerlrViewModel * answerlrViewModel = [AnswerlrViewModel sharedInstance];

    [AnswerLsRequest getActivity:activityParam Success:^(AnswerLsDict *response) {
        if (response.status == 200) {
            [answerlrViewModel bindGetActivityModel:response.data];
            
            double startTime = answerlrViewModel.startTime;
            double serverTimeDouble = answerlrViewModel.serverTimeDouble;
            double interval = serverTimeDouble-startTime;
            if (interval<0) {
                answerlrViewModel.isContinueAnswer = YES;
            }else{
                //正在进行
                answerlrViewModel.isContinueAnswer = NO;
            }
            [self pushAnswerlrViewController:answerlrViewModel from:from];
        }else{
            [HUDProgressTool showErrorWithText:response.msg];
            [answerlrViewModel stopTime];
        }
    } failure:^(NSError *error) {
        
    }];
}
//获取服务时间
+ (void)getServeDate:(NSInteger)specId from:(UIViewController *)from isBanner:(BOOL)isBanner{
    [AnswerLsRequest getDate:nil Success:^(AnswerLsDate *response) {
        if (response.status == 200) {
            AnswerlrViewModel * answerlrViewModel = [AnswerlrViewModel sharedInstance];
            
            [answerlrViewModel bindServerTime:response.data];
            [answerlrViewModel keepTime];
            
            if (isBanner) {
                GetActivityParam * activityParam = [GetActivityParam new];
                activityParam.specId = specId;
                [AnswerLsRequest getSpecList:activityParam Success:^(AnswerLsArray *response) {
                    if (response.status == 200) {
                        NSArray * array = response.data;
                        if (array.count!=0) {
                            NSDictionary * dict = array[0];
                            GetSpecListModel * specModel = [GetSpecListModel new];
                            [specModel setValuesForKeysWithDictionary:dict];
                            specModel.specId = [dict[@"id"] integerValue];
                            
                            answerlrViewModel.selectSpecModel = specModel;
                        }
                        [self getActivity:specId from:from];
                    }
                } failure:^(NSError *error) {
                    
                }];
            }else{
                [self getActivity:specId from:from];
            }
        }
    } failure:^(NSError *error) {
        
    }];
}

+ (void)pushAnswerlrViewController:(AnswerlrViewModel *)answerlrViewModel from:(UIViewController *)from{
    
    if ([AccountManager isNeedLogin]) {
        [AccountManager showLoginView];
        return;
    }
    
    AnswerlrViewController * lrVC = [[AnswerlrViewController alloc] initWithNibName:@"AnswerlrViewController" bundle:nil];
    lrVC.viewModel = answerlrViewModel;
    [from.navigationController pushViewController:lrVC animated:YES];
}

#pragma mark - 达人主播h5
+ (void)showExpertAnchorHtml5:(UIViewController *)from detailModel:(TopicWorkDetailModel *)detailModel{
    AccountManager * accountManger = [AccountManager shared];
    LookCheckStatusPram * statusPram = [LookCheckStatusPram new];
    statusPram.uid = accountManger.account.uid;
    [PersonHomeRequest lookCheckStatus:statusPram Success:^(LookCheckStatusResponse *response2) {
        if (response2.status == 200) {
            NSInteger checkStatus = [response2.data[@"checkStatus"] integerValue];
            if (checkStatus == 4) {
                [self intelligenThtml5:detailModel];
            }else if(checkStatus == 0 || checkStatus == 2){
                ExpertAnchorStatusViewController * statusVC = [[ExpertAnchorStatusViewController alloc] initWithNibName:@"ExpertAnchorStatusViewController" bundle:nil];
                statusVC.checkStatus = checkStatus;
                statusVC.statusVCBlock = ^() {
                    [self intelligenThtml5:detailModel];
                };
                [from.navigationController pushViewController:statusVC animated:YES];
            }else if (checkStatus == 1){
                [HUDProgressTool showSuccessWithText:@"您已是主播!"];
            }
            
        }
    } failure:^(NSError *error) {
        
    }];
}


//达人主播
+ (void)intelligenThtml5:(TopicWorkDetailModel *)detailModel{
    AccountManager * accountManger = [AccountManager shared];
    NSString * uid = [NSString stringWithFormat:@"%ld",accountManger.account.uid];
    NSString * phoneNumber = accountManger.account.userName;
    
    NSString *unicodeStr = [detailModel.nickname stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString * usrString = [NSString stringWithFormat:@"%@?uid=%@&phone=%@&nickname=%@",kApiAapplyH5ServerHost,uid,phoneNumber,unicodeStr];
    FloorItemDM * itemDM = [FloorItemDM new];
    itemDM.type = FloorEventLink;
    itemDM.param = usrString;
    itemDM.title = @"我要做主播";
    [ComFloorEvent handleEventWithFloor:itemDM];
}

#pragma mark - showWebViewController

+ (void)showWebViewController:(UIViewController *)from webLink:(NSString *)webLink {
    
    AccountModel *account = [[AccountManager shared] account];
    
    FloorItemDM * itemDM = [FloorItemDM new];
    itemDM.type = FloorEventParam;
    itemDM.title = @"推送消息";
    NSString * nickname = [account.nickName stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    itemDM.param = [NSString stringWithFormat:@"%@?uid=%ld&phone=%@&nickname=%@",webLink,account.uid,account.userName,nickname];
    [ComFloorEvent handleEventWithFloor:itemDM];
}

#pragma mark - 图文展示
+ (void)showImageTextViewController:(UIViewController *)from bannerModel:(HomeBannerListModel *)bannerModel{
    ImageTextViewController * textVC = [[ImageTextViewController alloc] init];
    textVC.bannerModel = bannerModel;
    [from.navigationController pushViewController:textVC animated:YES];
}

#pragma mark - 跳转到答题车神分享

+ (void)showAnswerShareViewController:(UIViewController *)from title:(NSString *)title webLink:(NSString *)webLink{
    UserInfoParam * param = [UserInfoParam new];
    param.uid = 0;
    [PersonHomeRequest getUserInfo:param Success:^(PersonHomeResponse *response) {
        if (response.status == 200) {
            NSString * unicodetitle = [title stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

            NSString * unicodenickname = [response.data.nickname stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            NSString * webLinkUrl = [NSString stringWithFormat:@"%@?qrcode=%@&nickname=%@&title=%@",webLink,response.data.inviteCode,unicodenickname,unicodetitle];
            
            [SocialThirdController shareWebLink:webLinkUrl title:title content:@"发耶APP-用声音打开美好艺术" thumbnail:[UIImage imageNamed:@"share_icon"] completed:^(BOOL success, NSString *errMsg) {
                if (success) {
                    [HUDProgressTool showOnlyText:@"已分享"];
                } else {
                    [HUDProgressTool showOnlyText:errMsg];
                }
            }];
        }
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark - 资金相关

+ (void)showMyWalletViewController:(UIViewController *)from {
    MyWalletViewController *vc = [[MyWalletViewController alloc] init];
    
    [from.navigationController pushViewController:vc animated:YES];
}

+ (void)showWithdrawMoneyViewController:(UIViewController *)from {
    
    WithdrawMoneyViewController *vc = [[WithdrawMoneyViewController alloc] init];
    [from.navigationController pushViewController:vc animated:YES];
}

@end
