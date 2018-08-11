//
//  ShopMallParam.h
//  HWTou
//
//  Created by robinson on 2018/4/12.
//  Copyright © 2018年 LieMi. All rights reserved.
//

#import "BaseParam.h"

@interface ShopMallParam : BaseParam

@end

@interface GetMySellerListParam:BaseParam
@property (nonatomic,assign) NSInteger page;//页码
@property (nonatomic,assign) NSInteger pagesize;//每页显示条数
@property (nonatomic,assign) NSInteger flag;//标志。1：我的保证金列表 2：参拍中列表 3： 未拍中列表
@end

@interface GetBidSellerRecordParam:BaseParam
@property (nonatomic,assign) NSInteger page;//页码
@property (nonatomic,assign) NSInteger pagesize;//每页显示条数
@property (nonatomic,assign) NSInteger acvId;//活动ID
@property (nonatomic,assign) NSInteger sellerGoodsId;//商品ID
@end

@interface BidSellerGoodsParam:BaseParam

@property (nonatomic,assign) NSInteger sellerGoodsId;//商品ID
@property (nonatomic,assign) NSInteger acvId;//活动ID
@property (nonatomic,assign) NSInteger performId;//专场ID
@property (nonatomic,copy) NSString * bidMoney;//竞价金额，元
@property (nonatomic,assign) NSInteger sellerId;//卖家ID
@property (nonatomic,assign) NSInteger flag;// 1：竞价，2：举牌
@end

@interface GetSellerPerformGoodsParam:BaseParam
@property (nonatomic,assign) NSInteger acvId;//活动ID
@property (nonatomic,assign) NSInteger sellerGoodsId;//商品ID
@property (nonatomic,assign) NSInteger performId;//专场ID
@end

@interface GetSellerPerformGoodsListParam:BaseParam
@property (nonatomic,assign) NSInteger page;//页码
@property (nonatomic,assign) NSInteger pagesize;//每页显示条数
@property (nonatomic,assign) NSInteger performId;//专场ID
@end

@interface GetSellerPerformListParam:BaseParam
@property (nonatomic,assign) NSInteger state;//商品、拍卖品ID
@end

@interface CancelOrderParam:BaseParam
@property (nonatomic,assign) NSInteger oId;//订单ID
@end

@interface GetFayeArtParam:BaseParam
@property (nonatomic,assign) NSInteger page;//页码
@property (nonatomic,assign) NSInteger pagesize;//每页显示条数
@property (nonatomic,assign) NSInteger status;//状态，0：隐藏，1：显示，2：全部，客户端传 1
@end

@interface GetGoodsOrderListParam:BaseParam
@property (nonatomic,assign) NSInteger page;//页码
@property (nonatomic,assign) NSInteger pagesize;//每页显示条数
@property (nonatomic,assign) NSInteger flag;//1：我的商品订单，2：已拍中拍卖品订单
@property (nonatomic,assign) NSInteger status;//0：查看全部订单，1:查看待付款订单，2:查看待发货订单，3:查看待收货订单，4:查看已收货订单
@end

@interface AddGoodsOrderParam:BaseParam
@property (nonatomic,copy) NSString * addrName;//收件人地址
@property (nonatomic,copy) NSString * addrPhone;//收件人手机号
@property (nonatomic,copy) NSString * address;//收件人地址
@property (nonatomic,assign) NSInteger flag;//订单标志：1：商品订单，2：拍卖订单
@property (nonatomic,copy) NSString * sellerDetails;// 卖家详情（客户端需要把以下格式化好的数据转化成字符串传输给后台)
@end

@interface AddProveMoneyOrderParam:BaseParam
@property (nonatomic,assign) NSInteger acvId;//拍卖活动ID
@property (nonatomic,assign) NSInteger goodsId;//商品ID
@property (nonatomic,assign) NSInteger sellerId;//卖家ID
@property (nonatomic,copy) NSString * proveMoney;//保证金金额
@end

@interface UpdateSellerGoodsGoodParam:BaseParam
@property (nonatomic,assign) NSInteger oId;//订单ID
@property (nonatomic,copy) NSString * addrName;//收货名
@property (nonatomic,copy) NSString * addrPhone;//收货联系方式
@property (nonatomic,copy) NSString * address;//收货地址
@property (nonatomic,copy) NSString * sellerWord;//给卖家留言
@end

@interface GetShopCartListParam:BaseParam
@property (nonatomic,assign) NSInteger page;//页码
@property (nonatomic,assign) NSInteger pagesize;//每页显示条数
@end

@interface DelShopCartParam:BaseParam
@property (nonatomic,assign) NSInteger shopCartId;//购物车ID
@end

@interface AddShopCartParam:BaseParam
@property (nonatomic,assign) NSInteger goodsId;//商品、拍卖品ID
@property (nonatomic,assign) NSInteger sellerId;//卖家ID
@end

@interface GetGoodsDetailParam:BaseParam
@property (nonatomic,assign) NSInteger goodsId;//商品、拍卖品ID
@end

@interface GetGoodsListParam:BaseParam
@property (nonatomic,assign) NSInteger flag;//    是    int    标志，1：商品，2：拍卖品
@property (nonatomic,assign) NSInteger page;//页码，默认1
@property (nonatomic,assign) NSInteger pagesize;//每页显示条数，默认20
//@property (nonatomic,copy) NSString * goodsName;//商品、拍卖品名，通过商品名模糊查询
//@property (nonatomic,assign) NSInteger sellerId;//卖家ID，通过卖家查询
@property (nonatomic,assign) NSInteger priClassId;//分类ID，通过分类查询
@property (nonatomic,assign) NSInteger status;//状态：0：下架，1：上架，通过状态查询
@end

@interface GetGoodsClassesParam:BaseParam
//@property (nonatomic,assign) NSInteger page;//页码，默认1
//@property (nonatomic,assign) NSInteger pagesize;//每页显示条数，默认20
@property (nonatomic,assign) NSInteger flag;//    是    int    标志，1：商品，2：拍卖品
@property (nonatomic,assign) NSInteger state;//通过条件查询，不传查询所有，0：查看隐藏状态的商品分类，1：查看显示状态的商品分类
@end

@interface AddGoodsAddrParam:BaseParam
@property (nonatomic,copy) NSString * addrName;//收件人姓名
@property (nonatomic,copy) NSString * addrPhone;//收件人手机号
@property (nonatomic,copy) NSString * address;//收件人详细地址
@property (nonatomic,copy) NSString * addressDetail;//收件人详细地址
@end

@interface UpdateGoodsAddrParam:BaseParam
@property (nonatomic,assign) NSInteger addrId;//收件人ID
@property (nonatomic,copy) NSString * addrName;//收件人姓名
@property (nonatomic,copy) NSString * addrPhone;//收件人手机号
@property (nonatomic,copy) NSString * address;//收件人详细地址
@property (nonatomic,assign) NSInteger isDef;//传1,设为默认收件人
@end

@interface GetGoodsAddrListParam:BaseParam
@property (nonatomic,assign) NSInteger addrId;//收件人ID
@property (nonatomic,assign) NSInteger isDef;//传1,设为默认收件人
@end

@interface DelGoodsAddrParam:BaseParam
@property (nonatomic,assign) NSInteger addrId;//收件人ID
@end
