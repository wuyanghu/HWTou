//
//  SigninRequest.m
//  HWTou
//
//  Created by PP on 16/7/11.
//  Copyright (c) 2016年 LieMi. All rights reserved.
//

#import "SigninRequest.h"

@implementation SigninParam

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.type = 1;
    }
    return self;
}
@end

@implementation SigninResult

@end

@implementation SigninResponse

@end

@implementation SigninRequest

+ (NSString *)requestServerHost {
    return kApiUserServerHost;
}

+ (void)signinWithParam:(SigninParam *)param
                success:(void (^)(SigninResponse *))success
                failure:(void (^)(NSError *))failure{
    
    [self requestWithParam:param responseClass:[SigninResponse class] success:success failure:failure];
    
}

+ (NSString *)requestApiPath{
    
    return @"user/login";
    
}

@end
