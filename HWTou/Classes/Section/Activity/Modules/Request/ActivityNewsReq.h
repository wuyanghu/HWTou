//
//  ActivityNewsReq.h
//  HWTou
//
//  Created by 彭鹏 on 2017/4/6.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "SessionRequest.h"
#import "BaseResponse.h"
#import "BaseParam.h"

@class ActivityNewsDM;
@class ActivityCategoryDM;

#pragma mark - 请求参数
@interface NewsListParam : BaseParam

@property (nonatomic, copy) NSString *keywords;
@property (nonatomic, assign) NSInteger start_page;
@property (nonatomic, assign) NSInteger pages;

@end

@interface NewsListCateParam : NewsListParam

@property (nonatomic, strong) NSNumber *ncid;

@end

@interface NewsDetailParam : BaseParam

@property (nonatomic, assign) NSInteger news_id;

@end

#pragma mark - 请求响应 结果
@interface ActivityNewsList : NSObject

@property (nonatomic, strong) ActivityCategoryDM *category_info;
@property (nonatomic, assign) NSInteger total_pages;
@property (nonatomic, copy  ) NSArray   *list;

@end

@interface ActivityNewsResp : BaseResponse

@property (nonatomic, strong) ActivityNewsList *data;

@end

#pragma mark - 请求响应
@interface NewsDetailResp : BaseResponse

@property (nonatomic, strong) ActivityNewsDM *data;

@end

@interface NewsCategoryResp : BaseResponse

@property (nonatomic, copy) NSArray *data;

@end


#pragma mark - 请求执行
@interface ActivityNewsReq : SessionRequest

// 新闻列表
+ (void)listWithParam:(NewsListParam *)param
              success:(void (^)(ActivityNewsResp *response))success
              failure:(void (^) (NSError *error))failure;

// 新闻详情
+ (void)detailWithParam:(NewsDetailParam *)param
                success:(void (^)(NewsDetailResp *response))success
                failure:(void (^) (NSError *error))failure;

// 新闻分类
+ (void)categorySuccess:(void (^)(NewsCategoryResp *response))success
                failure:(void (^) (NSError *error))failure;

// 指定类型获取列表
+ (void)listByCateWithParam:(NewsListCateParam *)param
                    success:(void (^)(ActivityNewsResp *response))success
                    failure:(void (^) (NSError *error))failure;

@end
