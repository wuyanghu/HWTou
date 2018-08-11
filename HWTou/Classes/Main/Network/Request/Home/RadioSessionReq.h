//
//  RadioSessionReq.h
//  HWTou
//
//  Created by Reyna on 2017/11/26.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "SessionRequest.h"
#import "BaseResponse.h"

@interface RadioSessionReq : SessionRequest

/*
 * 广播评论详情
 */
+ (void)getChannelCommentWithPage:(int)page pageSize:(int)pageSize channelId:(int)channelId radioId:(int)radioId success:(void (^)(NSDictionary *response))success failure:(void (^) (NSError *error))failure;
/*
 * 广播评论
 */
+ (void)commentChannelWithChannelId:(int)channelId uid:(NSInteger)uid toUid:(NSInteger)toUid commentText:(NSString *)commentText commentUrl:(NSString *)commentUrl location:(NSString *)location parentId:(int)parentId preCommentId:(int)preCommentId commentFlag:(int)commentFlag success:(void (^)(BaseResponse *response))success failure:(void (^) (NSError *error))failure;

//话题评论
+ (void)commentTopic:(int)topicId uid:(NSInteger)uid toUid:(NSInteger)toUid commentText:(NSString *)commentText commentUrl:(NSString *)commentUrl location:(NSString *)location parentId:(int)parentId preCommentId:(int)preCommentId commentFlag:(int)commentFlag success:(void (^)(BaseResponse *response))success failure:(void (^)(NSError *))failure ;

//聊吧评论
+ (void)commentChat:(int)isM chatId:(int)chatId uid:(NSInteger)uid toUid:(NSInteger)toUid commentText:(NSString *)commentText commentUrl:(NSString *)commentUrl location:(NSString *)location parentId:(int)parentId preCommentId:(int)preCommentId commentFlag:(int)commentFlag success:(void (^)(BaseResponse *response))success failure:(void (^)(NSError *))failure;

@end
