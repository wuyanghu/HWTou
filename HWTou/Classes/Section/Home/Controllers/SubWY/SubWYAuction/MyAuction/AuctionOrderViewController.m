//
//  AuctionOrderViewController.m
//  HWTou
//
//  Created by robinson on 2018/3/20.
//  Copyright © 2018年 LieMi. All rights reserved.
//

#import "AuctionOrderViewController.h"
#import "VTMagicController.h"
#import "PublicHeader.h"
#import "AuctionOrderDetailViewController.h"
#import "CommodityShowDetail2ViewController.h"
#import "UIView+NTES.h"
#import "DeviceInfoTool.h"
#import "PayWayViewController.h"
#import "AuctionOrderDetail1ViewController.h"
#import "SubWYAuctionPayWayViewController.h"

@interface AuctionOrderViewController ()<VTMagicViewDataSource,VTMagicViewDelegate,CommodityOrderDetailDelegate>
@property (nonatomic, strong) VTMagicController *magicController;
@property (nonatomic,strong) NSMutableArray * listTitle;
@end

@implementation AuctionOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"已拍中";
    // Do any additional setup after loading the view.
    
    [self.view addSubview:self.magicController.magicView];
    self.magicController.magicView.frame = self.view.frame;
    [self.magicController.magicView reloadData];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - CommodityShowDetailDelegate

- (void)orderPushDetailVC:(GetGoodsOrderListModel *)model{
    if (model.status == 0 || model.status == -1) {
        return;
    }
    AuctionOrderDetail1ViewController * cartVC = [[AuctionOrderDetail1ViewController alloc] initWithNibName:nil bundle:nil];
    cartVC.orderListModel = model;
    cartVC.shopCartDataArray = [self configCartModel:model];
    cartVC.totalPrice = [self calculateTotalPrice:model];
    [self.navigationController pushViewController:cartVC animated:YES];
}

#pragma mark - private mothed

- (NSString *)calculateTotalPrice:(GetGoodsOrderListModel *)model{
    double totalPrice = 0;
    for (GoodsDetailModel * detailModel in model.goodsDetailArray) {
        totalPrice += [detailModel.price doubleValue];
    }
    return [NSString stringWithFormat:@"%.2f",totalPrice];
}

- (NSMutableArray *)configCartModel:(GetGoodsOrderListModel *)model{
    NSMutableArray * shopCartDataArray = [[NSMutableArray alloc] init];
    
    GetShopCartListModel * getShopCartListModel = [GetShopCartListModel new];
    getShopCartListModel.uid = model.userId;
    getShopCartListModel.sellerName = model.sellerName;//卖家名
    getShopCartListModel.sellerId = model.sellerId;//卖家ID
    [shopCartDataArray addObject:getShopCartListModel];
    
    for (GoodsDetailModel * detailModel in model.goodsDetailArray) {
        GetShopCartListResultModel * cartResultModel = [GetShopCartListResultModel  new];
        cartResultModel.cartId = 0;//购物车ID
        cartResultModel.goodsId = detailModel.goodsId;//商品ID
        cartResultModel.goodsName = detailModel.goodsName;//商品名
        cartResultModel.imgUrl = detailModel.goodsImg;//商品图片
        cartResultModel.introduction = @"";//商品简介
        cartResultModel.stockNum = detailModel.num;//商品库存（注意：若库存为0客户端要限制不能勾选结算）
        cartResultModel.actualMoney = detailModel.price;//商品售价
        [getShopCartListModel.cartGoodsListArr addObject:cartResultModel];
    }
    
    
    return shopCartDataArray;
}

#pragma mark - VTMagicView

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
        menuItem.titleLabel.font = FontPFRegular(16.0f);
    }
    return menuItem;
}

- (UIViewController *)magicView:(VTMagicView *)magicView viewControllerAtPage:(NSUInteger)pageIndex
{
    static NSString * recomId;
    recomId = [NSString stringWithFormat:@"recom.identifier%ld",pageIndex];
    AuctionOrderDetailViewController * contentVC = [magicView dequeueReusablePageWithIdentifier:recomId];

    if (!contentVC) {
        contentVC = [[AuctionOrderDetailViewController alloc] init];
        contentVC.delegate = self;
    }

    contentVC.labelId = pageIndex;
    return contentVC;
}

#pragma mark - getter
- (VTMagicController *)magicController
{
    if (!_magicController) {
        _magicController = [[VTMagicController alloc] init];
        _magicController.magicView.dataSource = self;
        _magicController.magicView.delegate = self;
        _magicController.magicView.sliderHeight = 2.5;
        _magicController.magicView.sliderExtension = 30;
        _magicController.magicView.navigationHeight = 44;
        CGFloat itemWidth = self.listTitle.count>5?kMainScreenWidth/5:kMainScreenWidth/self.listTitle.count;
        _magicController.magicView.itemWidth = itemWidth;
        _magicController.magicView.navigationColor = UIColorFromHex(0xfafafa);
        _magicController.magicView.sliderColor = UIColorFromHex(0xb4292d);
    }
    return _magicController;
}

- (NSMutableArray *)listTitle
{
    if (!_listTitle) {
        _listTitle = [NSMutableArray array];
        [_listTitle addObject:@"全部"];
        [_listTitle addObject:@"待付款"];
        [_listTitle addObject:@"待发货"];
        [_listTitle addObject:@"待收货"];
        [_listTitle addObject:@"已收货"];
    }
    return _listTitle;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
