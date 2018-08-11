//
//  VerifyPwdRequest.m
//  HWTou
//
//  Created by Alan Jiang on 2017/4/18.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "VerifyPwdRequest.h"

#import "AccountManager.h"

#pragma mark - 请求参数
@implementation VerifyPwdParam
@synthesize password;

@end

#pragma mark - 请求执行
@implementation VerifyPwdRequest

+ (NSString *)requestApiPath{
    
    return @"member/index/check-pwd";
    
}

// 验证已登陆用户的密码
+ (void)verifyPwdWithParam:(VerifyPwdParam *)param
                   success:(void (^)(BaseResponse *response))success
                   failure:(void (^)(NSError *error))failure{
    
    [param setPassword:[AccountManager passwordEncrypt:param.password]];
    
    [self requestWithParam:param responseClass:[BaseResponse class] success:success failure:failure];
    
}

@end
