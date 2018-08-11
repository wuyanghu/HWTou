//
//  NTESLiveInnerView.m
//  NIMLiveDemo
//
//  Created by chris on 16/4/4.
//  Copyright © 2016年 Netease. All rights reserved.
//

#import "NTESLiveInnerView.h"
#import "NTESLiveChatView.h"
#import "NTESLiveLikeView.h"
#import "NTESLivePresentView.h"
#import "NTESLiveCoverView.h"
#import "NTESLiveroomInfoView.h"
#import "NTESTextInputView.h"
#import "NTESLiveManager.h"
#import "UIView+NTES.h"
#import "NTESLiveActionView.h"
#import "NTESTimerHolder.h"
#import "NTESLiveBypassView.h"
#import "NTESMicConnector.h"
#import "NTESGLView.h"
#import "NTESAnchorMicView.h"
#import "NTESNetStatusView.h"
#import "NTESCameraZoomView.h"
#import "NoLiveFooterView.h"
#import "LiveNaviBar.h"
#import "NoLiveHeaderView.h"
#import "LiveHeaderView.h"
#import "LiveFooterView.h"
#import "AnchorFooterView.h"
#import "AnchorMoreFooterView.h"
#import "NTESMessageModel.h"
#import "LiveSuperManagerFooterView.h"
#import "SuperManagerView.h"
#import "UIView+Toast.h"
#import "PersonHomeReq.h"
#import "AccountManager.h"
#import "HUDProgressTool.h"
#import "LiveAttendView.h"
#import "UIApplication+Extension.h"
#import "Navigation.h"
#import "RedPacketIsHaveTipView.h"
#import "PlayerCommentModel.h"
#import "GetRedPacketCardView.h"
#import "NTESGrowingTextView.h"
#import "DeviceInfoTool.h"
#import "RadioSessionReq.h"
#import "ReplyStyleView.h"
#import "TZImagePickerController.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "UtilsMacro.h"
#import "ComFloorEvent.h"
#import "SocialThirdController.h"

@interface NTESLiveInnerView()<NTESLiveActionViewDelegate,NTESTextInputViewDelegate,NTESTimerHolderDelegate,NTESLiveBypassViewDelegate,NTESLiveCoverViewDelegate,NTESLiveChatViewDelegate,NoLiveFooterViewDelegate,LiveNaviBarProtocol,AnchorFooterViewDelegate,AnchorMoreFooterViewDelegate,SuperManagerViewDelegate,LiveSuperManagerFooterViewDelegate,LiveFooterViewDelegate,LiveHeaderViewDelegate,NoLiveHeaderViewDelegate,LiveAttendViewDelegate,RedPacketIsHaveTipViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,TZImagePickerControllerDelegate>{
    CGFloat _keyBoradHeight;
    NTESTimerHolder *_timer;
    CALayer *_cameraLayer;
    CGSize _lastRemoteViewSize;
}

@property (nonatomic, strong) UIButton *startLiveButton;          //开始直播按钮
@property (nonatomic, strong) UIButton *closeButton;              //关闭直播按钮
@property (nonatomic, strong) UIButton *cameraButton;             //相机反转按钮

@property (nonatomic, copy)   NSString *roomId;                   //聊天室ID

@property (nonatomic, strong) NTESLiveroomInfoView *infoView;      //直播间信息视图
@property (nonatomic, strong) NTESTextInputView    *textInputView; //输入框
@property (nonatomic, strong) NTESLiveChatView     *chatView;      //聊天窗
@property (nonatomic, strong) NTESLiveActionView   *actionView;    //操作条
@property (nonatomic, strong) NTESLiveLikeView     *likeView;      //爱心视图
@property (nonatomic, strong) NTESLivePresentView  *presentView;   //礼物到达视图
@property (nonatomic, strong) NTESLiveCoverView    *coverView;     //状态覆盖层

@property (nonatomic,strong) NoLiveFooterView * noLiveFooterView;//无直播操作条
@property (nonatomic,strong) NoLiveHeaderView * noLiveHeaderView;//无主播头部
@property (nonatomic,strong) LiveNaviBar * naviBar;//导航栏
@property (nonatomic,strong) LiveHeaderView * liveHeaderView;//有主播头部(观众)
@property (nonatomic,strong) LiveFooterView * liveFooterView;//有主播底部(观众)
@property (nonatomic,strong) AnchorFooterView * anchorFooterView;//主播端

@property (nonatomic,strong) LiveAttendView * liveAttendView;//关注
@property (nonatomic,strong) ReplyStyleView * replyStyleView;//回复
@property (nonatomic, strong) UIControl *replyBackView;//评论背景层

@property (nonatomic,strong) LiveSuperManagerFooterView * liveSuperManagerFooterView;//超级管理员
@property (nonatomic,strong) SuperManagerView * superManagerView;

@property (nonatomic, strong) NTESLiveBypassView   *bypassView;    //互动直播的小视图
@property (nonatomic, strong) NTESGLView           *glView;        //接收YUV数据的视图
@property (nonatomic, strong) NTESAnchorMicView    *micView;       //主播是音视频的时候的麦克风图
@property (nonatomic, strong) UILabel              *bypassNickLabel; //互动直播昵称
@property (nonatomic, strong) UILabel              *roomIdLabel;      //房间ID

@property (nonatomic, strong) NTESNetStatusView    *netStatusView;    //网络状态视图

@property (nonatomic, strong) NTESCameraZoomView   *cameraZoomView;

@property (nonatomic) BOOL isActionViewMoveUp;    //actionView上移标识

@end

@implementation NTESLiveInnerView

- (instancetype)initWithChatroom:(NSString *)chatroomId
                           frame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _roomId = chatroomId;
        [self setup];
    }
    return self;
}


- (void)dealloc{
//    [_chatView.tableView removeObserver:self forKeyPath:@"contentOffset"];
//    [_micView removeObserver:self forKeyPath:@"hidden"];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [_timer stopTimer];
}

#pragma mark - Public
- (void)addMessages:(NSArray<NIMMessage *> *)messages
{
    [self.chatView addMessages:messages];
}

- (void)addPresentMessages:(NSArray<NIMMessage *> *)messages
{
    for (NIMMessage *message in messages) {
        [self.presentView addPresentMessage:message];
    }
}

- (void)resetZoomSlider;
{
    [self.cameraZoomView reset];
}

- (void)fireLike
{
    [self.likeView fireLike];
}

- (void)updateNetStatus:(NIMNetCallNetStatus)status
{
    [self.netStatusView refresh:status];
    [self.netStatusView sizeToFit];
}

- (void)updateConnectorCount:(NSInteger)count
{
    [self.actionView updateInteractButton:count];
}

