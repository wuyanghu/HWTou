//
//  NTESChatroomViewController.m
//  NIM
//
//  Created by chris on 15/12/11.
//  Copyright © 2015年 Netease. All rights reserved.
//

#import "NTESChatroomViewController.h"
#import "NTESChatroomConfig.h"
#import "NTESJanKenPonAttachment.h"
#import "NTESSessionMsgConverter.h"
#import "NTESChatroomManager.h"
#import "UIView+Toast.h"
#import "NTESGalleryViewController.h"
#import "NTESVideoViewController.h"
#import "NIMLocationViewController.h"
#import "NTESFilePreViewController.h"
#import "NIMKitLocationPoint.h"
#import "NTESRedPacketManager.h"
#import "NTESRedPacketAttachment.h"
#import "NTESRedPacketTipAttachment.h"

@import MobileCoreServices;
@import AVFoundation;

@interface NTESChatroomViewController ()
{
    BOOL _isRefreshing;
}

@property (nonatomic,strong) NTESChatroomConfig *config;

@property (nonatomic,strong) NIMChatroom *chatroom;

@end

@implementation NTESChatroomViewController

- (instancetype)initWithChatroom:(NIMChatroom *)chatroom
{
    self = [super initWithSession:[NIMSession session:chatroom.roomId type:NIMSessionTypeChatroom]];
    if (self) {
        _chatroom = chatroom;
    }
    return self;
}

- (void)dealloc
{
    [self.tableView removeObserver:self forKeyPath:@"contentOffset"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
    
    UIImageView*imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"zb_img_bg"]];
    self.tableView.backgroundView = imageView;
}

- (id<NIMSessionConfig>)sessionConfig{
    return self.config;
}


- (BOOL)onTapCell:(NIMKitEvent *)event
{
    BOOL handled = [super onTapCell:event];
    NSString *eventName = event.eventName;
    if ([eventName isEqualToString:NIMKitEventNameTapContent])
    {
        NIMMessage *message = event.messageModel.message;
        NSDictionary *actions = [self cellActions];
        NSString *value = actions[@(message.messageType)];
        if (value) {
            SEL selector = NSSelectorFromString(value);
            if (selector && [self respondsToSelector:selector]) {
                SuppressPerformSelectorLeakWarning([self performSelector:selector withObject:message]);
                handled = YES;
            }
        }
    }
    else if([eventName isEqualToString:NIMKitEventNameTapLabelLink])
    {
        NSString *link = event.data;
        [self openSafari:link];
        handled = YES;
    }
//    else if([eventName isEqualToString:NIMDemoEventNameOpenSnapPicture])
//    {
//        NIMCustomObject *object = event.messageModel.message.messageObject;
//        NTESSnapchatAttachment *attachment = (NTESSnapchatAttachment *)object.attachment;
//        if(attachment.isFired){
//            return handled;
//        }
//        UIView *sender = event.data;
//        self.currentSingleSnapView = [NTESGalleryViewController alertSingleSnapViewWithMessage:object.message baseView:sender];
//        handled = YES;
//    }
//    else if([eventName isEqualToString:NIMDemoEventNameCloseSnapPicture])
//    {
//        //点击很快的时候可能会触发两次查看，所以这里不管有没有查看过 先强直销毁掉
//        NIMCustomObject *object = event.messageModel.message.messageObject;
//        UIView *senderView = event.data;
//        [senderView dismissPresentedView:YES complete:nil];
//
//        NTESSnapchatAttachment *attachment = (NTESSnapchatAttachment *)object.attachment;
//        if(attachment.isFired){
//            return handled;
//        }
//        attachment.isFired  = YES;
//        NIMMessage *message = object.message;
//        if ([NTESBundleSetting sharedConfig].autoRemoveSnapMessage) {
//            [[NIMSDK sharedSDK].conversationManager deleteMessage:message];
//            [self uiDeleteMessage:message];
//        }else{
//            [[NIMSDK sharedSDK].conversationManager updateMessage:message forSession:message.session completion:nil];
//            [self uiUpdateMessage:message];
//        }
//        [[NSFileManager defaultManager] removeItemAtPath:attachment.filepath error:nil];
//        self.currentSingleSnapView = nil;
//        handled = YES;
//    }
    else if([eventName isEqualToString:NIMKitEventNameTapRobotLink])
    {
        NSString *link = event.data;
        [self openSafari:link];
        handled = YES;
    }
//    else if([eventName isEqualToString:NIMDemoEventNameOpenRedPacket])
//    {
//        NIMCustomObject *object = event.messageModel.message.messageObject;
//        NTESRedPacketAttachment *attachment = (NTESRedPacketAttachment *)object.attachment;
//        [[NTESRedPacketManager sharedManager] openRedPacket:attachment.redPacketId from:event.messageModel.message.from session:self.session];
//        handled = YES;
//    }
//    else if([eventName isEqualToString:NTESShowRedPacketDetailEvent])
//    {
//        NIMCustomObject *object = event.messageModel.message.messageObject;
//        NTESRedPacketTipAttachment *attachment = (NTESRedPacketTipAttachment *)object.attachment;
//        [[NTESRedPacketManager sharedManager] showRedPacketDetail:attachment.packetId];
//        handled = YES;
//    }
    
    if (!handled)
    {
        NSAssert(0, @"invalid event");
    }
    return handled;
}


- (BOOL)onTapMediaItem:(NIMMediaItem *)item
{
    SEL  sel = item.selctor;
    BOOL response = [self respondsToSelector:sel];
    if (response) {
        SuppressPerformSelectorLeakWarning([self performSelector:sel withObject:item]);
    }
    return response;
}

