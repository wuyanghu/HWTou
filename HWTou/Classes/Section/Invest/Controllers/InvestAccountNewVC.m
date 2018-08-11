//
//  InvestAccountNewVC.m
//  HWTou
//
//  Created by 彭鹏 on 2017/8/11.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "ConsumptionGoldViewController.h"
#import "CopperCollectionViewCell.h"
#import "InvestAccountNewVC.h"
#import "CopperAccountView.h"
#import "MeViewController.h"
#import "InvestAccountDM.h"
#import "PersonalInfoReq.h"
#import <YYModel/YYModel.h>
#import <HWTSDK/HWTAPI.h>
#import "RongduManager.h"
#import "PublicHeader.h"

@interface InvestAccountNewVC ()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) CopperAccountView *vHeaderAccount;
@property (nonatomic, strong) InvestAccountDM *dmAccount;
@property (nonatomic, strong) PersonalInfoDM *dmPersonal;
@property (nonatomic, assign) BOOL hideAnimated;
@property (nonatomic, copy) NSArray *listData;

@end

@implementation InvestAccountNewVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupData];
    [self createUI];
    [self setNav];
    self.hideAnimated = YES;
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

- (void)loadInfoData
{
    [PersonalInfoReq personalInfoSuccess:^(PersonalInfoResp *response) {
        if (response.success) {
            self.dmPersonal = response.data;
            self.vHeaderAccount.gold = self.dmPersonal.gold;
        } else {
            [HUDProgressTool showOnlyText:response.msg];
        }
    } failure:^(NSError *error) {
        [HUDProgressTool showOnlyText:[error urlErrorCodeDescribe]];
    }];
    
    [[HWTAPI sharedInstance] getUserInfoCallBack:^(NSDictionary *dataDic, RdAppError *error) {
        if (error.errCode == 1) {
            InvestAccountDM *dmAccount = [InvestAccountDM yy_modelWithDictionary:dataDic];
            self.vHeaderAccount.dmAccount = self.dmAccount = dmAccount;
        } else {
            [HUDProgressTool showOnlyText:error.errMessage];
        }
    }];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    // 如果当前VC是MeViewController则不需要隐藏, 和外面冲突
    UIViewController *topVC = self.navigationController.topViewController;
    if ([topVC isKindOfClass:[MeViewController class]] == NO) {
        [self.navigationController setNavigationBarHidden:NO animated:YES];
    }
}
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)createUI
{
    [self setTitle:@"铜钱账户"];
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    flowLayout.itemSize = CGSizeMake((kMainScreenWidth - 3)/3, CoordYSizeScale(95));
    flowLayout.headerReferenceSize = CGSizeMake(kMainScreenWidth, CoordYSizeScale(320));
    flowLayout.minimumInteritemSpacing = 1.5;
    flowLayout.minimumLineSpacing = 1.5;
    flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 10, 0);
    
    _collectionView = [[UICollectionView alloc] initWithFrame:self.view.frame collectionViewLayout:flowLayout];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.backgroundColor = UIColorFromHex(0xf4f4f4);
    _collectionView.showsVerticalScrollIndicator = NO;
    [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headerView"];
    [_collectionView registerClass:[CopperCollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([CopperAccountView class])];
    [_collectionView registerClass:[CopperAccountView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass([CopperAccountView class])];
    [self.view addSubview:_collectionView];
    
    [_collectionView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

- (void)setupData
{
    [self loadInfoData];
    
    NSArray *titles = @[@"提前花", @"资产统计", @"投资管理", @"回款计划", @"充值记录", @"我的红包", @"体验金"];
    NSArray *images = @[@"copper_ahead", @"copper_count", @"copper_mannage", @"copper_backmoney", @"copper_topup", @"copper_lucky", @"copper_expensive"];
    
    NSMutableArray *tempData = [NSMutableArray arrayWithCapacity:titles.count];
    [titles enumerateObjectsUsingBlock:^(NSString *title, NSUInteger idx, BOOL *stop) {
        InvestFunctionDM *dmAccount = [InvestFunctionDM new];
        OBJECTOFARRAYATINDEX(dmAccount.imgName, images, idx);
        dmAccount.title = title;
        dmAccount.type = idx;
        
        [tempData addObject:dmAccount];
    }];
    self.listData = tempData;
}

- (void)setNav
{
    UIButton *btnBack = [[UIButton alloc] init];
    [btnBack setImage:[UIImage imageNamed:@"navi_back_white"] forState:UIControlStateNormal];
    [btnBack addTarget:self action:@selector(actionBack) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *labNavTitle = [BasisUITool getLabelWithTextColor:UIColorFromHex(0xffffff) size:18];
    [labNavTitle setText:self.navigationItem.title];
    [self.view addSubview:labNavTitle];
    [self.view addSubview:btnBack];
    
    [labNavTitle makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(@20);
        make.height.equalTo(@40);
    }];
    
    [btnBack makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(labNavTitle);
        make.leading.equalTo(self);
        make.size.equalTo(CGSizeMake(40, 40));
    }];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.listData.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CopperCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([CopperAccountView class]) forIndexPath:indexPath];
    OBJECTOFARRAYATINDEX(cell.dmAccount, self.listData, indexPath.item);
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        self.vHeaderAccount = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:NSStringFromClass([CopperAccountView class]) forIndexPath:indexPath];
        self.vHeaderAccount.dmAccount = self.dmAccount;
        self.vHeaderAccount.gold = self.dmPersonal.gold;
        return self.vHeaderAccount;
    } else {
        return nil;
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    
    InvestFunctionDM *dmAccount;
    OBJECTOFARRAYATINDEX(dmAccount, self.listData, indexPath.item);
    switch (dmAccount.type) {
        case InvestAccountForward:{ // 提前花
            ConsumptionGoldViewController *vc = [ConsumptionGoldViewController new];
            [self.navigationController pushViewController:vc animated:YES];
            break;}
        case InvestAccountStatis: // 资产计划
            [[HWTAPI sharedInstance] jumpToAssetStatisticsFromVC:self];
            break;
        case InvestAccountManage: // 投资管理
            [[HWTAPI sharedInstance] jumpToInvestmentManagementSegementVCFromVC:self];
            break;
        case InvestAccountPayback: // 回款计划
            [[HWTAPI sharedInstance] jumpToPaybackSegementFromVC:self];
            break;
        case InvestAccountRecord: // 充值和投资记录
            [[HWTAPI sharedInstance] jumpToRechargeRecordSegementVCFromVC:self withIndex:recharge];
            break;
        case InvestAccountRedPage: // 我的红包
            [[HWTAPI sharedInstance] jumpToCouponsSegementFromVC:self];
            break;
        case InvestAccountExperGold: // 体验金
            [[HWTAPI sharedInstance] jumpToExpListFromVC:self];
            break;
        default:
            break;
    }
}

- (void)actionBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
