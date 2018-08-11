//
//  ProductListReq.h
//  HWTou
//
//  Created by pengpeng on 17/3/24.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "SessionRequest.h"
#import "BaseResponse.h"
#import "BaseParam.h"

@interface ProductListParam : BaseParam

@property (nonatomic, assign) NSInteger mcid;
@property (nonatomic, assign) NSInteger start_page;
@property (nonatomic, assign) NSInteger pages;

@end

@interface ProductSearchParam : BaseParam

@property (nonatomic, assign) NSInteger start_page;
@property (nonatomic, assign) NSInteger pages;
@property (nonatomic, copy) NSString *keywords;

@end

@interface ProductListResult : NSObject

@property (nonatomic, assign) NSInteger total_pages;
@property (nonatomic, copy  ) NSArray   *list;

@end

@interface ProductListResp : BaseResponse

@property (nonatomic, strong) ProductListResult *data;

@end

@interface ProductListReq : SessionRequest

+ (void)productWithParam:(ProductListParam *)param
                 success:(void (^)(ProductListResp *response))success
                 failure:(void (^) (NSError *error))failure;

+ (void)searchWithParam:(ProductSearchParam *)param
                success:(void (^)(ProductListResp *response))success
                failure:(void (^) (NSError *error))failure;

@end
