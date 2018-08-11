//
//  ConsumptionGoldViewController.m
//  HWTou
//
//  Created by 赤 那 on 2017/4/21.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "ConsumptionDetailsViewController.h"
#import "ConsumDetailsListViewController.h"
#import "ConsumptionGoldViewController.h"
#import "InvestAccountNewVC.h"
#import "ConsumpGoldExtractVC.h"
#import "ConsumptionGoldView.h"
#import "MeViewController.h"
#import "PersonalInfoReq.h"
#import <YYModel/YYModel.h>
#import <HWTSDK/HWTAPI.h>
#import "RongduManager.h"
#import "PublicHeader.h"
#import "ConsumptionGoldReq.h"
#import "PublicHeader.h"
#import "VTMagic.h"
#import "MMAlertView.h"


@interface ConsumptionGoldViewController ()<ConsumptionGoldViewDelegate,VTMagicViewDelegate,VTMagicViewDataSource>

@property (nonatomic, strong) ConsumptionGoldView *m_ConsumptionGoldView;

@property (nonatomic, strong) PersonalInfoDM *m_PersonalInfoModel;
@property (nonatomic, assign) BOOL hideAnimated;
@property (nonatomic, strong) VTMagicController *magicController;
@property (nonatomic, strong) MMAlertView *vHint;

@end

@implementation ConsumptionGoldViewController
@synthesize m_ConsumptionGoldView;
@synthesize m_PersonalInfoModel;

#pragma mark - Life Cycle
- (void)viewDidLoad{
    
    [super viewDidLoad];
    
    [self setTitle:@"提前花"];
    
    [self dataInitialization];
    [self addMainView];
    [self createUI];
    self.hideAnimated = YES;
    
    [[RongduManager share] getInvestRecord];
    [m_ConsumptionGoldView setPersonalInfo:self.m_PersonalInfoModel];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // 界面没有隐藏才调用隐藏，防止隐藏动画过程UI显示问题
    if (!self.navigationController.navigationBarHidden) {
        [self.navigationController setNavigationBarHidden:YES animated:!self.hideAnimated];
    }
    self.hideAnimated = NO;
    [self loadInfoData];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    // 如果当前VC是MeViewController则不需要隐藏, 和外面冲突
    UIViewController *topVC = self.navigationController.topViewController;
    if ([topVC isKindOfClass:[MeViewController class]] == NO &&
        [topVC isKindOfClass:[InvestAccountNewVC class]] == NO) {
        [self.navigationController setNavigationBarHidden:NO animated:YES];
    }
}

- (void)loadInfoData
{
    [PersonalInfoReq personalInfoSuccess:^(PersonalInfoResp *response) {
        m_PersonalInfoModel = response.data;
        [m_ConsumptionGoldView setPersonalInfo:m_PersonalInfoModel];
    } failure:^(NSError *error) {
        [HUDProgressTool showOnlyText:[error urlErrorCodeDescribe]];
    }];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

#pragma mark - Add UI
- (void)addMainView
{
    [self addConsumptionGoldView];
    [self addNavBarView];
}

- (void)addNavBarView{
    
    UILabel *labNavTitle = [BasisUITool getLabelWithTextColor:[UIColor whiteColor]
                                                         size:NAVIGATION_FONT_TITLE_SIZE];
    
    [labNavTitle setText:self.navigationItem.title];
    
    [self.view addSubview:labNavTitle];
    
    UIButton *backBtn = [BasisUITool getBtnWithTarget:self
                                               action:@selector(onNavigationCustomLeftBtnClick:)];
    
//    [backBtn.layer setCornerRadius:0];
//    [backBtn.layer setMasksToBounds:NO];
    
    [backBtn setImage:ImageNamed(NAVIGATION_IMG_WHITE_BACKBTN_NOR) forState:UIControlStateNormal];
    [backBtn setImage:ImageNamed(NAVIGATION_IMG_WHITE_BACKBTN_HLT) forState:UIControlStateHighlighted];
    
    [self.view addSubview:backBtn];
    
    UIButton *HintBtn = [BasisUITool getBtnWithTarget:self
                                                  action:@selector(Hint:)];
    [HintBtn setImage:[UIImage imageNamed:@"consumption_hint_ico"] forState:UIControlStateNormal];
    [self.view addSubview:HintBtn];

    MMAlertViewConfig *alertConfig = [MMAlertViewConfig globalConfig];
    alertConfig.defaultTextOK = @"确定";
    alertConfig.titleFontSize = 16.0f;
    alertConfig.titleColor = UIColorFromHex(0x333333);
    
    NSString *message = @"1、投资提前花的标后，提前花到账，状态为冻结，待满标后即可使用；\n 2、标的回款后，提前花金额可提现";
    _vHint = [[MMAlertView alloc] initWithConfirmTitle:@"温馨提示" detail:message];
    _vHint.detailLabel.textAlignment = NSTextAlignmentLeft;
    _vHint.detailLabel.textColor = UIColorFromHex(0x333333);
    _vHint.detailLabel.font = FontPFRegular(12.0f);
    
    [labNavTitle makeConstraints:^(MASConstraintMaker *make) {

        make.top.equalTo(@20);
        make.centerX.equalTo(self.view);
        make.height.equalTo(@40);
        
    }];
    
    [backBtn makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.equalTo(labNavTitle);
        make.width.equalTo(50);
        make.leading.equalTo(self.view);
        
    }];
    [HintBtn makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.equalTo(labNavTitle);
        make.width.equalTo(25);
        make.height.equalTo(25);
        make.trailing.equalTo(self.view).offset(CoordXSizeScale(-10));
        
    }];
