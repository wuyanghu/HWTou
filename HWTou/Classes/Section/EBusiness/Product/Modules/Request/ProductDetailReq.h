//
//  ProductDetailReq.h
//  HWTou
//
//  Created by 彭鹏 on 2017/4/7.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "SessionRequest.h"
#import "SessionRequest.h"
#import "BaseResponse.h"
#import "BaseParam.h"

@class ProductDetailDM;

@interface ProductDetailParam : BaseParam

@property (nonatomic, assign) NSInteger item_id;

@end

@interface ProductDetailResp : BaseResponse

@property (nonatomic, strong) ProductDetailDM *data;

@end

@interface ProductDetailReq : SessionRequest

+ (void)detailWithParam:(ProductDetailParam *)param
                success:(void (^)(ProductDetailResp *response))success
                failure:(void (^) (NSError *error))failure;

@end
