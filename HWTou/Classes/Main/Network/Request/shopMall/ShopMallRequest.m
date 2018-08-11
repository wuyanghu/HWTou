//
//  ShopMallRequest.m
//  HWTou
//
//  Created by robinson on 2018/1/30.
//  Copyright © 2018年 LieMi. All rights reserved.
//

#import "ShopMallRequest.h"
#import "SecurityTool.h"
#import "YYModel.h"

@implementation ShopMallRequest

static NSString *sApiPath = nil;

+ (NSString *)requestServerHost {
    return kApiShoppMallUrlHost;
}

+ (NSString *)requestApiPath
{
    return sApiPath;
}

+ (HttpRequestMethod)requestMethod{
    return HttpRequestMethodPost;
}

#pragma mark - 拍卖活动模块
//查看拍卖专场下活动对应的拍卖品列表（客户端）
+ (void)getSellerPerformGoodsList:(GetSellerPerformGoodsListParam *)param
                     Success:(void (^)(AnswerLsDict *response))success
                     failure:(void (^) (NSError *error))failure{
    
    sApiPath = @"sellerActivity/getSellerPerformGoodsList";
    [super requestWithParam:param responseClass:[AnswerLsDict class] success:success failure:failure];
}

//查看拍卖专场下活动对应的拍卖品详情（客户端）
+ (void)getSellerPerformGoods:(GetSellerPerformGoodsParam *)param
                          Success:(void (^)(AnswerLsDict *response))success
                          failure:(void (^) (NSError *error))failure{
    
    sApiPath = @"sellerActivity/getSellerPerformGoods";
    [super requestWithParam:param responseClass:[AnswerLsDict class] success:success failure:failure];
}

//拍卖品竞价（加密接口）
+ (void)bidSellerGoods:(BidSellerGoodsParam *)param
                      Success:(void (^)(AnswerLsDict *response))success
                      failure:(void (^) (NSError *error))failure{
    NSDictionary *paramDict = [param yy_modelToJSONObject];
    paramDict = [SecurityTool getAesDict:paramDict];
    sApiPath = @"sellerActivity/bidSellerGoods";
    [super requestWithParam:paramDict responseClass:[AnswerLsDict class] success:success failure:failure];
}
//竞价记录
+ (void)getBidSellerRecord:(GetBidSellerRecordParam *)param
               Success:(void (^)(AnswerLsArray *response))success
               failure:(void (^) (NSError *error))failure{
    sApiPath = @"sellerActivity/getBidSellerRecord";
    [super requestWithParam:param responseClass:[AnswerLsArray class] success:success failure:failure];
}

//我的保证金列表、未拍中、参拍中列表
+ (void)getMySellerList:(GetMySellerListParam *)param
                   Success:(void (^)(AnswerLsArray *response))success
                   failure:(void (^) (NSError *error))failure{
    sApiPath = @"sellerActivity/getMySellerList";
    [super requestWithParam:param responseClass:[AnswerLsArray class] success:success failure:failure];
}

#pragma mark - 拍卖专场模块
//查看拍卖专场
+ (void)getSellerPerformList:(GetSellerPerformListParam *)param
          Success:(void (^)(AnswerLsDict *response))success
          failure:(void (^) (NSError *error))failure{
    
    sApiPath = @"sellerPerform/getSellerPerformList";
    [super requestWithParam:param responseClass:[AnswerLsDict class] success:success failure:failure];
}

#pragma mark - 商城管理模块
//查看商品、拍卖品增加浏览量
+ (void)lookGoods:(GetGoodsDetailParam *)param
              Success:(void (^)(AnswerLsDate *response))success
              failure:(void (^) (NSError *error))failure{
//    NSDictionary *paramDict = [param yy_modelToJSONObject];
//    paramDict = [SecurityTool getAesDict:paramDict];
    
    sApiPath = @"goodsManager/lookGoods";
    [super requestWithParam:param responseClass:[AnswerLsDate class] success:success failure:failure];
}

#pragma mark - 订单模块
//结算生成商品订单（加密接口)
+ (void)addGoodsOrder:(AddGoodsOrderParam *)param
            Success:(void (^)(AnswerLsDict *response))success
            failure:(void (^) (NSError *error))failure{
    NSDictionary *paramDict = [param yy_modelToJSONObject];
    paramDict = [SecurityTool getAesDict:paramDict];
    
    sApiPath = @"goodsOrder/addGoodsOrder";
    [super requestWithParam:paramDict responseClass:[AnswerLsDict class] success:success failure:failure];
}

//生成保证金订单（加密接口）
+ (void)addProveMoneyOrder:(AddProveMoneyOrderParam *)param
              Success:(void (^)(AnswerLsDict *response))success
              failure:(void (^) (NSError *error))failure{
    NSDictionary *paramDict = [param yy_modelToJSONObject];
    paramDict = [SecurityTool getAesDict:paramDict];
    
    sApiPath = @"goodsOrder/addProveMoneyOrder";
    [super requestWithParam:paramDict responseClass:[AnswerLsDict class] success:success failure:failure];
}

//更新拍卖品订单（加密接口）
+ (void)updateSellerGoodsGood:(UpdateSellerGoodsGoodParam *)param
                   Success:(void (^)(AnswerLsDict *response))success
                   failure:(void (^) (NSError *error))failure{
    NSDictionary *paramDict = [param yy_modelToJSONObject];
    paramDict = [SecurityTool getAesDict:paramDict];
    
    sApiPath = @"goodsOrder/updateSellerGoodsGood";
    [super requestWithParam:paramDict responseClass:[AnswerLsDict class] success:success failure:failure];
}

