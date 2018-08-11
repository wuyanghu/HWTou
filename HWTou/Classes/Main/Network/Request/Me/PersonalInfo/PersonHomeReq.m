//
//  PersonHomeReq.m
//  HWTou
//
//  Created by robinson on 2017/11/20.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "PersonHomeReq.h"
#import "AccountManager.h"

static NSString *sApiPath = nil;

@implementation PersonHomeParam
- (instancetype)init{
    self = [super init];
    if (self) {
        _page = 1;
        _pagesize = 10;
    }
    return self;
}
@end

@implementation InviteListParam
- (instancetype)init{
    self = [super init];
    if (self) {
        _page = 1;
        _pagesize = 10;
    }
    return self;
}
@end


@implementation UserInfoParam
@end

@implementation FocusSomeOneParam
@end

@implementation CheckNicknameParam

@end

@implementation PersonHomeResponse

@end

@implementation CityInfoResponse

@end

@implementation SaveUserDataParam

@end

@implementation LookCheckStatusPram
@end

@implementation LookCheckStatusResponse
@end

@implementation UpdateUserLifeValueParam
- (instancetype)init{
    self = [super init];
    if (self) {
        _uid = [AccountManager shared].account.uid;
        _flag = 2;
        _remarkFlag = 3;
    }
    return self;
}
@end

@implementation PersonHomeRequest

+ (NSString *)requestServerHost {
    return kApiUserServerHost;
}

+ (NSString *)requestApiPath{
    return sApiPath;
}

//查看主播达人审核状态
+ (void)lookCheckStatus:(LookCheckStatusPram *)param
            Success:(void (^)(LookCheckStatusResponse *response))success
            failure:(void (^) (NSError *error))failure{
    sApiPath = @"userTopic/lookCheckStatus";
    [super requestWithParam:param responseClass:[LookCheckStatusResponse class] success:success failure:failure];
}

+ (void)getUserInfo:(UserInfoParam *)param
                  Success:(void (^)(PersonHomeResponse *response))success
                  failure:(void (^) (NSError *error))failure{
    sApiPath = @"userData/getUserInfo";
    [super requestWithParam:param responseClass:[PersonHomeResponse class] success:success failure:failure];
}

//获取我的邀请的人列表
+ (void)inviteList:(InviteListParam *)param
            Success:(void (^)(CityInfoResponse *response))success
            failure:(void (^) (NSError *error))failure{
    sApiPath = @"userData/inviteList";
    [super requestWithParam:param responseClass:[CityInfoResponse class] success:success failure:failure];
}

//邀请活动规则
+ (void)getInvActivity:(void (^)(LookCheckStatusResponse *response))success
           failure:(void (^) (NSError *error))failure{
    sApiPath = @"userData/getInvActivity";
    [super requestWithParam:nil responseClass:[LookCheckStatusResponse class] success:success failure:failure];
}

//获取关注,粉丝,屏蔽的人 列表
+ (void)focusAndFansAndShiledList:(PersonHomeParam *)param
                          Success:(void (^)(CityInfoResponse *response))success
                          failure:(void (^) (NSError *error))failure{
    sApiPath = @"userData/focusAndFansAndShiledList";
    [super requestWithParam:param responseClass:[CityInfoResponse class] success:success failure:failure];
}
//保存个人主页资料
+ (void)saveUserData:(SaveUserDataParam *)param
             Success:(void (^)(PersonHomeResponse *response))success
             failure:(void (^) (NSError *error))failure{
    sApiPath = @"userData/saveUserData";
    [super requestWithParam:param responseClass:[BaseResponse class] success:success failure:failure];
}

+ (void)checkNickname:(NSString *)nickName
              Success:(void (^)(BaseResponse *response))success
              failure:(void (^) (NSError *error))failure{
    CheckNicknameParam * nickNameParam = [CheckNicknameParam new];
    nickNameParam.nickName = nickName;
    sApiPath = @"userData/checkNickname";
    [super requestWithParam:nickNameParam responseClass:[BaseResponse class] success:success failure:failure];
}
//话题banner
+ (void)topicBannerList:(BaseParam *)param
             Success:(void (^)(MyTopicListResponse *response))success
             failure:(void (^) (NSError *error))failure{
    sApiPath = @"banner/topicBannerList";
    [super requestWithParam:param responseClass:[MyTopicListResponse class] success:success failure:failure];
}
//是否关注某人
+ (void)focusSomeOne:(FocusSomeOneParam *)param
                Success:(void (^)(TopicWorkDetailResponse *response))success
                failure:(void (^) (NSError *error))failure{
    sApiPath = @"userData/focusSomeOne";
    [super requestWithParam:param responseClass:[TopicWorkDetailResponse class] success:success failure:failure];
}

//生命值记录
+ (void)updateUserLifeValue:(UpdateUserLifeValueParam *)param
             Success:(void (^)(BaseResponse *response))success
             failure:(void (^) (NSError *error))failure{
    sApiPath = @"userData/updateUserLifeValue";
    [super requestWithParam:param responseClass:[BaseResponse class] success:success failure:failure];
}

//是否屏蔽某人
+ (void)shieldSomeOne:(ShieldSomeOneParam *)param
                    Success:(void (^)(BaseResponse *response))success
                    failure:(void (^) (NSError *error))failure{
    sApiPath = @"userData/shieldSomeOne";
    [super requestWithParam:param responseClass:[BaseResponse class] success:success failure:failure];
}

//是否屏蔽某人
+ (void)reportSomeOne:(ReportSomeOneParam *)param
              Success:(void (^)(BaseResponse *response))success
              failure:(void (^) (NSError *error))failure{
    sApiPath = @"userData/reportSomeOne";
    [super requestWithParam:param responseClass:[BaseResponse class] success:success failure:failure];
}

@end

@implementation CityInfoRequest

+ (NSString *)requestServerHost {
    return kApiUserServerHost;
}

+ (NSString *)requestApiPath{
    return sApiPath;
}

+ (HttpRequestMethod)requestMethod
{
    return HttpRequestMethodGet;
}

//城市信息获取  获取全部区域接口
+ (void)getAllCity:(void (^)(CityInfoResponse *response))success
           failure:(void (^) (NSError *error))failure{
    sApiPath = @"city/getAllCity";
    [super requestWithParam:nil responseClass:[CityInfoResponse class] success:success failure:failure];
}

//根据上级ID获取区域接口
+ (void)getAllCityArea:(NSString *)parentId success:(void (^)(CityInfoResponse *response))success
           failure:(void (^) (NSError *error))failure{
    sApiPath = [NSString stringWithFormat:@"city/getAllCityArea?parentId=%@",parentId];
    [super requestWithParam:nil responseClass:[CityInfoResponse class] success:success failure:failure];
}
@end



@implementation ShieldSomeOneParam
@end

@implementation ReportSomeOneParam
@end
