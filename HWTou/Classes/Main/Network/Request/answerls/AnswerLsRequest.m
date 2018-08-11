//
//  AnswerLsRequest.m
//  HWTou
//
//  Created by robinson on 2018/1/30.
//  Copyright © 2018年 LieMi. All rights reserved.
//

#import "AnswerLsRequest.h"

@implementation AnswerLsRequest

static NSString *sApiPath = nil;

+ (NSString *)requestServerHost {
    return kApiAnswerLsUrlHost;
}

+ (NSString *)requestApiPath
{
    return sApiPath;
}

+ (HttpRequestMethod)requestMethod{
    return HttpRequestMethodPost;
}

//答题车神用户信息
+ (void)getUserInfo:(BaseParam *)param
              Success:(void (^)(AnswerLsDict *response))success
              failure:(void (^) (NSError *error))failure{
    sApiPath = @"userData/getUserInfo";
    [super requestWithParam:param responseClass:[AnswerLsDict class] success:success failure:failure];
}

//获取下一场活动信息
+ (void)getActivity:(GetActivityParam *)param
            Success:(void (^)(AnswerLsDict *response))success
            failure:(void (^) (NSError *error))failure{
    sApiPath = @"activity/getActivity";
    [super requestWithParam:param responseClass:[AnswerLsDict class] success:success failure:failure];
}

//获取当前系统时间
+ (void)getDate:(BaseParam *)param
            Success:(void (^)(AnswerLsDate *response))success
            failure:(void (^) (NSError *error))failure{
    sApiPath = @"userData/getDate";
    [super requestWithParam:nil responseClass:[AnswerLsDate class] success:success failure:failure];
}

//题目选项信息
+ (void)getQuestionBankInfo:(GetQuestionBankInfoParam *)param
            Success:(void (^)(AnswerLsDict *response))success
            failure:(void (^) (NSError *error))failure{
    sApiPath = @"questionBank/getQuestionBankInfo";
    [super requestWithParam:param responseClass:[AnswerLsDict class] success:success failure:failure];
}

//答题专场列表
+ (void)getSpecList:(GetActivityParam *)param
        Success:(void (^)(AnswerLsArray *response))success
        failure:(void (^) (NSError *error))failure{
    sApiPath = @"specPerform/getSpecList";
    [super requestWithParam:param responseClass:[AnswerLsArray class] success:success failure:failure];
}

//A,B,C各选项人数统计
+ (void)getAnsNum:(GetAnsNumParam *)param
            Success:(void (^)(AnswerLsDict *response))success
            failure:(void (^) (NSError *error))failure{
    sApiPath = @"questionBank/getAnsNum";
    [super requestWithParam:param responseClass:[AnswerLsDict class] success:success failure:failure];
}
//用户回答
+ (void)addUserAns:(AddUserAnsParam *)param
          Success:(void (^)(AnswerLsDict *response))success
          failure:(void (^) (NSError *error))failure{
    sApiPath = @"questionBank/addUserAns";
    [super requestWithParam:param responseClass:[AnswerLsDict class] success:success failure:failure];
}

//获取实时在线人数
+ (void)getOnlineNum:(GetActivityParam *)param
          Success:(void (^)(AnswerLsInt *response))success
          failure:(void (^) (NSError *error))failure{
    sApiPath = @"activity/getOnlineNum";
    [super requestWithParam:param responseClass:[AnswerLsInt class] success:success failure:failure];
}

//活动结束,修改状态（废弃）
+ (void)updateStatus:(UpdateStatusParam *)param
             Success:(void (^)(AnswerLsDict *response))success
             failure:(void (^) (NSError *error))failure{
    sApiPath = @"activity/updateStatus";
    [super requestWithParam:param responseClass:[AnswerLsDict class] success:success failure:failure];
}

//退出活动
+ (void)exitActivity:(GetActivityParam *)param
            Success:(void (^)(AnswerLsDict *response))success
            failure:(void (^) (NSError *error))failure{
    sApiPath = @"activity/exitActivity";
    [super requestWithParam:param responseClass:[AnswerLsDict class] success:success failure:failure];
}
//获取奖励金
+ (void)getMoney:(GetMoneyParam *)param
             Success:(void (^)(AnswerLsDouble *response))success
             failure:(void (^) (NSError *error))failure{
    sApiPath = @"questionBank/getMoney";
    [super requestWithParam:param responseClass:[AnswerLsDouble class] success:success failure:failure];
}

//随机获取两名获奖用户
+ (void)getWinUser:(GetMoneyParam *)param
         Success:(void (^)(AnswerLsDict *response))success
         failure:(void (^) (NSError *error))failure{
    sApiPath = @"questionBank/getWinUser";
    [super requestWithParam:param responseClass:[AnswerLsDict class] success:success failure:failure];
}

@end
