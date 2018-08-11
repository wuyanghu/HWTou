//
//  ProductCategoryReq.h
//  HWTou
//
//  Created by pengpeng on 17/3/23.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "SessionRequest.h"
#import "BaseResponse.h"
#import "BaseParam.h"

@class ProductCategoryList;

@interface CategoryChildParam : BaseParam

@property (nonatomic, assign) NSInteger mcid;

@end

@interface CategoryChildResp : BaseResponse

@property (nonatomic, strong) ProductCategoryList *data;

@end

@interface ProductCategoryResp : BaseResponse

@property (nonatomic, copy) NSArray *data;

@end

@interface ProductCategoryReq : SessionRequest

+ (void)categorySuccess:(void (^)(ProductCategoryResp *response))success
                failure:(void (^) (NSError *error))failure;

/**
 获取二级分类
 @param param 一级分类ID
 */
+ (void)childCategoryWithParam:(CategoryChildParam *)param
                       success:(void (^)(CategoryChildResp *response))success
                       failure:(void (^) (NSError *error))failure;

@end
