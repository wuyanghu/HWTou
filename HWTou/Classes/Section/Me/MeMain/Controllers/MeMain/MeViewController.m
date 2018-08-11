//
//  MeViewController.m
//  HWTou
//
//  Created by pengpeng on 17/3/7.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "MeViewController.h"

#import "PublicHeader.h"

#import "MeView.h"
#import "MeFuncModel.h"
#import "MessageReq.h"
#import "WZLBadgeImport.h"

#import <HWTSDK/HWTAPI.h>
#import "RongduManager.h"
#import "InvestAccountNewVC.h"
#import "CouponViewController.h"
#import "MyWalletViewController.h"
#import "MyOrderViewController.h"
#import "MessageViewController.h"
#import "OrderListViewController.h"
#import "ActivityListViewController.h"
#import "MyCollectionViewController.h"
#import "MemberCenterViewController.h"
#import "PersonalInfoViewController.h"
#import "PersonalSetUpViewController.h"
#import "ConsumptionGoldViewController.h"
#import "CustomerAndFeedbackViewController.h"
#import "InvestViewController.h"
#import "PersonalHomePageViewController.h"
#import "WorkBenchViewController.h"
#import "CollectSessionReq.h"
#import "TopicWorkDetailModel.h"
#import "PersonalAttendViewController.h"
#import "ExpertAnchorViewController.h"
#import "ComFloorEvent.h"
#import "PersonHomeReq.h"
#import "ExpertAnchorStatusViewController.h"
#import "ComWebViewController.h"
#import "CollectionViewController.h"
#import "InviteMyFriendViewController.h"
#import "CommodityOrderViewController.h"
#import "MyAuctionViewController.h"

typedef NS_ENUM(NSInteger,buttonTag) {
    leftButtonTag,
    rightButtonTag,
};

@interface MeViewController ()<MeViewProtocol>{

    BOOL g_IsNavHidden;
    
}

@property (nonatomic, strong) UIBarButtonItem *itemMessage;
@property (nonatomic, strong) MeView *m_MeView;
@property (nonatomic, strong) UIButton *m_MsgBtn;

@end

@implementation MeViewController
@synthesize m_MeView;
@synthesize m_MsgBtn;

#pragma mark - Life Cycle
- (void)viewDidLoad{
    
    [super viewDidLoad];

    [self dataInitialization];
    [self addMainView];
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    // 界面没有隐藏才调用隐藏，防止隐藏动画过程UI显示问题
    if (!self.navigationController.navigationBarHidden) {
        [self.navigationController setNavigationBarHidden:YES animated:YES];
    }
    
    if (!IsNilOrNull(m_MeView)) [m_MeView obtainPersonalInfo];
    
    [self loadBadgeNumber];
    
    g_IsNavHidden = NO;
    
}

- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    
    // 如果当前VC是self则不需要隐藏，如TabBar切换的过程
    if (self.navigationController.topViewController != self && g_IsNavHidden == NO) {
        
        [self.navigationController setNavigationBarHidden:NO animated:YES];
        
    }
    
}

- (void)didReceiveMemoryWarning{
    
    [super didReceiveMemoryWarning];
    
}

#pragma mark - Add UI
- (void)addMainView{

    [self addMeView];
    [self addNavBarView];
    
}

