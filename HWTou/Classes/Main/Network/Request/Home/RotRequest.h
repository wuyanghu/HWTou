//
//  RotRequest.h
//  HWTou
//
//  Created by robinson on 2017/12/11.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "BaseRequest.h"
#import "BaseParam.h"
#import "BaseResponse.h"
#import "SessionRequest.h"

@interface GuessULikeParam:BaseParam
@property (nonatomic,assign) NSInteger page;
@end

@interface BannerListParam:BaseParam
@property (nonatomic,assign) NSInteger flag;//1:热门banner,2：话题banner，3:钱潮banner
@end

@interface SearchRtcDetailParam:BaseParam
@property (nonatomic,copy) NSString * searchText;// 搜索内容
@property (nonatomic,assign) NSInteger flag;// 1: 搜索广播， 2：搜索话题
@property (nonatomic,assign) NSInteger page;// 页码
@property (nonatomic,assign) NSInteger pagesize;// 每页显示条数
@end

@interface SearchUserParam:BaseParam
@property (nonatomic,copy) NSString * searchText;// 搜索内容
@property (nonatomic,assign) NSInteger page;// 页码
@property (nonatomic,assign) NSInteger pagesize;// 每页显示条数
@end

@interface HotRecChangeListParam:BaseParam
@property (nonatomic,assign) NSInteger recId;//推荐ID
@property (nonatomic,assign) NSInteger page;//页码点击换一批时，page从2开始分页，如果 page * pagesize>我传的总条数count，page再从1开始传`
@property (nonatomic,assign) NSInteger pagesize;//每页条数
@end

@interface TopComHistoriesParam:BaseParam
@property (nonatomic,assign) NSInteger page;//页码点击换一批时，page从2开始分页，如果 page * pagesize>我传的总条数count，page再从1开始传`
@property (nonatomic,assign) NSInteger pagesize;//每页条数
@property (nonatomic,assign) NSInteger chatId;//聊吧ID
@property (nonatomic,copy) NSString * idate;//时间按天搜索 ，传参格式20180102 yyyyMMdd
@end

//查看聊吧分类
@interface ChatByClassParam:BaseParam
@property (nonatomic,assign) NSInteger classId;//聊吧分类ID
@property (nonatomic,assign) NSInteger page;//页码点击换一批时，page从2开始分页，如果 page * pagesize>我传的总条数count，page再从1开始传`
@property (nonatomic,assign) NSInteger pagesize;//每页条数
@end

@interface GetChatInfoParam:BaseParam
@property (nonatomic,assign) NSInteger rtcId;
@end

@interface ChatOutUserParam:BaseParam
@property (nonatomic,copy) NSString * accId;//用户ID
@property (nonatomic,assign) NSInteger chatId;//聊吧ID
@end

@interface PullStreamParam:BaseParam
@property (nonatomic,assign) NSInteger uid;//主播ID
@property (nonatomic,assign) NSInteger rtcId;//聊吧ID
@property (nonatomic,assign) NSInteger flag;//1:开始推流，2：结束推流
@property (nonatomic,copy) NSString * cid;//频道ID
@end

@interface IsMicParam:BaseParam
@property (nonatomic,assign) NSInteger flag;//1：开始，2：退出
@property (nonatomic,assign) NSInteger roomId;//房间ID
@property (nonatomic,assign) NSInteger chatId;//聊吧ID
@property (nonatomic,assign) NSInteger anchorId;//主播ID
@end

@interface IsOpenMicParam:BaseParam
@property (nonatomic,assign) NSInteger flag;//1：开始，2：停止
@property (nonatomic,assign) NSInteger chatId;//int    聊吧ID
@end

@interface GetChatBmgParam:BaseParam
@property (nonatomic,assign) NSInteger flag;//1:背景音乐，2：特效音乐
@property (nonatomic,assign) NSInteger labelId;//聊吧背景音乐标签ID （后台管理系统不传）
@end

@interface GetChatRecordsParam:BaseParam
@property (nonatomic,assign) NSInteger anchorId;//主播ID 、 聊吧ID
@property (nonatomic,assign) NSInteger flag;//1：通过主播ID查看直播记录，2：通过聊吧ID查看直播记录
@property (nonatomic,assign) NSInteger page;//页码
@property (nonatomic,assign) NSInteger pagesize;//每页显示条数
@end

@interface SaveRoomInfoParam:BaseParam
@property (nonatomic,copy) NSString * roomName;//房间名
@property (nonatomic,assign) NSInteger acType;//直播模式，1：音频，2：视频
@property (nonatomic,assign) NSInteger rtcId;//聊吧ID
@end

@interface DictResponse:BaseResponse
@property (nonatomic,strong) NSDictionary * data;
@end

@interface ArrayResponse:BaseResponse
@property (nonatomic,strong) NSArray * data;
@end

