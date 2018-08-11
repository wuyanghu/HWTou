//
//  HomeConfigReq.h
//  HWTou
//
//  Created by 彭鹏 on 2017/5/2.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "SessionRequest.h"
#import "BaseResponse.h"

@interface HomeConfigResp : BaseResponse

@property (nonatomic, copy) NSArray *data;

@end

@interface HomeConfigReq : SessionRequest

+ (void)configSuccess:(void (^)(HomeConfigResp *response))success
              failure:(void (^) (NSError *error))failure;

@end
