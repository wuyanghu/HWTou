//
//  NetworkProxy.h
//
//  Created by PP on 15/11/3.
//  Copyright (c) 2016年 PP. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NetworkProxy : NSObject

/**
 *  @brief http请求
 *
 *  @param requestClass 请求类(这里必须是BaseRequest类或子类)
 *  @param params       请求参数
 *  @param success      请求成功
 *  @param failure      请求失败
 */
+ (NSURLSessionTask *)requestWithClass:(Class)requestClass
                      params:(NSDictionary *)params
                      success:(void (^)(id responseObj))success
                      failure:(void (^)(NSError *error))failure;

@end
