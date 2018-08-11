//
//  GetSellerPerformGoodsListModel.h
//  HWTou
//
//  Created by robinson on 2018/4/19.
//  Copyright © 2018年 LieMi. All rights reserved.
//

#import "BaseModel.h"

@class GoodsListModel;

@interface GetSellerPerformGoodsListModel : BaseModel
@property (nonatomic,assign) NSInteger totalCount;//总条数
@property (nonatomic,assign) NSInteger acvId;//活动ID
@property (nonatomic,assign) NSInteger performId;//专场ID
@property (nonatomic,assign) NSInteger time;//时间毫秒 （客户端自己根据状态格式化下时间戳）
@property (nonatomic,assign) NSInteger status;//拍卖活动状态：0：未开始，1：进行中，2：已结束
@property (nonatomic,assign) NSInteger acStatus;//拍卖报名状态：0：未开始，1：进行中，2：已结束
@property (nonatomic,copy) NSString * startTime;//拍卖活动开始时间
@property (nonatomic,copy) NSString * endTime;//拍卖活动结束时间

@property (nonatomic,strong) NSMutableArray<GoodsListModel *> * goodsListArr;
@end

@interface GoodsListModel:BaseModel
@property (nonatomic,assign) NSInteger goodsId;//拍卖品ID
@property (nonatomic,copy) NSString * goodsName;//拍卖品名称
@property (nonatomic,copy) NSString * introduction;//拍卖品简介
@property (nonatomic,assign) NSInteger priClassId;//拍卖品分类ID
@property (nonatomic,copy) NSString * className;//拍卖品分类名
@property (nonatomic,assign) NSInteger sellerId;//卖家ID
@property (nonatomic,copy) NSString * sellerName;//拍卖品 卖家名
@property (nonatomic,copy) NSString * imgUrl;//拍卖品 图片
@property (nonatomic,copy) NSString * details;//拍卖品详情
@property (nonatomic,assign) NSInteger createTime;//拍卖品 创建时间
@property (nonatomic,assign) NSInteger status;//拍卖品状态：0：下架，1：上架
@property (nonatomic,copy) NSString * actualMoney;//拍卖品起步价
@property (nonatomic,copy) NSString * adviceMoney;//拍卖品封顶价
@property (nonatomic,copy) NSString * courierMoney;//拍卖品加价幅度
@property (nonatomic,copy) NSString * proveMoney;//拍卖品保证金
@property (nonatomic,assign) NSInteger lookNum;//拍卖品浏览量
@property (nonatomic,copy) NSString * bannerUrl;//拍卖品banner
@property (nonatomic,assign) NSInteger rank;//活动拍卖品排序值
@property (nonatomic,assign) NSInteger stockNum;//拍卖品库存
@property (nonatomic,assign) NSInteger isPayProve;//是否缴纳过保证金，0：否，1：是
@property (nonatomic,copy) NSString * currentBidMoney;//当前竞价金额，客户端需判断如果是0.00则显示起拍价
@property (nonatomic,assign) NSInteger bidCount;//竞价次数
@property (nonatomic,copy) NSString * donePrice;//成交价，客户端需判断如果是0.00则显示未成交

- (NSString *)getCurrentPrice;
- (NSString *)getCurrentPriceStr;
@end
