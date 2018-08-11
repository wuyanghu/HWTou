//
//  GetActivityModel.h
//  HWTou
//
//  Created by robinson on 2018/1/31.
//  Copyright © 2018年 LieMi. All rights reserved.
//

#import "BaseModel.h"

@interface GetActivityModel : BaseModel
@property (nonatomic,assign) NSInteger actId;//活动ID
@property (nonatomic,copy) NSString * actTitle;//活动标题
@property (nonatomic,copy) NSString * startTime;//活动开始时间
@property (nonatomic,assign) NSInteger quesStay;//题目页面停留时长(s)
@property (nonatomic,assign) NSInteger ansStay;//答案页面停留时长(s)
@property (nonatomic,assign) double actReward;//活动奖励（元）
@property (nonatomic,assign) NSInteger onlineNum;//当前活动在线人数
@property (nonatomic,assign) NSInteger quesNum;//题目总数量
@property (nonatomic,assign) NSInteger timestamp;//活动开始时间时间戳
@property (nonatomic,copy) NSString * bgmUrl;//背景图
@property (nonatomic,copy) NSString * listenUrl;//背景音乐
@end
