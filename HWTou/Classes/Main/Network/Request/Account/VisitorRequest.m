//
//  VisitorRequest.m
//  HWTou
//
//  Created by Reyna on 2018/3/6.
//  Copyright © 2018年 LieMi. All rights reserved.
//

#import "VisitorRequest.h"

@implementation VisitorRequest

+ (NSString *)requestServerHost {
    return kApiUserServerHost;
}

+ (NSString *)requestApiPath{
    
    return @"userData/getVisitorInfo";
    
}

+ (void) loginByVisitorWithSuccess:(void (^)(NSDictionary *))success
                          failure:(void (^)(NSError *))failure {
    
    [self requestWithParam:nil responseClass:nil success:success failure:failure];
}

@end
