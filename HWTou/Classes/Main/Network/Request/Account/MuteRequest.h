//
//  MuteRequest.h
//  HWTou
//
//  Created by robinson on 2018/1/30.
//  Copyright © 2018年 LieMi. All rights reserved.
//

#import "SessionRequest.h"
#import "BaseParam.h"
#import "AnswerLsResponse.h"

@interface MuteUserParam:BaseParam
@property (nonatomic,copy) NSString * accId;//用户ID
@property (nonatomic,assign) NSInteger flag;//标志：1：禁言，2：永久禁言，3：解封
@property (nonatomic,assign) NSInteger roomId;//聊天室ID
@end

@interface SetPayPwdParam:BaseParam
@property (nonatomic,copy) NSString * pwdF;// 用户第一次输入的密码
@property (nonatomic,copy) NSString * pwdS;//用户第二次输入的密码
@end

@interface IsPayPwdParam:BaseParam
@property (nonatomic,copy) NSString *payPwd;//支付密码
@end

@interface MuteRequest : SessionRequest
//是否设置过支付密码
+ (void)isSetPayPwd:(void (^)(AnswerLsInt *response))success
            failure:(void (^) (NSError *error))failure;
//验证支付密码
+ (void)isPayPwd:(IsPayPwdParam *)param
         Success:(void (^)(AnswerLsDict *response))success
         failure:(void (^) (NSError *error))failure;
//设置支付密码
+ (void)setPayPwd:(SetPayPwdParam *)param
          Success:(void (^)(AnswerLsDict *response))success
          failure:(void (^) (NSError *error))failure;
//永久禁言列表
+ (void)getUserMute:(void (^)(AnswerLsArray *response))success
            failure:(void (^) (NSError *error))failure;

//禁言，永久禁言，解封 用户
+ (void)muteUser:(MuteUserParam *)param
         Success:(void (^)(AnswerLsDict *response))success
         failure:(void (^) (NSError *error))failure;
//全体禁言
+ (void)muteAllUser:(MuteUserParam *)param
            Success:(void (^)(AnswerLsDict *response))success
            failure:(void (^) (NSError *error))failure;
@end
