//
//  MessageReq.m
//  HWTou
//
//  Created by 彭鹏 on 2017/4/10.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "MessageReq.h"
#import "MessageDM.h"

#pragma mark - 请求参数
@implementation MessageListParam

@end

@implementation MessageMarkParam

@end


@implementation MessageNumParam

@end

#pragma mark - 请求结果
@implementation MessageNumDM

@end

@implementation MessageListDM

+ (NSDictionary *)modelContainerPropertyGenericClass
{
    return @{@"list" : [MessageDM class]};
}

@end

@implementation MessageNumResp

@end

@implementation MessageResp

@end

#pragma mark - 请求执行
@implementation MessageReq

static NSString *sApiPath = nil;

+ (NSString *)requestServerHost{
    return kApiServerHost;
}

+ (NSString *)requestApiPath
{
    return sApiPath;
}

+ (void)listWithParam:(MessageListParam *)param success:(void (^)(MessageResp *))success failure:(void (^)(NSError *))failure
{
    sApiPath = @"push/mail-api/index";
    [super requestWithParam:param responseClass:[MessageResp class] success:success failure:failure];
}

+ (void)markWithParam:(MessageMarkParam *)param success:(void (^)(BaseResponse *))success failure:(void (^)(NSError *))failure
{
    sApiPath = @"push/mail-api/change-status";
    [super requestWithParam:param responseClass:[BaseResponse class] success:success failure:failure];
}

+ (void)numberWithParam:(MessageNumParam *)param success:(void (^)(MessageNumResp *))success failure:(void (^)(NSError *))failure
{
    sApiPath = @"push/mail-api/get-num";
    [super requestWithParam:param responseClass:[MessageNumResp class] success:success failure:failure];
}
@end
