//
//  WeiboUserReq.h
//
//  Created by 彭鹏 on 16/10/26.
//  Copyright © 2016年 LieMi. All rights reserved.
//

#import "BaseRequest.h"

@interface WeiboUserInfo : NSObject

@property (nonatomic, copy) NSString *id;

@property (nonatomic, copy) NSString *screen_name;  // 昵称

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *location;     // 用户所在地

@property (nonatomic, copy) NSString *profile_url;  // 微博地址

@property (nonatomic, copy) NSString *gender;       // 性别 m：男、f：女、n：未知

@property (nonatomic, assign) NSInteger province;

@property (nonatomic, assign) NSInteger city;

@end


@interface WeiboUserParam : NSObject

@property (nonatomic, copy) NSString *uid;
@property (nonatomic, copy) NSString *access_token;

@end

@interface WeiboUserReq : BaseRequest

+ (void)userInfoWithParam:(WeiboUserParam *)param
                  success:(void (^) (WeiboUserInfo *response))success
                  failure:(void (^) (NSError *error))failure;
@end
