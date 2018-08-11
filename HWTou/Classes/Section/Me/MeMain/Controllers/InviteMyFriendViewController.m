//
//  InviteMyFriendViewController.m
//  HWTou
//
//  Created by Reyna on 2018/2/7.
//  Copyright © 2018年 LieMi. All rights reserved.
//

#import "InviteMyFriendViewController.h"
#import "PublicHeader.h"
#import "TopNavBarView.h"
#import "InviteFriendListViewController.h"
#import "SocialThirdController.h"
#import "PersonHomeReq.h"
#import "MeViewController.h"
#import "InviteEarningsViewController.h"
#import "ComWebViewController.h"
#import "MoneyInfoRequest.h"
#import "MoneyAccountModel.h"

@interface InviteMyFriendViewController ()<TopNavBarDelegate>
{
    NSDictionary * responeDict;
}
@property (nonatomic, strong) TopNavBarView *navBar;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UILabel *ruleLab;
@property (weak, nonatomic) IBOutlet UIView *moneyBV;
@property (weak, nonatomic) IBOutlet UILabel *moneyLab;
@property (weak, nonatomic) IBOutlet UILabel *inviteCodeLab;

@end

@implementation InviteMyFriendViewController

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    // 如果当前VC是MeViewController则不需要隐藏
    UIViewController *topVC = self.navigationController.topViewController;
    if (![topVC isKindOfClass:[MeViewController class]]) {
        [self.navigationController setNavigationBarHidden:NO animated:YES];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // 界面没有隐藏才调用隐藏，防止隐藏动画过程UI显示问题
    if (!self.navigationController.navigationBarHidden) {
        [self.navigationController setNavigationBarHidden:YES animated:YES];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createUI];

    [self userAccountRequest];
    [self requestGetInvActivity];
    [self getInviteCode];
}

