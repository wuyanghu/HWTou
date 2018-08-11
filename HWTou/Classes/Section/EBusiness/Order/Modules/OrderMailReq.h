//
//  OrderMailReq.h
//  HWTou
//
//  Created by 彭鹏 on 2017/4/12.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "SessionRequest.h"
#import "BaseResponse.h"
#import "BaseParam.h"

@interface OrderMailParam : BaseParam

@property (nonatomic, copy) NSString  *mail_no; // 物流单号

@end

@interface OrderMailDM : NSObject

@property (nonatomic, copy) NSString *accept_time;
@property (nonatomic, copy) NSString *accept_station;
@property (nonatomic, copy) NSString *remark;

@end

@interface OrderMailResult : NSObject

@property (nonatomic, copy) NSString *mail_no;
@property (nonatomic, copy) NSString *company_name;
@property (nonatomic, copy) NSArray  *list;
@property (nonatomic, assign) NSInteger status;

@end

@interface OrderMailResp : BaseResponse

@property (nonatomic, strong) OrderMailResult *data;

@end

@interface OrderMailReq : SessionRequest

+ (void)mailWithParam:(OrderMailParam *)param
              success:(void (^)(OrderMailResp *response))success
              failure:(void (^) (NSError *error))failure;
@end