- (void)onTapMediaItemJanKenPon:(NIMMediaItem *)item{
    NTESJanKenPonAttachment *attachment = [[NTESJanKenPonAttachment alloc] init];
    attachment.value = arc4random() % 3 + 1;
    [self sendMessage:[NTESSessionMsgConverter msgWithJenKenPon:attachment]];
}

- (void)sendMessage:(NIMMessage *)message
{
    NIMChatroomMember *member = [[NTESChatroomManager sharedInstance] myInfo:self.chatroom.roomId];
    message.remoteExt = @{@"type":@(member.type)};
    [super sendMessage:message];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"contentOffset"]) {
        CGFloat offset = 44.f;
        if (self.tableView.contentOffset.y <= -offset && !_isRefreshing && self.tableView.isDragging) {
            _isRefreshing = YES;
            UIRefreshControl *refreshControl = [self findRefreshControl];
            [refreshControl beginRefreshing];
            [refreshControl sendActionsForControlEvents:UIControlEventValueChanged];
            [self.tableView endEditing:YES];
        }
        else if(self.tableView.contentOffset.y >= 0)
        {
            _isRefreshing = NO;
        }
    }
}

- (UIRefreshControl *)findRefreshControl
{
    for (UIRefreshControl *subView in self.tableView.subviews) {
        if ([subView isKindOfClass:[UIRefreshControl class]]) {
            return subView;
        }
    }
    return nil;
}

#pragma mark - Cell Actions
- (void)showImage:(NIMMessage *)message
{
    NIMImageObject *object = message.messageObject;
    NTESGalleryItem *item = [[NTESGalleryItem alloc] init];
    item.thumbPath      = [object thumbPath];
    item.imageURL       = [object url];
    item.name           = [object displayName];
    item.itemId         = [message messageId];
    item.size           = [object size];
    
    NIMSession *session = [self isMemberOfClass:[NTESChatroomViewController class]]? self.session : nil;
    
    NTESGalleryViewController *vc = [[NTESGalleryViewController alloc] initWithItem:item session:session];
    [self.navigationController pushViewController:vc animated:YES];
    if(![[NSFileManager defaultManager] fileExistsAtPath:object.thumbPath]){
        //如果缩略图下跪了，点进看大图的时候再去下一把缩略图
        __weak typeof(self) wself = self;
        [[NIMSDK sharedSDK].resourceManager download:object.thumbUrl filepath:object.thumbPath progress:nil completion:^(NSError *error) {
            if (!error) {
                [wself uiUpdateMessage:message];
            }
        }];
    }
}

- (void)showVideo:(NIMMessage *)message
{
    NIMVideoObject *object = message.messageObject;
    NIMSession *session = [self isMemberOfClass:[NTESChatroomViewController class]]? self.session : nil;
    
    NTESVideoViewItem *item = [[NTESVideoViewItem alloc] init];
    item.path = object.path;
    item.url  = object.url;
    item.session = session;
    item.itemId  = object.message.messageId;
    
    NTESVideoViewController *playerViewController = [[NTESVideoViewController alloc] initWithVideoViewItem:item];
    [self.navigationController pushViewController:playerViewController animated:YES];
    if(![[NSFileManager defaultManager] fileExistsAtPath:object.coverPath]){
        //如果封面图下跪了，点进视频的时候再去下一把封面图
        __weak typeof(self) wself = self;
        [[NIMSDK sharedSDK].resourceManager download:object.coverUrl filepath:object.coverPath progress:nil completion:^(NSError *error) {
            if (!error) {
                [wself uiUpdateMessage:message];
            }
        }];
    }
}

- (void)showLocation:(NIMMessage *)message
{
    NIMLocationObject *object = message.messageObject;
    NIMKitLocationPoint *locationPoint = [[NIMKitLocationPoint alloc] initWithLocationObject:object];
    NIMLocationViewController *vc = [[NIMLocationViewController alloc] initWithLocationPoint:locationPoint];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)showFile:(NIMMessage *)message
{
    NIMFileObject *object = message.messageObject;
    NTESFilePreViewController *vc = [[NTESFilePreViewController alloc] initWithFileObject:object];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)showCustom:(NIMMessage *)message
{
    //普通的自定义消息点击事件可以在这里做哦~
}

- (void)openSafari:(NSString *)link
{
    NSURLComponents *components = [[NSURLComponents alloc] initWithString:link];
    if (components)
    {
        
        if (!components.scheme)
        {
            //默认添加 http
            components.scheme = @"http";
        }
        [[UIApplication sharedApplication] openURL:[components URL]];
    }
}

#pragma mark - 录音事件
- (void)onRecordFailed:(NSError *)error
{
    [self.view makeToast:@"录音失败" duration:2 position:CSToastPositionCenter];
}

- (BOOL)recordFileCanBeSend:(NSString *)filepath
{
    NSURL    *URL = [NSURL fileURLWithPath:filepath];
    AVURLAsset *urlAsset = [[AVURLAsset alloc]initWithURL:URL options:nil];
    CMTime time = urlAsset.duration;
    CGFloat mediaLength = CMTimeGetSeconds(time);
    return mediaLength > 2;
}

- (void)showRecordFileNotSendReason
{
    [self.view makeToast:@"录音时间太短" duration:0.2f position:CSToastPositionCenter];
}


#pragma mark - Get

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

- (NTESChatroomConfig *)config{
    if (!_config) {
        _config = [[NTESChatroomConfig alloc] initWithChatroom:self.chatroom.roomId];
    }
    return _config;
}


@end
