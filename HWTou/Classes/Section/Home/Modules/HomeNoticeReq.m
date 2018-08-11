//
//  HomeNoticeReq.m
//  HWTou
//
//  Created by 彭鹏 on 2017/3/21.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "HomeNoticeReq.h"
#import "HomeNoticeDM.h"
#import "BaseParam.h"

@implementation HomeNoticeResp

+ (NSDictionary *)modelContainerPropertyGenericClass
{
    return @{@"data" : [HomeNoticeDM class]};
}

@end

@implementation HomeNoticeReq

+ (NSString *)requestApiPath
{
    return @"notice/index/index";
}

+ (void)noticeReqSuccess:(void (^)(HomeNoticeResp *))success failure:(void (^)(NSError *))failure
{
    [super requestWithParam:[BaseParam new] responseClass:[HomeNoticeResp class] success:success failure:failure];
}
@end
