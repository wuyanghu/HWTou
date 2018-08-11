//
//  GetUserInfoModel.h
//  HWTou
//
//  Created by robinson on 2018/1/31.
//  Copyright © 2018年 LieMi. All rights reserved.
//

#import "BaseModel.h"

@interface GetUserInfoModel : BaseModel
@property (nonatomic,copy) NSString * headUrl;//用户头像
@property (nonatomic,copy) NSString * nickname;//用户昵称
@property (nonatomic,copy)  NSString * balance;//余额（可提现金额）
@property (nonatomic,assign)  NSInteger lifeValue;//生命值
@property (nonatomic,copy)  NSString * qAward;//答题奖励
@end
