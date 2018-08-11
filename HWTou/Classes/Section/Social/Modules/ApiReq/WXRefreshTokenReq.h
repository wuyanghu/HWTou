//
//  WXRefreshTokenReq.h
//
//  Created by pengpeng on 16/8/22.
//  Copyright © 2016年 LieMi. All rights reserved.
//

#import "BaseRequest.h"
#import "WXTokenRequest.h"

@interface WXRefreshTokenParam : NSObject

@property (nonatomic, copy) NSString *appid;
@property (nonatomic, copy) NSString *grant_type;
@property (nonatomic, copy) NSString *refresh_token;

@end

@interface WXRefreshTokenResp : WXTokenModel

@end

@interface WXRefreshTokenReq : BaseRequest

+ (void)refreshTokenWithParam:(WXRefreshTokenParam *)param
                      success:(void (^) (WXRefreshTokenResp *response))success
                      failure:(void (^) (NSError *error))failure;

@end
