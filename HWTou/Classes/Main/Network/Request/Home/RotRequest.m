//
//  RotRequest.m
//  HWTou
//
//  Created by robinson on 2017/12/11.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "RotRequest.h"
#import "AccountManager.h"

@implementation GuessULikeParam
@end

@implementation BannerListParam
@end

@implementation HotRecChangeListParam
@end

@implementation GetChatInfoParam

@end

@implementation SaveRoomInfoParam

@end

@implementation DictResponse
@end

@implementation ArrayResponse
@end

@implementation SearchRtcDetailParam
- (instancetype)init{
    self = [super init];
    if (self) {
        _page = 1;
        _pagesize = 10;
    }
    return self;
}
@end

@implementation ChatByClassParam
- (instancetype)init{
    self = [super init];
    if (self) {
        _page = 1;
        _pagesize = 10;
    }
    return self;
}
@end

@implementation TopComHistoriesParam
- (instancetype)init{
    self = [super init];
    if (self) {
        _page = 1;
        _pagesize = 10;
    }
    return self;
}
@end

@implementation SearchUserParam
- (instancetype)init{
    self = [super init];
    if (self) {
        _page = 1;
        _pagesize = 10;
    }
    return self;
}
@end

@implementation PullStreamParam

@end

@implementation RotRequest
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

//猜你喜欢列表
+ (void)guessULike:(GuessULikeParam *)param
                  Success:(void (^)(ArrayResponse *response))success
                  failure:(void (^) (NSError *error))failure{
    sApiPath = @"hot/guessULike";
    [super requestWithParam:param responseClass:[ArrayResponse class] success:success failure:failure];
}

//热门推荐列表
+ (void)getHotRecList:(BaseParam *)param
              Success:(void (^)(ArrayResponse *response))success
              failure:(void (^) (NSError *error))failure{
    sApiPath = @"hot/getHotRecList";
    [super requestWithParam:param responseClass:[ArrayResponse class] success:success failure:failure];
}

//热门最新推荐列表
+ (void)getHotNewRecList:(BaseParam *)param
              Success:(void (^)(ArrayResponse *response))success
              failure:(void (^) (NSError *error))failure{
    sApiPath = @"hot/getHotNewRecList";
    [super requestWithParam:param responseClass:[ArrayResponse class] success:success failure:failure];
}

//热门推荐换一批及更多
+ (void)getHotRecChangeList:(HotRecChangeListParam *)param
                    Success:(void (^)(DictResponse *response))success
                    failure:(void (^) (NSError *error))failure{
    sApiPath = @"hot/getHotRecChangeList";
    [super requestWithParam:param responseClass:[DictResponse class] success:success failure:failure];
}
//banner列表
+ (void)getBannerList:(BannerListParam *)param
                    Success:(void (^)(ArrayResponse *response))success
                    failure:(void (^) (NSError *error))failure{
    sApiPath = @"banner/getBannerList";
    [super requestWithParam:param responseClass:[ArrayResponse class] success:success failure:failure];
}

//广告页
+ (void)getAdvert:(BaseParam *)param
              Success:(void (^)(DictResponse *response))success
              failure:(void (^) (NSError *error))failure{
    sApiPath = @"banner/getAdvert";
    [super requestWithParam:param responseClass:[DictResponse class] success:success failure:failure];
}

//搜索话题，广播
+ (void)searchRtcDetail:(SearchRtcDetailParam *)param
              Success:(void (^)(ArrayResponse *response))success
              failure:(void (^) (NSError *error))failure{
    sApiPath = @"search/searchRtcDetail";
    [super requestWithParam:param responseClass:[ArrayResponse class] success:success failure:failure];
}

//搜索用户
+ (void)searchUser:(SearchUserParam *)param
                Success:(void (^)(ArrayResponse *response))success
                failure:(void (^) (NSError *error))failure{
    sApiPath = @"search/searchUser";
    [super requestWithParam:param responseClass:[ArrayResponse class] success:success failure:failure];
}

//我的聊吧列表
+ (void)getMyChats:(void (^)(ArrayResponse *response))success
                    failure:(void (^) (NSError *error))failure{
    sApiPath = @"chat/getMyChats";
    [super requestWithParam:[BaseParam new] responseClass:[ArrayResponse class] success:success failure:failure];
}

//查看聊吧分类
+ (void)getChatClasses:(BaseParam *)param
           Success:(void (^)(ArrayResponse *response))success
           failure:(void (^) (NSError *error))failure{
    sApiPath = @"chat/getChatClasses";
    [super requestWithParam:param responseClass:[ArrayResponse class] success:success failure:failure];
}

//通过聊吧分类查看聊吧列表
+ (void)getChatByClass:(ChatByClassParam *)param
               Success:(void (^)(ArrayResponse *response))success
               failure:(void (^) (NSError *error))failure{
    sApiPath = @"chat/getChatByClass";
    [super requestWithParam:param responseClass:[ArrayResponse class] success:success failure:failure];
}

//历史置顶列表
+ (void)getTopComHistories:(TopComHistoriesParam *)param
           Success:(void (^)(ArrayResponse *response))success
           failure:(void (^) (NSError *error))failure{
    sApiPath = @"chat/getTopComHistories";
    [super requestWithParam:param responseClass:[ArrayResponse class] success:success failure:failure];
}


