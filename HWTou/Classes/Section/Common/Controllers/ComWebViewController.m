//
//  ComWebViewController.m
//
//  Created by pengpeng on 17/3/27.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import <WebKit/WebKit.h>
#import "LoginViewController.h"
#import "CustomNavigationController.h"
#import "ProductDetailViewController.h"
#import "LuckyMoneyViewController.h"
#import "UINavigationItem+Margin.h"
#import "SocialThirdController.h"
#import "ComWebViewController.h"
#import "ProductDetailDM.h"
#import "ComFloorEvent.h"
#import "PublicHeader.h"
#import "TopicWorkDetailModel.h"
#import "InviteMyFriendViewController.h"
#import "GuessULikeModel.h"

@interface ComWebViewController () <WKNavigationDelegate, WKScriptMessageHandler>
{
    NSString * shareUrl;
}
@property (nonatomic, strong) UIView    *viewFail;
@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic, strong) UIProgressView *vProgress;
@property (nonatomic, copy) ComWebScriptHandle handleScriptIn; // 用于内部处理

@end

@implementation ComWebViewController

/** 进度条颜色 */
#define kProgressColor  [UIColor colorWithRed:180/255.0f green:41/255.0f blue:45/255.0f alpha:1]

static  NSString * const kEstimatedProgress = @"estimatedProgress";
static  NSString * const kWKWebViewTitle = @"title";

/** JSScript Name */
static NSString *productInfo = @"productInfo";
static NSString *activityInfo = @"openActInfo";
static NSString *toInvest = @"toInvestPage";
static NSString *toRedPack = @"toRedPage";
static NSString *getSureTokenNew = @"getSureTokenNew";
static NSString *goTopic = @"goTopic";
static NSString *goPhone = @"phoneCall";
static NSString *toPlayActivity = @"toPlayActivity";
static NSString *toInviteFriends = @"toInviteFriends";
static NSString *linkUsefor = @"linkUsefor";
static NSString *iOSAutoPlay = @"iOSAutoPlay";
static NSString *goToBack = @"goToBack";
static NSString *toChartRoom = @"toChartRoom";

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self createUI];
    
    if (self.webUrl.length > 0) {
        [self loadWebWithUrl:self.webUrl];
    }
    [self addJSToOCEvent];

}

- (void)createUI
{
    UIBarButtonItem *itemShare = [UIBarButtonItem itemWithImageName:@"navi_share_nor" hltImageName:nil target:self action:@selector(actionShare)];
    [self.navigationItem addRightBarButtonItem:itemShare fixedSpace:10];
    
    self.webView.navigationDelegate = self;
    [self.view addSubview:self.webView];
    
    self.webView.translatesAutoresizingMaskIntoConstraints = NO;
    NSLayoutConstraint *leftConstraint = [NSLayoutConstraint constraintWithItem:self.webView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0];
    
    NSLayoutConstraint *rightConstraint = [NSLayoutConstraint constraintWithItem:self.webView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeRight multiplier:1.0 constant:0];
    
    NSLayoutConstraint *bottomConstraint = [NSLayoutConstraint constraintWithItem:self.webView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0];
    
    NSLayoutConstraint *heightConstraint = [NSLayoutConstraint constraintWithItem:self.webView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:0];
    
    NSArray *constraints = @[leftConstraint, rightConstraint, bottomConstraint, heightConstraint];
    [self.view addConstraints:constraints];
    
    [self.webView addObserver:self forKeyPath:kEstimatedProgress options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
    [self.webView addObserver:self forKeyPath:kWKWebViewTitle options:NSKeyValueObservingOptionNew context:nil];
}

- (WKWebView *)webView
{
    if (_webView == nil) {
        _webView = [[WKWebView alloc] init];
    }
    return _webView;
}

- (void)dealloc
{
    [self.webView removeObserver:self forKeyPath:kEstimatedProgress];
    [self.webView removeObserver:self forKeyPath:kWKWebViewTitle];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self removeScriptMethod:toInvest];
    [self removeScriptMethod:toRedPack];
    [self removeScriptMethod:productInfo];
    [self removeScriptMethod:activityInfo];
    [self removeScriptMethod:getSureTokenNew];
    [self removeScriptMethod:goTopic];
    [self removeScriptMethod:goPhone];
    [self removeScriptMethod:toPlayActivity];
    [self removeScriptMethod:toInviteFriends];
    [self removeScriptMethod:linkUsefor];
    [self removeScriptMethod:iOSAutoPlay];
    [self removeScriptMethod:goToBack];
    [self removeScriptMethod:toChartRoom];
}