//    [detailsBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//       
//        make.centerY.equalTo(labNavTitle);
//        make.width.equalTo(50);
//        make.trailing.equalTo(self.view);
//        
//    }];
    
}

- (void)addConsumptionGoldView{
    
    ConsumptionGoldView *consumptionGoldView = [[ConsumptionGoldView alloc] init];
    
    [consumptionGoldView setM_Delegate:self];
    
    [self setM_ConsumptionGoldView:consumptionGoldView];
    [self.view addSubview:consumptionGoldView];
    
    [consumptionGoldView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.equalTo(self.view);
        
    }];
    
}
- (void)createUI
{
    [self.view addSubview:self.magicController.magicView];
    self.magicController.magicView.backgroundColor = [UIColor redColor];
    [self.magicController.magicView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(m_ConsumptionGoldView.m_TableView.bottom).offset(CoordYSizeScale(11));
        make.bottom.equalTo(self.view);
        make.leading.trailing.equalTo(self.view);
    }];
    [self.magicController.magicView reloadData];
}
- (VTMagicController *)magicController
{
    if (!_magicController) {
        _magicController = [[VTMagicController alloc] init];
        _magicController.magicView.dataSource = self;
        _magicController.magicView.delegate = self;
        _magicController.magicView.sliderHeight = 2.5;
        _magicController.magicView.sliderExtension = CoordXSizeScale(10);
        _magicController.magicView.navigationHeight = CoordYSizeScale(44);
        _magicController.magicView.itemWidth = kMainScreenWidth/self.listTitle.count;
        _magicController.magicView.navigationColor = UIColorFromHex(0xffffff);
        _magicController.magicView.sliderColor = UIColorFromHex(0xb4292d);
        _magicController.magicView.separatorHeight = 0;//去除底部黑线
    }
    return _magicController;
}

- (NSArray *)listTitle
{
    return @[@"提前花明细", @"提现明细"];
    //    return @[@"提前花明细", @"提现明细", @"购买明细"];
}

- (NSArray<NSString *> *)menuTitlesForMagicView:(VTMagicView *)magicView
{
    return self.listTitle;
}

- (UIButton *)magicView:(VTMagicView *)magicView menuItemAtIndex:(NSUInteger)itemIndex
{
    static NSString *itemIdentifier = @"itemIdentifier";
    UIButton *menuItem = [magicView dequeueReusableItemWithIdentifier:itemIdentifier];
    if (!menuItem) {
        menuItem = [UIButton buttonWithType:UIButtonTypeCustom];
        [menuItem setTitleColor:UIColorFromHex(0x333333) forState:UIControlStateNormal];
        [menuItem setTitleColor:UIColorFromHex(0xb4292d) forState:UIControlStateSelected];
        menuItem.titleLabel.font = FontPFRegular(14.0f);
    }
    return menuItem;
}

- (UIViewController *)magicView:(VTMagicView *)magicView viewControllerAtPage:(NSUInteger)pageIndex
{
    static NSString *idContent = @"com.Identifier";
    ConsumDetailsListViewController *contentVC = [magicView dequeueReusablePageWithIdentifier:idContent];
    if (!contentVC) {
        contentVC = [[ConsumDetailsListViewController alloc] init];
    }
    contentVC.type = pageIndex;
    return contentVC;
}

#pragma mark - Public Functions
- (void)dataInitialization{
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
}

- (void)setPersonalInfo:(PersonalInfoDM *)model{
    
    [self setM_PersonalInfoModel:model];
    
    [m_ConsumptionGoldView setPersonalInfo:model];
    
}

#pragma mark - Button Handlers
- (void)onNavigationCustomLeftBtnClick:(id)sender{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}
-(void)Hint:(UIButton*)sender
{
    [_vHint show];
}

//- (void)onNavigationCustomRightBtnClick:(id)sender{
//    
//    ConsumptionDetailsViewController *consumptionDetailsVC = [[ConsumptionDetailsViewController alloc] init];
//    [self.navigationController pushViewController:consumptionDetailsVC animated:YES];
//}

#pragma mark - ConsumptionGoldView Delegate Manager
- (void)onTableViewDidSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    switch ([indexPath row]) {
        case 0:{// 提现
            ConsumpGoldExtractVC *vc = [[ConsumpGoldExtractVC alloc] init];
            vc.dmInfo = m_PersonalInfoModel;
            [self.navigationController pushViewController:vc animated:YES];
            break;}
        default:
            break;
    }
    
}

@end
