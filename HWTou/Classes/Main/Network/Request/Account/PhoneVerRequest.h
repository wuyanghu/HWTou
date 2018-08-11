//
//  PhoneVerRequest.h
//  HWTou
//
//  Created by 赤 那 on 2017/3/22.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "BaseRequest.h"
#import "BaseResponse.h"

#pragma mark - 请求参数
@interface PhoneVerParam : NSObject

@property (nonatomic, strong) NSString *phone;


@end

#pragma mark - 请求响应 结果
@interface PhoneVerResult : NSObject

@property (nonatomic, assign) NSInteger status; // 1 为已注册，0 为未注册

@end

#pragma mark - 请求响应
@interface PhoneVerResponse : BaseResponse

@property (nonatomic, strong) PhoneVerResult *data;

@end

#pragma mark - 请求执行
@interface PhoneVerRequest : BaseRequest

/**
 *  @brief 手机是否注册验证
 *
 *  @param param    PhoneVerParam
 *  @param success  请求成功回调的block
 *  @param failure  请求失败回调的block
 *
 */
+ (void)phoneVerWithParam:(PhoneVerParam *)param
                  success:(void (^)(PhoneVerResponse *response))success
                  failure:(void (^)(NSError *error))failure;

@end
