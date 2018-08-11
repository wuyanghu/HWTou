//
//  InvestAccountDM.h
//  HWTou
//
//  Created by 彭鹏 on 2017/8/11.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    InvestAccountForward,   // 提前花
    InvestAccountStatis,    // 资产统计
    InvestAccountManage,    // 投资管理
    InvestAccountPayback,   // 回款计划
    InvestAccountRecord,    // 提现和充值记录
    InvestAccountRedPage,   // 红包
    InvestAccountExperGold, // 体验金
    InvestAccountRealName,  // 实名认证
    InvestAccountCash,      // 提现
    InvestAccountRecharge,  // 充值
    
} InvestAccountType;

@interface InvestAccountDM : NSObject

@property (nonatomic, assign) double accountAmountTotal; // 我的总资产
@property (nonatomic, assign) double amountFrozen;
@property (nonatomic, assign) double amountInvesting;
@property (nonatomic, assign) double balanceAvailable; // 可用余额
@property (nonatomic, assign) double incomeCapital;
@property (nonatomic, assign) double incomeCollected;  // 已收收益
@property (nonatomic, assign) double incomeCollecting; // 待到账收益

@end

@interface InvestFunctionDM : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *imgName;
@property (nonatomic, assign) InvestAccountType type;

@end
