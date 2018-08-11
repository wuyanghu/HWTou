//
//  RadioRequest.m
//  HWTou
//
//  Created by Reyna on 2017/11/23.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "RadioRequest.h"
#import "AccountManager.h"

@implementation RadioRequest

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

#pragma mark - 查看签约电台

+ (void)getRadioSignWithSuccess:(void (^)(NSDictionary *))success failure:(void (^)(NSError *))failure {
    
    sApiPath = @"radio/getRadioSign";
    [self requestWithParam:nil responseClass:nil success:success failure:failure];
}

#pragma mark - 查询电台节目单列表详情

+ (void)getRadioDetailListWithParam:(RadioDetailListParam *)param success:(void (^)(RadioDetailListResponse *response))success failure:(void (^) (NSError *error))failure {
    
    sApiPath = @"radio/getRadioDetailList";
    [self requestWithParam:param responseClass:[RadioDetailListResponse class] success:success failure:failure];
}

#pragma mark - 查看广播频道列表

+ (void)getRadioDetailWithPage:(int)page pageSize:(int)pageSize targetId:(int)targetId success:(void (^)(NSDictionary *response))success failure:(void (^)(NSError *))failure {
    
    sApiPath = @"radio/getRadioDetail2";
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    NSString * token = [[AccountManager shared] account].token;
    [dic setObject:token!=nil?token:@"" forKey:@"token"];
    [dic setValue:@(page) forKey:@"page"];
    [dic setValue:@(pageSize) forKey:@"pagesize"];
    [dic setValue:@(targetId) forKey:@"targetId"];
    [self requestWithParam:dic responseClass:nil success:success failure:failure];
}

#pragma mark - 查看广播频道排行榜

+ (void)getRadioDetailTopWithSuccess:(void (^)(NSDictionary *response))success failure:(void (^) (NSError *error))failure {
    
    sApiPath = @"radio/getRadioDetailTop";
    
    [self requestWithParam:nil responseClass:nil success:success failure:failure];
}

#pragma mark - 查看电台分类列表

+ (void)getRadioClassWithSuccess:(void (^)(NSDictionary *response))success failure:(void (^)(NSError *))failure {
    
    sApiPath = @"radio/getRadioClass";
    
    [self requestWithParam:nil responseClass:nil success:success failure:failure];
}

#pragma mark - 查看电台地区列表

+ (void)getRadioAreaWithAreaName:(NSString *)areaName success:(void (^)(NSDictionary *response))success failure:(void (^)(NSError *))failure {
    
    sApiPath = @"radio/getRadioArea";
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:areaName forKey:@"areaName"];
    [self requestWithParam:dic responseClass:nil success:success failure:failure];
}

#pragma mark - 广播状态详情

+ (void)getChannelStateWithChannelId:(int)channelId radioId:(int)radioId success:(void (^)(NSDictionary *))success failure:(void (^)(NSError *))failure {
    
    sApiPath = @"detail/getChannelState";
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    NSString * token = [[AccountManager shared] account].token;
    [dic setObject:token!=nil?token:@"" forKey:@"token"];
    [dic setValue:@(channelId) forKey:@"channelId"];
    [dic setValue:@(radioId) forKey:@"radioId"];
    [self requestWithParam:dic responseClass:nil success:success failure:failure];
}

#pragma mark - 聊吧状态详情

+ (void)getChatState:(int)chatId success:(void (^)(NSDictionary *))success failure:(void (^)(NSError *))failure {
    
    sApiPath = @"detail/getChatState";
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    NSString * token = [[AccountManager shared] account].token;
    [dic setObject:token!=nil?token:@"" forKey:@"token"];
    [dic setValue:@(chatId) forKey:@"chatId"];
    [self requestWithParam:dic responseClass:nil success:success failure:failure];
}

#pragma mark - 聊吧评论详情

+ (void)getChatComment:(ChatCommentParam *)chatParam success:(void (^)(NSDictionary *))success failure:(void (^)(NSError *))failure {
    
    sApiPath = @"detail/getChatComment";
    [self requestWithParam:chatParam responseClass:nil success:success failure:failure];
}

