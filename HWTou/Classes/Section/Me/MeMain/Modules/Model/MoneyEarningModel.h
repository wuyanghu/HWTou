//
//  MoneyEarningModel.h
//  HWTou
//
//  Created by Reyna on 2018/3/30.
//  Copyright © 2018年 LieMi. All rights reserved.
//

#import "BaseModel.h"

@interface MoneyEarningModel : BaseModel

@property (nonatomic, assign) int userId; //用户ID
@property (nonatomic, assign) int rtcId; //广播，话题，聊吧ID
@property (nonatomic, assign) int rtcUid; //主播ID，话题创建人ID

@property (nonatomic, copy) NSString *tipMoney; //打赏数（元）
@property (nonatomic, assign) int chargeType; //打赏方式，0：余额，1：支付宝，2：微信
@property (nonatomic, copy) NSString *tipTime; //打赏时间

@property (nonatomic, assign) int flag; //1:广播，2：话题，3：聊吧
@property (nonatomic, copy) NSString *avater; //用户头像
@property (nonatomic, copy) NSString *nickName; //用户昵称
@property (nonatomic, copy) NSString *desc; //聊吧、话题标题
@property (nonatomic, assign) int totalCount; //总条数

@end
