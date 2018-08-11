//
//  CommodityShowDetail2ViewController.m
//  HWTou
//
//  Created by robinson on 2018/4/10.
//  Copyright © 2018年 LieMi. All rights reserved.
//

#import "CommodityShowDetail2ViewController.h"
#import "ShoppingCartSettleViewController.h"
#import "PublicHeader.h"
#import "ShopMallRequest.h"
#import "GetGoodsAddrListModel.h"
#import "AddAddressViewController.h"
#import "ComCarouselView.h"

@interface CommodityShowDetail2ViewController ()<AddAddressViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UIView *commodityRollView;

@property (nonatomic,strong) ComCarouselImageView * vCarouselImg;

@property (weak, nonatomic) IBOutlet UILabel *commodityNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *commodityDescLabel;
@property (weak, nonatomic) IBOutlet UILabel *commodityPriceLabel;

@property (weak, nonatomic) IBOutlet UILabel *merchantAddLabel;
@property (weak, nonatomic) IBOutlet UILabel *commodityDetailLabel;

@property (weak, nonatomic) IBOutlet UIImageView *commodityIntroLabel;

@property (nonatomic,strong) GetGoodsAddrListModel * defaultAddrModel;
@end

@implementation CommodityShowDetail2ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setTitle:@"商品详情"];
    
    [self.commodityRollView addSubview:self.vCarouselImg];
    [self.vCarouselImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.commodityRollView);
    }];
    
    [self refreshView];
    [self getGoodsAddrListRequest];
    [self lookGoods];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - request

- (void)lookGoods{
    GetGoodsDetailParam * param = [GetGoodsDetailParam new];
    param.goodsId = _getGoodsListModel.goodsId;
    [ShopMallRequest lookGoods:param Success:^(AnswerLsDate *response) {
        if (response.status == 200) {

        }
    } failure:^(NSError *error) {
        
    }];
}

- (void)getGoodsAddrListRequest{
    GetGoodsAddrListParam * param = [GetGoodsAddrListParam new];
    param.isDef = 1;
    [ShopMallRequest getGoodsAddrList:param Success:^(AnswerLsArray *response) {
        if (response.status == 200) {
            
            for (NSDictionary * dict in response.data) {
                GetGoodsAddrListModel * listModel = [GetGoodsAddrListModel new];
                [listModel setValuesForKeysWithDictionary:dict];
                if (listModel.isDef == 1) {
                    _defaultAddrModel = listModel;
                }
            }

        }else{
            [self.view makeToast:response.msg duration:2.0f position:CSToastPositionCenter];
        }
    } failure:^(NSError *error) {
        [self.view makeToast:@"网络繁忙" duration:2.0f position:CSToastPositionCenter];
    }];
}

#pragma mark - delegate
//AddAddressViewControllerDelegate
- (void)addAddressVCAction{

}

#pragma mark - UI

- (void)refreshView{
    NSArray * dataArray = [_getGoodsListModel.bannerUrl componentsSeparatedByString:@","];
    NSMutableArray *urlGroup = [NSMutableArray array];
    
    for (NSString * urlString in dataArray) {
        [urlGroup addObject:urlString];
    }
    self.vCarouselImg.imageURLStringsGroup = urlGroup;
    
    self.commodityNameLabel.text = _getGoodsListModel.goodsName;
    self.commodityDescLabel.text = _getGoodsListModel.introduction;
    self.commodityPriceLabel.text = [NSString stringWithFormat:@"¥ %@",_getGoodsListModel.actualMoney];
    
    self.merchantAddLabel.text = _getGoodsListModel.sellerName;
    //    self.commodityDetailLabel.text = getGoodsListModel.details;
    
    [self.commodityIntroLabel sd_setImageWithURL:[NSURL URLWithString:_getGoodsListModel.details]];
}

#pragma mark - private mothed

- (NSMutableArray *)configCartModel{
    NSMutableArray * shopCartDataArray = [[NSMutableArray alloc] init];
    
    GetShopCartListModel * getShopCartListModel = [GetShopCartListModel new];
    getShopCartListModel.uid = 0;
    getShopCartListModel.sellerName = _getGoodsListModel.sellerName;//卖家名
    getShopCartListModel.sellerId = _getGoodsListModel.sellerId;//卖家ID
    [shopCartDataArray addObject:getShopCartListModel];
    
    GetShopCartListResultModel * cartResultModel = [GetShopCartListResultModel  new];
    cartResultModel.cartId = 0;//购物车ID
    cartResultModel.goodsId = _getGoodsListModel.goodsId;//商品ID
    cartResultModel.goodsName = _getGoodsListModel.goodsName;//商品名
    cartResultModel.imgUrl = _getGoodsListModel.imgUrl;//商品图片
    cartResultModel.introduction = _getGoodsListModel.introduction;//商品简介
    cartResultModel.stockNum = _getGoodsListModel.stockNum;//商品库存（注意：若库存为0客户端要限制不能勾选结算）
    cartResultModel.actualMoney = _getGoodsListModel.actualMoney;//商品售价
    [getShopCartListModel.cartGoodsListArr addObject:cartResultModel];
    
    return shopCartDataArray;
}

#pragma mark - action

- (IBAction)goPayAction:(id)sender {
    if (_defaultAddrModel) {
        ShoppingCartSettleViewController * settleVC = [[ShoppingCartSettleViewController alloc] initWithNibName:nil bundle:nil];
        settleVC.defaultAddrModel = _defaultAddrModel;
        settleVC.shopCartDataArray = [self configCartModel];
        settleVC.totalPrice = _getGoodsListModel.actualMoney;
        [self.navigationController pushViewController:settleVC animated:YES];
    }else{
        AddAddressViewController * addrVC = [[AddAddressViewController alloc] initWithNibName:nil bundle:nil];
        addrVC.delegate = self;
        [self.navigationController pushViewController:addrVC animated:YES];
    }
    
}

- (IBAction)addToShoppingCartAction:(id)sender {
    AddShopCartParam * param = [AddShopCartParam new];
    param.goodsId = _getGoodsListModel.goodsId;
    param.sellerId = _getGoodsListModel.sellerId;
    [ShopMallRequest addShopCart:param Success:^(AnswerLsDict *response) {
        if (response.status == 200) {
            [self.view makeToast:@"已加入购物车" duration:2.0f position:CSToastPositionCenter];
        }else{
            [self.view makeToast:response.msg duration:2.0f position:CSToastPositionCenter];
        }
    } failure:^(NSError *error) {
       [self.view makeToast:@"网络繁忙" duration:2.0f position:CSToastPositionCenter];
    }];
}


#pragma mark - getter
- (ComCarouselImageView *)vCarouselImg{
    if (!_vCarouselImg) {
        _vCarouselImg = [[ComCarouselImageView alloc] init];
        _vCarouselImg.delegate = self;
    }
    return _vCarouselImg;
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
