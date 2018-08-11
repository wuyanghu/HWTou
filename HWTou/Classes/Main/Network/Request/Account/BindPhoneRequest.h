//
//  BindPhoneRequest.h
//  HWTou
//
//  Created by 赤 那 on 2017/4/25.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "BaseParam.h"
#import "BaseResponse.h"
#import "SessionRequest.h"

#pragma mark - 请求参数
@interface BindPhoneParam : BaseParam

@property (nonatomic, strong) NSString *phone;
@property (nonatomic, strong) NSString *code;

@end

#pragma mark - 请求响应
@interface BindPhoneResponse : BaseResponse

@end

#pragma mark - 请求执行
@interface BindPhoneRequest : SessionRequest

/**
 *  @brief 重新绑定手机号
 *
 *  @param param    CourseListParam
 *  @param success  请求成功回调的block
 *  @param failure  请求失败回调的block
 *
 */
+ (void)updateBindPhoneWithParam:(BindPhoneParam *)param
                         success:(void (^)(BaseResponse *response))success
                         failure:(void (^)(NSError *error))failure;

@end
