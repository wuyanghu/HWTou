//
//  InvestActivityReq.h
//  HWTou
//
//  Created by 彭鹏 on 2017/8/11.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "SessionRequest.h"
#import "BaseResponse.h"
#import "BaseParam.h"

@interface InvestActivityParam : BaseParam

@property (nonatomic, assign) NSInteger status;
@property (nonatomic, assign) NSInteger start_page;
@property (nonatomic, assign) NSInteger pages;

@end

@interface InvestActivityResult : NSObject

@property (nonatomic, copy) NSArray *list;

@end

@interface InvestActivityResp : BaseResponse

@property (nonatomic, strong) InvestActivityResult *data;

@end


@interface InvestActivityReq : SessionRequest

+ (void)activityWithParam:(InvestActivityParam *)param
                  success:(void (^)(InvestActivityResp *result))success
                  failure:(void (^)(NSError *error))failure;
@end
