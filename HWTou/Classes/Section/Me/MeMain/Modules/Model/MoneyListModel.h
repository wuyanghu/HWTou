//
//  MoneyListModel.h
//  HWTou
//
//  Created by Reyna on 2018/2/2.
//  Copyright © 2018年 LieMi. All rights reserved.
//

#import "BaseModel.h"

@interface MoneyListModel : BaseModel

@property (nonatomic, assign) int rId; //记录ID
@property (nonatomic, assign) int uid; //用户ID
@property (nonatomic, assign) NSInteger createTime; //用户发起时间戳
@property (nonatomic, assign) NSInteger endTime; //提现处理结束时间戳
@property (nonatomic, assign) int financialType; //交易类型，1充值，2提现，3答题奖励，4邀请奖励，5发红包，6 抢红包，7 红包退回 ,8:打赏支出，9：打赏收入

@property (nonatomic, copy) NSString *financialDesc; //交易描述

@property (nonatomic, copy) NSString *money; //交易发起金额
@property (nonatomic, copy) NSString *realAmt; //实际交易金额

@property (nonatomic, copy) NSString *ordId; //订单号

@property (nonatomic, assign) NSInteger ordDate; //订单时间戳
@property (nonatomic, assign) int withdrawStatus; //提现状态；0：提现中，2：提现失败，3：提现成功
@property (nonatomic, assign) int rewardType; //邀请奖励类型，0：现金奖励，1：商城优惠券

@end