#pragma mark - 重要信息列表

+ (void)getTopComs:(TopComsParam *)chatParam success:(void (^)(NSDictionary *))success failure:(void (^)(NSError *))failure {
    
    sApiPath = @"chat/getTopComs";
    [self requestWithParam:chatParam responseClass:nil success:success failure:failure];
}

#pragma mark - 移除置顶聊吧评论

+ (void)delTopCom:(DelTopComParam *)chatParam success:(void (^)(NSDictionary *))success failure:(void (^)(NSError *))failure {
    
    sApiPath = @"chat/delTopCom";
    [self requestWithParam:chatParam responseClass:nil success:success failure:failure];
}

#pragma mark - 话题状态详情

+ (void)getTopicStateWithTopicId:(int)topicId success:(void (^)(NSDictionary *))success failure:(void (^)(NSError *))failure {
    
    sApiPath = @"detail/getTopicState";
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    NSString * token = [[AccountManager shared] account].token;
    [dic setObject:token!=nil?token:@"" forKey:@"token"];
    [dic setValue:@(topicId) forKey:@"topicId"];
    [self requestWithParam:dic responseClass:nil success:success failure:failure];
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
    [dic setValue:@"0" forKey:@"manager"];
    [self requestWithParam:dic responseClass:nil success:success failure:failure];
}

#pragma mark - 话题评论详情

+ (void)getTopicCommentWithPage:(int)page pageSize:(int)pageSize topicId:(int)topicId success:(void (^)(NSDictionary *))success failure:(void (^)(NSError *))failure {
    
    sApiPath = @"detail/getTopicComment";
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    NSString * token = [[AccountManager shared] account].token;
    [dic setObject:token!=nil?token:@"" forKey:@"token"];
    [dic setValue:@(page) forKey:@"page"];
    [dic setValue:@(pageSize) forKey:@"pagesize"];
    [dic setValue:@(topicId) forKey:@"topicId"];
    [dic setValue:@"0" forKey:@"manager"];
    [self requestWithParam:dic responseClass:nil success:success failure:failure];
}

#pragma mark - 评论回复详情

+ (void)getCommentReplyWithPage:(int)page pageSize:(int)pageSize parentCommentId:(int)parentCommentId parentUid:(int)parentUid success:(void (^)(NSDictionary *))success failure:(void (^)(NSError *))failure {
    
    sApiPath = @"detail/getCommentReply";
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    NSString * token = [[AccountManager shared] account].token;
    [dic setObject:token!=nil?token:@"" forKey:@"token"];
    [dic setValue:@(page) forKey:@"page"];
    [dic setValue:@(pageSize) forKey:@"pagesize"];
    [dic setValue:@(parentCommentId) forKey:@"parentCommentId"];
    [dic setValue:@(parentUid) forKey:@"parentUid"];
    [dic setObject:@"0" forKey:@"manager"];
    [self requestWithParam:dic responseClass:nil success:success failure:failure];
}

#pragma mark - 广播点赞

+ (void)goodActionForRadioWithChannelId:(int)channelId success:(void (^)(NSDictionary *))success failure:(void (^)(NSError *))failure {
    
    sApiPath = @"praise/praiseChannel";
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:@(channelId) forKey:@"channelId"];
    NSString * token = [[AccountManager shared] account].token;
    [dic setObject:token!=nil?token:@"" forKey:@"token"];
    [self requestWithParam:dic responseClass:nil success:success failure:failure];
}

#pragma mark - 话题点赞

+ (void)praiseTopicWithTopicId:(int)topicId success:(void (^)(NSDictionary *))success failure:(void (^)(NSError *))failure {
    
    sApiPath = @"praise/praiseTopic";
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:@(topicId) forKey:@"topicId"];
    NSString * token = [[AccountManager shared] account].token;
    [dic setObject:token!=nil?token:@"" forKey:@"token"];
    [self requestWithParam:dic responseClass:nil success:success failure:failure];
}

#pragma mark - 聊吧点赞

