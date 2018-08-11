//
//  MuteRequest.m
//  HWTou
//
//  Created by robinson on 2018/1/30.
//  Copyright © 2018年 LieMi. All rights reserved.
//

#import "MuteRequest.h"
#import "YYModel.h"
#import "SecurityTool.h"

@implementation MuteRequest

static NSString *sApiPath = nil;

+ (NSString *)requestServerHost {
    return kApiUserServerHost;
}

+ (NSString *)requestApiPath
{
    return sApiPath;
}

+ (HttpRequestMethod)requestMethod{
    return HttpRequestMethodPost;
}
//设置支付密码
+ (void)setPayPwd:(SetPayPwdParam *)param
         Success:(void (^)(AnswerLsDict *response))success
         failure:(void (^) (NSError *error))failure{
    NSDictionary *paramDict = [param yy_modelToJSONObject];
    paramDict = [SecurityTool getAesDict:paramDict];
    
    sApiPath = @"user/setPayPwd";
    [super requestWithParam:paramDict responseClass:[AnswerLsDict class] success:success failure:failure];
}

//验证支付密码
+ (void)isPayPwd:(IsPayPwdParam *)param
          Success:(void (^)(AnswerLsDict *response))success
          failure:(void (^) (NSError *error))failure{
    NSDictionary *paramDict = [param yy_modelToJSONObject];
    paramDict = [SecurityTool getAesDict:paramDict];
    
    sApiPath = @"user/isPayPwd";
    [super requestWithParam:paramDict responseClass:[AnswerLsDict class] success:success failure:failure];
}

//是否设置过支付密码
+ (void)isSetPayPwd:(void (^)(AnswerLsInt *response))success
          failure:(void (^) (NSError *error))failure{
    BaseParam * param = [BaseParam new];
    NSDictionary *paramDict = [param yy_modelToJSONObject];
    paramDict = [SecurityTool getAesDict:paramDict];
    
    sApiPath = @"user/isSetPayPwd";
    [super requestWithParam:paramDict responseClass:[AnswerLsInt class] success:success failure:failure];
}

//永久禁言列表
+ (void)getUserMute:(void (^)(AnswerLsArray *response))success
            failure:(void (^) (NSError *error))failure{
    sApiPath = @"user/getUserMute";
    [super requestWithParam:nil responseClass:[AnswerLsArray class] success:success failure:failure];
}

//禁言，永久禁言，解封 用户
+ (void)muteUser:(MuteUserParam *)param
            Success:(void (^)(AnswerLsDict *response))success
            failure:(void (^) (NSError *error))failure{
    sApiPath = @"user/muteUser";
    [super requestWithParam:param responseClass:[AnswerLsDict class] success:success failure:failure];
}

//全体禁言
+ (void)muteAllUser:(MuteUserParam *)param
         Success:(void (^)(AnswerLsDict *response))success
         failure:(void (^) (NSError *error))failure{
    sApiPath = @"user/muteAllUser";
    [super requestWithParam:param responseClass:[AnswerLsDict class] success:success failure:failure];
}


@end

@implementation MuteUserParam

@end

@implementation SetPayPwdParam
@end

@implementation IsPayPwdParam
@end
