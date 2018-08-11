//
//  PersonalInfoDM.h
//  HWTou
//
//  Created by 彭鹏 on 2017/4/3.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import <CoreGraphics/CoreGraphics.h>
#import <Foundation/Foundation.h>

@interface PersonalInfoDM : NSObject

@property (nonatomic, assign) NSInteger uid;                // 用户 ID
@property (nonatomic, assign) NSInteger score;              // 会员积分
@property (nonatomic, assign) NSInteger level;              // 会员等级

@property (nonatomic, copy) NSString *phone;                // 手机号
@property (nonatomic, copy) NSString *nickname;             // 昵称
@property (nonatomic, copy) NSString *head_url;             // 头像 Url
@property (nonatomic, copy) NSString *acct_name;            // 提现账号
@property (nonatomic, copy) NSString *card_no;              // 提现卡号

@property (nonatomic, assign) CGFloat investment_balance;     // 投资余额
@property (nonatomic, assign) CGFloat gold_history;           // 提前花历史
@property (nonatomic, assign) CGFloat gold_enable;            // 提前花可提现余额
@property (nonatomic, assign) CGFloat gold;                   // 提前花当前余额

@property (nonatomic, copy) NSString *create_time;            // 创建时间

@property (nonatomic, assign) BOOL is_bang;                   // 是否已绑定融都账号
@property (nonatomic, copy) NSString *phoneNumber;            // 融都手机号
@property (nonatomic, copy) NSString *pwd;                    // 融都密码
@property (nonatomic, copy) NSString *userId;                 // 融都ID
@property (nonatomic, copy) NSString *userName;               // 融都用户名

@end