@interface RotRequest : SessionRequest
//猜你喜欢列表
+ (void)guessULike:(GuessULikeParam *)param
           Success:(void (^)(ArrayResponse *response))success
           failure:(void (^) (NSError *error))failure;
//热门推荐列表
+ (void)getHotRecList:(BaseParam *)param
           Success:(void (^)(ArrayResponse *response))success
           failure:(void (^) (NSError *error))failure;
//热门最新推荐列表
+ (void)getHotNewRecList:(BaseParam *)param
                 Success:(void (^)(ArrayResponse *response))success
                 failure:(void (^) (NSError *error))failure;
//热门推荐换一批及更多
+ (void)getHotRecChangeList:(HotRecChangeListParam *)param
                 Success:(void (^)(DictResponse *response))success
                 failure:(void (^) (NSError *error))failure;
//banner列表
+ (void)getBannerList:(BannerListParam *)param
              Success:(void (^)(ArrayResponse *response))success
              failure:(void (^) (NSError *error))failure;
//广告页
+ (void)getAdvert:(BaseParam *)param
          Success:(void (^)(DictResponse *response))success
          failure:(void (^) (NSError *error))failure;
//搜索话题，广播
+ (void)searchRtcDetail:(SearchRtcDetailParam *)param
                Success:(void (^)(ArrayResponse *response))success
                failure:(void (^) (NSError *error))failure;
//搜索用户
+ (void)searchUser:(SearchUserParam *)param
           Success:(void (^)(ArrayResponse *response))success
           failure:(void (^) (NSError *error))failure;
//我的聊吧列表
+ (void)getMyChats:(void (^)(ArrayResponse *response))success
           failure:(void (^) (NSError *error))failure;
//查看聊吧分类
+ (void)getChatClasses:(BaseParam *)param
               Success:(void (^)(ArrayResponse *response))success
               failure:(void (^) (NSError *error))failure;
//通过聊吧分类查看聊吧列表
+ (void)getChatByClass:(ChatByClassParam *)param
               Success:(void (^)(ArrayResponse *response))success
               failure:(void (^) (NSError *error))failure;
//历史置顶列表
+ (void)getTopComHistories:(TopComHistoriesParam *)param
                   Success:(void (^)(ArrayResponse *response))success
                   failure:(void (^) (NSError *error))failure;

#pragma mark -  聊吧直播

//查看首页聊吧ID
+ (void)getHomeChatIDDetailWithSuccess:(void (^)(DictResponse *response))success
                               failure:(void (^) (NSError *error))failure;
//查看聊吧基本信息
+ (void)getChatInfo:(GetChatInfoParam *)param
            Success:(void (^)(DictResponse *response))success
            failure:(void (^) (NSError *error))failure;
//创建音视频房间
+ (void)saveRoomInfo:(SaveRoomInfoParam *)param
             Success:(void (^)(DictResponse *response))success
             failure:(void (^) (NSError *error))failure;
//获取音视频房间
+ (void)getRoomInfo:(GetChatInfoParam *)param
            Success:(void (^)(DictResponse *response))success
            failure:(void (^) (NSError *error))failure;
//我的聊吧列表新
+ (void)getMyChatsT:(void (^)(ArrayResponse *response))success
            failure:(void (^) (NSError *error))failure;
//管理聊吧列表
+ (void)getAdminChats:(void (^)(ArrayResponse *response))success
              failure:(void (^) (NSError *error))failure;
//开始结束推流
+ (void)pullStream:(PullStreamParam *)param Success:(void (^)(ArrayResponse *response))success
           failure:(void (^) (NSError *error))failure;
//开始退出连麦
+ (void)isMic:(IsMicParam *)param Success:(void (^)(ArrayResponse *response))success
      failure:(void (^) (NSError *error))failure;
//开始退出连麦主播
+ (void)isOpenMic:(IsOpenMicParam *)param Success:(void (^)(DictResponse *response))success failure:(void (^) (NSError *error))failure;
//查看聊吧背景音乐标签
+ (void)getChatLabels:(void (^)(ArrayResponse *response))success
              failure:(void (^) (NSError *error))failure;
//获取聊吧背景音乐和特效音
+ (void)getChatBmg:(GetChatBmgParam *)param Success:(void (^)(ArrayResponse *response))success failure:(void (^) (NSError *error))failure;
//踢出房间
+ (void)getChatOutUser:(ChatOutUserParam *)param
               Success:(void (^)(DictResponse *response))success
               failure:(void (^) (NSError *error))failure;
//直播记录及详情
+ (void)getChatRecords:(GetChatRecordsParam *)param Success:(void (^)(ArrayResponse *response))success failure:(void (^) (NSError *error))failure;
//获取聊吧背景音乐无主播
+ (void)getChatMusicList:(NSInteger)rtcId Success:(void (^)(ArrayResponse *response))success failure:(void (^) (NSError *error))failure;
@end