- (void)refreshChatroom:(NIMChatroom *)chatroom isMuteUser:(NSInteger)isMuteUser
{
    _roomId = chatroom.roomId;

    NSString *placeHolder = [NSString stringWithFormat:@"当前直播间ID:%@",chatroom.roomId];
    UITextView *textView = self.textInputView.textView;
    textView.editable = YES;
//    textView.placeholderAttributedText = [[NSAttributedString alloc] initWithString:placeHolder attributes:@{NSFontAttributeName:textView.font,NSForegroundColorAttributeName:[UIColor lightGrayColor]}];
    
    self.anchorMoreFooterView.isAllReliseMute = YES;
    if (chatroom.inAllMuteMode) {
        [self.noLiveFooterView updateMuteView:NTESLiveAllMuteType];
        [self.liveFooterView updateMuteView:NTESLiveAllMuteType];
        self.anchorMoreFooterView.isAllReliseMute = NO;
    }else if (isMuteUser){
        [self.noLiveFooterView updateMuteView:NTESLiveTempMuteType];
        [self.liveFooterView updateMuteView:NTESLiveTempMuteType];
    }else{
        [self.noLiveFooterView updateMuteView:NTESLiveRelieveAllMuteType];
        [self.liveFooterView updateMuteView:NTESLiveRelieveAllMuteType];
    }
}

- (void)updateRemoteView:(NSData *)yuvData
                   width:(NSUInteger)width
                  height:(NSUInteger)height
{
    if ([NTESLiveManager sharedInstance].role == NTESLiveRoleAnchor){
        [self.bypassView updateRemoteView:yuvData width:width height:height];
        if (_lastRemoteViewSize.width != width || _lastRemoteViewSize.height != height) {
            _lastRemoteViewSize = CGSizeMake(width, height);
            [self setNeedsLayout];
        }
    }else{
        [self.glView render:yuvData width:width height:height];
    }
}

- (void)updateBeautify:(BOOL)isBeautify
{
    [self.actionView updateBeautify:isBeautify];
}

- (void)updateflashButton:(BOOL)isOn
{
    [self.actionView updateflashButton:isOn];
}

- (void)updateFocusButton:(BOOL)isOn
{
    [self.actionView updateFocusButton:isOn];
}

- (void)updateMirrorButton:(BOOL)isOn
{
    [self.actionView updateMirrorButton:isOn];
}

- (void)updateQualityButton:(BOOL)isHigh
{
    [self.actionView updateQualityButton:isHigh];
}

- (void)updateWaterMarkButton:(BOOL)isOn
{
    [self.actionView updateWaterMarkButton:isOn];
}

- (void)updateMuteView:(NTESLiveMuteType)type{
    [self.noLiveFooterView updateMuteView:type];
    [self.liveFooterView updateMuteView:type];
}

- (CGFloat)getActionViewHeight
{
    return self.actionView.ntesHeight;
}

//刷新头部
- (void)setChatInfoModel:(GetChatInfoModel *)chatInfoModel{
    _chatInfoModel = chatInfoModel;
    self.liveHeaderView.chatInfoModel = chatInfoModel;
    self.noLiveHeaderView.chatInfoModel = chatInfoModel;
    [self.naviBar.titleLabel setText:chatInfoModel.chatName];
//    if (_isLive) {
//        self.chatView.ntesTop = self.liveHeaderView.ntesBottom;
//        self.chatView.ntesBottom = UIScreenHeight-self.liveHeaderView.ntesBottom-50;
//    }else{
//        self.chatView.ntesTop = self.noLiveHeaderView.ntesBottom;
//        self.chatView.ntesBottom = UIScreenHeight-self.noLiveHeaderView.ntesBottom-50;
//    }
}

#pragma mark - Action

- (void)startLive:(id)sender
{
    [self.startLiveButton setTitle:@"初始化中，请等待..." forState:UIControlStateNormal];
    if ([self.delegate respondsToSelector:@selector(onActionType:sender:)]) {
        [self.delegate onActionType:NTESLiveActionTypeLive sender:self.startLiveButton];
    }
}

- (void)onRotateCamera:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(onActionType:sender:)]) {
        [self.delegate onActionType:NTESLiveActionTypeCamera sender:self.cameraButton];
    }

}
- (void)onClose:(id)sender
{
    if ([NTESLiveManager sharedInstance].role == NTESLiveRoleAnchor) {
        if ([self.delegate respondsToSelector:@selector(onCloseLiving)]) {
            [self.delegate onCloseLiving];
        }
    }else{
        if ([self.delegate respondsToSelector:@selector(onClosePlaying)]) {
            [self.delegate onClosePlaying];
        }
    }
}

- (void)stopBypassing:(id)sender
{
    [self switchToBypassExitConfirmUI];
}

#pragma mark - Notification

