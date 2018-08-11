//
//  UploadRequest.m
//  HWTou
//
//  Created by Reyna on 2017/12/7.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "UploadRequest.h"
#import "AccountManager.h"

@implementation UploadRequest

static NSString *sApiPath = nil;

+ (NSString *)requestServerHost {
    return kApiListenServerHost;
}

+ (NSString *)requestApiPath
{
    return sApiPath;
}

+ (HttpRequestMethod)requestMethod{
    
    return HttpRequestMethodPost;
    
}

#pragma mark -

+ (void)createUploadVideoWithFileName:(NSString *)fileName title:(NSString *)title desc:(NSString *)desc size:(long)size tags:(NSString *)tags success:(void (^)(NSDictionary *))success failure:(void (^)(NSError *))failure {
 
    sApiPath = @"oss/createUploadVideo";
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:fileName forKey:@"fileName"];
    [dic setObject:title forKey:@"title"];
    [dic setObject:desc forKey:@"desc"];
    [dic setValue:@(size) forKey:@"size"];
    [dic setObject:tags forKey:@"tags"];
    [self requestWithParam:dic responseClass:nil success:success failure:failure];
}

@end
