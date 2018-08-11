//
//  GetRedPacketDetailModel.h
//  HWTou
//
//  Created by Reyna on 2018/3/8.
//  Copyright © 2018年 LieMi. All rights reserved.
//

#import "BaseModel.h"

@interface GetRedPacketDetailModel : BaseModel

@property (nonatomic, copy) NSString *getAvater;//抢红包的用户头像
@property (nonatomic, copy) NSString *getNickName;//抢红包的用户昵称
@property (nonatomic, copy) NSString *getTime;//抢到的时间
@property (nonatomic, copy) NSString *getUserId;//抢红包的用户ID
@property (nonatomic, copy) NSString *getMoney;//抢到的钱

@property (nonatomic, assign) int getMax;//是否最佳，0：否，1：是

@end
