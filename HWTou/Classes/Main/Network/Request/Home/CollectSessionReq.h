//
//  CollectRequest.h
//  HWTou
//
//  Created by robinson on 2017/11/27.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "SessionRequest.h"
#import "BaseParam.h"
#import "BaseResponse.h"

#pragma mark - 请求
//收藏广播
@interface CollectChannelParam:BaseParam
@property (nonatomic,assign) NSInteger channelId;
@property (nonatomic,assign) NSInteger radioId;
@end
//收藏话题
@interface CollectTopicParam:BaseParam
@property (nonatomic,assign) NSInteger topicId;//话题ID
@end
//收藏聊吧
@interface CollectChatParam:BaseParam
@property (nonatomic,assign) NSInteger chatId;//聊吧ID
@end

@interface HotTopicListParam:BaseParam
@property (nonatomic,assign) NSInteger page;
@property (nonatomic,assign) NSInteger pagesize;
@end
//根据标签查询话题列表
@interface LabelTopicListParam:BaseParam
@property (nonatomic,assign) NSInteger page;
@property (nonatomic,assign) NSInteger pagesize;

@property (nonatomic,assign) NSInteger labelId;//标签ID
@end

//用户动态
@interface MarkDetailParam:BaseParam
@property (nonatomic,assign) NSInteger page;
@property (nonatomic,assign) NSInteger pagesize;
@property (nonatomic,assign) NSInteger targetId;//查看用户ID，查看自己动态传0
@end
//话题评论详情
@interface TopicCommentParam:BaseParam
@property (nonatomic,assign) NSInteger page;
@property (nonatomic,assign) NSInteger pagesize;
@property (nonatomic,assign) NSInteger topicId;//话题ID
@property (nonatomic,copy)  NSString * manager;//判断工作台身份（如果是达人管理员工作台进入 传topicManager，否则传0, 后台管理前端调此接口传manager
@end

@interface DelTopicParam:BaseParam
@property (nonatomic,assign) NSInteger topicId;
@end

#pragma mark - 响应
@interface CollectChannelResponse:BaseResponse
@property (nonatomic,strong) NSDictionary * data;
@end

@interface TopicWorkDetailResponse:BaseResponse
@property (nonatomic,strong) NSDictionary * data;
@end

@interface MyTopicListResponse:BaseResponse
@property (nonatomic,strong) NSArray * data;
@end

@interface MoneyComChatResponse:BaseResponse
@property (nonatomic,copy) NSString * data;
@end

@interface CollectSessionReq : SessionRequest
//收藏广播
+ (void)getCollectChannel:(CollectChannelParam *)param
                  Success:(void (^)(CollectChannelResponse *response))success
                  failure:(void (^) (NSError *error))failure;
//收藏话题
+ (void)collectTopic:(CollectTopicParam *)param
             Success:(void (^)(CollectChannelResponse *response))success
             failure:(void (^) (NSError *error))failure;
//收藏聊吧
+ (void)collectChat:(CollectChatParam *)param
            Success:(void (^)(CollectChannelResponse *response))success
            failure:(void (^) (NSError *error))failure;
//获取话题工作台状态
+ (void)getTopicWorkDetail:(BaseParam *)param
                   Success:(void (^)(TopicWorkDetailResponse *response))success
                   failure:(void (^) (NSError *error))failure;
//热门话题列表
+ (void)getHotTopicList:(HotTopicListParam *)param
                   Success:(void (^)(MyTopicListResponse *response))success
                   failure:(void (^) (NSError *error))failure;
//我的话题列表
+ (void)getMyTopicList:(HotTopicListParam *)param
               Success:(void (^)(MyTopicListResponse *response))success
               failure:(void (^) (NSError *error))failure;
//删除话题
+ (void)delTopic:(DelTopicParam *)param
         Success:(void (^)(BaseResponse *response))success
         failure:(void (^) (NSError *error))failure;

//话题标签列表
+ (void)topicLabelList:(BaseParam *)param
               Success:(void (^)(MyTopicListResponse *response))success
               failure:(void (^) (NSError *error))failure;
//今日优选列表
+ (void)getTodayTopicList:(LabelTopicListParam *)param
               Success:(void (^)(MyTopicListResponse *response))success
               failure:(void (^) (NSError *error))failure;
//根据标签查询话题列表
+ (void)getLabelTopicList:(LabelTopicListParam *)param
                  Success:(void (^)(MyTopicListResponse *response))success
                  failure:(void (^) (NSError *error))failure;
//用户动态
+ (void)userDetail:(MarkDetailParam *)param
           Success:(void (^)(MyTopicListResponse *response))success
           failure:(void (^) (NSError *error))failure;
//钱潮推荐列表
+ (void)getMCRecList:(BaseParam *)param
             Success:(void (^)(MyTopicListResponse *response))success
             failure:(void (^) (NSError *error))failure;
//查看钱潮聊吧ID
+ (void)getMoneyComChat:(BaseParam *)param
                Success:(void (^)(MoneyComChatResponse *response))success
                failure:(void (^) (NSError *error))failure;
////话题点赞
//+ (void)praiseTopic:(HotTopicListParam *)param
//            Success:(void (^)(BaseResponse *response))success
//            failure:(void (^) (NSError *error))failure;
@end

