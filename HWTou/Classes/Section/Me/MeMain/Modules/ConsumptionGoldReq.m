//
//  ConsumptionGoldReq.m
//  HWTou
//
//  Created by 彭鹏 on 2017/7/10.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "ConsumptionGoldReq.h"
#import "ConsumpGoldDetailDM.h"


typedef NS_ENUM(NSInteger, ConsumpReqType) {
    ConsumpReqDetail,
    ConsumpReqExtract,
    ConsumpReqBuyDeatail,
    ConsumpReqExtractDeatail,
};

static NSInteger kReqType;

@implementation ConsumpDetailParam

@end

@implementation ConsumpExtractParam

@end

@implementation ConsumpDetailList

+ (NSDictionary *)modelContainerPropertyGenericClass
{
    return @{@"list" : [ConsumpGoldDetailDM class]};
}

@end

@implementation ConsumpDetailResp

@end

@implementation ConsumptionGoldReq

+ (NSString *)requestApiPath
{
    NSString *kApiPath = nil;
    switch (kReqType) {
        case ConsumpReqExtract:
            kApiPath = @"rongdu/exchange/index";
            break;
        case ConsumpReqExtractDeatail:
            kApiPath = @"rongdu/ti/index";
            break;
        case ConsumpReqBuyDeatail:
            kApiPath = @"rongdu/buy/index";
            break;
        default:
            kApiPath = @"rongdu/glod/index";
            break;
    }
    return kApiPath;
}

+ (void)detailWithParam:(ConsumpExtractParam *)param success:(void (^)(ConsumpDetailResp *))success failure:(void (^)(NSError *))failure
{
    kReqType = ConsumpReqDetail;
    [super requestWithParam:param responseClass:[ConsumpDetailResp class] success:success failure:failure];
}

+ (void)extractWithParam:(ConsumpExtractParam *)param success:(void (^)(BaseResponse *))success failure:(void (^)(NSError *))failure
{
    kReqType = ConsumpReqExtract;
    [super requestWithParam:param responseClass:[BaseResponse class] success:success failure:failure];
}

+ (void)extracDetailWithParam:(ConsumpDetailParam *)param success:(void (^)(ConsumpDetailResp *))success failure:(void (^)(NSError *))failure
{
    kReqType = ConsumpReqExtractDeatail;
    [super requestWithParam:param responseClass:[ConsumpDetailResp class] success:success failure:failure];
}

+ (void)buyDetailWithParam:(ConsumpDetailParam *)param success:(void (^)(ConsumpDetailResp *))success failure:(void (^)(NSError *))failure
{
    kReqType = ConsumpReqBuyDeatail;
    [super requestWithParam:param responseClass:[ConsumpDetailResp class] success:success failure:failure];
}
@end
