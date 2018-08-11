//
//  ConsumptionGoldReq.h
//  HWTou
//
//  Created by 彭鹏 on 2017/7/10.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "SessionRequest.h"
#import "BaseResponse.h"
#import "BaseParam.h"

@interface ConsumpExtractParam : BaseParam

@property (nonatomic, copy) NSString *acct_name;
@property (nonatomic, copy) NSString *card_no;
@property (nonatomic, assign) double money;

@end

@interface ConsumpDetailParam : BaseParam

@property (nonatomic, assign) NSInteger start_page;
@property (nonatomic, assign) NSInteger pages;

@end

@interface ConsumpDetailList : NSObject

@property (nonatomic, assign) NSInteger total_pages;
@property (nonatomic, copy)   NSArray *list;

@end

@interface ConsumpDetailResp : BaseResponse

@property (nonatomic, strong) ConsumpDetailList *data;

@end

@interface ConsumptionGoldReq : SessionRequest

+ (void)detailWithParam:(ConsumpDetailParam *)param
                success:(void (^)(ConsumpDetailResp *response))success
                failure:(void (^) (NSError *error))failure;

+ (void)extracDetailWithParam:(ConsumpDetailParam *)param
                      success:(void (^)(ConsumpDetailResp *response))success
                      failure:(void (^) (NSError *error))failure;

+ (void)extractWithParam:(ConsumpExtractParam *)param
                 success:(void (^)(BaseResponse *response))success
                 failure:(void (^) (NSError *error))failure;

+ (void)buyDetailWithParam:(ConsumpDetailParam *)param
                   success:(void (^)(ConsumpDetailResp *response))success
                   failure:(void (^) (NSError *error))failure;

@end
