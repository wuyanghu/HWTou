//
//  PersonalInfoReq.h
//  HWTou
//
//  Created by 彭鹏 on 2017/4/3.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "BaseParam.h"
#import "BaseResponse.h"
#import "SessionRequest.h"

@class PersonalInfoDM;

#pragma mark - 请求参数
@interface PersonalInfoParam : BaseParam



@end

// 修改
@interface PersonalInfoUpdateParam : BaseParam

@property (nonatomic, strong) NSString *head_url;
@property (nonatomic, strong) NSString *nickname;

@end

#pragma mark - 请求响应 结果
@interface PersonalInfoResult : NSObject

@end

#pragma mark - 请求响应
@interface PersonalInfoResp : BaseResponse

@property (nonatomic, strong) PersonalInfoDM *data;

@end

#pragma mark - 请求执行
@interface PersonalInfoReq : SessionRequest

/**
 *  @brief 获取个人信息
 *
 *  @param success  请求成功回调的block
 *  @param failure  请求失败回调的block
 *
 */
+ (void)personalInfoSuccess:(void (^)(PersonalInfoResp *response))success
                    failure:(void (^) (NSError *error))failure;

/**
 *  @brief 修改个人信息
 *
 *  @param param    PersonalInfoUpdateParam
 *  @param success  请求成功回调的block
 *  @param failure  请求失败回调的block
 *
 */
+ (void)updatePersonalInfo:(PersonalInfoUpdateParam *)param
                   Success:(void (^)(BaseResponse *response))success
                   failure:(void (^) (NSError *error))failure;

@end
