//
//  BaseResponse.h
//  HWTou
//
//  Created by 彭鹏 on 16/8/9.
//  Copyright © 2016年 LieMi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BaseResponse : NSObject

// 错误描述:errcode != 0时会有错误信息返回
@property (nonatomic, copy) NSString        *msg;
// 错误码 0为正常
@property (nonatomic, assign) NSInteger     errcode;
// 业务操作成功与否
@property (nonatomic, assign) BOOL          success;
@property (nonatomic, assign) NSInteger status;

@end
