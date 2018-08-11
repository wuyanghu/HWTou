//
//  RadioSessionReq.m
//  HWTou
//
//  Created by Reyna on 2017/11/26.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "RadioSessionReq.h"
#import "AccountManager.h"

@implementation RadioSessionReq

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

#pragma mark - 广播评论详情

+ (void)getChannelCommentWithPage:(int)page pageSize:(int)pageSize channelId:(int)channelId radioId:(int)radioId success:(void (^)(NSDictionary *))success failure:(void (^)(NSError *))failure {
    
    sApiPath = @"detail/getChannelComment";
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    NSString * token = [[AccountManager shared] account].token;
    [dic setObject:token!=nil?token:@"" forKey:@"token"];
    [dic setValue:@(page) forKey:@"page"];
    [dic setValue:@(pageSize) forKey:@"pagesize"];
    [dic setValue:@(channelId) forKey:@"channelId"];
    [dic setValue:@(radioId) forKey:@"radioId"];
    [dic setValue:@(0) forKey:@"manager"];
    [self requestWithParam:dic responseClass:[BaseResponse class] success:success failure:failure];
}

#pragma mark - 广播评论

+ (void)commentChannelWithChannelId:(int)channelId uid:(NSInteger)uid toUid:(NSInteger)toUid commentText:(NSString *)commentText commentUrl:(NSString *)commentUrl location:(NSString *)location parentId:(int)parentId preCommentId:(int)preCommentId commentFlag:(int)commentFlag success:(void (^)(BaseResponse *response))success failure:(void (^)(NSError *))failure {
    
    sApiPath = @"comment/commentChannel";
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    NSString * token = [[AccountManager shared] account].token;
    [dic setObject:token!=nil?token:@"" forKey:@"token"];
    [dic setValue:@(uid) forKey:@"uid"];
    [dic setValue:@(toUid) forKey:@"toUid"];
    [dic setValue:@(channelId) forKey:@"channelId"];
    [dic setObject:commentText forKey:@"commentText"];
    [dic setValue:@(parentId) forKey:@"parentId"];
    [dic setValue:@(preCommentId) forKey:@"preCommentId"];
    [dic setObject:commentUrl forKey:@"commentUrl"];
    [dic setValue:@(commentFlag) forKey:@"commentFlag"];
    [dic setObject:location forKey:@"location"];
    
    [self requestWithParam:dic responseClass:[BaseResponse class] success:success failure:failure];
}

#pragma mark - 话题评论

+ (void)commentTopic:(int)topicId uid:(NSInteger)uid toUid:(NSInteger)toUid commentText:(NSString *)commentText commentUrl:(NSString *)commentUrl location:(NSString *)location parentId:(int)parentId preCommentId:(int)preCommentId commentFlag:(int)commentFlag success:(void (^)(BaseResponse *response))success failure:(void (^)(NSError *))failure {
    
    sApiPath = @"comment/commentTopic";
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    NSString * token = [[AccountManager shared] account].token;
    [dic setObject:token!=nil?token:@"" forKey:@"token"];
    [dic setValue:@(uid) forKey:@"uid"];
    [dic setValue:@(toUid) forKey:@"toUid"];
    [dic setValue:@(topicId) forKey:@"topicId"];
    [dic setObject:commentText forKey:@"commentText"];
    [dic setValue:@(parentId) forKey:@"parentId"];
    [dic setValue:@(preCommentId) forKey:@"preCommentId"];
    [dic setObject:commentUrl forKey:@"commentUrl"];
    [dic setValue:@(commentFlag) forKey:@"commentFlag"];
    [dic setObject:location forKey:@"location"];
    
    [self requestWithParam:dic responseClass:[BaseResponse class] success:success failure:failure];
}

#pragma mark - 聊吧评论

+ (void)commentChat:(int)isM chatId:(int)chatId uid:(NSInteger)uid toUid:(NSInteger)toUid commentText:(NSString *)commentText commentUrl:(NSString *)commentUrl location:(NSString *)location parentId:(int)parentId preCommentId:(int)preCommentId commentFlag:(int)commentFlag success:(void (^)(BaseResponse *response))success failure:(void (^)(NSError *))failure {
    
    sApiPath = @"comment/commentChat";
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    NSString * token = [[AccountManager shared] account].token;
    [dic setObject:token!=nil?token:@"" forKey:@"token"];
    [dic setValue:@(isM) forKey:@"isM"];
    [dic setValue:@(uid) forKey:@"uid"];
    [dic setValue:@(toUid) forKey:@"toUid"];
    [dic setValue:@(chatId) forKey:@"chatId"];
    [dic setObject:commentText forKey:@"commentText"];
    [dic setValue:@(parentId) forKey:@"parentId"];
    [dic setValue:@(preCommentId) forKey:@"preCommentId"];
    [dic setObject:commentUrl forKey:@"commentUrl"];
    [dic setValue:@(commentFlag) forKey:@"commentFlag"];
    [dic setObject:location forKey:@"location"];
    
    [self requestWithParam:dic responseClass:[BaseResponse class] success:success failure:failure];
}

@end