+ (void)praiseChatWithChatId:(int)chatId success:(void (^)(NSDictionary *))success failure:(void (^)(NSError *))failure {
    
    sApiPath = @"praise/praiseChat";
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:@(chatId) forKey:@"chatId"];
    NSString * token = [[AccountManager shared] account].token;
    [dic setObject:token!=nil?token:@"" forKey:@"token"];
    [self requestWithParam:dic responseClass:nil success:success failure:failure];
}


#pragma mark - 评论点赞

+ (void)praiseCommentWithCommentId:(int)commentId success:(void (^)(NSDictionary *))success failure:(void (^)(NSError *))failure {
    
    sApiPath = @"praise/praiseComment";
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:@(commentId) forKey:@"commentId"];
    NSString * token = [[AccountManager shared] account].token;
    [dic setObject:token!=nil?token:@"" forKey:@"token"];
    [self requestWithParam:dic responseClass:nil success:success failure:failure];
}

#pragma mark - 删除广播评论

+ (void)deleteChannelCommentWithChannelId:(int)channelId commentId:(int)commentId radioId:(int)radioId success:(void (^)(NSDictionary *))success failure:(void (^)(NSError *))failure {
    
    sApiPath = @"comment/delChannelComment";
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    NSString * token = [[AccountManager shared] account].token;
    [dic setObject:token!=nil?token:@"" forKey:@"token"];
    [dic setValue:@(channelId) forKey:@"channelId"];
    [dic setValue:@(commentId) forKey:@"commentId"];
    [dic setValue:@(radioId) forKey:@"radioId"];
    [self requestWithParam:dic responseClass:nil success:success failure:failure];
}

#pragma mark - 删除话题评论

+ (void)deleteTopicCommentWithTopicId:(int)topicId commentId:(int)commentId success:(void (^)(NSDictionary *))success failure:(void (^)(NSError *))failure {
    
    sApiPath = @"comment/delTopicComment";
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    NSString * token = [[AccountManager shared] account].token;
    [dic setObject:token!=nil?token:@"" forKey:@"token"];
    [dic setValue:@(topicId) forKey:@"topicId"];
    [dic setValue:@(commentId) forKey:@"commentId"];
    [self requestWithParam:dic responseClass:nil success:success failure:failure];
}

#pragma mark - 删除聊吧评论

+ (void)delChatCommentWithChatId:(int)chatId commentId:(int)commentId success:(void (^)(NSDictionary *))success failure:(void (^)(NSError *))failure {
    
    sApiPath = @"comment/delChatComment";
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    NSString * token = [[AccountManager shared] account].token;
    [dic setObject:token!=nil?token:@"" forKey:@"token"];
    [dic setValue:@(chatId) forKey:@"chatId"];
    [dic setValue:@(commentId) forKey:@"commentId"];
    [self requestWithParam:dic responseClass:nil success:success failure:failure];
}

#pragma mark - 播放电台

+ (void)lookRadioWithChannelId:(int)channelId radioId:(int)radioId success:(void (^)(NSDictionary *))success failure:(void (^)(NSError *))failure {
    
    sApiPath = @"look/lookRadio";
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    NSString * token = [[AccountManager shared] account].token;
    [dic setObject:token!=nil?token:@"" forKey:@"token"];
    [dic setValue:@(channelId) forKey:@"channelId"];
    [dic setValue:@(radioId) forKey:@"radioId"];
    [self requestWithParam:dic responseClass:nil success:success failure:failure];
}

#pragma mark - 播放话题

+ (void)lookTopicWithTopicId:(int)topicId success:(void (^)(NSDictionary *))success failure:(void (^)(NSError *))failure {
    
    sApiPath = @"look/lookTopic";
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    NSString * token = [[AccountManager shared] account].token;
    [dic setObject:token!=nil?token:@"" forKey:@"token"];
    [dic setValue:@(topicId) forKey:@"topicId"];
    [self requestWithParam:dic responseClass:nil success:success failure:failure];
}

#pragma mark - 播放聊吧

