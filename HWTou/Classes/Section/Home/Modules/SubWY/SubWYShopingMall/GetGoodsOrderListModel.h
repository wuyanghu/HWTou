//
//  GetGoodsOrderListModel.h
//  HWTou
//
//  Created by robinson on 2018/4/17.
//  Copyright © 2018年 LieMi. All rights reserved.
//

#import "BaseModel.h"

@class GoodsDetailModel;

@interface GetGoodsOrderListModel : BaseModel
@property (nonatomic,assign) NSInteger oId;//订单ID
@property (nonatomic,copy) NSString * orderId;//订单编号ID
@property (nonatomic,assign) NSInteger userId;// 用户ID
@property (nonatomic,copy) NSString * payOrderId;//订单平台支付流水号
@property (nonatomic,copy) NSString * transactionNo;//订单第三方支付流水号
@property (nonatomic,assign) NSInteger flag;//1：商品订单，2：拍卖品订单
@property (nonatomic,assign) NSInteger status;//0:订单未付款被取消,-1: 订单所有商品已退款，1：待付款，2：待发货，3：待收货，4：已收货
@property (nonatomic,assign) NSInteger isCancel;//订单是否取消，0：否，1：是
@property (nonatomic,assign) NSInteger chargeType;//支付方式，0：余额，1：支付宝，2:微信
@property (nonatomic,copy) NSString * totalMoney;//订单总金额
@property (nonatomic,assign) NSInteger sellerId;//卖家ID
@property (nonatomic,copy) NSString * sellerName;//卖家名
@property (nonatomic,copy) NSString * sellerPhone;//卖家手机号
@property (nonatomic,copy) NSString * sellerWord;//买家针对卖家的留言
@property (nonatomic,copy) NSString * addrName;//收货人姓名
@property (nonatomic,copy) NSString * addrPhone;//收货人联系方式
@property (nonatomic,copy) NSString * address;//收货人地址
@property (nonatomic,copy) NSString * createTime;//创建时间
@property (nonatomic,copy) NSString * payTime;//付款时间
@property (nonatomic,copy) NSString * sendTime;//发货时间
@property (nonatomic,copy) NSString * doneTime;//成交时间
@property (nonatomic,assign) NSInteger remainTime;//待付款订单支付剩余时间戳
@property (nonatomic,copy) NSString * countTime;
@property (nonatomic,strong) NSMutableArray<GoodsDetailModel *> * goodsDetailArray;
@end

@interface GoodsDetailModel:BaseModel
@property (nonatomic,assign) NSInteger goodsId;//商品ID
@property (nonatomic,copy) NSString * price;//商品价格
@property (nonatomic,assign) NSInteger num ;//商品数量
@property (nonatomic,copy) NSString * goodsName;//商品名
@property (nonatomic,copy) NSString * goodsImg;//商品图片
@property (nonatomic,assign) NSInteger goodsState;//商品状态：0：正常，2：退款成功,3:商家取消发货退款成功
@end
