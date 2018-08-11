//
//  UploadRequest.h
//  HWTou
//
//  Created by Reyna on 2017/12/7.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "BaseRequest.h"

@interface UploadRequest : BaseRequest

/*
 * 获取上传凭证
 */
+ (void)createUploadVideoWithFileName:(NSString *)fileName title:(NSString *)title desc:(NSString *)desc size:(long)size tags:(NSString *)tags success:(void (^)(NSDictionary *response))success failure:(void (^) (NSError *error))failure;

@end
