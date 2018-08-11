//
//  InvestProductDM.h
//  HWTou
//
//  Created by 彭鹏 on 2017/8/11.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RDInvestListDM;

@interface InvestProductDM : NSObject

@property (nonatomic, copy) NSNumber *amountBorrow; // 项目总额
@property (nonatomic, copy) NSString *formatBorrow; // 项目总额

@property (nonatomic, copy) NSNumber *amountInvestable; // 可投资金额
@property (nonatomic, copy) NSNumber *amountInvested; // 已投资金额
@property (nonatomic, copy) NSNumber *category; // 0:普通标 1:新手标
@property (nonatomic, copy) NSNumber *categoryId;
@property (nonatomic, copy) NSString *categoryName;
@property (nonatomic, copy) NSString *categoryRemark;
@property (nonatomic, copy) NSNumber *classify; // 分类 0:普通标 1:浮动标 2:即投即息标 3:活期理财
@property (nonatomic, copy) NSNumber *countDown;
@property (nonatomic, copy) NSString *id; // 标ID
@property (nonatomic, copy) NSNumber *userId;
@property (nonatomic, copy) NSNumber *investMax; // 最低投标金额
@property (nonatomic, copy) NSNumber *investMin; // 最高投标金额
@property (nonatomic, copy) NSNumber *isRegionConfirm;
@property (nonatomic, copy) NSString *name; // 标名称
@property (nonatomic, copy) NSNumber *openTime;
@property (nonatomic, copy) NSNumber *platformRateYear; // 平台加息年利率
@property (nonatomic, copy) NSNumber *progressPercentage; // 进度比例
@property (nonatomic, copy) NSNumber *rateYear; // 年化收益
@property (nonatomic, copy) NSNumber *rateYearMin; //最低年化率
@property (nonatomic, copy) NSNumber *timeLimit; // 借款期限
@property (nonatomic, assign) NSInteger timeType; // 期限类型 0:按月 1:按天
@property (nonatomic, assign) NSInteger status; // 标状态 1招标中(初审通过);3满标待审;4还款中;8已还款
@property (nonatomic, assign) NSInteger type; // 标种 0体验标 101担保标 102抵押标 103信用标 104秒还标
@property (nonatomic, assign) BOOL investAble;
@property (nonatomic, strong) RDInvestListDM *dmForward; // 提前花产品

@end

@interface InvestProductListResp : NSObject

@property (nonatomic, assign) NSInteger page;
@property (nonatomic, assign) NSInteger totalPage;
@property (nonatomic, copy) NSArray *tenderList;

@end
