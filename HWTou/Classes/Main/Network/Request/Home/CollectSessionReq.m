//
//  CollectRequest.m
//  HWTou
//
//  Created by robinson on 2017/11/27.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "CollectSessionReq.h"

@implementation CollectSessionReq

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
//收藏广播
+ (void)getCollectChannel:(CollectChannelParam *)param
                  Success:(void (^)(CollectChannelResponse *response))success
                  failure:(void (^) (NSError *error))failure{
    sApiPath = @"collect/collectChannel";
    [super requestWithParam:param responseClass:[CollectChannelResponse class] success:success failure:failure];
}
//收藏话题
+ (void)collectTopic:(CollectTopicParam *)param
                  Success:(void (^)(CollectChannelResponse *response))success
                  failure:(void (^) (NSError *error))failure{
    sApiPath = @"collect/collectTopic";
    [super requestWithParam:param responseClass:[CollectChannelResponse class] success:success failure:failure];
}

//收藏聊吧
+ (void)collectChat:(CollectChatParam *)param
             Success:(void (^)(CollectChannelResponse *response))success
             failure:(void (^) (NSError *error))failure{
    sApiPath = @"collect/collectChat";
    [super requestWithParam:param responseClass:[CollectChannelResponse class] success:success failure:failure];
}

//获取话题工作台状态
+ (void) getTopicWorkDetail:(BaseParam *)param
                   Success:(void (^)(TopicWorkDetailResponse *response))success
                   failure:(void (^) (NSError *error))failure{
    sApiPath = @"work/getTopicWorkDetail";
    [super requestWithParam:param responseClass:[CollectChannelResponse class] success:success failure:failure];
}

//我的话题列表
+ (void)getMyTopicList:(HotTopicListParam *)param
                   Success:(void (^)(MyTopicListResponse *response))success
                   failure:(void (^) (NSError *error))failure{
    sApiPath = @"topic/getMyTopicList";
    [super requestWithParam:param responseClass:[MyTopicListResponse class] success:success failure:failure];
}

//删除话题
+ (void)delTopic:(DelTopicParam *)param
         Success:(void (^)(BaseResponse *response))success
         failure:(void (^) (NSError *error))failure{
    sApiPath = @"topic/delTopic";
    [super requestWithParam:param responseClass:[BaseResponse class] success:success failure:failure];
}
//热门话题列表
+ (void)getHotTopicList:(HotTopicListParam *)param
                Success:(void (^)(MyTopicListResponse *response))success
                failure:(void (^) (NSError *error))failure{
    sApiPath = @"topic/getHotTopicList";
    [super requestWithParam:param responseClass:[MyTopicListResponse class] success:success failure:failure];
}
//话题标签列表
+ (void)topicLabelList:(BaseParam *)param
               Success:(void (^)(MyTopicListResponse *response))success
               failure:(void (^) (NSError *error))failure{
    sApiPath = @"topic/topicLabelList";
    [super requestWithParam:param responseClass:[MyTopicListResponse class] success:success failure:failure];
}

//钱潮推荐列表
+ (void)getMCRecList:(BaseParam *)param
               Success:(void (^)(MyTopicListResponse *response))success
               failure:(void (^) (NSError *error))failure{
    sApiPath = @"moneyCome/getMCRecList";
    [super requestWithParam:param responseClass:[MyTopicListResponse class] success:success failure:failure];
}

//查看钱潮聊吧ID
+ (void)getMoneyComChat:(BaseParam *)param
             Success:(void (^)(MoneyComChatResponse *response))success
             failure:(void (^) (NSError *error))failure{
    sApiPath = @"chat/getMoneyComChat";
    [super requestWithParam:param responseClass:[MoneyComChatResponse class] success:success failure:failure];
}

//今日优选列表
+ (void)getTodayTopicList:(LabelTopicListParam *)param
                  Success:(void (^)(MyTopicListResponse *response))success
                  failure:(void (^) (NSError *error))failure{
    sApiPath = @"topic/getTodayTopicList";
    [super requestWithParam:param responseClass:[MyTopicListResponse class] success:success failure:failure];
}

//根据标签查询话题列表
+ (void)getLabelTopicList:(LabelTopicListParam *)param
                  Success:(void (^)(MyTopicListResponse *response))success
                  failure:(void (^) (NSError *error))failure{
    sApiPath = @"topic/getLabelTopicList";
    [super requestWithParam:param responseClass:[MyTopicListResponse class] success:success failure:failure];
}

//用户动态
+ (void)userDetail:(MarkDetailParam *)param
           Success:(void (^)(MyTopicListResponse *response))success
           failure:(void (^) (NSError *error))failure{
    sApiPath = @"detail/getMarkDetail";
    [super requestWithParam:param responseClass:[MyTopicListResponse class] success:success failure:failure];
}

//话题点赞
//+ (void)praiseTopic:(HotTopicListParam *)param
//           Success:(void (^)(BaseResponse *response))success
//           failure:(void (^) (NSError *error))failure{
//    sApiPath = @"praise/praiseTopic";
//    [super requestWithParam:param responseClass:[BaseResponse class] success:success failure:failure];
//}

//话题评论详情
//+ (void)getTopicComment:(TopicCommentParam *)param
//            Success:(void (^)(MyTopicListResponse *response))success
//            failure:(void (^) (NSError *error))failure{
//    sApiPath = @"detail/getTopicComment";
//    [super requestWithParam:param responseClass:[MyTopicListResponse class] success:success failure:failure];
//}



@end

@implementation CollectChannelParam
- (instancetype)init{
    self = [super init];
    if (self) {
        _radioId = 0;
    }
    return self;
}
@end

@implementation CollectChannelResponse
@end

@implementation TopicWorkDetailResponse
@end

@implementation HotTopicListParam
- (instancetype)init{
    self = [super init];
    if (self) {
        _page = 1;
        _pagesize = 10;
    }
    return self;
}
@end

@implementation MyTopicListResponse
@end

@implementation DelTopicParam
@end

@implementation TopicCommentParam
- (instancetype)init{
    self = [super init];
    if (self) {
        _page = 1;
        _pagesize = 10;
    }
    return self;
}
@end

@implementation MarkDetailParam
- (instancetype)init{
    self = [super init];
    if (self) {
        _page = 1;
        _pagesize = 10;
    }
    return self;
}
@end

@implementation LabelTopicListParam
- (instancetype)init{
    self = [super init];
    if (self) {
        _page = 1;
        _pagesize = 10;
    }
    return self;
}
@end

@implementation CollectTopicParam
@end

@implementation CollectChatParam
@end

@implementation MoneyComChatResponse
@end
