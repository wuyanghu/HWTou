//
//  ProductCommentReq.m
//  HWTou
//
//  Created by 彭鹏 on 2017/4/13.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "ProductCommentReq.h"
#import "ProductCommentDM.h"

typedef NS_ENUM(NSInteger, CommentRequestType){
    CommentRequestList,     // 评论列表
    CommentRequestSubmit,   // 单个评论
    CommentRequestBatch,    // 批量评论
};

@implementation CommentListParam

@end

@implementation CommentSubmitParam

@end

@implementation CommentBatchParam

+ (NSDictionary *)modelContainerPropertyGenericClass
{
    return @{@"commets" : [CommentSubmitParam class]};
}

@end

@implementation CommentListResult

+ (NSDictionary *)modelContainerPropertyGenericClass
{
    return @{@"list" : [ProductCommentDM class]};
}

@end

@implementation CommentListResp

@end

@implementation ProductCommentReq

static CommentRequestType typeReq;

+ (NSString *)requestServerHost{
    return kApiServerHost;
}

+ (NSString *)requestApiPath
{
    NSString *apiPath = @"shop/commet-api/index";
    switch (typeReq) {
        case CommentRequestSubmit:
            apiPath = @"shop/commet-api/add";
            break;
        case CommentRequestBatch:
            apiPath = @"shop/commet-api/batch-add";
            break;
        default:
            break;
    }
    return apiPath;
}

+ (HttpRequestSerializerType)requestSerializerType
{
    if (typeReq == CommentRequestBatch) {
        return HttpRequestSerializerTypeJSON;
    }
    return HttpRequestSerializerTypeData;
}

+ (void)listWithParam:(CommentListParam *)param success:(void (^)(CommentListResp *))success failure:(void (^)(NSError *))failure
{
    typeReq = CommentRequestList;
    [super requestWithParam:param responseClass:[CommentListResp class] success:success failure:failure];
}

+ (void)submitWithParam:(CommentSubmitParam *)param success:(void (^)(BaseResponse *))success failure:(void (^)(NSError *))failure
{
    typeReq = CommentRequestSubmit;
    [super requestWithParam:param responseClass:[BaseResponse class] success:success failure:failure];
}

+ (void)batchWithParam:(CommentBatchParam *)param success:(void (^)(BaseResponse *))success failure:(void (^)(NSError *))failure
{
    typeReq = CommentRequestBatch;
    [super requestWithParam:param responseClass:[BaseResponse class] success:success failure:failure];
}
@end
