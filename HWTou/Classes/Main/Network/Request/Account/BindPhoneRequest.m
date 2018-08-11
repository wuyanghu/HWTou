//
//  BindPhoneRequest.m
//  HWTou
//
//  Created by 赤 那 on 2017/4/25.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "BindPhoneRequest.h"

#pragma mark - 请求参数
@implementation BindPhoneParam
@synthesize phone,code;

@end

#pragma mark - 请求响应
@implementation BindPhoneResponse

@end

#pragma mark - 请求执行
@implementation BindPhoneRequest

static NSString *sApiPath = nil;

+ (NSString *)requestApiPath{
    
    return sApiPath;
    
}

// 重新绑定手机号
+ (void)updateBindPhoneWithParam:(BindPhoneParam *)param
                         success:(void (^)(BaseResponse *))success
                         failure:(void (^)(NSError *))failure{

    sApiPath = @"member/index/bind-phone";
    
    [super requestWithParam:param responseClass:[BaseResponse class] success:success failure:failure];
    
}

@end
