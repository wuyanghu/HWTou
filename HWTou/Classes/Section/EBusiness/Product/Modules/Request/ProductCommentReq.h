//
//  ProductCommentReq.h
//  HWTou
//
//  Created by 彭鹏 on 2017/4/13.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "SessionRequest.h"

#import "BaseParam.h"
#import "BaseResponse.h"
#import "SessionRequest.h"

#import "ProductCollectDM.h"

#pragma mark - 请求参数
@interface CommentListParam : BaseParam

@property (nonatomic, assign) NSInteger item_id;
@property (nonatomic, assign) NSInteger flag; // 0:无图 1:有图 2:全部
@property (nonatomic, assign) NSInteger start_page;
@property (nonatomic, assign) NSInteger pages;

@end

@interface CommentSubmitParam : BaseParam

@property (nonatomic, assign) NSInteger order_id;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSArray *img_urls;

@end

@interface CommentBatchParam : BaseParam

@property (nonatomic, assign) NSInteger mpid;
@property (nonatomic, copy) NSArray *commets;

@end


#pragma mark - 请求响应 结果
@interface CommentListResult : NSObject

@property (nonatomic, assign) NSInteger total_pages;
@property (nonatomic, strong) NSArray   *list;

@end

#pragma mark - 请求响应
@interface CommentListResp : BaseResponse

@property (nonatomic, strong) CommentListResult *data;

@end

#pragma mark - 请求执行
@interface ProductCommentReq : SessionRequest

/**
 提交商品评价
 */
+ (void)submitWithParam:(CommentSubmitParam *)param
                success:(void (^)(BaseResponse *response))success
                failure:(void (^) (NSError *error))failure;


/**
 批量提交评论
 */
+ (void)batchWithParam:(CommentBatchParam *)param
               success:(void (^)(BaseResponse *response))success
               failure:(void (^) (NSError *error))failure;

/**
 商品评价列表
 */
+ (void)listWithParam:(CommentListParam *)param
              success:(void (^)(CommentListResp *response))success
              failure:(void (^) (NSError *error))failure;

@end
