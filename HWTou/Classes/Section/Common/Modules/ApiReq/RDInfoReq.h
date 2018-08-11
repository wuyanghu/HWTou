//
//  RDInfoReq.h
//  HWTou
//
//  Created by 彭鹏 on 2017/7/5.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "SessionRequest.h"
#import "BaseResponse.h"
#import "BaseParam.h"

@interface RDInvestListDM : NSObject

@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSNumber *is_open;
@property (nonatomic, copy) NSString *rate;
@property (nonatomic, copy) NSNumber *status;
@property (nonatomic, copy) NSString *t_money;
@property (nonatomic, copy) NSString *tname;

@end

@interface RDInvestRecordDM : NSObject

@property (nonatomic, copy) NSString *borrowName;
@property (nonatomic, copy) NSString *addTime;
@property (nonatomic, copy) NSString *capital;
@property (nonatomic, assign) NSInteger id;
@property (nonatomic, assign) NSInteger status;

@end

@interface RDUserInfoParam : BaseParam

@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) NSString *phoneNumber;
@property (nonatomic, copy) NSString *pwd;
@property (nonatomic, assign) NSInteger userId;

@end

@interface RDUnbindParam : BaseParam

@property (nonatomic, copy) NSString *r_username;
@property (nonatomic, copy) NSString *r_password;

@end

@interface RDInvestRecordParam : BaseParam

@property (nonatomic, copy) NSArray *investList;

@end

@interface RDInvestListParam : BaseParam

@property (nonatomic, assign) NSInteger start_page;
@property (nonatomic, assign) NSInteger pages;

@end

@interface RDUserInfoResp : BaseResponse

@property (nonatomic, strong) RDUserInfoParam *data;

@end

@interface RDRecordResp : BaseResponse

@property (nonatomic, strong) RDUserInfoParam *data;

@end

@interface RDInvestListResp : BaseResponse

@property (nonatomic, copy) NSArray *data;

@end

@interface RDInfoReq : SessionRequest

+ (void)updateWithParam:(RDUserInfoParam *)param
                success:(void (^)(BaseResponse *response))success
                failure:(void (^)(NSError *error))failure;

+ (void)infoWithSuccess:(void (^)(RDUserInfoResp *response))success
                failure:(void (^)(NSError *error))failure;

+ (void)listWithSuccess:(void (^)(RDInvestListResp *response))success
                failure:(void (^)(NSError *error))failure;

+ (void)recordWithParam:(RDInvestRecordParam *)param
                success:(void (^)(BaseResponse *response))success
                failure:(void (^)(NSError *error))failure;

+ (void)unbindWithParam:(RDUnbindParam *)param
                success:(void (^)(BaseResponse *response))success
                failure:(void (^)(NSError *error))failure;

@end
