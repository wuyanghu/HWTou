//
//  InvestViewController.m
//  HWTou
//
//  Created by pengpeng on 17/3/7.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "InvestViewController.h"
#import "InvestActivityReq.h"
#import "InvestProductDM.h"
#import <YYModel/YYModel.h>
#import <HWTSDK/HWTAPI.h>
#import "PublicHeader.h"
#import "InvestParam.h"
#import "BannerAdReq.h"
#import "RDInfoReq.h"
#import "InvestView.h"

@interface InvestViewController ()

@property (nonatomic, strong) NSArray *listForward; // 提前花列表
@property (nonatomic, strong) InvestView *vInvest;
@property (nonatomic, assign) NSInteger curPage;
@property (nonatomic, copy) NSArray *dataArr;
@property (nonatomic, copy) NSArray *bannerArr;
@property (nonatomic, assign) BOOL delayScroll;

@end

@implementation InvestViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self createUI];
}

- (void)createUI
{
    self.navigationItem.title = @"钱潮";
    
//    self.vInvest = [[InvestView alloc] init];
//    self.vInvest.backgroundColor = UIColorFromHex(0xf4f4f4);
//    
//    [self.view addSubview:self.vInvest];
//    [self.vInvest makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(self.view);
//    }];
//
//    WeakObj(self);
//    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//        [selfWeak loadNewData];
//    }];
//
//    header.lastUpdatedTimeLabel.hidden = YES;
//    self.vInvest.tableView.mj_header = header;
//    [self.vInvest.tableView.mj_header beginRefreshing];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self addNotification];
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)addNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(skipInvestProduct:)
                                                 name:NOTIF_SkipInvestProduct
                                               object:nil];
}

- (void)skipInvestProduct:(NSNotification *)notif
{
    if (self.vInvest) {
        [self.vInvest scrollToProductPosition];
    } else {
        self.delayScroll = YES;
    }
}

- (void)loadNewData
{
    dispatch_group_t dispatchGroup = dispatch_group_create();
    dispatch_group_enter(dispatchGroup);
    
    BannerAdParam *bParam = [[BannerAdParam alloc] init];
    bParam.type = BannerAdInvset;
    [BannerAdReq bannerWithParam:bParam success:^(BannerAdResp *response) {
        self.vInvest.banners = response.data.list;
        dispatch_group_leave(dispatchGroup);
    } failure:^(NSError *error) {
        dispatch_group_leave(dispatchGroup);
    }];
    
    dispatch_group_enter(dispatchGroup);
    InvestActivityParam *param = [InvestActivityParam new];
    param.status = 1;
    param.start_page = 0;
    param.pages = 10;
    
    [InvestActivityReq activityWithParam:param success:^(InvestActivityResp *result) {
        self.vInvest.ativity = result.data.list;
        dispatch_group_leave(dispatchGroup);
    } failure:^(NSError *error) {
        dispatch_group_leave(dispatchGroup);
    }];
    
    dispatch_group_enter(dispatchGroup);
    // 从发耶后台获取提前花列表
    [RDInfoReq listWithSuccess:^(RDInvestListResp *response) {
        self.listForward = response.data;
        // 从融都SDK获取产品列表
        [self loadListData:YES completed:^{
            dispatch_group_leave(dispatchGroup);
        }];
    } failure:^(NSError *error) {
        [self loadListData:YES completed:^{
            dispatch_group_leave(dispatchGroup);
        }];
        [HUDProgressTool showOnlyText:[error urlErrorCodeDescribe]];
    }];
    
    dispatch_group_notify(dispatchGroup, dispatch_get_main_queue(), ^(){
        [self.vInvest.tableView.mj_header endRefreshing];
        // 解决还未进入这个页面，就收到了通知要求定位到精选产品位置
        if (self.delayScroll) {
            self.delayScroll = NO;
            [self.vInvest scrollToProductPosition];
        }
    });
}

- (void)loadListData:(BOOL)refresh completed:(void(^)(void))completed
{
    if (refresh) {
        self.curPage = 1;
    }
    
    [[HWTAPI sharedInstance] getProductListWithPageNumber:self.curPage result:^(NSDictionary *dataDic, RdAppError *error) {
        if (error.errCode == 1) {
            self.curPage++;
            InvestProductListResp *result = [InvestProductListResp yy_modelWithDictionary:dataDic];
            
            // 遍历提前花数据
            [result.tenderList enumerateObjectsUsingBlock:^(InvestProductDM *dmProduct, NSUInteger idx, BOOL *stop) {
                [self.listForward enumerateObjectsUsingBlock:^(RDInvestListDM *dmForward, NSUInteger idx, BOOL *stop) {
                    if ([dmProduct.id isEqualToString:dmForward.id]) {
                        dmProduct.dmForward = dmForward;
                        *stop = YES;
                    }
                }];
            }];
            
            if (refresh) {
                self.vInvest.listData = result.tenderList;
            } else {
                NSMutableArray *tempData = [NSMutableArray arrayWithArray:self.vInvest.listData];
                [tempData addObjectsFromArray:result.tenderList];
                self.vInvest.listData = tempData;
            }
            
            BOOL isMore = self.curPage < result.totalPage ? YES : NO;
            [self setLoadMore:isMore];
            !completed ?: completed();
        } else {
            !completed ?: completed();
            [HUDProgressTool showOnlyText:error.errMessage];
        }
    }];
}

- (void)setLoadMore:(BOOL)isMore
{
    if (isMore) {
        WeakObj(self);
        self.vInvest.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            [selfWeak loadListData:NO completed:nil];
        }];
    } else {
        self.vInvest.tableView.mj_footer = nil;
    }
}
@end
