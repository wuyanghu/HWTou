//
//  NSError+URLErrorCode.h
//
//  Created by PP on 16/8/1.
//  Copyright (c) 2016年 PP. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSError (URLErrorCode)

/**
 *  @brief  URL网络请求错误码转换
 *
 *  @return 错误码描述
 */
- (NSString *)urlErrorCodeDescribe;

@end
