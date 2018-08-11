//
//  ConsumptionDetailsViewController.m
//  HWTou
//
//  Created by 赤 那 on 2017/4/24.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "ConsumptionDetailsViewController.h"
#import "ConsumptionDetailsView.h"
#import "ConsumptionGoldReq.h"
#import "PublicHeader.h"
#import "VTMagic.h"


@interface ConsumDetailsListVC : BaseViewController

@property (nonatomic, strong) ConsumptionDetailsView *vDetail;
@property (nonatomic, assign) NSInteger type; // 0:提前花明细 1:提现明细 2:购买明细

@end

@implementation ConsumDetailsListVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self createUI];
}

- (void)createUI
{
    ConsumptionDetailsView *consumptionDetailsView = [[ConsumptionDetailsView alloc] init];
    
    self.vDetail = consumptionDetailsView;
    [self.view addSubview:consumptionDetailsView];
    
    [consumptionDetailsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    WeakObj(self);
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [selfWeak loadDetailData:YES];
    }];
    
    header.lastUpdatedTimeLabel.hidden = YES;
    self.vDetail.tableView.mj_header = header;
    [self.vDetail.tableView.mj_header beginRefreshing];
}

- (void)loadDetailData:(BOOL)refresh
{
    ConsumpDetailParam *param = [ConsumpDetailParam new];
    param.start_page = refresh ? 0 : self.vDetail.listData.count;
    param.pages = 20;
    
    if (self.type == 1) {
        [ConsumptionGoldReq extracDetailWithParam:param success:^(ConsumpDetailResp *response) {
             [self handleData:refresh response:response];
        } failure:^(NSError *error) {
            [HUDProgressTool showOnlyText:[error urlErrorCodeDescribe]];
        }];
    } else if (self.type == 2) {
        [ConsumptionGoldReq buyDetailWithParam:param success:^(ConsumpDetailResp *response) {
            [self handleData:refresh response:response];
        } failure:^(NSError *error) {
            [HUDProgressTool showOnlyText:[error urlErrorCodeDescribe]];
        }];
    } else {
        [ConsumptionGoldReq detailWithParam:param success:^(ConsumpDetailResp *response) {
            [self handleData:refresh response:response];
        } failure:^(NSError *error) {
            [HUDProgressTool showOnlyText:[error urlErrorCodeDescribe]];
        }];
    }
}

- (void)handleData:(BOOL)refresh response:(ConsumpDetailResp *)response
{
    if (response.success) {
        if (refresh) {
            self.vDetail.listData = response.data.list;
        } else {
            NSMutableArray *tempData = [NSMutableArray arrayWithArray:self.vDetail.listData];
            [tempData addObjectsFromArray:response.data.list];
            self.vDetail.listData = tempData;
        }
        
        BOOL isMore = self.vDetail.listData.count < response.data.total_pages ? YES : NO;
        [self setLoadMore:isMore];
        [self handleLoadCompleted];
    } else {
        [HUDProgressTool showOnlyText:response.msg];
    }
}

- (void)setLoadMore:(BOOL)isMore
{
    if (isMore) {
        WeakObj(self);
        self.vDetail.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            [selfWeak loadDetailData:NO];
        }];
    } else {
        self.vDetail.tableView.mj_footer = nil;
    }
}

// 更新视图状态显示
- (void)handleLoadCompleted
{
    [self.vDetail.tableView.mj_header endRefreshing];
    [self.vDetail.tableView.mj_footer endRefreshing];
}

@end

@interface ConsumptionDetailsViewController () <VTMagicViewDataSource, VTMagicViewDelegate>

@property (nonatomic, strong) ConsumptionDetailsView *vDetail;
@property (nonatomic, strong) VTMagicController *magicController;

@end

@implementation ConsumptionDetailsViewController

- (VTMagicController *)magicController
{
    if (!_magicController) {
        _magicController = [[VTMagicController alloc] init];
        _magicController.magicView.dataSource = self;
        _magicController.magicView.delegate = self;
        _magicController.magicView.sliderHeight = 2.5;
        _magicController.magicView.sliderExtension = CoordXSizeScale(10);
        _magicController.magicView.navigationHeight = 32;
        _magicController.magicView.itemWidth = kMainScreenWidth/self.listTitle.count;
        _magicController.magicView.navigationColor = UIColorFromHex(0xfafafa);
        _magicController.magicView.sliderColor = UIColorFromHex(0xb4292d);
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
    ConsumDetailsListVC *contentVC = [magicView dequeueReusablePageWithIdentifier:idContent];
    if (!contentVC) {
        contentVC = [[ConsumDetailsListVC alloc] init];
    }
    contentVC.type = pageIndex;
    
    return contentVC;
}

#pragma mark - Life Cycle
- (void)viewDidLoad{
    
    [super viewDidLoad];
    [self setTitle:@"消费明细"];
    [self createUI];
}

- (void)createUI
{
    [self.view addSubview:self.magicController.magicView];
    [self.magicController.magicView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [self.magicController.magicView reloadData];
}
@end
