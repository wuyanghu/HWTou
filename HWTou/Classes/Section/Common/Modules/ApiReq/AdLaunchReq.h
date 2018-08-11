//
//  AdLaunchReq.h
//  HWTou
//
//  Created by 彭鹏 on 2017/6/16.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "BaseResponse.h"
#import "BaseRequest.h"

@interface AdLaunchDM : NSObject

@property (nonatomic, assign) BOOL ad_sw;
@property (nonatomic, assign) NSInteger ad_second;
@property (nonatomic, assign) NSInteger click_type;
@property (nonatomic, copy) NSString *img_url;
@property (nonatomic, copy) NSString *param;

@end

@interface AdLaunchResp : BaseResponse

@property (nonatomic, strong) AdLaunchDM *data;

@end

@interface AdLaunchReq : BaseRequest

+ (void)adLaunchSuccess:(void (^)(AdLaunchResp *response))success
                failure:(void (^) (NSError *error))failure;

@end
