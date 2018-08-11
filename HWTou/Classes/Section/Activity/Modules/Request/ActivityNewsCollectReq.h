//
//  ActivityNewsCollectReq.h
//  HWTou
//
//  Created by 赤 那 on 2017/4/9.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "BaseParam.h"
#import "BaseResponse.h"
#import "SessionRequest.h"

#import "ActivityNewsCollectDM.h"

#pragma mark - 请求参数
@interface ActivityNewsCollectListParam : BaseParam

@property (nonatomic, assign) NSInteger start_page;
@property (nonatomic, assign) NSInteger pages;

@end

@interface ActivityNewsCollectParam : BaseParam

@property (nonatomic, assign) NSInteger news_id;

@end

#pragma mark - 请求响应 结果
@interface ActivityNewsCollectResult : NSObject

@property (nonatomic, assign) NSInteger total_pages;
@property (nonatomic, strong) NSArray *list;

@end

#pragma mark - 请求响应
@interface ActivityNewsCollectResp : BaseResponse

@property (nonatomic, strong) ActivityNewsCollectResult *data;

@end

#pragma mark - 请求执行
@interface ActivityNewsCollectReq : SessionRequest

/**
 *  @brief 收藏活动新闻
 *
 *  @param param    ActivityCollectParam
 *  @param success  请求成功回调的block
 *  @param failure  请求失败回调的block
 *
 */
+ (void)addActivityNewsCollectWithParam:(ActivityNewsCollectParam *)param
                                success:(void (^)(BaseResponse *response))success
                                failure:(void (^) (NSError *error))failure;

/**
 *  @brief 取消收藏的活动新闻
 *
 *  @param param    ActivityCollectParam
 *  @param success  请求成功回调的block
 *  @param failure  请求失败回调的block
 *
 */
+ (void)cancelActivityNewsCollectWithParam:(ActivityNewsCollectParam *)param
                                   success:(void (^)(BaseResponse *response))success
                                   failure:(void (^) (NSError *error))failure;

/**
 *  @brief 用户收藏的活动新闻列表
 *
 *  @param param    ActivityCollectParam
 *  @param success  请求成功回调的block
 *  @param failure  请求失败回调的block
 *
 */
+ (void)obtainActivityNewsCollectListWithParam:(ActivityNewsCollectListParam *)param
                                       success:(void (^)(ActivityNewsCollectResp *response))success
                                       failure:(void (^) (NSError *error))failure;

@end
