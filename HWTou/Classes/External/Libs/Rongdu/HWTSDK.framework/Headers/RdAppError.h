//
//  RdAppError.h
//  demoapp
//
//  Created by erongdu_cxk on 16/2/29.
//  Copyright © 2016年 Yosef Lin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RdAppServiceResult.h"
#import "ServiceCommon.h"


/**
 *  将错误信息汇总
 */
@interface RdAppError : NSObject

/**
 *  错误代码
 */
@property (nonatomic, readonly) NSInteger errCode;

/**
 *  错误信息
 */
@property (nonatomic, readonly, strong, nullable) NSString *errMessage;

/**
 *  根据网络请求返回的数据生成错误信息
 *
 *  @param result 服务器返回的数据
 *  @param error  错误信息
 *
 *  @return 汇总错误信息
 */
- (nonnull instancetype)initWithServiceResult:(nullable RdAppServiceResult *)result Error:(nullable NSError *)error;

/**
 *  自定义错误
 *
 *  @param rdErrorType 错误类型
 *  @param errMessage  错误描述
 *
 *  @return 错误类型
 */
- (nonnull instancetype)initWithErrorCode:(RdAppErrorType)rdErrorType AndErrorMessage:(nullable NSString *)errMessage;
@end
