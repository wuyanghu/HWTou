//
//  GetRedPacketViewModel.h
//  HWTou
//
//  Created by Reyna on 2018/3/8.
//  Copyright © 2018年 LieMi. All rights reserved.
//

#import "BaseViewModel.h"
#import "GetRedPacketDetailModel.h"

@interface GetRedPacketViewModel : BaseViewModel

@property (nonatomic, copy) NSString *avater; //发红包者头像
@property (nonatomic, copy) NSString *nickName;//发红包者昵称
@property (nonatomic, copy) NSString *userAvater;//该用户头像
@property (nonatomic, copy) NSString *userNickName;//该用户昵称
@property (nonatomic, copy) NSString *redText;//红包文本
@property (nonatomic, copy) NSString *getRedMoney;//获取到红包的钱
@property (nonatomic, copy) NSString *redDesc;//红包描述

@property (nonatomic, assign) int redState;//红包对应用户的状态: 1抢完了，2：已领取，3：已过期
@property (nonatomic, assign) int fromUserId;//红包来源用户ID
@property (nonatomic, assign) int redRId;//红包ID

@property (nonatomic, strong) NSMutableArray *redLists;

@end
