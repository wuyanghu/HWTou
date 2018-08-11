//
//  VerifyPwdRequest.h
//  HWTou
//
//  Created by Alan Jiang on 2017/4/18.
//  Copyright © 2017年 LieMi. All rights reserved.
//  验证已登陆用户的密码

#import "BaseParam.h"
#import "BaseRequest.h"
#import "BaseResponse.h"

#pragma mark - 请求参数
@interface VerifyPwdParam : BaseParam

@property (nonatomic, strong) NSString *password;

@end

#pragma mark - 请求执行
@interface VerifyPwdRequest : BaseRequest

/**
 *  @brief 验证已登陆用户的密码
 *
 *  @param param    VerifyCodeParam
 *  @param success  请求成功回调的block
 *  @param failure  请求失败回调的block
 *
 */
+ (void)verifyPwdWithParam:(VerifyPwdParam *)param
                   success:(void (^)(BaseResponse *response))success
                   failure:(void (^)(NSError *error))failure;

@end
