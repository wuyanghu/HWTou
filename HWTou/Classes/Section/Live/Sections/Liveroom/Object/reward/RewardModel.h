//
//  RewardModel.h
//  HWTou
//
//  Created by robinson on 2018/3/28.
//  Copyright © 2018年 LieMi. All rights reserved.
//

#import "BaseModel.h"

@interface RewardModel : BaseModel
@property (nonatomic,assign) NSInteger userId;//用户ID
@property (nonatomic,assign) NSInteger rtcId;// 广播，话题，聊吧ID
@property (nonatomic,assign) NSInteger rtcUid;// 主播ID，话题创建人ID
@property (nonatomic,copy) NSString * tipMoney ;// 累计打赏金额（元）
@property (nonatomic,assign) NSInteger flag ;// 1:广播，2：话题，3：聊吧
@property (nonatomic,copy) NSString * avater ;//用户头像
@property (nonatomic,copy) NSString * nickName;//用户昵称
@property (nonatomic,assign) NSInteger totalCount ;//总条数
@end
