//
//  TopicRequest.m
//  HWTou
//
//  Created by Reyna on 2017/12/7.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "TopicRequest.h"
#import "AccountManager.h"

@implementation TopicRequest

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

+ (void)getPlayInfoWithVid:(NSString *)vid success:(void (^)(NSDictionary *))success failure:(void (^)(NSError *))failure {
    
    sApiPath = @"oss/getPlayInfo";
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:vid forKey:@"vid"];
    [self requestWithParam:dic responseClass:nil success:success failure:failure];
}

+ (void)createTopicWithBmgUrls:(NSString *)bmgUrls listenUrl:(NSString *)listenUrl labelIds:(NSString *)labelIds title:(NSString *)title content:(NSString *)content success:(void (^)(NSDictionary *))success failure:(void (^)(NSError *))failure {
    
    sApiPath = @"topic/createTopic";
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    NSString * token = [[AccountManager shared] account].token;
    [dic setObject:token!=nil?token:@"" forKey:@"token"];
    [dic setObject:bmgUrls forKey:@"bmgUrls"];
    [dic setObject:listenUrl forKey:@"listenUrl"];
    [dic setObject:labelIds forKey:@"labelIds"];
    [dic setObject:title forKey:@"title"];
    [dic setObject:content forKey:@"content"];
    [self requestWithParam:dic responseClass:nil success:success failure:failure];
}

+ (void)delTopicWithTopicId:(int)topicId success:(void (^)(NSDictionary *))success failure:(void (^)(NSError *))failure {
    
    sApiPath = @"topic/delTopic";
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    NSString * token = [[AccountManager shared] account].token;
    [dic setObject:token!=nil?token:@"" forKey:@"token"];
    [dic setValue:@(topicId) forKey:@"topicId"];
    [self requestWithParam:dic responseClass:nil success:success failure:failure];
}

@end
