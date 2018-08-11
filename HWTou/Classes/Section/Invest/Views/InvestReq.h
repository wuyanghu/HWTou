//
//  InvestReq.h
//  HWTou
//
//  Created by 张维扬 on 2017/8/11.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "SessionRequest.h"
#import "BaseResponse.h"
#import "InvestParam.h"

@interface InvestListResp : NSObject

@property (nonatomic, copy) NSString *condition;
@property (nonatomic, copy) NSString *create_time;
@property (nonatomic, copy) NSString *end_time;
@property (nonatomic, copy) NSString *price;
@property (nonatomic, copy) NSString *start_time;
@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *type;

@end

@interface InvestDataResp : NSObject

@property (nonatomic, copy) NSArray *list;

@end


@interface InvestConfigResponse : BaseResponse

@property (nonatomic, strong) InvestDataResp *data;

@end

@interface InvestSwitchResult : NSObject

@property (nonatomic, assign) BOOL status;

@end

@interface InvestSwitchResp : BaseResponse

@property (nonatomic, strong) InvestSwitchResult *data;

@end

@interface InvestReq : BaseRequest

+ (void)redPackWithParam:(BaseParam *)param
                 success:(void (^)(InvestConfigResponse *result))success
                 failure:(void (^)(NSError *error))failure;

+ (void)switchSuccess:(void (^)(InvestSwitchResp *response))success
              failure:(void (^)(NSError *error))failure;

@end
