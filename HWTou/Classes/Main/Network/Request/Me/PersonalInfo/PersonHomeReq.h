//
//  PersonHomeReq.h
//  HWTou
//
//  Created by robinson on 2017/11/20.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "BaseParam.h"
#import "BaseResponse.h"
#import "SessionRequest.h"
#import "PersonHomeDM.h"
#import "CollectSessionReq.h"

@interface PersonHomeParam : BaseParam
@property (nonatomic,assign) NSInteger uid;//用户标志 0：查看自己的主页，非0：查看他人的主页
@property (nonatomic,assign) NSInteger flag;//标志，1：关注列表 2：粉丝列表 3：屏蔽的人的列表
@property (nonatomic,assign) NSInteger page;//页码
@property (nonatomic,assign) NSInteger pagesize;//每页显示条数
@end

@interface LookCheckStatusPram:NSObject
@property (nonatomic,assign) NSInteger uid;
@end

@interface UserInfoParam:BaseParam
@property (nonatomic,assign) NSInteger uid;//用户标志 0：查看自己的主页，非0：查看他人的主页
@end

@interface InviteListParam:BaseParam
@property (nonatomic,assign) NSInteger page;//页码
@property (nonatomic,assign) NSInteger pagesize;//每页显示条数
@end

//是否关注某人
@interface FocusSomeOneParam:BaseParam
@property (nonatomic,copy) NSString * focusId;//关注用户ID
@end

@interface CheckNicknameParam : BaseParam
@property (nonatomic,copy) NSString * nickName;//用户标志 0：查看自己的主页，非0：查看他人的主页
@end

@interface UpdateUserLifeValueParam:BaseParam
@property (nonatomic,assign) NSInteger uid;//用户ID
@property (nonatomic,assign) NSInteger  flag;//1：增加生命值，2：减生命值
@property (nonatomic,assign) NSInteger remarkFlag;//记录标志： 1，邀请用户生命值加1，2：邀请的用户邀请用户生命值加1，3：答题活动生命值减1
@property (nonatomic,assign) NSInteger toId;//对应生命值的活动ID或者用户ID
@end

@interface ShieldSomeOneParam:BaseParam
@property (nonatomic,assign) NSInteger shieldId;//被屏蔽的用户ID
@end

@interface ReportSomeOneParam:BaseParam
@property (nonatomic,assign) NSInteger reportId;//被举报人ID
@end

@interface SaveUserDataParam : BaseParam
@property (nonatomic,copy) NSString * headUrl;
@property (nonatomic,copy) NSString * nickname;
@property (nonatomic,copy) NSString * bmgs;
@property (nonatomic,copy) NSString * introduce;
@property (nonatomic,assign) NSInteger sex;
@property (nonatomic,copy) NSString * city;
@property (nonatomic,copy) NSString * area;
@property (nonatomic,copy) NSString * sign;
@end

@interface PersonHomeResponse : BaseResponse
@property (nonatomic, strong) PersonHomeDM *data;
@end

@interface CityInfoResponse : BaseResponse
@property (nonatomic, strong) NSArray * data;
@end

@interface LookCheckStatusResponse : BaseResponse
@property (nonatomic, strong) NSDictionary * data;
@end

@interface PersonHomeRequest : SessionRequest
//查看主播达人审核状态
+ (void)lookCheckStatus:(LookCheckStatusPram *)param
                Success:(void (^)(LookCheckStatusResponse *response))success
                failure:(void (^) (NSError *error))failure;
//获取用户个人主页信息
+ (void)getUserInfo:(UserInfoParam *)param
                  Success:(void (^)(PersonHomeResponse *response))success
                  failure:(void (^) (NSError *error))failure;
//获取关注,粉丝,屏蔽的人 列表
+ (void)focusAndFansAndShiledList:(PersonHomeParam *)param
                  Success:(void (^)(CityInfoResponse *response))success
                  failure:(void (^) (NSError *error))failure;
//检测昵称
+ (void)checkNickname:(NSString *)nickName
              Success:(void (^)(BaseResponse *response))success
              failure:(void (^) (NSError *error))failure;
//保存个人主页资料
+ (void)saveUserData:(SaveUserDataParam *)param
                  Success:(void (^)(PersonHomeResponse *response))success
                  failure:(void (^) (NSError *error))failure;
//话题banner
+ (void)topicBannerList:(BaseParam *)param
                Success:(void (^)(MyTopicListResponse *response))success
                failure:(void (^) (NSError *error))failure;
//是否关注某人
+ (void)focusSomeOne:(FocusSomeOneParam *)param
             Success:(void (^)(TopicWorkDetailResponse *response))success
             failure:(void (^) (NSError *error))failure;
//获取我的邀请的人列表
+ (void)inviteList:(InviteListParam *)param
           Success:(void (^)(CityInfoResponse *response))success
           failure:(void (^) (NSError *error))failure;
//邀请活动规则
+ (void)getInvActivity:(void (^)(LookCheckStatusResponse *response))success
               failure:(void (^) (NSError *error))failure;
//生命值记录
+ (void)updateUserLifeValue:(UpdateUserLifeValueParam *)param
                    Success:(void (^)(BaseResponse *response))success
                    failure:(void (^) (NSError *error))failure;
//是否屏蔽某人
+ (void)shieldSomeOne:(ShieldSomeOneParam *)param
              Success:(void (^)(BaseResponse *response))success
              failure:(void (^) (NSError *error))failure;
//是否屏蔽某人
+ (void)reportSomeOne:(ReportSomeOneParam *)param
              Success:(void (^)(BaseResponse *response))success
              failure:(void (^) (NSError *error))failure;
@end

//城市信息获取
@interface CityInfoRequest : SessionRequest
//城市信息获取  获取全部区域接口
+ (void)getAllCity:(void (^)(CityInfoResponse *response))success
           failure:(void (^) (NSError *error))failure;
//根据上级ID获取区域接口
+ (void)getAllCityArea:(NSString *)parentId success:(void (^)(CityInfoResponse *response))success
               failure:(void (^) (NSError *error))failure;
@end
