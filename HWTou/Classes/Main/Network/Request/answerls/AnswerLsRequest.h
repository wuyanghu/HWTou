//
//  AnswerLsRequest.h
//  HWTou
//
//  Created by robinson on 2018/1/30.
//  Copyright © 2018年 LieMi. All rights reserved.
//

#import "SessionRequest.h"
#import "AnswerLsParam.h"
#import "AnswerLsResponse.h"

@interface AnswerLsRequest : SessionRequest
//答题车神用户信息
+ (void)getUserInfo:(BaseParam *)param
            Success:(void (^)(AnswerLsDict *response))success
            failure:(void (^) (NSError *error))failure;
//获取下一场活动信息
+ (void)getActivity:(GetActivityParam *)param
            Success:(void (^)(AnswerLsDict *response))success
            failure:(void (^) (NSError *error))failure;
//获取当前系统时间
+ (void)getDate:(BaseParam *)param
        Success:(void (^)(AnswerLsDate *response))success
        failure:(void (^) (NSError *error))failure;
//题目选项信息
+ (void)getQuestionBankInfo:(GetQuestionBankInfoParam *)param
                    Success:(void (^)(AnswerLsDict *response))success
                    failure:(void (^) (NSError *error))failure;
//答题专场列表
+ (void)getSpecList:(GetActivityParam *)param
            Success:(void (^)(AnswerLsArray *response))success
            failure:(void (^) (NSError *error))failure;
//A,B,C各选项人数统计
+ (void)getAnsNum:(GetAnsNumParam *)param
          Success:(void (^)(AnswerLsDict *response))success
          failure:(void (^) (NSError *error))failure;
//用户回答
+ (void)addUserAns:(AddUserAnsParam *)param
           Success:(void (^)(AnswerLsDict *response))success
           failure:(void (^) (NSError *error))failure;
//获取实时在线人数
+ (void)getOnlineNum:(GetActivityParam *)param
             Success:(void (^)(AnswerLsInt *response))success
             failure:(void (^) (NSError *error))failure;
//活动结束,修改状态
+ (void)updateStatus:(UpdateStatusParam *)param
             Success:(void (^)(AnswerLsDict *response))success
             failure:(void (^) (NSError *error))failure;
//退出活动
+ (void)exitActivity:(GetActivityParam *)param
             Success:(void (^)(AnswerLsDict *response))success
             failure:(void (^) (NSError *error))failure;
//获取奖励金
+ (void)getMoney:(GetMoneyParam *)param
         Success:(void (^)(AnswerLsDouble *response))success
         failure:(void (^) (NSError *error))failure;
//随机获取两名获奖用户
+ (void)getWinUser:(GetMoneyParam *)param
           Success:(void (^)(AnswerLsDict *response))success
           failure:(void (^) (NSError *error))failure;
@end