- (void)addMeView{

    MeView *meView = [[MeView alloc] init];
    [meView setM_Delegate:self];
    [self setM_MeView:meView];
    [self.view addSubview:meView];
    
    [meView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
}

- (void)addNavBarView{
    
    UILabel *labNavTitle = [BasisUITool getLabelWithTextColor:UIColorFromHex(0x333333)
                                                         size:NAVIGATION_FONT_TITLE_SIZE];
    [labNavTitle setText:self.navigationItem.title];
    [self.view addSubview:labNavTitle];
    
//    UIButton *msgBtn = [BasisUITool getBtnWithTarget:self
//                                              action:@selector(onNavigationCustomLeftBtnClick:)];
//    msgBtn.tag = leftButtonTag;
//    [msgBtn.layer setCornerRadius:0];
//    [msgBtn.layer setMasksToBounds:NO];
//
//    [msgBtn setImage:ImageNamed(NAVIGATION_IMG_SMSBTN_NOR) forState:UIControlStateNormal];
//    [msgBtn setImage:ImageNamed(NAVIGATION_IMG_SMSBTN_HLT) forState:UIControlStateHighlighted];
//
//    [self setM_MsgBtn:msgBtn];
//    [self.view addSubview:msgBtn];
    
    UIButton * workBtn = [BasisUITool getNormalBtnWithTarget:self action:@selector(onNavigationCustomLeftBtnClick:)];
    workBtn.tag = rightButtonTag;
    [workBtn setTitle:@"工作台" forState:UIControlStateNormal];
    [workBtn setTitleColor:UIColorFromHex(0x2B2B2B) forState:UIControlStateNormal];
    [workBtn setBackgroundImage:[UIImage imageNamed:@"wode_btn_work"] forState:UIControlStateNormal];
    [self.view addSubview:workBtn];
    
    [labNavTitle makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(@40);
        make.height.equalTo(@40);
    }];
    
//    [msgBtn makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.equalTo(labNavTitle);
//        make.leading.equalTo(self.view).offset(10);
//    }];
    
    [workBtn makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(labNavTitle);
        make.right.equalTo(self.view.mas_right);
    }];
    
}

- (void)loadBadgeNumber{
    
    if ([AccountManager isNeedLogin]) {
        
        return;
        
    }
    
    MessageNumParam *param = [MessageNumParam new];
    
    param.type = 0;
    
    [MessageReq numberWithParam:param success:^(MessageNumResp *response) {
        
        [self setMsgNumber:response.data.number];
        
    } failure:nil];
    
}

- (void)setMsgNumber:(NSInteger)num{
    
    if (num > 0) {
        
        [m_MsgBtn setBadgeCenterOffset:CGPointMake(-5, 5)];
        [m_MsgBtn setBadgeBgColor:UIColorFromHex(0xb4292d)];
        [m_MsgBtn showBadgeWithStyle:WBadgeStyleNumber value:num animationType:WBadgeAnimTypeNone];
        
    } else {
        
        [m_MsgBtn clearBadge];
        
    }
    
}

#pragma mark - Public Functions
- (void)dataInitialization{
    
    g_IsNavHidden = NO;
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
}

#pragma mark - Button Handlers
- (void)onNavigationCustomLeftBtnClick:(UIButton *)sender{

    if ([AccountManager isNeedLogin]) {
        [AccountManager showLoginView];
        return;
    }
    
    if (sender.tag == leftButtonTag) {
        BaseViewController * baseVC = [[MessageViewController alloc] init];
        [self.navigationController pushViewController:baseVC animated:YES];
    }else{
        
        [CollectSessionReq getTopicWorkDetail:[BaseParam new] Success:^(TopicWorkDetailResponse *response) {
            if (response.status == 200) {
                TopicWorkDetailModel * detailModel = [TopicWorkDetailModel new];
                [detailModel setValuesForKeysWithDictionary:response.data];
                //如果是达人主播，进工作台
                if (detailModel.isChatM == 1 || detailModel.isChatAnchor == 1) {//聊吧
                    WorkBenchViewController * baseVC = [[WorkBenchViewController alloc] init];
                    [baseVC.detailModel setValuesForKeysWithDictionary:response.data];
                    baseVC.workType = workChatType;
                    [self.navigationController pushViewController:baseVC animated:YES];
                    return ;
                }
                
                [Navigation showExpertAnchorHtml5:self detailModel:detailModel];

            }else{

            }

        } failure:^(NSError *error) {
            [HUDProgressTool showErrorWithText:ReqErrCode_Custom_ErrorInfo];
        }];
        
    }
    
}

#pragma mark - MeView Delegate Manager
- (void)onPersonalInfo {
    
    [Navigation showPersonalHomePageViewController:self attendType:editDataButtonType uid:0];
}

