//
//  AddressRequest.h
//  HWTou
//
//  Created by 赤 那 on 2017/3/26.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "BaseParam.h"
#import "BaseResponse.h"
#import "SessionRequest.h"

#pragma mark - 请求参数
// 新增 or 修改
@interface AddressParam : BaseParam

@property (nonatomic, assign) NSInteger maid;           // 收货地址编号
@property (nonatomic, assign) NSInteger p_id;           // 省地区编号
@property (nonatomic, assign) NSInteger city_id;        // 市地区编号
@property (nonatomic, assign) NSInteger d_id;           // 区地区编号
@property (nonatomic, strong) NSString *name;           // 收货人地址
@property (nonatomic, strong) NSString *tel;            // 收货人电话
@property (nonatomic, strong) NSString *address;        // 收货地址
@property (nonatomic, strong) NSString *post_code;      // 邮编 (选填)

@end

@interface AddressAddResult : NSObject

@property (nonatomic, assign) NSInteger maid;           // 收货地址编号

@end

#pragma mark - 请求响应
@interface AddressResponse : BaseResponse

@property (nonatomic, strong) NSArray *data;

@end

@interface AddressAddResp : BaseResponse

@property (nonatomic, strong) AddressAddResult *data;

@end

#pragma mark - 请求执行
@interface AddressRequest : SessionRequest

/**
 *  @brief 新增收货地址
 *
 *  @param param    AddressParam
 *  @param success  请求成功回调的block
 *  @param failure  请求失败回调的block
 *
 */
+ (void)addConsigneeAddressWithParam:(AddressParam *)param
                             success:(void (^)(AddressAddResp *response))success
                             failure:(void (^)(NSError *error))failure;

/**
 *  @brief 获取收货地址列表
 *
 *  @param success  请求成功回调的block
 *  @param failure  请求失败回调的block
 *
 */
+ (void)obtainConsigneeAddressList:(void (^)(AddressResponse *response))success
                           failure:(void (^)(NSError *error))failure;

/**
 *  @brief 删除收货地址
 *
 *  @param param    AddressParam
 *  @param success  请求成功回调的block
 *  @param failure  请求失败回调的block
 *
 */
+ (void)deleteConsigneeAddressWithParam:(AddressParam *)param
                                success:(void (^)(BaseResponse *response))success
                                failure:(void (^)(NSError *error))failure;

/**
 *  @brief 设置默认收货地址
 *
 *  @param param    AddressParam
 *  @param success  请求成功回调的block
 *  @param failure  请求失败回调的block
 *
 */
+ (void)topConsigneeAddressWithParam:(AddressParam *)param
                             success:(void (^)(BaseResponse *response))success
                             failure:(void (^)(NSError *error))failure;

/**
 *  @brief 修改收货地址
 *
 *  @param param    AddressParam
 *  @param success  请求成功回调的block
 *  @param failure  请求失败回调的block
 *
 */
+ (void)modifyConsigneeAddressWithParam:(AddressParam *)param
                                success:(void (^)(BaseResponse *response))success
                                failure:(void (^)(NSError *error))failure;

@end