+ (void)lookChatWithChatId:(int)chatId success:(void (^)(NSDictionary *))success failure:(void (^)(NSError *))failure {
    
    sApiPath = @"look/lookChat";
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    NSString * token = [[AccountManager shared] account].token;
    [dic setObject:token!=nil?token:@"" forKey:@"token"];
    [dic setValue:@(chatId) forKey:@"chatId"];
    [self requestWithParam:dic responseClass:nil success:success failure:failure];
}

#pragma mark - 历史记录

+ (void)lookHistoryWithPage:(int)page pageSize:(int)pageSize success:(void (^)(NSDictionary *))success failure:(void (^)(NSError *))failure {
    
    sApiPath = @"detail/getLookHistory";
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    NSString * token = [[AccountManager shared] account].token;
    [dic setObject:token!=nil?token:@"" forKey:@"token"];
    [dic setValue:@(page) forKey:@"page"];
    [dic setValue:@(pageSize) forKey:@"pagesize"];
    [self requestWithParam:dic responseClass:nil success:success failure:failure];
}

#pragma mark - 播放历史删除

+ (void)delHistoryWithRtcIDs:(NSString *)rtcIds isAll:(int)isAll success:(void (^)(NSDictionary *))success failure:(void (^)(NSError *))failure {
    
    sApiPath = @"detail/delLookHistory";
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    NSString * token = [[AccountManager shared] account].token;
    [dic setObject:token!=nil?token:@"" forKey:@"token"];
    [dic setObject:rtcIds forKey:@"rtcIds"];
    [dic setObject:@(isAll) forKey:@"isAll"];
    [self requestWithParam:dic responseClass:nil success:success failure:failure];
}

#pragma mark - 我的收藏列表—》听说

+ (void)getMycollect:(int)page pageSize:(int)pageSize flag:(int)flag success:(void (^)(NSDictionary *))success failure:(void (^)(NSError *))failure {
    
    sApiPath = @"detail/getMycollect";
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    NSString * token = [[AccountManager shared] account].token;
    [dic setObject:token!=nil?token:@"" forKey:@"token"];
    [dic setValue:@(page) forKey:@"page"];
    [dic setValue:@(pageSize) forKey:@"pagesize"];
    [dic setValue:@(flag) forKey:@"flag"];
    [self requestWithParam:dic responseClass:nil success:success failure:failure];
}

#pragma mark - 置顶聊吧评论

+ (void)setTopCom:(TopComParam *)chatParam success:(void (^)(NSDictionary *))success failure:(void (^)(NSError *))failure {
    
    sApiPath = @"chat/setTopCom";
    [self requestWithParam:chatParam responseClass:nil success:success failure:failure];
}

#pragma mark - 查看路况聊吧ID

+ (void)getRoadChatWithCityCode:(NSString *)cityCode success:(void (^)(NSDictionary *))success failure:(void (^)(NSError *))failure {
 
    sApiPath = @"chat/getRoadChat";
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    NSString * token = [[AccountManager shared] account].token;
    [dic setObject:token!=nil?token:@"" forKey:@"token"];
    [dic setObject:cityCode forKey:@"city"];
    [self requestWithParam:dic responseClass:nil success:success failure:failure];
}

#pragma mark - 记录用户是否在后台

+ (void)recordUserIsOnline:(RecordUserIsOnlineParam *)param success:(void (^)(NSDictionary *))success failure:(void (^)(NSError *))failure {
    
    sApiPath = @"chat/recordUserIsOnline";
    
    [self requestWithParam:param responseClass:[BaseResponse class] success:success failure:failure];
}



@end

@implementation RadioDetailListParam
- (instancetype)init{
    self = [super init];
    if (self) {
        _page = 1;
        _pagesize = 10;
    }
    return self;
}
@end

@implementation RadioDetailListResponse

@end

@implementation ChatCommentParam
- (instancetype)init{
    self = [super init];
    if (self) {
        _page = 1;
        _pagesize = 10;
        _manager = @"chatManager";
    }
    return self;
}
@end

@implementation TopComsParam
- (instancetype)init{
    self = [super init];
    if (self) {
        _page = 1;
        _pagesize = 10;
    }
    return self;
}
@end


@implementation TopComParam
@end

@implementation DelTopComParam
@end

@implementation RecordUserIsOnlineParam

@end
