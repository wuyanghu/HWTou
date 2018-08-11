//
//  PersonalInfoReq.m
//  HWTou
//
//  Created by 彭鹏 on 2017/4/3.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "PersonalInfoReq.h"

#pragma mark - 请求参数
@implementation PersonalInfoParam

@end

@implementation PersonalInfoUpdateParam
@synthesize head_url,nickname;

@end

#pragma mark - 请求响应 结果
@implementation PersonalInfoResult

@end

#pragma mark - 请求响应
@implementation PersonalInfoResp

@end

#pragma mark - 请求执行
@implementation PersonalInfoReq

static NSString *sApiPath = nil;

+ (NSString *)requestServerHost{
    return kApiUserServerHost;
}

+ (NSString *)requestApiPath{
    
    return sApiPath;
    
}

// 获取个人信息
+ (void)personalInfoSuccess:(void (^)(PersonalInfoResp *))success
                    failure:(void (^)(NSError *))failure{
    
    sApiPath = @"member/index/info";
    
    [super requestWithParam:[BaseParam new] responseClass:[PersonalInfoResp class] success:success
                    failure:failure];
    
}

// 修改个人信息
+ (void)updatePersonalInfo:(PersonalInfoUpdateParam *)param
                   Success:(void (^)(BaseResponse *response))success
                   failure:(void (^) (NSError *error))failure{

    sApiPath = @"member/index/change-info";
    
    [super requestWithParam:param responseClass:[BaseResponse class] success:success failure:failure];
    
}

@end
