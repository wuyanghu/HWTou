//
//  RadioRequest.h
//  HWTou
//
//  Created by Reyna on 2017/11/23.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "BaseRequest.h"
#import "BaseResponse.h"
#import "BaseParam.h"
#import "SessionRequest.h"

@interface RadioDetailListParam:BaseParam
@property (nonatomic,assign) NSInteger channelId;
@property (nonatomic,assign) NSInteger page;
@property (nonatomic,assign) NSInteger pagesize;
@property (nonatomic,assign) NSInteger flag;
@end

//聊吧详情
@interface ChatCommentParam:BaseParam
@property (nonatomic,assign) NSInteger page;
@property (nonatomic,assign) NSInteger pagesize;
@property (nonatomic,assign) NSInteger chatId;//聊吧ID
@property (nonatomic,copy) NSString * manager;//判断工作台身份（如果是聊吧管理员工作台进入 传chatManager，否则传0, 后台管理前端调此接口传manager

@end

//重要信息列表
@interface TopComsParam:BaseParam
@property (nonatomic,assign) NSInteger page;
@property (nonatomic,assign) NSInteger pagesize;
@property (nonatomic,assign) NSInteger chatId;//聊吧ID
@end

//移除置顶聊吧评论
@interface DelTopComParam:BaseParam
@property (nonatomic,assign) NSInteger comId;//评论ID
@end

//置顶聊吧评论
@interface TopComParam:BaseParam
@property (nonatomic,assign) NSInteger chatId;//聊吧ID
@property (nonatomic,assign) NSInteger comId;//评论ID
@property (nonatomic,assign) NSInteger comUid;//评论的用户ID

@end

//记录用户是否在后台
@interface RecordUserIsOnlineParam:BaseParam

@property (nonatomic,copy) NSString * userPhone;//用户手机号
@property (nonatomic,assign) NSInteger chatId;//聊吧ID
@property (nonatomic,assign) NSInteger flag;//标记：0：用户进入APP，1：用户退出APP

@end

@interface RadioDetailListResponse:BaseResponse
@property (nonatomic,strong) NSArray * data;
@end

@interface RadioRequest : SessionRequest

/*
 * 查看签约电台
 */
+ (void)getRadioSignWithSuccess:(void (^)(NSDictionary *response))success failure:(void (^) (NSError *error))failure;

/*
 * 查询电台节目单列表详情
 */
+ (void)getRadioDetailListWithParam:(RadioDetailListParam *)param success:(void (^)(RadioDetailListResponse *response))success failure:(void (^) (NSError *error))failure;
 
/*
 * 查看广播频道列表
 */
+ (void)getRadioDetailWithPage:(int)page pageSize:(int)pageSize targetId:(int)targetId success:(void (^)(NSDictionary *response))success failure:(void (^) (NSError *error))failure;

/*
 * 查看广播频道排行榜
 */
+ (void)getRadioDetailTopWithSuccess:(void (^)(NSDictionary *response))success failure:(void (^) (NSError *error))failure;

/*
 * 查询电台分类列表
 */
+ (void)getRadioClassWithSuccess:(void (^)(NSDictionary *response))success failure:(void (^) (NSError *error))failure;

/*
 * 查询电台地区列表
 */
+ (void)getRadioAreaWithAreaName:(NSString *)areaName success:(void (^)(NSDictionary *response))success failure:(void (^) (NSError *error))failure;

/*
 * 广播状态详情
 */
+ (void)getChannelStateWithChannelId:(int)channelId radioId:(int)radioId success:(void (^)(NSDictionary *response))success failure:(void (^) (NSError *error))failure;

/*
 * 话题状态详情
 */
+ (void)getTopicStateWithTopicId:(int)topicId success:(void (^)(NSDictionary *response))success failure:(void (^) (NSError *error))failure;

// 聊吧状态详情

+ (void)getChatComment:(ChatCommentParam *)chatParam success:(void (^)(NSDictionary *))success failure:(void (^)(NSError *))failure ;

//聊吧状态详情

+ (void)getChatState:(int)chatId success:(void (^)(NSDictionary *))success failure:(void (^)(NSError *))failure;

/*
 * 广播评论详情
 */
