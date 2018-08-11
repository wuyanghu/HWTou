//
//  ActivityReq.h
//  HWTou
//
//  Created by 彭鹏 on 2017/4/6.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "SessionRequest.h"
#import "BaseResponse.h"
#import "BaseParam.h"

@class ActivityListDM;

#pragma mark - 请求参数
@interface ActivityParam : BaseParam

@property (nonatomic, assign) NSInteger type;
@property (nonatomic, assign) NSInteger start_page;
@property (nonatomic, assign) NSInteger pages;
@property (nonatomic, copy) NSString *keywords;

@end

@interface ActAppliedParam : BaseParam

@property (nonatomic, assign) NSInteger start_page;
@property (nonatomic, assign) NSInteger pages;

@end

@interface ActDetailParam : BaseParam

@property (nonatomic, assign) NSInteger act_id;

@end

#pragma mark - 请求响应 结果
@interface ActivityList : NSObject

@property (nonatomic, assign) NSInteger total_pages;
@property (nonatomic, copy  ) NSArray   *list;

@end

#pragma mark - 请求响应
@interface ActivityResp : BaseResponse

@property (nonatomic, strong) ActivityList *data;

@end

@interface ActDetailResp : BaseResponse

@property (nonatomic, strong) ActivityListDM *data;

@end

#pragma mark - 请求执行
@interface ActivityReq : SessionRequest

// 活动列表
+ (void)listWithParam:(ActivityParam *)param
              success:(void (^)(ActivityResp *response))success
              failure:(void (^) (NSError *error))failure;

// 已报名列表
+ (void)listAppliedWithParam:(ActAppliedParam *)param
                     success:(void (^)(ActivityResp *response))success
                     failure:(void (^) (NSError *error))failure;

// 新闻详情
+ (void)detailWithParam:(ActDetailParam *)param
                success:(void (^)(ActDetailResp *response))success
                failure:(void (^) (NSError *error))failure;
@end