- (void)keyboardWillShow:(NSNotification *)notification
{
    NSDictionary *info = notification.userInfo;
    _keyBoradHeight = [info[UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    [self layoutSubviews];
    NSLog(@"_keyBoradHeight = %.f",_keyBoradHeight);
}

//当键盘改变了frame(位置和尺寸)的时候调用
- (void)keyboardWillChangeFrameNotify:(NSNotification*)notify {
    
    // 键盘动画的时间
    CGFloat duration = [notify.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    // 取得键盘最后的frame
    CGRect keyboardFrame = [notify.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat finalY = keyboardFrame.origin.y;
    
    CGRect frame = self.textInputView.frame;
    if (finalY == self.ntesHeight) {
        [UIView animateWithDuration:duration animations:^{
            self.textInputView.frame = CGRectMake(0, self.ntesHeight, frame.size.width, frame.size.height);
            
//            self.replyStyleView.frame = CGRectMake(0, finalY - INPUT_DETAIL_HEIGHT, self.ntesWidth, INPUT_DETAIL_HEIGHT);
        } completion:^(BOOL finished) {
        }];
    }else {
        
        [UIView animateWithDuration:duration animations:^{
            CGFloat textY = self.ntesHeight - keyboardFrame.size.height-frame.size.height;
            self.textInputView.frame = CGRectMake(0,textY, frame.size.width, frame.size.height);
            
//            self.replyStyleView.frame = CGRectMake(0, finalY - 204, self.ntesWidth, INPUT_DETAIL_HEIGHT);
        } completion:^(BOOL finished) {
        }];
    }

}

- (void)keyboardWillHide:(NSNotification *)notification
{
    _keyBoradHeight = 0;
    [self layoutSubviews];
}

- (void)adjustViewPosition
{
    [self setNeedsLayout];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGFloat padding = 20.f;
    CGFloat delta = self.chatView.tableView.contentOffset.y;
    CGFloat bottom  = (delta < 0) ? self.chatView.ntesTop - delta : self.chatView.ntesTop;
    self.presentView.ntesBottom = bottom - padding;
    
    self.roomIdLabel.ntesTop = self.infoView.ntesBottom + 10.f;
    self.roomIdLabel.ntesLeft = 10.f;
    self.roomIdLabel.ntesWidth = [self getRoomIdLabelWidth];
    
    bottom = 100.f;
    self.bypassView.ntesRight  = self.ntesWidth  - padding;
    self.bypassView.ntesBottom = self.ntesHeight - bottom;
    
    self.likeView.ntesBottom = self.actionView.ntesTop;
    self.likeView.ntesRight  = self.ntesWidth - 10.f;

    self.glView.ntesSize = self.ntesSize;
    
    self.bypassNickLabel.ntesCenterY  = self.liveHeaderView.ntesCenterY;
    self.bypassNickLabel.ntesCenterX = self.liveHeaderView.ntesCenterX-20;
    
    self.netStatusView.ntesCenterX = self.ntesWidth * .5f;
    self.netStatusView.ntesTop = 70.f;
    
    self.actionView.ntesLeft = 0;
    self.actionView.ntesBottom = self.ntesHeight - 10.f;
    self.actionView.ntesWidth = self.ntesWidth;
    
    if ([NTESLiveManager sharedInstance].orientation == NIMVideoOrientationLandscapeRight) {
        self.cameraZoomView.ntesCenterY = self.infoView.ntesCenterY;
        self.cameraZoomView.ntesCenterX = self.ntesWidth * .5f;
        self.cameraZoomView.ntesHeight = 22.f;
        self.cameraZoomView.ntesWidth = 225.f;
    }
    else
    {
        self.cameraZoomView.ntesTop = self.roomIdLabel.ntesBottom + 20.f;
        self.cameraZoomView.ntesCenterX = self.ntesWidth * .5f;
        self.cameraZoomView.ntesHeight = 22.f;
        self.cameraZoomView.ntesWidth = self.ntesWidth - 2 * 30.f;
    }
}

#pragma mark - ReplyInputViewDelegate

- (void)cancelBtnAction {
    
    [UIView animateWithDuration:0.225 animations:^{
        self.replyStyleView.frame = CGRectMake(0, UIScreenHeight, UIScreenWidth, INPUT_DETAIL_HEIGHT);
    } completion:^(BOOL finished) {
        self.replyBackView.hidden = YES;
    }];
}

- (void)publishBtnAction:(NSString *)conent location:(NSString *)locationStr data:(NSString *)data replyFlag:(int)replyFlag commentModel:(PlayerCommentModel *)playerCommentModel {
    if (self.delegate) {
//        [self.delegate didSendMessage:conent location:locationStr data:data replyFlag:replyFlag];
    }
}

- (void)imageAction:(NSArray *)imageArray{
    if (self.delegate) {
        [self.delegate didSendImageView:imageArray];
    }
}

- (void)swithCommentTypeAction {
    
    [UIView animateWithDuration:0.225 animations:^{
        self.replyStyleView.frame = CGRectMake(0, UIScreenHeight, UIScreenWidth, INPUT_DETAIL_HEIGHT);
    } completion:^(BOOL finished) {
        self.replyBackView.hidden = YES;
    }];
}

#pragma mark - AnchorMoreFooterViewDelegate

- (void)anchorMoreFooterViewAction:(SuperManagerMoreType)type{
    if (type == commentType) {
        [self onActionType:NTESLiveActionTypeChat sender:nil];
    }else if (type == commentPhotoType){
        [self selectExistingPictureOrVideo];
    }else if (type == closeType){
        [self onClose:nil];
    }else if (type == SuperManagerMoreTypeinteractor){
        [self onActionType:NTESLiveActionTypeInteract sender:nil];
    }else{
        [self.delegate superAction:type];
    }
}

#pragma mark - NTESLiveActionViewDelegate

- (void)onActionType:(NTESLiveActionType)type sender:(id)sender
{
    switch (type) {
        case NTESLiveActionTypeLike:
            [self.likeView fireLike];
        break;
        
        case NTESLiveActionTypeChat:
        {
            self.textInputView.hidden = NO;
            [self.textInputView.textView becomeFirstResponder];
        }
        break;
            
        case NTESLiveActionTypeMoveUp:
        {
            [self actionViewMoveToggle];
        }
        break;
            
        case NTESLiveActionTypeZoom:
        {
            self.cameraZoomView.hidden = !self.cameraZoomView.hidden;
            UIButton * button = (UIButton *)sender;
            [button setImage:[UIImage imageNamed:self.cameraZoomView.hidden ? @"icon_camera_zoom_n" :@"icon_camera_zoom_on_n"] forState:UIControlStateNormal];
            [button setImage:[UIImage imageNamed:self.cameraZoomView.hidden ? @"icon_camera_zoom_p" :@"icon_camera_zoom_on_p"] forState:UIControlStateHighlighted];
        }
            break;
        default:
        break;
    }
    
    
    if ([self.delegate respondsToSelector:@selector(onActionType:sender:)]) {
        [self.delegate onActionType:type sender:sender];
    }
}

#pragma mark - NTESTextInputViewDelegate
- (void)didSendText:(NSString *)text
{
    if ([self.delegate respondsToSelector:@selector(didSendText:)]) {
        [self.delegate didSendText:text];
    }
    
    [RadioSessionReq commentChat:0 chatId:_rtcId uid:_rtcId toUid:0 commentText:text commentUrl:@"" location:@"" parentId:0 preCommentId:0 commentFlag:0 success:^(BaseResponse *response) {
        
    } failure:^(NSError * error) {
        
    }];
}

- (void)willChangeHeight:(CGFloat)height
{
    [self adjustViewPosition];
}

#pragma mark - NTESLiveBypassViewDelegate
- (void)didConfirmExitBypass
{
    if ([self.delegate respondsToSelector:@selector(onCloseBypassing)]) {
        [self.delegate onCloseBypassing];
    }
}


#pragma mark - NTESLiveChatViewDelegate
- (void)onTapChatView:(CGPoint)point
{
    [self.textInputView.textView resignFirstResponder];
    if ([self.delegate respondsToSelector:@selector(onTapChatView:)]) {
        [self.delegate onTapChatView:point];
    }
}

- (void)longGesturePress:(NTESMessageModel *)model{
    if (_isSuperManager) {
        self.superManagerView.isSuperManager = YES;
        self.superManagerView.messageModel = model;
        [self.superManagerView show];
    }
    if (_chatInfoModel.isChatM) {
        self.superManagerView.isSuperManager = NO;
        self.superManagerView.messageModel = model;
        [self.superManagerView show];
    }
    
}

- (void)headerAction:(NTESMessageModel *)model{
    [self showUserInfoCardWithUserId:[model.message.from intValue]];
}

#pragma mark - LiveNaviBarProtocol

- (void)shareAction:(id)sender{
    AccountModel * account = [[AccountManager shared] account];
    
    UserInfoParam * param = [UserInfoParam new];
    param.uid = 0;
    [PersonHomeRequest getUserInfo:param Success:^(PersonHomeResponse *response) {
        if (response.status == 200) {
            
            NSString * unicodenickname = [response.data.nickname stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            NSString * title = [NSString stringWithFormat:@"%@@你:精彩直播，速来",account.nickName];
            NSString * webLinkUrl = [NSString stringWithFormat:@"%@?token=%@&id=%ld&nickname=%@",kApiLiveH5ServerHost,account.token,_rtcId,unicodenickname];
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

- (void)popAction:(id)sender{
    [self onClose:sender];
}

#pragma mark - LiveHeaderViewDelegate

- (void)liveHeaderViewAction:(LiveHeaderViewType)type{
    switch (type) {
        case LiveHeaderViewTypeNotice:
            {
                [self onActionType:NTESLiveActionTypeNotice sender:nil];
            }
            break;
        case LiveHeaderViewTypeGift:{
            [self onActionType:NTESLiveActionTypeGiftList sender:nil];
            
        }
            break;
        case LiveHeaderViewTypeAttend:{
            [self showUserInfoCardWithUserId:_saveRoomInfoModel.userId];
        }
            break;
        case LiveHeaderViewTypeHeader:{
            [Navigation showPersonalHomePageViewController:[UIApplication topViewController] attendType:dynamicButtonType uid:_saveRoomInfoModel.userId];
        }
            break;
        default:
            break;
    }
}

#pragma mark - NoLiveHeaderViewDelegate

- (void)noLiveHeaderViewAction:(LiveHeaderViewType)type{
    switch (type) {
        case LiveHeaderViewTypeNotice:
            {
                [self onActionType:NTESLiveActionTypeNotice sender:nil];
            }
            break;
        
        default:
            break;
    }
}

#pragma mark - LiveSuperManagerFooterViewDelegate

- (void)liveSuperManagerFooterViewAction:(NoLiveFooterViewType)type{
    switch (type) {
        case NoLiveFooterViewTypeSuperMore:
            {
                [self.anchorMoreFooterView show:LiveFooterMoreTypeSuper];
            }
            break;
        case NoLiveFooterViewTypeSend:{
            [self onActionType:NTESLiveActionTypeChat sender:nil];
        }
            break;
        case NoLiveFooterViewTypeInteract:{
            [self onActionType:NTESLiveActionTypeInteract sender:nil];
        }
            break;
        case NoLiveFooterViewTypeGift:{
            [self onActionType:NTESLiveActionTypeGift sender:nil];
        }
            break;
        case NoLiveFooterViewTypeRed:{
            [self onActionType:NTESLiveActionTypeRed sender:nil];
        }
            break;
        case NoLiveFooterViewTypePlay:{

            
        }
            break;
        case NoLiveFooterViewTypePause:{

        }
            break;
        default:
            break;
    }
}

#pragma mark - SuperManagerViewDelegate

- (void)superManagerWork:(superManagerViewType)type messageModel:(NTESMessageModel *)messageModel{
    [self.delegate superManagerWork:type messageModel:messageModel];
}

#pragma mark - AnchorFooterViewDelegate

- (void)anchorFooterViewAction:(AnchorFooterViewType)type{
    if (self.anchorFooterView.isInit) {
        [self makeToast:@"请开始直播" duration:2.0 position:CSToastPositionCenter];
        return;
    }
    switch (type) {
        case startLiveType:{
            [self.delegate onActionType:NTESLiveActionTypeLive sender:nil];
            }
            break;
        case interactType:{
            [self.delegate onActionType:NTESLiveActionTypeInteract sender:nil];
        }
            break;
        case specialMusicType:{
            [self.delegate onActionType:NTESLiveActionTypeSpecalAudio sender:nil];
        }
            break;
        case bmgMusicType:{
            [self.delegate onActionType:NTESLiveActionTypeMixAudio sender:nil];
        }
            break;
        case moreType:{
             [self.anchorMoreFooterView show:LiveFooterMoreTypeAnchor];
        }
            break;
        default:
            break;
    }
}

#pragma mark - LiveFooterViewDelegate
- (void)liveFooterViewAction:(NoLiveFooterViewType)type{
    switch (type) {
        case NoLiveFooterViewTypeSend:{
            [self onActionType:NTESLiveActionTypeChat sender:nil];
        }
            break;
        case NoLiveFooterViewTypeInteract:{
            [self onActionType:NTESLiveActionTypeInteract sender:nil];
        }
            break;
        case NoLiveFooterViewTypeGift:{
            [self onActionType:NTESLiveActionTypeGift sender:nil];
        }
            break;
        case NoLiveFooterViewTypeRed:{
            [self onActionType:NTESLiveActionTypeRed sender:nil];
        }
            break;
        case NoLiveFooterViewTypePlay:{
            [self onActionType:NTESLiveFooterViewTypePlay sender:nil];
        }
            break;
        case NoLiveFooterViewTypePause:{
            [self onActionType:NTESLiveFooterViewTypePause sender:nil];
        }
            break;
        case NoLiveFooterViewTypeMore:{
            [self.anchorMoreFooterView show:LiveFooterMoreTypeAudience];
        }
            break;
        default:
            break;
    }
}

#pragma mark - NoLiveFooterViewDelegate

- (void)noLiveFooterViewAction:(NoLiveFooterViewType)type{
    switch (type) {
        case NoLiveFooterViewTypeSend:{
                [self onActionType:NTESLiveActionTypeChat sender:nil];
            }
            break;
        case NoLiveFooterViewTypeInteract:{
            [self onActionType:NTESLiveActionTypeInteract sender:nil];
            }
            break;
        case NoLiveFooterViewTypeGift:{
            [self onActionType:NTESLiveActionTypeGift sender:nil];
        }
            break;
        case NoLiveFooterViewTypeRed:{
            [self onActionType:NTESLiveActionTypeRed sender:nil];
        }
            break;
        case NoLiveFooterViewTypePlay:{
            [self onActionType:NTESNoLiveFooterViewTypePlay sender:nil];
        }
            break;
        case NoLiveFooterViewTypePause:{
            [self onActionType:NTESNoLiveFooterViewTypePause sender:nil];
        }
            break;
        case NoLiveFooterViewTypeMore:{
            [self.anchorMoreFooterView show:LiveFooterMoreTypeAudienceNo];
        }
        default:
            break;
    }
}

#pragma mark - NTESTimerHolderDelegate
- (void)onNTESTimerFired:(NTESTimerHolder *)holder
{
    if (self.delegate) {
        [self.delegate onActionType:NTESRefreshOnlineInfo sender:nil];
    }
    
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
    
    GetRedPacketCardView *view = [[GetRedPacketCardView alloc] initWithModel:commentModel rtcId:_rtcId];
    __weak typeof(self) weakSelf = self;
    view.refreshBlock = ^{
        [weakSelf.redPacketTipView fireLookingForRedPacket];
    };
    [view show];
}

#pragma mark - 选择照片
// 相册中选择
- (void)selectExistingPictureOrVideo{
    
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:1
                                                                                            delegate:self];
    
    // 默认为YES，如果设置为NO,用户将不能选择视频
    [imagePickerVc setAllowPickingVideo:NO];
    // 默认为YES，如果设置为NO,原图按钮将隐藏，用户不能选择发送原图
    [imagePickerVc setAllowPickingOriginalPhoto:NO];
    // 对照片排序，按修改时间升序，默认是YES。如果设置为NO,最新的照片会显示在最前面，内部的拍照按钮会排在第一个
    [imagePickerVc setSortAscendingByModificationDate:NO];
    
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos,NSArray *assets,BOOL isSelectOriginalPhoto) {
        
        [self.delegate didSendImageView:photos];
    }];
    
    [self.viewController presentViewController:imagePickerVc animated:YES completion:nil];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    // 获取媒体类型
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    
    // 判断是静态图像还是视频
    if([mediaType isEqual:(NSString *)kUTTypeImage]){
        
        UIImage *chosenImage = [info objectForKey:UIImagePickerControllerEditedImage];
        
        if (!IsNilOrNull(chosenImage)) {
            
            
        }
        
    }else if ([mediaType isEqualToString:(NSString *)kUTTypeMovie]){
        [self makeToast:@"系统只支持图片格式!"];
    }
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
}

#pragma mark - 关注弹窗
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
        
        _liveAttendView = [[LiveAttendView alloc] initWithUserModel:response.data isSelf:isSelf userId:userId];
        _liveAttendView.delegate = self;
        [_liveAttendView show];
        
    } failure:^(NSError *error) {
        [HUDProgressTool showErrorWithText:@"网络繁忙"];
    }];
}

#pragma mark - PersonInfoCardViewDelegate

- (void)mePageActionWithUserId:(int)userId isSelf:(BOOL)isSelf {
    [Navigation showPersonalHomePageViewController:[UIApplication topViewController] attendType:isSelf ? editDataButtonType : dynamicButtonType uid:userId];
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
        [[UIApplication topViewController] presentViewController:alert animated:YES completion:^{

        }];
    }
    else {
        [self attentionRequestWithUserId:userId];
    }
}

- (void)attentionRequestWithUserId:(int)userId {
    
    FocusSomeOneParam * param = [FocusSomeOneParam new];
    param.focusId = [NSString stringWithFormat:@"%d",userId];
    [PersonHomeRequest focusSomeOne:param Success:^(TopicWorkDetailResponse *response) {
        if (response.status == 200) {
            NSInteger state = [response.data[@"state"] integerValue];
            [HUDProgressTool showSuccessWithText:state == 0?@"取消关注成功":@"关注成功"];
            
            [_liveAttendView refreshWithState:state];
        }else{
            [HUDProgressTool showErrorWithText:response.msg];
        }
    } failure:^(NSError *error) {
        [HUDProgressTool showErrorWithText:@"网络繁忙"];
    }];
}

#pragma mark - Private
//- (UIView *)getTextViewFromTextInputView
//{
//    for (UIView *view in self.textInputView.subviews) {
//        if ([view isKindOfClass:[NTESGrowingInternalTextView class]]) {
//            return view;
//        }
//    }
//    return nil;
//}

- (void)switchToWaitingUI
{
    DDLogInfo(@"switch to waiting UI");
    if ([NTESLiveManager sharedInstance].role == NTESLiveRoleAudience)
    {
        [self switchToLinkingUI];
    }
    else
    {
        self.startLiveButton.hidden = NO;
        self.roomIdLabel.hidden = YES;
        [self.startLiveButton setTitle:@"开始直播" forState:UIControlStateNormal];
    }
    [self.bypassView refresh:nil status:NTESLiveBypassViewStatusNone];
    [self updateUserOnMic];
}


- (void)switchToPlayingUI
{
    DDLogInfo(@"switch to playing UI");
    self.coverView.hidden = YES;
    [self.textInputView.textView resignFirstResponder];
    self.textInputView.hidden = YES;
//    self.micView.hidden = [NTESLiveManager sharedInstance].type != NIMNetCallMediaTypeAudio;

    NTESLiveManager * liveManager = [NTESLiveManager sharedInstance];
    NIMChatroom *room = [liveManager roomInfo:self.roomId];
    if (!room) {
        DDLogInfo(@"chat room has not entered, ignore show playing UI");
        return;
    }
    self.chatView.hidden = NO;
    self.netStatusView.hidden = [NTESLiveManager sharedInstance].role == NTESLiveRoleAudience;
    [self.bypassView refresh:nil status:NTESLiveBypassViewStatusPlayingAndBypassingAudio];
    if ([NTESLiveManager sharedInstance].connectorOnMic.type == NIMNetCallMediaTypeAudio) {
        [self.bypassView refresh:nil status:NTESLiveBypassViewStatusPlayingAndBypassingAudio];
    }
    else
    {
        [self.bypassView refresh:nil status:NTESLiveBypassViewStatusPlaying];
    }
    
    self.glView.hidden = YES;
    if ([NTESLiveManager sharedInstance].role == NTESLiveRoleAudience || [NTESLiveManager sharedInstance].type == NIMNetCallMediaTypeAudio) {
        [self.actionView setActionType:NTESLiveActionTypeCamera disable:YES];
        [self.actionView setActionType:NTESLiveActionTypeBeautify disable:YES];
        [self.actionView setActionType:NTESLiveActionTypeQuality disable:YES];
    }
    self.actionView.userInteractionEnabled = YES;
    [self.actionView setActionType:NTESLiveActionTypeInteract disable:NO];
    [self updateUserOnMic];
    [_closeButton setImage:[UIImage imageNamed:@"icon_close_p"] forState:UIControlStateNormal];
    [_closeButton setImage:[UIImage imageNamed:@"icon_close_n"] forState:UIControlStateHighlighted];
    
    self.infoView.hidden = YES;
    self.roomIdLabel.hidden = YES;
    self.closeButton.hidden = YES;
    
    
    if ([NTESLiveManager sharedInstance].role == NTESLiveRoleAudience) {
        self.actionView.hidden = YES;
        if (_isSuperManager) {
            self.liveSuperManagerFooterView.hidden = NO;
        }else{
            self.liveFooterView.hidden = !_isLive;
            self.noLiveFooterView.hidden = _isLive;
        }
        self.liveHeaderView.hidden = !_isLive;
        self.noLiveHeaderView.hidden = _isLive;
    }else{
        self.liveHeaderView.hidden = NO;
        self.anchorFooterView.hidden = NO;
    }
    CGFloat chatBottom = [DeviceInfoTool getNavigationBarHeight];
    if (!self.liveHeaderView.hidden) {
        chatBottom += self.liveHeaderView.ntesHeight;
    }
    if (!self.noLiveHeaderView.hidden) {
        chatBottom += self.noLiveHeaderView.ntesHeight;
    }
    self.chatView.ntesTop = chatBottom;
    self.chatView.ntesHeight = UIScreenHeight-chatBottom-[DeviceInfoTool getTabbarHeight];
}

- (void)switchToLinkingUI
{
    DDLogInfo(@"switch to Linking UI");
    self.startLiveButton.hidden = YES;
    self.closeButton.hidden = NO;
    self.cameraButton.hidden = YES;
    self.roomIdLabel.hidden = YES;

    [self.coverView refreshWithChatroom:self.roomId status:NTESLiveCoverStatusLinking];
    self.coverView.hidden = NO;
    [self.closeButton setImage:[UIImage imageNamed:@"icon_close_n"] forState:UIControlStateNormal];
    [self.closeButton setImage:[UIImage imageNamed:@"icon_close_p"] forState:UIControlStateHighlighted];
}

- (void)switchToEndUI
{
    DDLogInfo(@"switch to End UI");
    [self.coverView refreshWithChatroom:self.roomId status:NTESLiveCoverStatusFinished];
    self.coverView.hidden = NO;
    self.roomIdLabel.hidden = YES;

    self.netStatusView.hidden = YES;
    if ([NTESLiveManager sharedInstance].role == NTESLiveRoleAnchor) {
        self.closeButton.hidden = YES;
        self.cameraButton.hidden = YES;
    }else{
        self.closeButton.hidden = NO;
        self.cameraButton.hidden = YES;
        [self.closeButton setImage:[UIImage imageNamed:@"icon_close_n"] forState:UIControlStateNormal];
        [self.closeButton setImage:[UIImage imageNamed:@"icon_close_p"] forState:UIControlStateHighlighted];
    }
}

- (void)switchToBypassStreamingUI:(NTESMicConnector *)connector
{
    DDLogInfo(@"switch to bypass streaming UI connector id %@",connector.uid);
    
    self.startLiveButton.hidden = YES;
//    self.infoView.hidden = NO;
//    self.likeView.hidden = NO;
    self.chatView.hidden = NO;
//    self.presentView.hidden = NO;
//    self.actionView.hidden  = NO;
//    self.textInputView.hidden = NO;
    self.netStatusView.hidden = NO;
//    self.cameraButton.hidden = NO;
//    self.roomIdLabel.hidden = NO;

    NTESLiveBypassViewStatus status = connector.type == NIMNetCallMediaTypeAudio? NTESLiveBypassViewStatusStreamingAudio: NTESLiveBypassViewStatusStreamingVideo;
    [self.bypassView refresh:connector status:status];
    self.glView.hidden = YES;
    [self updateUserOnMic];
    [_closeButton setImage:[UIImage imageNamed:@"icon_close_p"] forState:UIControlStateNormal];
    [_closeButton setImage:[UIImage imageNamed:@"icon_close_n"] forState:UIControlStateHighlighted];
}

- (void)switchToBypassingUI:(NTESMicConnector *)connector
{
    DDLogInfo(@"switch to bypassing UI connector id %@",connector.uid);
    self.startLiveButton.hidden = YES;
//    self.infoView.hidden = NO;
//    self.likeView.hidden = NO;
    self.chatView.hidden = NO;
//    self.presentView.hidden = NO;
//    self.actionView.hidden  = NO;
//    self.textInputView.hidden = NO;
    self.netStatusView.hidden = YES;
//    self.roomIdLabel.hidden = NO;

    NTESLiveBypassViewStatus status = connector.type == NIMNetCallMediaTypeAudio? NTESLiveBypassViewStatusLocalAudio: NTESLiveBypassViewStatusLocalVideo;
    [self.bypassView refresh:connector status:status];
    self.glView.hidden = NO;
    [self.actionView setActionType:NTESLiveActionTypeCamera disable: [NTESLiveManager sharedInstance].bypassType == NIMNetCallMediaTypeAudio];
    [self.actionView setActionType:NTESLiveActionTypeBeautify disable:[NTESLiveManager sharedInstance].bypassType == NIMNetCallMediaTypeAudio];
    [self.actionView setActionType:NTESLiveActionTypeInteract disable:YES];
    [self updateUserOnMic];
    [_closeButton setImage:[UIImage imageNamed:@"icon_close_p"] forState:UIControlStateNormal];
    [_closeButton setImage:[UIImage imageNamed:@"icon_close_n"] forState:UIControlStateHighlighted];
}

- (void)switchToBypassLoadingUI:(NTESMicConnector *)connector
{
    DDLogInfo(@"switch to bypass loading UI connector id %@",connector.uid);
    
    [self.bypassView refresh:connector status:NTESLiveBypassViewStatusLoading];
    [self setNeedsLayout];
}

- (void)switchToBypassExitConfirmUI
{
    DDLogInfo(@"switch to bypass exit confirm UI");
    
    [self.bypassView refresh:nil status:NTESLiveBypassViewStatusExitConfirm];
    [self setNeedsLayout];
}

- (void)setup
{
    [self addSubview:self.startLiveButton];
    [self addSubview:self.glView];
    [self addSubview:self.micView];
    [self addSubview:self.chatView];
    [self addSubview:self.bypassView];
    [self addSubview:self.bypassNickLabel];
//    [self addSubview:self.likeView];
//    [self addSubview:self.presentView];
//    [self addSubview:self.actionView];
//    [self addSubview:self.infoView];
    [self addSubview:self.textInputView];
    [self addSubview:self.coverView];
//    [self addSubview:self.closeButton];
    [self addSubview:self.netStatusView];
//    [self addSubview:self.roomIdLabel];
//    [self addSubview:self.cameraZoomView];
    [self addSubview:self.noLiveFooterView];
    [self addSubview:self.naviBar];
    [self addSubview:self.noLiveHeaderView];
    [self addSubview:self.liveHeaderView];
    [self addSubview:self.liveFooterView];
    [self addSubview:self.anchorFooterView];
    [self addSubview:self.liveSuperManagerFooterView];
    [self addSubview:self.replyBackView];
    [self adjustViewPosition];
    
    //监听键盘的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrameNotify:) name:UIKeyboardWillChangeFrameNotification object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
//    [self.chatView.tableView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
//    [self.micView addObserver:self forKeyPath:@"hidden" options:NSKeyValueObservingOptionNew context:nil];
    _timer = [[NTESTimerHolder alloc] init];
    [_timer startTimer:60 delegate:self repeats:YES];
}


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
//    if ([keyPath isEqualToString:@"contentOffset"]) {
//        CGPoint point = [change[@"new"] CGPointValue];
//        CGFloat padding = 20.f;
//        CGFloat bottom = (point.y < 0) ? self.chatView.ntesTop - point.y : self.chatView.ntesTop;
//        self.presentView.ntesBottom = bottom - padding;
//    }
//    if ([keyPath isEqualToString:@"hidden"]) {
//        BOOL hidden = [change[@"new"] boolValue];
//        if (hidden)
//        {
//            [self.micView stopAnimating];
//        }
//        else
//        {
//            [self.micView startAnimating];
//        }
//    }
}

-(void)actionViewMoveToggle
{
    _isActionViewMoveUp = !_isActionViewMoveUp;
    CGFloat rowHeight = 35;
    [self.actionView firstLineViewMoveToggle:_isActionViewMoveUp];
    if (_isActionViewMoveUp) {
        [UIView animateWithDuration:0.5 animations:^{
            _chatView.ntesBottom = self.ntesHeight - 3 * rowHeight - 30;
        }];
    }
    else
    {
        [UIView animateWithDuration:0.5 animations:^{
            _chatView.ntesBottom = self.ntesHeight - rowHeight - 20;
        }];
    }
    

}

- (CGFloat)getRoomIdLabelWidth
{
    CGRect rectTitle = [_roomIdLabel.text boundingRectWithSize:CGSizeMake(999, 30)
                                                       options:NSStringDrawingUsesLineFragmentOrigin
                                                    attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:9.f]}
        
                                                       context:nil];
    CGFloat width = self.infoView.ntesWidth;
    if (rectTitle.size.width > self.infoView.ntesWidth) {
        width = rectTitle.size.width + 10.f;
    }
    
    return width;
}