+ (void)getChannelCommentWithPage:(int)page pageSize:(int)pageSize channelId:(int)channelId radioId:(int)radioId success:(void (^)(NSDictionary *response))success failure:(void (^) (NSError *error))failure;

/*
 * 话题评论详情
 */
+ (void)getTopicCommentWithPage:(int)page pageSize:(int)pageSize topicId:(int)topicId success:(void (^)(NSDictionary *response))success failure:(void (^) (NSError *error))failure;

/*
 * 评论回复详情
 */
+ (void)getCommentReplyWithPage:(int)page pageSize:(int)pageSize parentCommentId:(int)parentCommentId parentUid:(int)parentUid success:(void (^)(NSDictionary *response))success failure:(void (^) (NSError *error))failure;

/*
 * 广播点赞
 */
+ (void)goodActionForRadioWithChannelId:(int)channelId success:(void (^)(NSDictionary *response))success failure:(void (^) (NSError *error))failure;

/*
 * 话题点赞
 */
+ (void)praiseTopicWithTopicId:(int)topicId success:(void (^)(NSDictionary *response))success failure:(void (^) (NSError *error))failure;

// 聊吧点赞
+ (void)praiseChatWithChatId:(int)chatId success:(void (^)(NSDictionary *))success failure:(void (^)(NSError *))failure;
/*
 * 评论点赞
 */
+ (void)praiseCommentWithCommentId:(int)commentId success:(void (^)(NSDictionary *response))success failure:(void (^) (NSError *error))failure;

/*
 * 删除广播评论
 */
+ (void)deleteChannelCommentWithChannelId:(int)channelId commentId:(int)commentId radioId:(int)radioId success:(void (^)(NSDictionary *))success failure:(void (^)(NSError *))failure;

/*
 * 删除话题评论
 */
+ (void)deleteTopicCommentWithTopicId:(int)topicId commentId:(int)commentId success:(void (^)(NSDictionary *))success failure:(void (^)(NSError *))failure;

//删除聊吧评论
+ (void)delChatCommentWithChatId:(int)chatId commentId:(int)commentId success:(void (^)(NSDictionary *))success failure:(void (^)(NSError *))failure;
/*
 * 播放电台
 */
+ (void)lookRadioWithChannelId:(int)channelId radioId:(int)radioId success:(void (^)(NSDictionary *response))success failure:(void (^) (NSError *error))failure;

/*
 * 播放话题
 */
+ (void)lookTopicWithTopicId:(int)topicId success:(void (^)(NSDictionary *response))success failure:(void (^) (NSError *error))failure;

// 播放聊吧
+ (void)lookChatWithChatId:(int)chatId success:(void (^)(NSDictionary *))success failure:(void (^)(NSError *))failure;
/*
 * 播放历史记录
 */
+ (void)lookHistoryWithPage:(int)page pageSize:(int)pageSize success:(void (^)(NSDictionary *response))success failure:(void (^) (NSError *error))failure;

/*
 * 播放历史删除
 */
+ (void)delHistoryWithRtcIDs:(NSString *)rtcIds isAll:(int)isAll success:(void (^)(NSDictionary *response))success failure:(void (^) (NSError *error))failure;

//我的收藏列表—》听说
+ (void)getMycollect:(int)page pageSize:(int)pageSize flag:(int)flag success:(void (^)(NSDictionary *))success failure:(void (^)(NSError *))failure;

//置顶聊吧评论
+ (void)setTopCom:(TopComParam *)chatParam success:(void (^)(NSDictionary *))success failure:(void (^)(NSError *))failure;

// 重要信息列表
+ (void)getTopComs:(TopComsParam *)chatParam success:(void (^)(NSDictionary *))success failure:(void (^)(NSError *))failure;

//移除置顶聊吧评论
+ (void)delTopCom:(DelTopComParam *)chatParam success:(void (^)(NSDictionary *))success failure:(void (^)(NSError *))failure;

/*
 * 查看路况聊吧ID
 */
+ (void)getRoadChatWithCityCode:(NSString *)cityCode success:(void (^)(NSDictionary *))success failure:(void (^)(NSError *))failure;
//记录用户是否在后台
+ (void)recordUserIsOnline:(RecordUserIsOnlineParam *)param success:(void (^)(NSDictionary *))success failure:(void (^)(NSError *))failure;
@end
