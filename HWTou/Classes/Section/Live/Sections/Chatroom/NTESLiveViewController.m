//
//  NTESLiveViewController.m
//  NIM
//
//  Created by chris on 15/12/16.
//  Copyright © 2015年 Netease. All rights reserved.
//

#import "NTESLiveViewController.h"
#import "NTESChatroomSegmentedControl.h"
#import "UIView+NTES.h"
#import "NTESPageView.h"
#import "NTESChatroomViewController.h"
#import "NTESChatroomMemberListViewController.h"
#import "UIImageView+WebCache.h"
#import "SVProgressHUD.h"
#import "UIImage+NTESColor.h"
#import "NTESLiveActionView.h"
#import "UIView+Toast.h"
#import "NTESSessionViewController.h"

@interface NTESLiveViewController ()<NTESLiveActionViewDataSource,NTESLiveActionViewDelegate,NIMChatroomManagerDelegate>

@property (nonatomic, copy)   NIMChatroom *chatroom;

@property (nonatomic, strong) NTESChatroomViewController *chatroomViewController;

@property (nonatomic, strong) NTESLiveActionView *actionView;

@end

@implementation NTESLiveViewController

NTES_USE_CLEAR_BAR

- (instancetype)initWithChatroom:(NIMChatroom *)chatroom{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        _chatroom = chatroom;
    }
    
    return self;
}

- (void)dealloc{
    [[NIMSDK sharedSDK].chatroomManager exitChatroom:_chatroom.roomId completion:nil];
    [[NIMSDK sharedSDK].chatroomManager removeDelegate:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"聊天室";
    self.view.backgroundColor = [UIColor whiteColor];

    self.chatroomViewController = [[NTESChatroomViewController alloc] initWithChatroom:self.chatroom];
    [self addChildViewController:self.chatroomViewController];
    
    [self.view addSubview:self.actionView];
    [self.actionView reloadData];
    [self adjustInputView];
    [self setupBackBarButtonItem];
    
    
    [[NIMSDK sharedSDK].chatroomManager addDelegate:self];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent
                                                animated:NO];
    [self.chatroomViewController beginAppearanceTransition:YES animated:animated];
}


- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault
                                                animated:NO];
    [self.chatroomViewController beginAppearanceTransition:NO animated:animated];
}


- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self.chatroomViewController endAppearanceTransition];
}


- (BOOL)shouldAutomaticallyForwardAppearanceMethods
{
    return NO;
}

#pragma mark - NTESLiveActionViewDataSource

- (NSInteger)numberOfPages
{
    return self.childViewControllers.count;
}

- (UIView *)viewInPage:(NSInteger)index
{
    UIView *view = self.childViewControllers[index].view;
    return view;
}

- (CGFloat)liveViewHeight
{
    return 0;
}


#pragma mark - NTESLiveActionViewDelegate

- (void)onTouchActionBackground
{
    [self.chatroomViewController.sessionInputView endEditing:YES];
}

#pragma mark - Get

- (NTESLiveActionView *)actionView
{
    if (!self.isViewLoaded) {
        return nil;
    }
    if (!_actionView) {
        _actionView = [[NTESLiveActionView alloc] initWithDataSource:self];
        _actionView.frame = self.view.bounds;
        _actionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _actionView.delegate = self;
    }
    return _actionView;
}

#pragma mark - NIMChatroomManagerDelegate
- (void)chatroom:(NSString *)roomId beKicked:(NIMChatroomKickReason)reason
{
    if ([roomId isEqualToString:self.chatroom.roomId]) {
        NSString *toast = [NSString stringWithFormat:@"你被踢出聊天室"];
        DDLogInfo(@"chatroom be kicked, roomId:%@  rease:%zd",roomId,reason);
        [[NIMSDK sharedSDK].chatroomManager exitChatroom:roomId completion:nil];
        
        [self.view.window makeToast:toast duration:2.0 position:CSToastPositionCenter];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)chatroom:(NSString *)roomId connectionStateChanged:(NIMChatroomConnectionState)state;
{
    DDLogInfo(@"chatroom connectionStateChanged roomId : %@  state:%zd",roomId,state);
}

- (void)chatroom:(NSString *)roomId autoLoginFailed:(NSError *)error
{
    NSString *toast = [NSString stringWithFormat:@"chatroom autoLoginFailed failed : %zd",error.code];
    DDLogInfo(@"%@",toast);
    [[NIMSDK sharedSDK].chatroomManager exitChatroom:roomId completion:nil];
    [self.view.window makeToast:toast duration:2.0 position:CSToastPositionCenter];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Private

//这个视图是替换一下聊天室的输入框，为了在多行输入显示时，输入框可以遮住上层的直播图
- (void)adjustInputView
{
    UIView *inputView  = self.chatroomViewController.sessionInputView;
    CGRect frame = [inputView.superview convertRect:inputView.frame toView:self.view];
    inputView.frame = frame;
    [self.view addSubview:inputView];
}

- (void)setupBackBarButtonItem
{
    UIImage *buttonNormal = [[UIImage imageNamed:@"chatroom_back_normal"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImage *buttonSelected = [[UIImage imageNamed:@"chatroom_back_selected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [self.navigationController.navigationBar setBackIndicatorImage:buttonNormal];
    [self.navigationController.navigationBar setBackIndicatorTransitionMaskImage:buttonSelected];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = backItem;
}

#pragma mark - Rotate
- (BOOL)shouldAutorotate{
    return NO;
}

@end
