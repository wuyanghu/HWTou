//
//  SigninRequest.h
//  HWTou
//
//  Created by PP on 16/7/11.
//  Copyright (c) 2016年 LieMi. All rights reserved.
//

#import "BaseRequest.h"
#import "BaseResponse.h"

@interface SigninParam : NSObject

@property (nonatomic, copy) NSString *username;
@property (nonatomic, copy) NSString *password;
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, copy) NSString *phoneType;//手机型号
@property (nonatomic, copy) NSString *phoneDevice;//手机设备号

@end

@interface SigninResult : NSObject
@property (nonatomic, copy) NSString  *imToken;//网易云凭证
@property (nonatomic, copy) NSString  *token;
@property (nonatomic, copy) NSString  *startTime;
@property (nonatomic, copy) NSString  *endTime;
@property (nonatomic, assign) NSInteger uid;

@end

@interface SigninResponse : BaseResponse

@property (nonatomic, strong) SigninResult *data;

@end

@interface SigninRequest : BaseRequest

+ (void)signinWithParam:(SigninParam *)param
                success:(void (^)(SigninResponse *response))success
                failure:(void (^) (NSError *error))failure;

@end