#pragma mark - 聊吧直播接口

//查看首页聊吧ID
+ (void)getHomeChatIDDetailWithSuccess:(void (^)(DictResponse *))success failure:(void (^)(NSError *))failure {
    sApiPath = @"/chat/getChatID";
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    NSString * token = [[AccountManager shared] account].token;
    [dic setObject:token!=nil?token:@"" forKey:@"token"];
    [self requestWithParam:dic responseClass:[DictResponse class] success:success failure:failure];
}

//查看聊吧基本信息
+ (void)getChatInfo:(GetChatInfoParam *)param
                   Success:(void (^)(DictResponse *response))success
                   failure:(void (^) (NSError *error))failure{
    sApiPath = @"chat/getChatInfoT";
    [super requestWithParam:param responseClass:[DictResponse class] success:success failure:failure];
}

//踢出房间
+ (void)getChatOutUser:(ChatOutUserParam *)param
            Success:(void (^)(DictResponse *response))success
            failure:(void (^) (NSError *error))failure{
    sApiPath = @"chat/chatOutUser";
    [super requestWithParam:param responseClass:[DictResponse class] success:success failure:failure];
}

//创建音视频房间
+ (void)saveRoomInfo:(SaveRoomInfoParam *)param
            Success:(void (^)(DictResponse *response))success
            failure:(void (^) (NSError *error))failure{
    sApiPath = @"chat/saveRoomInfo";
    [super requestWithParam:param responseClass:[DictResponse class] success:success failure:failure];
}
//获取音视频房间
+ (void)getRoomInfo:(GetChatInfoParam *)param
             Success:(void (^)(DictResponse *response))success
             failure:(void (^) (NSError *error))failure{
    sApiPath = @"chat/getRoomInfo";
    [super requestWithParam:param responseClass:[DictResponse class] success:success failure:failure];
}

//我的聊吧列表新
+ (void)getMyChatsT:(void (^)(ArrayResponse *response))success
            failure:(void (^) (NSError *error))failure{
    sApiPath = @"chat/getMyChatsT";
    [super requestWithParam:[BaseParam new] responseClass:[ArrayResponse class] success:success failure:failure];
}
//管理聊吧列表
+ (void)getAdminChats:(void (^)(ArrayResponse *response))success
            failure:(void (^) (NSError *error))failure{
    sApiPath = @"chat/getAdminChats";
    [super requestWithParam:[BaseParam new] responseClass:[ArrayResponse class] success:success failure:failure];
}

//开始结束推流
+ (void)pullStream:(PullStreamParam *)param Success:(void (^)(ArrayResponse *response))success
            failure:(void (^) (NSError *error))failure{
    sApiPath = @"chat/pullStream";
    [super requestWithParam:param responseClass:[ArrayResponse class] success:success failure:failure];
}

//开始退出连麦
+ (void)isMic:(IsMicParam *)param Success:(void (^)(ArrayResponse *response))success
           failure:(void (^) (NSError *error))failure{
    sApiPath = @"chat/isMic";
    [super requestWithParam:param responseClass:[ArrayResponse class] success:success failure:failure];
}

//开始退出连麦主播
+ (void)isOpenMic:(IsOpenMicParam *)param Success:(void (^)(DictResponse *response))success
      failure:(void (^) (NSError *error))failure{
    sApiPath = @"chat/isOpenMic";
    [super requestWithParam:param responseClass:[DictResponse class] success:success failure:failure];
}

//查看聊吧背景音乐标签
+ (void)getChatLabels:(void (^)(ArrayResponse *response))success
      failure:(void (^) (NSError *error))failure{
    sApiPath = @"chat/getChatLabels";
    [super requestWithParam:nil responseClass:[ArrayResponse class] success:success failure:failure];
}
//获取聊吧背景音乐和特效音
+ (void)getChatBmg:(GetChatBmgParam *)param Success:(void (^)(ArrayResponse *response))success failure:(void (^) (NSError *error))failure{
    sApiPath = @"chat/getChatBmg";
    [super requestWithParam:param responseClass:[ArrayResponse class] success:success failure:failure];
}

//直播记录及详情
+ (void)getChatRecords:(GetChatRecordsParam *)param Success:(void (^)(ArrayResponse *response))success failure:(void (^) (NSError *error))failure{
    sApiPath = @"chat/getChatRecords";
    [super requestWithParam:param responseClass:[ArrayResponse class] success:success failure:failure];
}

//获取聊吧背景音乐无主播
+ (void)getChatMusicList:(NSInteger)rtcId Success:(void (^)(ArrayResponse *response))success failure:(void (^) (NSError *error))failure{
    sApiPath = @"chat/getChatMusicList";
    [super requestWithParam:@{@"rtcId":@(rtcId)} responseClass:[ArrayResponse class] success:success failure:failure];
}

@end

@implementation IsMicParam

- (instancetype)init{
    self = [super init];
    if (self) {

    }
    return self;
}

@end

@implementation GetChatBmgParam

@end

@implementation IsOpenMicParam

@end

@implementation ChatOutUserParam

@end

@implementation GetChatRecordsParam

@end
