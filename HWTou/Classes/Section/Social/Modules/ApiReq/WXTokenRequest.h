//
//  WXTokenRequest.h
//  HWTou
//
//  Created by 彭鹏 on 2017/4/28.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "BaseRequest.h"

@interface WXTokenModel : NSObject

@property (nonatomic, assign) NSInteger expires_in;
@property (nonatomic, copy) NSString *access_token;
@property (nonatomic, copy) NSString *refresh_token;
@property (nonatomic, copy) NSString *openid;
@property (nonatomic, copy) NSString *scope;

@end

@interface WXTokenParam : NSObject

@property (nonatomic, copy) NSString *appid;
@property (nonatomic, copy) NSString *secret;
@property (nonatomic, copy) NSString *code;
@property (nonatomic, copy) NSString *grant_type;

@end

@interface WXTokenResponse : WXTokenModel

@property (nonatomic, copy) NSString *unionid;

@end

@interface WXTokenRequest : BaseRequest

+ (void)accessTokenWithParam:(WXTokenParam *)param
                     success:(void (^) (WXTokenResponse *response))success
                     failure:(void (^) (NSError *error))failure;

@end
