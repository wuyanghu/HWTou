//
//  WXUserInfoRequest.h
//
//  Created by pengpeng on 16/8/19.
//  Copyright © 2016年 LieMi. All rights reserved.
//

#import "BaseRequest.h"
#import "WXUserInfo.h"

@interface WXUserInfoParam : NSObject

@property (nonatomic, copy) NSString *openid;
@property (nonatomic, copy) NSString *access_token;

@end

@interface WXUserInfoRequest : BaseRequest

+ (void)userInfoWithParam:(WXUserInfoParam *)param
                  success:(void (^) (WXUserInfo *response))success
                  failure:(void (^) (NSError *error))failure;

@end


