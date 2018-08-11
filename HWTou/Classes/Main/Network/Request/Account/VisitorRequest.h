//
//  VisitorRequest.h
//  HWTou
//
//  Created by Reyna on 2018/3/6.
//  Copyright © 2018年 LieMi. All rights reserved.
//

#import "BaseRequest.h"

@interface VisitorRequest : BaseRequest

+ (void)loginByVisitorWithSuccess:(void (^)(NSDictionary *response))success
                failure:(void (^) (NSError *error))failure;

@end