- (void)addScriptMethod:(NSString *)name
{
    // OC注册供JS调用的方法
    [[self.webView configuration].userContentController addScriptMessageHandler:self name:name];
}

- (void)removeScriptMethod:(NSString *)name
{
    //移除JS方法
    [[self.webView configuration].userContentController removeScriptMessageHandlerForName:name];
}

- (BOOL)loadWebWithUrl:(NSString *)webUrl
{
    _webUrl = webUrl;
    if ([webUrl hasPrefix:@"http"]) {
        NSURL *url = [NSURL URLWithString:webUrl];
        NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:-1];
        [self.webView loadRequest:request];
        return YES;
    }
    return NO;
}

- (void)actionShare
{
    NSString *url;
    if (shareUrl) {
        url = shareUrl;
    }else{
        url = self.webView.URL.absoluteString;
    }
    [SocialThirdController shareWebLink:url title:self.webView.title content:@"发耶APP-用声音打开美好艺术" thumbnail:[UIImage imageNamed:@"share_icon"] completed:^(BOOL success, NSString *errMsg) {
        if (success) {
            [HUDProgressTool showOnlyText:@"已分享"];
        } else {
            [HUDProgressTool showOnlyText:errMsg];
        }
    }];
}

- (void)addJSToOCEvent
{
    [self addScriptMethod:toInvest];
    [self addScriptMethod:toRedPack];
    [self addScriptMethod:productInfo];
    [self addScriptMethod:activityInfo];
    [self addScriptMethod:getSureTokenNew];
    [self addScriptMethod:goTopic];
    [self addScriptMethod:goPhone];
    [self addScriptMethod:toPlayActivity];
    [self addScriptMethod:toInviteFriends];
    [self addScriptMethod:linkUsefor];
    [self addScriptMethod:iOSAutoPlay];
    [self addScriptMethod:goToBack];
    [self addScriptMethod:toChartRoom];
    
    WeakObj(self);
    self.handleScriptIn = ^(NSString *method, id param) {
        NSLog(@"web回调js方法:%@",method);
        if ([method isEqualToString:productInfo]) {
            [selfWeak handleProductDetail:param];
        } else if ([method isEqualToString:getSureTokenNew]) {
            // 新增刷新token方法，直接调用JS方法
            [selfWeak refreshToken];
        } else if ([method isEqualToString:activityInfo]) {
            // 进入活动详情
            [selfWeak handleActivityDetail:param];
        } else if ([method isEqualToString:toRedPack]) {
            // 跳转到红包页面
            [selfWeak handleRedPack];
        } else if ([method isEqualToString:toInvest]) {
            // 跳转到赚铜钱主页
            [selfWeak handleInvestHome];
        }else if ([method isEqualToString:goTopic]){
            [selfWeak handleGoTopic:param];//进入话题详情
        }else if ([method isEqualToString:goPhone]){
            [selfWeak handleGoPhone:param];//打电话
        }else if ([method isEqualToString:toPlayActivity]){//
            [selfWeak handleToPlayActivity:param];//跳到路况界面
        }else if ([method isEqualToString:toInviteFriends]){
            [selfWeak handleToInviteFriends];//跳到邀请好友
        }else if ([method isEqualToString:linkUsefor]){
            [selfWeak handleShare:param];
        }else if ([method isEqualToString:iOSAutoPlay]){
            [selfWeak handleAutoPlay];
        }else if ([method isEqualToString:goToBack]){
            [selfWeak handleGoToBack];
        }else if ([method isEqualToString:toChartRoom]){
            [selfWeak handleToChartRoom:param];
        }
    };
}

// 刷新token方法
- (void)refreshToken
{
    AccountModel *account = [[AccountManager shared] account];
    if (!IsStrEmpty(account.userName) && !IsStrEmpty(account.passWord)) {
        // 登录过，token过期处理
        [AccountManager loginWithUserName:account.userName password:account.passWord complete:^(NSInteger code, NSString *msg, NSInteger uid) {
                                     
            if (code == kHttpCodeOperateSucceed) {
                [self refreshJSToken];
            } else {
                [HUDProgressTool showOnlyText:msg];
                [self jumpLoginController];
            }
        } failure:^(NSError *error) {
            [HUDProgressTool showOnlyText:[error urlErrorCodeDescribe]];
        }];
    } else {
        [self jumpLoginController];
    }
}

