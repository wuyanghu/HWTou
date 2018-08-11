//
//  ActivityCollectReq.h
//  HWTou
//
//  Created by 赤 那 on 2017/4/9.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "BaseParam.h"
#import "BaseResponse.h"
#import "SessionRequest.h"

#import "ActivityCollectDM.h"

#pragma mark - 请求参数
@interface ActivityCollectListParam : BaseParam

@property (nonatomic, assign) NSInteger start_page;
@property (nonatomic, assign) NSInteger pages;

@end

@interface ActivityCollectParam : BaseParam

@property (nonatomic, assign) NSInteger act_id;

@end

#pragma mark - 请求响应 结果
@interface ActivityCollectResult : NSObject

@property (nonatomic, assign) NSInteger total_pages;
@property (nonatomic, strong) NSArray *list;

@end

#pragma mark - 请求响应
@interface ActivityCollectResp : BaseResponse

@property (nonatomic, strong) ActivityCollectResult *data;

@end

#pragma mark - 请求执行
@interface ActivityCollectReq : SessionRequest

/**
 *  @brief 收藏活动
 *
 *  @param param    ActivityCollectParam
 *  @param success  请求成功回调的block
 *  @param failure  请求失败回调的block
 *
 */
+ (void)addActivityCollectWithParam:(ActivityCollectParam *)param
                            success:(void (^)(BaseResponse *response))success
                            failure:(void (^) (NSError *error))failure;

/**
 *  @brief 取消收藏的活动
 *
 *  @param param    ActivityCollectParam
 *  @param success  请求成功回调的block
 *  @param failure  请求失败回调的block
 *
 */
+ (void)cancelActivityCollectWithParam:(ActivityCollectParam *)param
                               success:(void (^)(BaseResponse *response))success
                               failure:(void (^) (NSError *error))failure;

/**
 *  @brief 用户收藏的活动列表
 *
 *  @param param    ActivityCollectListParam
 *  @param success  请求成功回调的block
 *  @param failure  请求失败回调的block
 *
 */
+ (void)obtainActivityCollectListWithParam:(ActivityCollectListParam *)param
                                   success:(void (^)(ActivityCollectResp *response))success
                                   failure:(void (^) (NSError *error))failure;

@end
