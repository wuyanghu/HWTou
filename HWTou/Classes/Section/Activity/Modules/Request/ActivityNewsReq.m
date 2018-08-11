//
//  ActivityNewsReq.m
//  HWTou
//
//  Created by 彭鹏 on 2017/4/6.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "ActivityNewsReq.h"
#import "ActivityNewsDM.h"

typedef NS_ENUM(NSInteger, NewsRequestType){
    
    NewsRequestList,        // 新闻列表
    NewsRequestDetail,      // 新闻详情
    NewsRequestCategory,    // 新闻分类
    NewsRequestListByCate,  // 指定分类列表
};

#pragma mark - 请求参数
@implementation NewsListParam

@end

@implementation NewsListCateParam

@end

@implementation NewsDetailParam

@end

#pragma mark - 请求响应 结果
@implementation ActivityNewsList

+ (NSDictionary *)modelContainerPropertyGenericClass
{
    return @{@"list" : [ActivityNewsDM class]};
}

@end

#pragma mark - 请求响应
@implementation ActivityNewsResp

@end

@implementation NewsDetailResp

@end

@implementation NewsCategoryResp

+ (NSDictionary *)modelContainerPropertyGenericClass
{
    return @{@"data" : [ActivityCategoryDM class]};
}

@end

#pragma mark - 请求执行
@implementation ActivityNewsReq

static NewsRequestType type;

+ (NSString *)requestServerHost{
    return kApiServerHost;
}

+ (NSString *)requestApiPath
{
    NSString *apiPath = @"info/news-api/index";
    switch (type) {
        case NewsRequestDetail:
            apiPath = @"info/news-api/detail";
            break;
        case NewsRequestCategory:
            apiPath = @"info/news-api/category";
            break;
        case NewsRequestListByCate:
            apiPath = @"info/news-api/list-by-ncid";
            break;
        default:
            break;
    }
    return apiPath;
}

+ (void)listWithParam:(NewsListParam *)param
              success:(void (^)(ActivityNewsResp *))success
              failure:(void (^)(NSError *))failure
{
    type = NewsRequestList;
    [super requestWithParam:param responseClass:[ActivityNewsResp class] success:success failure:failure];
}

+ (void)detailWithParam:(NewsDetailParam *)param
                success:(void (^)(NewsDetailResp *))success
                failure:(void (^)(NSError *))failure
{
    type = NewsRequestDetail;
    [super requestWithParam:param responseClass:[NewsDetailResp class] success:success failure:failure];
}

+ (void)categorySuccess:(void (^)(NewsCategoryResp *))success failure:(void (^)(NSError *))failure
{
    type = NewsRequestCategory;
    [super requestWithParam:[BaseParam new] responseClass:[NewsCategoryResp class] success:success failure:failure];
    
}

+ (void)listByCateWithParam:(NewsListCateParam *)param success:(void (^)(ActivityNewsResp *))success failure:(void (^)(NSError *))failure
{
    type = NewsRequestListByCate;
    [super requestWithParam:param responseClass:[ActivityNewsResp class] success:success failure:failure];
    
}

@end
