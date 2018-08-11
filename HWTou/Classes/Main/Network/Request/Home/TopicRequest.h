//
//  TopicRequest.h
//  HWTou
//
//  Created by Reyna on 2017/12/7.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "BaseRequest.h"
#import "SessionRequest.h"

@interface TopicRequest : SessionRequest

/*
 * 获取播放地址（播放）
 */
+ (void)getPlayInfoWithVid:(NSString *)vid success:(void (^)(NSDictionary *response))success failure:(void (^) (NSError *error))failure;


/*
 * 创建话题
 */
+ (void)createTopicWithBmgUrls:(NSString *)bmgUrls listenUrl:(NSString *)listenUrl labelIds:(NSString *)labelIds title:(NSString *)title content:(NSString *)content success:(void (^)(NSDictionary *response))success failure:(void (^) (NSError *error))failure;


/*
 * 删除话题
 */
+ (void)delTopicWithTopicId:(int)topicId success:(void (^)(NSDictionary *response))success failure:(void (^) (NSError *error))failure;

@end
