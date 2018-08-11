//
//  ProductCartReq.h
//  HWTou
//
//  Created by 彭鹏 on 2017/3/29.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "SessionRequest.h"
#import "BaseResponse.h"
#import "BaseParam.h"

@interface CartAddParam : BaseParam

@property (nonatomic, assign) NSInteger item_id;
@property (nonatomic, assign) NSInteger mivid;
@property (nonatomic, assign) NSInteger num;

@end

@interface CartDeleteParam : BaseParam

@property (nonatomic, copy) NSArray *ids;

@end


@interface CartListResp : BaseResponse

@property (nonatomic, copy) NSArray *data;

@end

@interface ProductCartReq : SessionRequest

// 购物车列表
+ (void)listCartsSuccess:(void (^)(CartListResp *response))success
                 failure:(void (^) (NSError *error))failure;

// 添加购物车
+ (void)addCartsWithParam:(CartAddParam *)param
                  success:(void (^)(BaseResponse *response))success
                  failure:(void (^) (NSError *error))failure;

// 删除购物车
+ (void)deleteCartsWithParam:(CartDeleteParam *)param
                     success:(void (^)(BaseResponse *response))success
                     failure:(void (^) (NSError *error))failure;

@end

