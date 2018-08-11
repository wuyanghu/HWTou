//
//  RDInfoReq.m
//  HWTou
//
//  Created by 彭鹏 on 2017/7/5.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "RDInfoReq.h"

typedef NS_ENUM(NSInteger, RDInfoRequestType){
    RDInfoRequestInfo,
    RDInfoRequestList,
    RDInfoRequestUpdate,
    RDInfoRequestRecord,
    RDInfoRequestUnbind,
};


@implementation RDInvestListDM

@end

@implementation RDInvestRecordDM

@end

@implementation RDInvestListParam

@end

@implementation RDUnbindParam

@end

@implementation RDInvestRecordParam

+ (NSDictionary *)modelContainerPropertyGenericClass
{
    return @{@"investList" : [RDInvestRecordDM class]};
}

@end

@implementation RDInvestListResp

+ (NSDictionary *)modelContainerPropertyGenericClass
{
    return @{@"data" : [RDInvestListDM class]};
}

@end

@implementation RDUserInfoParam

@end

@implementation RDUserInfoResp

@end

@implementation RDInfoReq

static RDInfoRequestType typeReq;

+ (NSString *)requestApiPath
{
    NSString *kApiPath = nil;
    switch (typeReq) {
        case RDInfoRequestInfo:
            kApiPath = @"rongdu/user/sign";
            break;
        case RDInfoRequestUpdate:
            kApiPath = @"rongdu/user/index";
            break;
        case RDInfoRequestList:
            kApiPath = @"rongdu/index/index";
            break;
        case RDInfoRequestRecord:
            kApiPath = @"rongdu/index/record";
            break;
        case RDInfoRequestUnbind:
            kApiPath = @"rongdu/user/unset";
            break;
        default:
            break;
    }
    return kApiPath;
}

+ (HttpRequestSerializerType)requestSerializerType
{
    if (typeReq == RDInfoRequestRecord) {
        return HttpRequestSerializerTypeJSON;
    }
    return HttpRequestSerializerTypeData;
}


+ (void)updateWithParam:(RDUserInfoParam *)param success:(void (^)(BaseResponse *))success failure:(void (^)(NSError *))failure
{
    typeReq = RDInfoRequestUpdate;
    [super requestWithParam:param responseClass:[BaseResponse class] success:success failure:failure];
}

+ (void)infoWithSuccess:(void (^)(RDUserInfoResp *))success failure:(void (^)(NSError *))failure
{
    typeReq = RDInfoRequestInfo;
    [super requestWithParam:[BaseParam new] responseClass:[RDUserInfoResp class] success:success failure:failure];
}

+ (void)listWithSuccess:(void (^)(RDInvestListResp *))success failure:(void (^)(NSError *))failure
{
    typeReq = RDInfoRequestList;
    RDInvestListParam *param = [RDInvestListParam new];
    param.start_page = 0;
    param.pages = 20;// 实际后台返回所有
    [super requestWithParam:param responseClass:[RDInvestListResp class] success:success failure:failure];
}

+ (void)recordWithParam:(RDInvestRecordParam *)param success:(void (^)(BaseResponse *))success failure:(void (^)(NSError *))failure
{
    typeReq = RDInfoRequestRecord;
    [super requestWithParam:param responseClass:[BaseResponse class] success:success failure:failure];
}

+ (void)unbindWithParam:(RDUnbindParam *)param success:(void (^)(BaseResponse *))success failure:(void (^)(NSError *))failure
{
    typeReq = RDInfoRequestUnbind;
    [super requestWithParam:param responseClass:[BaseResponse class] success:success failure:failure];
}

@end
