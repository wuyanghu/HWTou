//
//  UserDataModel.h
//  HWTou
//
//  Created by 赤 那 on 2017/4/4.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserDataModel : NSObject

@property (nonatomic, assign) NSInteger uid;                    // 用户 ID
@property (nonatomic, strong) NSString *pthone;                 // 联系电话
@property (nonatomic, strong) NSString *nickname;               // 昵称
@property (nonatomic, strong) NSString *head_url;               // 头像 url
@property (nonatomic, assign) NSInteger score;                  // 会员积分
@property (nonatomic, assign) NSInteger level;                  // 会员积分
@property (nonatomic, assign) double investment_balance;        // 投资账户余额
@property (nonatomic, assign) double gold_history;              // 历史提前花总额
@property (nonatomic, assign) double gold;                      // 提前花总额
@property (nonatomic, assign) double gold_enable;               // 可提提前花
@property (nonatomic, strong) NSString *create_time;            // 注册时间

@end