- (void)createUI {
    self.navBar.delegate = self;
    
#ifdef __IPHONE_11_0
    if ([_scrollView respondsToSelector:@selector(setContentInsetAdjustmentBehavior:)]) {
        _scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
#endif
    
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.colors = @[(__bridge id)UIColorFromHex(0xe95065).CGColor, (__bridge id)UIColorFromHex(0xf3666f).CGColor];
    gradientLayer.locations = @[@0.3, @0.72, @1.0];
    gradientLayer.startPoint = CGPointMake(0.5, 0);
    gradientLayer.endPoint = CGPointMake(0.5, 1.0);
    gradientLayer.frame = CGRectMake(0, 0, kMainScreenWidth, 158);
    [self.moneyBV.layer insertSublayer:gradientLayer atIndex:0];
}

#pragma mark - Request

- (void)userAccountRequest {
    
    NSInteger uid = [AccountManager shared].account.uid;
    [MoneyInfoRequest getUserAccountWithUid:uid success:^(NSDictionary *response) {
        
        if ([[response objectForKey:@"status"] intValue] == 200) {
            
            NSDictionary *dataDic =[response objectForKey:@"data"];
            MoneyAccountModel *m = [[MoneyAccountModel alloc] init];
            [m bindWithDic:dataDic];
            self.moneyLab.text = [NSString stringWithFormat:@"%@",m.iAward];
        }else {
            [HUDProgressTool showErrorWithText:[response objectForKey:@"msg"]];
        }
    } failure:^(NSError *error) {
        [HUDProgressTool showErrorWithText:ReqErrCode_Custom_ErrorInfo];
    }];
}

- (void)requestGetInvActivity{
    [PersonHomeRequest getInvActivity:^(LookCheckStatusResponse *response) {
        if (response.status == 200) {
            responeDict = response.data;
            NSString *ruleStr = response.data[@"remark"];
            NSString *decodeStr = [self htmlEntityDecode:ruleStr];
            NSAttributedString *htmlContent = [self attributedStringWithHTMLString:decodeStr];
            self.ruleLab.attributedText = htmlContent;
            
            CGFloat height = [htmlContent boundingRectWithSize:CGSizeMake(kMainScreenWidth - 20, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size.height;
            
            if (height + 560.5 + 30 > kMainScreenHeight) {
                self.scrollView.contentSize = CGSizeMake(kMainScreenWidth, height + 560.5 + 30);
            }
            else {
                self.scrollView.contentSize = CGSizeMake(kMainScreenWidth, kMainScreenHeight);
            }
        }
        
    } failure:^(NSError *error) {
        
    }];
}

- (void)getInviteCode{
    //个人资料
    UserInfoParam * homeParam = [UserInfoParam new];
    homeParam.uid = 0;
    [PersonHomeRequest getUserInfo:homeParam Success:^(PersonHomeResponse *response) {
        if (response.status == 200) {
            self.inviteCodeLab.text = response.data.inviteCode;
        }
        
    } failure:^(NSError *error) {
        [HUDProgressTool showErrorWithText:ReqErrCode_Custom_ErrorInfo];
    }];
}

#pragma mark - Action

- (IBAction)myInviteBtnAction:(id)sender {
    
    InviteFriendListViewController * inviteFriendlistVC = [[InviteFriendListViewController alloc] init];
    [self.navigationController pushViewController:inviteFriendlistVC animated:YES];
}

- (IBAction)shouyiBtnAction:(id)sender {
    
    InviteEarningsViewController *vc = [[InviteEarningsViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)gonglveBtnAction:(id)sender {
    
    NSString *urlString = [NSString stringWithFormat:@"%@?type=1",kApiInviteStrategyUrlHost];
    ComWebViewController *webVC = [[ComWebViewController alloc] init];
    webVC.title = @"邀请奖金";
    webVC.webUrl = urlString;
    [self.navigationController pushViewController:webVC animated:YES];
}

- (IBAction)tixianBtnAction:(id)sender {
    
    [Navigation showMyWalletViewController:self];
}

- (IBAction)inviteBtnAction:(id)sender {
    
    NSString *unicodetitle = [responeDict[@"title"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *nickName = [AccountManager shared].account.nickName;
    NSString *unicodeStr = [nickName stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString * urlstring = [NSString stringWithFormat:@"%@/downloadapp/#/?qrcode=%@&title=%@&nickname=%@",kApiH5UrlHost,self.inviteCodeLab.text,unicodetitle,unicodeStr];
    NSString * title = responeDict[@"title"];
    NSString * content = [NSString stringWithFormat:@"你的好友%@邀请你一起用声音打开美好艺术",nickName];
    
    [SocialThirdController shareWebLink:urlstring title:title content:content thumbnail:[UIImage imageNamed:@"share_icon"] completed:^(BOOL success, NSString *errMsg) {
        if (success) {
            [HUDProgressTool showOnlyText:@"已分享"];
        } else {
            [HUDProgressTool showOnlyText:errMsg];
        }
    }];
}

#pragma mark - TopNavBarDelegate

- (void)topNavBackBtnAction {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Get

- (TopNavBarView *)navBar {
    if (!_navBar) {
        _navBar = [[TopNavBarView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 64) type:1];
        [self.view addSubview:_navBar];
    }
    return _navBar;
}

#pragma mark - HTMLContent

//将 &lt 等类似的字符转化为HTML中的“<”等
- (NSString *)htmlEntityDecode:(NSString *)string
{
    string = [string stringByReplacingOccurrencesOfString:@"&quot;" withString:@"\""];
    string = [string stringByReplacingOccurrencesOfString:@"&apos;" withString:@"'"];
    string = [string stringByReplacingOccurrencesOfString:@"&lt;" withString:@"<"];
    string = [string stringByReplacingOccurrencesOfString:@"&gt;" withString:@">"];
    string = [string stringByReplacingOccurrencesOfString:@"&amp;" withString:@"&"]; // Do this last so that, e.g. @"&amp;lt;" goes to @"&lt;" not @"<"
    
    return string;
}

//将HTML字符串转化为NSAttributedString富文本字符串
- (NSAttributedString *)attributedStringWithHTMLString:(NSString *)htmlString
{
    NSDictionary *options = @{ NSDocumentTypeDocumentAttribute : NSHTMLTextDocumentType,
                               NSCharacterEncodingDocumentAttribute :@(NSUTF8StringEncoding) };
    
    NSData *data = [htmlString dataUsingEncoding:NSUTF8StringEncoding];
    
    return [[NSAttributedString alloc] initWithData:data options:options documentAttributes:nil error:nil];
}

#pragma mark -

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