- (void)updateUserOnMic
{
    NTESMicConnector *connector = [NTESLiveManager sharedInstance].connectorOnMic;
    NSString *nick = connector.nick;
    self.bypassNickLabel.text = nick.length? [NSString stringWithFormat:@"连麦者：%@",nick] : @"";
    [self.bypassNickLabel sizeToFit];
    [self setNeedsLayout];
}

- (void)onTapreplyBackViewBackground:(id)sender{
    [self.replyStyleView resignEditing:NO];
    [self cancelBtnAction];
}

#pragma mark - NTESLiveCoverViewDelegate
- (void)didPressBackButton
{
    [self.viewController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Get

- (UIControl *)replyBackView {
    if (!_replyBackView) {
        _replyBackView = [[UIControl alloc] initWithFrame:CGRectMake(0, 0, UIScreenWidth, UIScreenHeight)];
        _replyBackView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
        [_replyBackView addSubview:self.replyStyleView];
        _replyBackView.hidden = YES;
        [_replyBackView addTarget:self action:@selector(onTapreplyBackViewBackground:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _replyBackView;
}

- (ReplyStyleView *)replyStyleView{
    if (!_replyStyleView) {
        _replyStyleView = [[ReplyStyleView alloc] initWithFrame:CGRectMake(0, UIScreenHeight, UIScreenWidth, INPUT_DETAIL_HEIGHT)];
        [_replyStyleView setModel:nil];
        _replyStyleView.replyStyleViewDelegate = self;
    }
    return _replyStyleView;
}

- (RedPacketIsHaveTipView *)redPacketTipView {
    if (!_redPacketTipView) {
        _redPacketTipView = [[RedPacketIsHaveTipView alloc] initWithFrame:CGRectMake(UIScreenWidth - 112, 200, 112, 159)];
        _redPacketTipView.delegate = self;
        [self addSubview:_redPacketTipView];
        [self bringSubviewToFront:_redPacketTipView];
        [_redPacketTipView setRtcId:_rtcId];
    }
    return _redPacketTipView;
}

- (AnchorMoreFooterView *)anchorMoreFooterView{
    if (!_anchorMoreFooterView) {
        _anchorMoreFooterView = [[AnchorMoreFooterView alloc] initWithFrame:CGRectMake(0, self.ntesHeight, self.ntesWidth, self.ntesHeight)];
        _anchorMoreFooterView.anchorMoreDelegate = self;
    }
    return _anchorMoreFooterView;
}

- (SuperManagerView *)superManagerView{
    if (!_superManagerView) {
        _superManagerView = [[SuperManagerView alloc] initWithFrame:CGRectMake(0, self.ntesHeight, self.ntesWidth, self.ntesHeight)];
        _superManagerView.superDelegate = self;
    }
    return _superManagerView;
}

- (LiveNaviBar *)naviBar{
    if (!_naviBar) {
        _naviBar = [[[NSBundle mainBundle] loadNibNamed:@"LiveNaviBar" owner:self options:nil] lastObject];
        _naviBar.frame = CGRectMake(0, 0, self.ntesWidth, [DeviceInfoTool getNavigationBarHeight]);
        _naviBar.naviBarDelegate = self;
    }
    return _naviBar;
}

- (AnchorFooterView *)anchorFooterView{
    if (!_anchorFooterView) {
        _anchorFooterView = [[[NSBundle mainBundle] loadNibNamed:@"AnchorFooterView" owner:self options:nil] lastObject];
        _anchorFooterView.frame = CGRectMake(0, self.ntesHeight-[DeviceInfoTool getTabbarHeight], self.ntesWidth, [DeviceInfoTool getTabbarHeight]);
        _anchorFooterView.hidden = YES;
        _anchorFooterView.anchorDelegate = self;
    }
    return _anchorFooterView;
}

- (LiveSuperManagerFooterView *)liveSuperManagerFooterView{
    if (!_liveSuperManagerFooterView) {
        _liveSuperManagerFooterView = [[[NSBundle mainBundle] loadNibNamed:@"LiveSuperManagerFooterView" owner:self options:nil] lastObject];
        _liveSuperManagerFooterView.frame = CGRectMake(0, self.ntesHeight-[DeviceInfoTool getTabbarHeight], self.ntesWidth, [DeviceInfoTool getTabbarHeight]);
        _liveSuperManagerFooterView.hidden = YES;
        _liveSuperManagerFooterView.superDelegate = self;
    }
    return _liveSuperManagerFooterView;
}

- (LiveFooterView *)liveFooterView{
    if (!_liveFooterView) {
        _liveFooterView = [[[NSBundle mainBundle] loadNibNamed:@"LiveFooterView" owner:self options:nil] lastObject];
        _liveFooterView.frame = CGRectMake(0, self.ntesHeight-[DeviceInfoTool getTabbarHeight], self.ntesWidth, [DeviceInfoTool getTabbarHeight]);
        _liveFooterView.hidden = YES;
        _liveFooterView.liveDelegate = self;
    }
    return _liveFooterView;
}

- (LiveHeaderView *)liveHeaderView{
    if (!_liveHeaderView) {
        _liveHeaderView = [[[NSBundle mainBundle] loadNibNamed:@"LiveHeaderView" owner:self options:nil] lastObject];
        _liveHeaderView.frame = CGRectMake(0, 64, self.ntesWidth, 92);
        _liveHeaderView.hidden = YES;
        _liveHeaderView.liveDelegate = self;
    }
    return _liveHeaderView;
}

- (NoLiveHeaderView *)noLiveHeaderView{
    if (!_noLiveHeaderView) {
        _noLiveHeaderView = [[NoLiveHeaderView alloc] initWithFrame:CGRectMake(0, 64, self.ntesWidth, 25)];
        _noLiveHeaderView.hidden = YES;
        _noLiveHeaderView.noLiveDelegate = self;
    }
    return _noLiveHeaderView;
}

- (NoLiveFooterView *)noLiveFooterView{
    if (!_noLiveFooterView) {
        _noLiveFooterView = [[[NSBundle mainBundle] loadNibNamed:@"NoLiveFooterView" owner:self options:nil] lastObject];
        _noLiveFooterView.frame = CGRectMake(0, self.ntesHeight-[DeviceInfoTool getTabbarHeight], self.ntesWidth, [DeviceInfoTool getTabbarHeight]);
        _noLiveFooterView.hidden = YES;
        _noLiveFooterView.liveDelegate = self;
    }
    return _noLiveFooterView;
}

- (UIButton *)startLiveButton
{
    if (!_startLiveButton) {
        _startLiveButton = [UIButton buttonWithType:UIButtonTypeCustom];
        UIImage *backgroundImageNormal = [[UIImage imageNamed:@"btn_round_rect_normal"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10) resizingMode:UIImageResizingModeStretch];
        UIImage *backgroundImageHighlighted = [[UIImage imageNamed:@"btn_round_rect_pressed"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10) resizingMode:UIImageResizingModeStretch];
        [_startLiveButton setBackgroundImage:backgroundImageNormal forState:UIControlStateNormal];
        [_startLiveButton setBackgroundImage:backgroundImageHighlighted forState:UIControlStateHighlighted];
        [_startLiveButton setTitleColor:UIColorFromRGB(0x238efa) forState:UIControlStateNormal];
        [_startLiveButton addTarget:self action:@selector(startLive:) forControlEvents:UIControlEventTouchUpInside];
        _startLiveButton.ntesSize = CGSizeMake(215, 46);
        _startLiveButton.center = self.center;
        _startLiveButton.autoresizingMask = UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin;
    }
    return _startLiveButton;
}

- (NTESTextInputView *)textInputView
{
    if (!_textInputView) {
        CGFloat height = 64.f;
        _textInputView = [[NTESTextInputView alloc] initWithFrame:CGRectMake(0, self.ntesHeight, self.ntesWidth, height)];
        _textInputView.delegate = self;
//        _textInputView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;
        _textInputView.hidden = YES;
        _textInputView.textView.placeholder = @"聊点什么吧";
        _textInputView.textView.editable = NO;
    }
    return _textInputView;
}

- (NTESLiveChatView *)chatView
{
    if (!_chatView) {
        NSInteger chatViewTop = self.liveHeaderView.ntesBottom;
        _chatView = [[NTESLiveChatView alloc] initWithFrame:CGRectMake(0,chatViewTop, UIScreenWidth, UIScreenHeight-chatViewTop-[DeviceInfoTool getTabbarHeight])];
        _chatView.hidden = YES;
        _chatView.delegate = self;
    }
    return _chatView;
}

- (NTESLiveActionView *)actionView
{
    if (!_actionView) {
        _actionView = [[NTESLiveActionView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        [_actionView sizeToFit];
//        CGFloat bottom = 54.f;
//        _actionView.bottom = self.height - bottom;
        _actionView.delegate = self;
        _actionView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin;
        _actionView.hidden = YES;
        if ([NTESLiveManager sharedInstance].type == NIMNetCallMediaTypeAudio) {
            [self.actionView setActionType:NTESLiveActionTypeCamera disable:YES];
        }
    }
    return _actionView;
}

- (NTESLiveLikeView *)likeView
{
    if (!_likeView) {
        CGFloat width  = 50.f;
        CGFloat height = 300.f;
        _likeView = [[NTESLiveLikeView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
        _likeView.hidden = YES;
    }
    return _likeView;
}

- (NTESLivePresentView *)presentView
{
    if(!_presentView){
        CGFloat width  = 200.f;
        CGFloat height = 96.f;
        _presentView = [[NTESLivePresentView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
        _presentView.ntesBottom = self.actionView.ntesTop;
        _presentView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        _presentView.hidden = YES;
    }
    return _presentView;
}

- (NTESLiveCoverView *)coverView
{
    if (!_coverView) {
        _coverView = [[NTESLiveCoverView alloc] initWithFrame:self.bounds];
        _coverView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _coverView.hidden = YES;
        _coverView.delegate = self;
    }
    return _coverView;
}

- (NTESLiveroomInfoView *)infoView
{
    if (!_infoView) {
        _infoView = [[NTESLiveroomInfoView alloc] initWithFrame:CGRectMake(10, 10, 0, 0)];
        [_infoView sizeToFit];
        _infoView.hidden = YES;
    }
    return _infoView;
}

- (UIButton *)closeButton
{
    if(!_closeButton)
    {
        _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_closeButton setImage:[UIImage imageNamed:@"icon_close_n"] forState:UIControlStateNormal];
        [_closeButton setImage:[UIImage imageNamed:@"icon_close_p"] forState:UIControlStateHighlighted];
        [_closeButton addTarget:self action:@selector(onClose:) forControlEvents:UIControlEventTouchUpInside];
        _closeButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin;
        _closeButton.ntesSize = CGSizeMake(44, 44);
        _closeButton.ntesTop = 5.f;
        _closeButton.ntesRight = self.ntesWidth - 5.f;
    }
    return _closeButton;
}

- (UIButton *)cameraButton
{
    if (!_cameraButton) {
        _cameraButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _cameraButton.tag = NTESLiveActionTypeCamera;
        [_cameraButton setImage:[UIImage imageNamed:@"icon_camera_rotate_n"] forState:UIControlStateNormal];
        [_cameraButton setImage:[UIImage imageNamed:@"icon_camera_rotate_p"] forState:UIControlStateHighlighted];
        [_cameraButton sizeToFit];
        [_cameraButton addTarget:self action:@selector(onRotateCamera:) forControlEvents:UIControlEventTouchUpInside];
        _cameraButton.ntesSize = CGSizeMake(44, 44);
        _cameraButton.ntesTop = 5.f;
        _cameraButton.ntesRight = _closeButton.ntesLeft - 10.f;

    }
    return _cameraButton;
}

- (NTESLiveBypassView *)bypassView
{
    if (!_bypassView) {
        _bypassView = [[NTESLiveBypassView alloc] initWithFrame:CGRectZero];
        _bypassView.delegate = self;
        [_bypassView sizeToFit];
    }
    return _bypassView;
}

- (NTESGLView *)glView
{
    if (!_glView) {
        _glView = [[NTESGLView alloc] initWithFrame:self.bounds];
        _glView.contentMode = UIViewContentModeScaleAspectFill;
        _glView.hidden = YES;
    }
    return _glView;
}

- (NTESAnchorMicView *)micView
{
    if (!_micView) {
        _micView = [[NTESAnchorMicView alloc] initWithFrame:self.bounds];
//        _micView.hidden = YES;
    }
    return _micView;
}

- (UILabel *)bypassNickLabel
{
    if (!_bypassNickLabel) {
        _bypassNickLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _bypassNickLabel.backgroundColor = UIColorFromRGBA(0x0,0.3);
        _bypassNickLabel.textColor = UIColorFromRGB(0xffffff);
        _bypassNickLabel.font = [UIFont systemFontOfSize:16.f];
    }
    return _bypassNickLabel;
}

- (UILabel *)roomIdLabel
{
    if (!_roomIdLabel) {
        _roomIdLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _roomIdLabel.backgroundColor = UIColorFromRGBA(0x0,0.6);
        _roomIdLabel.textColor = UIColorFromRGB(0xffffff);
        _roomIdLabel.font = [UIFont systemFontOfSize:9.f];
        _roomIdLabel.text =[NSString stringWithFormat:@"房间ID:%@",_roomId];
        _roomIdLabel.textAlignment = NSTextAlignmentCenter;
        _roomIdLabel.layer.masksToBounds = YES;
        _roomIdLabel.layer.cornerRadius = 8.f;
        CGRect rectTitle = [_roomIdLabel.text boundingRectWithSize:CGSizeMake(999, 30)
                                                options:NSStringDrawingUsesLineFragmentOrigin
                                             attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:9.f]}
                                                context:nil];
        _roomIdLabel.ntesHeight = rectTitle.size.height + 8.f ;
    }
    return _roomIdLabel;
}

- (NTESCameraZoomView*)cameraZoomView
{
    if(!_cameraZoomView)
    {
        _cameraZoomView = [[NTESCameraZoomView alloc]initWithFrame:CGRectZero];
        _cameraZoomView.hidden = YES;
    }
    return _cameraZoomView;
}


- (NTESNetStatusView *)netStatusView
{
    if (!_netStatusView) {
        _netStatusView = [[NTESNetStatusView alloc] initWithFrame:CGRectZero];
        //没有回调之前，默认为较好的网络情况
        [_netStatusView refresh:NIMNetCallNetStatusGood];
        [_netStatusView sizeToFit];
        _netStatusView.hidden = YES;
        [self setNeedsLayout];
    }
    return _netStatusView;
}

@end
