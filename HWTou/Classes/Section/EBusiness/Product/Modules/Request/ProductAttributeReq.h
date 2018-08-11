//
//  ProductAttributeReq.h
//  HWTou
//
//  Created by 彭鹏 on 2017/5/8.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "SessionRequest.h"
#import "BaseResponse.h"
#import "BaseParam.h"

@interface ProductAttListParam : BaseParam

@property (nonatomic, assign) NSInteger item_id;

@end

@interface ProductAttStockParam : BaseParam

@property (nonatomic, assign) NSInteger item_id;

@end

/**
 商品属性库存价格
 */
@interface ProductAttStockResult : BaseResponse

@property (nonatomic, assign) NSInteger total_pages;
@property (nonatomic, copy) NSArray *list;

@end

@interface ProductAttStockResp : BaseResponse

@property (nonatomic, strong) ProductAttStockResult *data;

@end

@interface ProductAttListResp : BaseResponse

@property (nonatomic, copy) NSArray *data;

@end

@interface ProductAttributeReq : SessionRequest

/**
 获取属性列表
 */
+ (void)listWithParam:(ProductAttListParam *)param
              success:(void (^)(ProductAttListResp *response))success
              failure:(void (^) (NSError *error))failure;

/**
 获取属性组合信息如库存价格
 */
+ (void)stockWithParam:(ProductAttStockParam *)param
               success:(void (^)(ProductAttStockResp *response))success
               failure:(void (^) (NSError *error))failure;
@end
