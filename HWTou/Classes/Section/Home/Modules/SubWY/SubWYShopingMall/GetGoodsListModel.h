//
//  GetGoodsListModel.h
//  HWTou
//
//  Created by robinson on 2018/4/13.
//  Copyright © 2018年 LieMi. All rights reserved.
//

#import "BaseModel.h"

@interface GetGoodsListModel : BaseModel
@property (nonatomic,assign) NSInteger goodsId;//商品、拍卖品ID
@property (nonatomic,copy) NSString * goodsName;//商品、拍卖品名称
@property (nonatomic,copy) NSString * introduction;//商品、拍卖品简介
@property (nonatomic,assign) NSInteger priClassId;//商品、拍卖品分类ID
@property (nonatomic,copy) NSString * className;//商品、拍卖品分类名
@property (nonatomic,assign) NSInteger sellerId;//卖家ID
@property (nonatomic,copy) NSString * sellerName;//商品、拍卖品 卖家名
@property (nonatomic,copy) NSString * imgUrl;//商品、拍卖品 图片
@property (nonatomic,copy) NSString * details;//商品、拍卖品详情
@property (nonatomic,assign) NSInteger createTime;//商品、拍卖品 创建时间
@property (nonatomic,assign) NSInteger status;// 商品状态：0：下架，1：上架
@property (nonatomic,copy) NSString * actualMoney;//商品售价、拍卖品起步价
@property (nonatomic,copy) NSString * adviceMoney;//拍卖品封顶价
@property (nonatomic,copy) NSString * courierMoney;//拍卖品加价幅度
@property (nonatomic,copy) NSString * proveMoney;//拍卖品保证金
@property (nonatomic,assign) NSInteger lookNum;//商品、拍卖品浏览量
@property (nonatomic,copy) NSString * bannerUrl;//商品、拍卖品banner
@property (nonatomic,assign) NSInteger rank;//商品在分类下的排序值
@property (nonatomic,assign) NSInteger stockNum;//商品、拍卖品库存
@end
