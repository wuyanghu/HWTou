//
//  PhoneVerRequest.m
//  HWTou
//
//  Created by 赤 那 on 2017/3/22.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "PhoneVerRequest.h"

#pragma mark - 请求参数
@implementation PhoneVerParam
@synthesize phone;

@end

#pragma mark - 请求响应 结果
@implementation PhoneVerResult

@end

#pragma mark - 请求响应
@implementation PhoneVerResponse

@end

#pragma mark - 请求执行
@implementation PhoneVerRequest

+ (NSString *)requestServerHost {
    return kApiUserServerHost;
}

+ (void)phoneVerWithParam:(PhoneVerParam *)param
                  success:(void (^)(PhoneVerResponse *response))success
                  failure:(void (^)(NSError *error))failure{
    
    [super requestWithParam:param responseClass:[PhoneVerResponse class] success:success failure:failure];
    
}

+ (NSString *)requestApiPath{
    
    return @"user/isRegister";
    
}

@end