- (void)handleToPlayActivity:(id)param{
    NSLog(@"handleToPlayActivity");
}

- (void)handleToInviteFriends{
    InviteMyFriendViewController * frientVC = [[InviteMyFriendViewController alloc] init];
    [self.navigationController pushViewController:frientVC animated:YES];
}

- (void)jumpLoginController
{
    LoginViewController *loginVC = [[LoginViewController alloc] init];
    
    WeakObj(loginVC);
    loginVC.loginSuccess = ^{
        [loginVCWeak dismissViewControllerAnimated:YES completion:nil];
        [self refreshJSToken];
    };
    
    CustomNavigationController *navCtl = [[CustomNavigationController alloc] initWithRootViewController:loginVC];
    [self presentViewController:navCtl animated:YES completion:nil];
}

- (void)refreshJSToken
{
    NSString *jsMethod = [NSString stringWithFormat:@"reLoginCallback('%@')", [AccountManager shared].account.token];
    [self.webView evaluateJavaScript:jsMethod completionHandler:^(id result, NSError * error) {
        NSLog(@"OC to JS result:%@, error:%@", result, error);
    }];
}

- (void)handleProductDetail:(NSString *)item_id
{
    FloorItemDM *dmItem = [FloorItemDM new];
    dmItem.type = FloorEventProduct;
    dmItem.param = item_id;
    [ComFloorEvent handleEventWithFloor:dmItem];
}

- (void)handleActivityDetail:(NSString *)actId
{
    FloorItemDM *dmItem = [FloorItemDM new];
    dmItem.type = FloorEventActivity;
    dmItem.param = actId;
    [ComFloorEvent handleEventWithFloor:dmItem];
}

- (void)handleRedPack
{
    LuckyMoneyViewController *vc = [LuckyMoneyViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)handleInvestHome
{
    FloorItemDM *dmItem = [FloorItemDM new];
    dmItem.type = FloorEventInvest;
    [ComFloorEvent handleEventWithFloor:dmItem];
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIF_SkipInvestProduct object:nil];
}

- (void)handleGoTopic:(id)param{
    NSDictionary * dictParam = (NSDictionary *)param;
    MyTopicListModel * topicListModel = [MyTopicListModel new];
    topicListModel.topicId = [dictParam[@"tid"] intValue];
    [Navigation showAudioPlayerViewController:self radioModel:topicListModel];
}

- (void)handleGoPhone:(id)param{
    NSDictionary * dictParam = (NSDictionary *)param;
    NSString * phone = dictParam[@"tid"];
    NSMutableString *str=[[NSMutableString alloc]initWithFormat:@"tel:%@",phone];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
}

- (void)handleShare:(id)param{
    NSDictionary * dictParam = (NSDictionary *)param;
    shareUrl = dictParam[@"link"];
}

- (void)handleToChartRoom:(id)param{
    NSDictionary * dictParam = (NSDictionary *)param;
    GuessULikeModel * ulikeModel = [GuessULikeModel new];
    ulikeModel.roomId = [dictParam[@"croomId"] integerValue];
    ulikeModel.rtcId = [dictParam[@"rtcId"] integerValue];
    
    [Navigation lookLiveRoom:self model:ulikeModel];
}

- (void)handleAutoPlay {
    [self.webView evaluateJavaScript: @"var audio = document.getElementById('audio'); audio.play();" completionHandler: nil];
}

- (void)handleGoToBack {
    [self.navigationController popViewControllerAnimated:YES];
}

- (BOOL)reloadWebWithUrl:(NSString *)webUrl
{
    BOOL success = [self loadWebWithUrl:webUrl];
    [self.webView reload];
    return success;
}

#pragma mark - 屏幕旋转控制
- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationPortrait;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)showFailView
{
    if (self.viewFail == nil) {
        UIButton *button = [[UIButton alloc] initWithFrame:self.view.bounds];
        [button.titleLabel setFont:[UIFont systemFontOfSize:15.0]];
        [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorWithWhite:0.8 alpha:1] forState:UIControlStateHighlighted];
        [button addTarget:self action:@selector(reloadAfterFail) forControlEvents:UIControlEventTouchUpInside];
        button.titleLabel.textAlignment = NSTextAlignmentCenter;
        button.titleLabel.numberOfLines = 0;
        [button setTitle:@"加载失败\n点击屏幕重试" forState:UIControlStateNormal];
        
        self.viewFail = button;
        [self.view addSubview:self.viewFail];
    }
    self.viewFail.hidden = NO;
}