- (void)buttonSelected:(UIButton *)button {
    
    if ([AccountManager isNeedLogin]) {
        [AccountManager showLoginView];
        return;
    }
    
    PersonalAttendViewController * attendVC = [[PersonalAttendViewController alloc] init];
    if (button.tag == 1) {//关注
        attendVC.personalAttendType = personalAttendType;
    }else if (button.tag == 2){//粉丝
        attendVC.personalAttendType = personalFansType;
    }
    [self.navigationController pushViewController:attendVC animated:YES];
}

- (void)onFunctionalResponse:(FuncType)funcType withPersonalInfo:(PersonHomeDM *)model{

    UIViewController *vc;
    switch (funcType) {
        case FuncType_MyOrder:{// 我的订单
            
            if ([AccountManager isNeedLogin]) {
                [AccountManager showLoginView];
                return;
            }
            
            vc = [[MyOrderViewController alloc] init];
            
            break;}
        case FuncType_MyCollection:{// 我的收藏
            
            if ([AccountManager isNeedLogin]) {
                [AccountManager showLoginView];
                return;
            }
            
            vc = [[CollectionViewController alloc] init];
            break;}
        case FuncType_MemberCenter:{// 会员中心
            
            if ([AccountManager isNeedLogin]) {
                [AccountManager showLoginView];
                return;
            }
            
            vc = [[MemberCenterViewController alloc] init];
            
            [(MemberCenterViewController *)vc setMemberInfo:model];
            
            break;}
        case FuncType_Coupon:{// 优惠劵
            
            if ([AccountManager isNeedLogin]) {
                [AccountManager showLoginView];
                return;
            }
            
            vc = [[CouponViewController alloc] init];
            
            break;}
        case FuncType_Activity:{// 活动报名
            
            if ([AccountManager isNeedLogin]) {
                [AccountManager showLoginView];
                return;
            }
            
            vc = [[ActivityListViewController alloc] init];
            
            [(ActivityListViewController *)vc setOnlyApplied:YES];
            vc.title = @"我的报名";
            
            break;}
        case FuncType_PersonalSetUp:{// 个人设置
            
            vc = [[PersonalSetUpViewController alloc] init];
            
            break;}
        case FuncType_CustomerAndFeedback:{// 客服与反馈
            FloorItemDM * itemDM = [FloorItemDM new];
            itemDM.type = FloorEventParam;
            itemDM.title = @"客服与反馈";
            itemDM.param = kApiCustomH5UrlHost;
            [ComFloorEvent handleEventWithFloor:itemDM];
            break;
            }
        case FuncType_RedPacket:{// 红包
            
            if ([AccountManager isNeedLogin]) {
                [AccountManager showLoginView];
                return;
            }
            
            g_IsNavHidden = YES;
            
            vc = [[MyWalletViewController alloc] init];
            
            break;}
        case FuncType_GG:{// 绿色公约
            FloorItemDM * itemDM = [FloorItemDM new];
            itemDM.type = FloorEventParam;
            itemDM.title = @"发耶绿色公约";
            itemDM.param = kApiFayeGreenConventionUrlHost;
            [ComFloorEvent handleEventWithFloor:itemDM];
            break;}
        case FuncType_UserManage:{// 用户管理手册
            FloorItemDM * itemDM = [FloorItemDM new];
            itemDM.type = FloorEventParam;
            itemDM.title = @"用户管理手册";
            itemDM.param = kApiFayeUserManageRuleUrlHost;
            [ComFloorEvent handleEventWithFloor:itemDM];
            break;}
        case FuncType_InvestFriend:{//邀请好友
            
            if ([AccountManager isNeedLogin]) {
                [AccountManager showLoginView];
                return;
            }
            
            g_IsNavHidden = YES;

            vc = [[InviteMyFriendViewController alloc] init];
        }
            break;
        case FuncType_order:{//我的订单
            vc = [[CommodityOrderViewController alloc] init];
        }
            break;
        case FuncType_paimai:{//我的拍卖
            vc = [[MyAuctionViewController alloc] initWithNibName:nil bundle:nil];
        }
            break;
        default:
            break;
    }
    
    if (!IsNilOrNull(vc)) [self.navigationController pushViewController:vc animated:YES];
    
}

@end
