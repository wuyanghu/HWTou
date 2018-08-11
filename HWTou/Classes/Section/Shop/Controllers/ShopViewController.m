//
//  ShopViewController.m
//  HWTou
//
//  Created by pengpeng on 17/3/7.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "ProductCartViewController.h"
#import "MessageViewController.h"
#import "ShopViewController.h"
#import "ProductCategoryReq.h"
#import "WZLBadgeImport.h"
#import "ProductCartReq.h"
#import "PublicHeader.h"
#import "FloorListReq.h"
#import "BannerAdReq.h"
#import "MessageReq.h"
#import "ShopView.h"

@interface ShopViewController ()

@property (nonatomic, strong) ShopView *vShop;
@property (nonatomic, strong) UIBarButtonItem *itemCart;
@property (nonatomic, strong) UIBarButtonItem *itemMessage;

@end

@implementation ShopViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self createUI];
}

- (void)createUI
{
    self.itemMessage = [UIBarButtonItem itemWithImageName:@"navi_msg_nor" hltImageName:nil target:self action:@selector(actionMessage)];
    self.itemCart = [UIBarButtonItem itemWithImageName:@"navi_btn_cart" hltImageName:nil target:self action:@selector(actionCart)];
    self.navigationItem.leftBarButtonItem = self.itemMessage;
    self.navigationItem.rightBarButtonItem = self.itemCart;
    
    self.title = @"好选";
    
    self.vShop = [[ShopView alloc] init];
    [self.view addSubview:self.vShop];
    
    [self.vShop makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    WeakObj(self);
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [selfWeak loadNewData];
    }];
    
    header.lastUpdatedTimeLabel.hidden = YES;
    self.vShop.collectionView.mj_header = header;
    [self.vShop.collectionView.mj_header beginRefreshing];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self loadBadgeNumber];
}

- (void)actionCart
{
    if ([AccountManager isNeedLogin]) {
        [AccountManager showLoginView];
        return;
    }
    ProductCartViewController *cartVC = [[ProductCartViewController alloc] init];
    [self.navigationController pushViewController:cartVC animated:YES];
}

- (void)actionMessage
{
    if ([AccountManager isNeedLogin]) {
        [AccountManager showLoginView];
        return;
    }
    MessageViewController *msgVC = [[MessageViewController alloc] init];
    [self.navigationController pushViewController:msgVC animated:YES];
}

- (void)loadBadgeNumber
{
    if ([AccountManager isNeedLogin]) {
        return;
    }
    [ProductCartReq listCartsSuccess:^(CartListResp *response) {
        [self setCartNumber:response.data.count];
    } failure:nil];
    
    MessageNumParam *param = [MessageNumParam new];
    param.type = 0;
    [MessageReq numberWithParam:param success:^(MessageNumResp *response) {
        [self setMsgNumber:response.data.number];
    } failure:nil];
}

- (void)setCartNumber:(NSInteger)num
{
    if (num > 0) {
        [self.itemCart setBadgeBgColor:UIColorFromHex(0xb4292d)];
        [self.itemCart showBadgeWithStyle:WBadgeStyleNumber value:num animationType:WBadgeAnimTypeNone];
    } else {
        [self.itemCart clearBadge];
    }
}

- (void)setMsgNumber:(NSInteger)num
{
    if (num > 0) {
        [self.itemMessage setBadgeCenterOffset:CGPointMake(-5, 5)];
        [self.itemMessage setBadgeBgColor:UIColorFromHex(0xb4292d)];
        [self.itemMessage showBadgeWithStyle:WBadgeStyleNumber value:num animationType:WBadgeAnimTypeNone];
    } else {
        [self.itemMessage clearBadge];
    }
}

- (void)loadNewData
{
    dispatch_group_t dispatchGroup = dispatch_group_create();
    dispatch_group_enter(dispatchGroup);
    
    BannerAdParam *bParam = [[BannerAdParam alloc] init];
    bParam.type = BannerAdShop;
    [BannerAdReq bannerWithParam:bParam success:^(BannerAdResp *response) {
        self.vShop.banners = response.data.list;
        dispatch_group_leave(dispatchGroup);
    } failure:^(NSError *error) {
        dispatch_group_leave(dispatchGroup);
    }];
    
    dispatch_group_enter(dispatchGroup);
    
    [ProductCategoryReq categorySuccess:^(ProductCategoryResp *response) {
        self.vShop.categorys = response.data;
        dispatch_group_leave(dispatchGroup);
    } failure:^(NSError *error) {
        dispatch_group_leave(dispatchGroup);
    }];
    
    dispatch_group_enter(dispatchGroup);
    [self loadFloorData:YES completed:^{
        dispatch_group_leave(dispatchGroup);
    }];
    
    dispatch_group_notify(dispatchGroup, dispatch_get_main_queue(), ^(){
        [self.vShop.collectionView.mj_header endRefreshing];
    });
}

- (void)loadFloorData:(BOOL)refresh completed:(void(^)(void))completed
{
    FloorListParam *fParam = [[FloorListParam alloc] init];
    fParam.type = FloorListShop;
    fParam.start_page = refresh ? 0 : self.vShop.floors.count;
    fParam.pages = 10;
    
    [FloorListReq floorWithParam:fParam success:^(FloorListResp *response) {
        if (refresh) {
            self.vShop.floors = response.data.list;
        } else {
            NSMutableArray *tempData = [NSMutableArray arrayWithArray:self.vShop.floors];
            [tempData addObjectsFromArray:response.data.list];
            self.vShop.floors = tempData;
        }
        
        BOOL isMore = self.vShop.floors.count < response.data.total_pages ? YES : NO;
        [self.vShop.collectionView.mj_footer endRefreshing];
        [self setLoadMore:isMore];
        
        !completed ?: completed();
    } failure:^(NSError *error) {
        !completed ?: completed();
        [self.vShop.collectionView.mj_footer endRefreshing];
        [HUDProgressTool showOnlyText:[error urlErrorCodeDescribe]];
    }];
}

- (void)setLoadMore:(BOOL)isMore
{
    if (isMore) {
        WeakObj(self);
        self.vShop.collectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            [selfWeak loadFloorData:NO completed:nil];
        }];
    } else {
        self.vShop.collectionView.mj_footer = nil;
    }
}
@end
