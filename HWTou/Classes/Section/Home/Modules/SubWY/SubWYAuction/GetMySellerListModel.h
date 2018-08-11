//
//  GetMySellerListModel.h
//  HWTou
//
//  Created by robinson on 2018/4/23.
//  Copyright © 2018年 LieMi. All rights reserved.
//

#import "BaseModel.h"

typedef enum : NSUInteger{
    AuctionOrderStateTypeProceed,//参拍中
    AuctionOrderStateTypeNoGet,//未拍中
    AuctionOrderStateTypeMargin,//保证金
}AuctionOrderStateType;

@interface GetMySellerListModel : BaseModel
@property (nonatomic,assign) NSInteger pId;//保证金记录ID
@property (nonatomic,assign) NSInteger userId;//用户ID
@property (nonatomic,copy) NSString * userName;//用户名
@property (nonatomic,copy) NSString * userPhone;//用户手机号
@property (nonatomic,assign) NSInteger chargeType;//保证金支付方式0：余额，1：支付宝，2：微信
@property (nonatomic,copy) NSString * proveMoney;//保证金金额
@property (nonatomic,copy) NSString * refundMoney;//退款金额
@property (nonatomic,assign) NSInteger acvId;//拍卖活动ID
@property (nonatomic,copy) NSString * acvName;//拍卖活动名字
@property (nonatomic,assign) NSInteger sellerGoodsId;//拍卖品ID
@property (nonatomic,assign) NSInteger sellerId;//卖家ID
@property (nonatomic,copy) NSString * sellerName;//卖家名
@property (nonatomic,copy) NSString * goodsName;//拍卖品名
@property (nonatomic,copy) NSString * goodsImg;//拍卖品图片
@property (nonatomic,copy) NSString * currentBidMoney;//当前报价
@property (nonatomic,copy) NSString * mineBidMoney;//我的报价
@property (nonatomic,copy) NSString * doneBidMoney;//成交价
@property (nonatomic,assign) NSInteger acStatus;//拍卖活动状态，0：未开始，1：进行中，2：已结束
@property (nonatomic,assign) NSInteger isRefund;//是否退款，0：否，1：是
@property (nonatomic,assign) NSInteger isPay;//是否结算，0：否，1：是
@property (nonatomic,assign) NSInteger isGet;//是否拍得，0：否，1：是
@property (nonatomic,assign) NSInteger isProvePay;//是否付保证金，0：否，1：是
@property (nonatomic,copy) NSString * proveOrderId;//保证金订单编号
@property (nonatomic,copy) NSString * provePayTime;//保证金付款时间
@property (nonatomic,assign) NSInteger time;//根据活动倒计时时间戳
@property (nonatomic,assign) NSInteger performId;//专场ID

@property (nonatomic,copy) NSString * countTime;
@end