//商品订单列表:客户端 (加密接口)
+ (void)getGoodsOrderList:(GetGoodsOrderListParam *)param
              Success:(void (^)(AnswerLsArray *response))success
              failure:(void (^) (NSError *error))failure{
    NSDictionary *paramDict = [param yy_modelToJSONObject];
    paramDict = [SecurityTool getAesDict:paramDict];
    
    sApiPath = @"goodsOrder/getGoodsOrderList";
    [super requestWithParam:paramDict responseClass:[AnswerLsArray class] success:success failure:failure];
}

//取消订单 (加密接口)
+ (void)cancelOrder:(CancelOrderParam *)param
                  Success:(void (^)(AnswerLsDict *response))success
                  failure:(void (^) (NSError *error))failure{
    NSDictionary *paramDict = [param yy_modelToJSONObject];
    paramDict = [SecurityTool getAesDict:paramDict];
    
    sApiPath = @"goodsOrder/cancelOrder";
    [super requestWithParam:paramDict responseClass:[AnswerLsDict class] success:success failure:failure];
}

//确认收货订单 (加密接口)
+ (void)confirmReceipt:(CancelOrderParam *)param
            Success:(void (^)(AnswerLsDict *response))success
            failure:(void (^) (NSError *error))failure{
    NSDictionary *paramDict = [param yy_modelToJSONObject];
    paramDict = [SecurityTool getAesDict:paramDict];
    
    sApiPath = @"goodsOrder/confirmReceipt";
    [super requestWithParam:paramDict responseClass:[AnswerLsDict class] success:success failure:failure];
}

#pragma mark - 首页工艺品模块
//查看发耶工艺品
+ (void)getFayeArt:(GetFayeArtParam *)param
               Success:(void (^)(AnswerLsDict *response))success
               failure:(void (^) (NSError *error))failure{
    
    sApiPath = @"fayeArt/getFayeArt";
    [super requestWithParam:param responseClass:[AnswerLsDict class] success:success failure:failure];
}

#pragma mark - 购物车模块

//添加商品到购物车
+ (void)addShopCart:(AddShopCartParam *)param
               Success:(void (^)(AnswerLsDict *response))success
               failure:(void (^) (NSError *error))failure{
    sApiPath = @"shopCart/addShopCart";
    [super requestWithParam:param responseClass:[AnswerLsDict class] success:success failure:failure];
}

//购物车商品批量删除
+ (void)delShopCart:(AddShopCartParam *)param
            Success:(void (^)(AnswerLsDict *response))success
            failure:(void (^) (NSError *error))failure{
    sApiPath = @"shopCart/delShopCart";
    [super requestWithParam:param responseClass:[AnswerLsDict class] success:success failure:failure];
}

//查看购物车列表
+ (void)getShopCartList:(GetShopCartListParam *)param
            Success:(void (^)(AnswerLsArray *response))success
            failure:(void (^) (NSError *error))failure{
    sApiPath = @"shopCart/getShopCartList";
    [super requestWithParam:param responseClass:[AnswerLsArray class] success:success failure:failure];
}

#pragma mark - 商品分类模块

//查看商品、拍卖品详情
+ (void)getGoodsDetail:(GetGoodsDetailParam *)param
             Success:(void (^)(AnswerLsDict *response))success
             failure:(void (^) (NSError *error))failure{
    sApiPath = @"goodsManager/getGoodsDetail";
    [super requestWithParam:param responseClass:[AnswerLsDict class] success:success failure:failure];
}

//查看商品、拍卖品列表
+ (void)getGoodsList:(GetGoodsListParam *)param
                Success:(void (^)(AnswerLsDict *response))success
                failure:(void (^) (NSError *error))failure{
    sApiPath = @"goodsManager/getGoodsList";
    [super requestWithParam:param responseClass:[AnswerLsDict class] success:success failure:failure];
}

//查看商品、拍卖品分类
+ (void)getGoodsClasses:(GetGoodsClassesParam *)param
             Success:(void (^)(AnswerLsArray *response))success
             failure:(void (^) (NSError *error))failure{
    sApiPath = @"goodsClass/getGoodsClasses";
    [super requestWithParam:param responseClass:[AnswerLsArray class] success:success failure:failure];
}

#pragma mark - 收件人模块
//添加收件人
+ (void)addGoodsAddr:(AddGoodsAddrParam *)param
              Success:(void (^)(AnswerLsDict *response))success
              failure:(void (^) (NSError *error))failure{
    sApiPath = @"goodsAddr/addGoodsAddr";
    [super requestWithParam:param responseClass:[AnswerLsDict class] success:success failure:failure];
}

//修改收件人、设为默认收件人
+ (void)updateGoodsAddr:(UpdateGoodsAddrParam *)param
             Success:(void (^)(AnswerLsDict *response))success
             failure:(void (^) (NSError *error))failure{
    sApiPath = @"goodsAddr/updateGoodsAddr";
    [super requestWithParam:param responseClass:[AnswerLsDict class] success:success failure:failure];
}

//查看收件人列表、查询默认收件人、查询指定收件人
+ (void)getGoodsAddrList:(GetGoodsAddrListParam *)param
                Success:(void (^)(AnswerLsArray *response))success
                failure:(void (^) (NSError *error))failure{
    sApiPath = @"goodsAddr/getGoodsAddrList";
    [super requestWithParam:param responseClass:[AnswerLsArray class] success:success failure:failure];
}

//删除收件人
+ (void)delGoodsAddr:(DelGoodsAddrParam *)param
                Success:(void (^)(AnswerLsDict *response))success
                failure:(void (^) (NSError *error))failure{
    sApiPath = @"goodsAddr/delGoodsAddr";
    [super requestWithParam:param responseClass:[AnswerLsDict class] success:success failure:failure];
}

@end