- (UIProgressView *)vProgress
{
    if (_vProgress == nil) {
        
        CGRect frame = self.view.frame;
        frame.size.height = 4.0f;
        
        _vProgress = [[UIProgressView alloc] initWithFrame:frame];
        _vProgress.tintColor = kProgressColor;
        _vProgress.trackTintColor = [UIColor clearColor];
        
        [self.view addSubview:_vProgress];
    }
    return _vProgress;
}

#pragma mark Private Method
- (void)reloadAfterFail
{
    self.viewFail.hidden = YES;
    [self reloadWebWithUrl:self.webUrl];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    
    if ([keyPath isEqualToString:kEstimatedProgress]) {
        CGFloat newProgress = [[change objectForKey:NSKeyValueChangeNewKey] doubleValue];
        CGFloat oldProgress = [[change objectForKey:NSKeyValueChangeOldKey] doubleValue];
        // 进度条倒退的问题
        if (newProgress <= oldProgress) {
            [self.vProgress setProgress:newProgress animated:NO];
            return;
        }
        [self.vProgress setProgress:newProgress animated:YES];
        if (newProgress == 1) {
            [UIView animateWithDuration:0.5 animations:^{
                self.vProgress.layer.opacity = 0.8;
            } completion:^(BOOL finished) {
                self.vProgress.hidden = YES;
            }];
        } else {
            self.vProgress.layer.opacity = 1;
            self.vProgress.hidden = NO;
        }
    } else if ([keyPath isEqualToString:kWKWebViewTitle]) {
        if (!self.title) {
            self.title = self.webView.title;
        }
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

#pragma mark - WKScriptMessageHandler
// OC在JS调用方法做的处理
- (void)userContentController:(WKUserContentController *)userContentController
      didReceiveScriptMessage:(WKScriptMessage *)message
{
    !self.handleScriptIn ?: self.handleScriptIn(message.name, message.body);
    !self.handleScript ?: self.handleScript(message.name, message.body);
}

#pragma mark - WKNavigationDelegate
// 根据webView、navigationAction相关信息决定这次跳转是否可以继续进行
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler
{
    //NSLog(@"%s", __FUNCTION__);
    WKNavigationActionPolicy policy = WKNavigationActionPolicyAllow;
    
    NSString *url = navigationAction.request.URL.absoluteString;
    if ([url hasPrefix:@"https://itunes.apple.com"] || [url hasPrefix:@"tel://"] || [url hasPrefix:@"sms://"] || [url hasPrefix:@"mailto://"] || [url hasPrefix:@"telprompt://"])
    {
        if ([[UIApplication sharedApplication] openURL:navigationAction.request.URL]) {
            policy = WKNavigationActionPolicyCancel;
        }
    }
    decisionHandler(policy);
}

// 当客户端收到服务器的响应头，根据response相关信息，可以决定这次跳转是否可以继续进行
- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler
{
    decisionHandler(WKNavigationResponsePolicyAllow);
}

// 页面开始加载时调用
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(null_unspecified WKNavigation *)navigation
{
}

// 启动时加载数据发生错误就会调用这个方法
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error
{
    NSLog(@"%s", __FUNCTION__);
    if (error.code == NSURLErrorCannotFindHost || error.code == NSURLErrorCannotConnectToHost ||
        error.code == NSURLErrorNetworkConnectionLost || error.code == NSURLErrorBadServerResponse
        || error.code == NSURLErrorNotConnectedToInternet) {
        [self showFailView];
    }
}

// 当内容开始返回时调用
- (void)webView:(WKWebView *)webView didCommitNavigation:(null_unspecified WKNavigation *)navigation
{
}

// 页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation
{
}

// 当一个正在提交的页面在跳转过程中出现错误时调用这个方法
- (void)webView:(WKWebView *)webView didFailNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error
{
    NSLog(@"%s", __FUNCTION__);
    [HUDProgressTool showOnlyText:@"加载失败..."];
}

@end
