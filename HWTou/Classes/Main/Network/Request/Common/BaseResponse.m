//
//  BaseResponse.m
//  HWTou
//
//  Created by 彭鹏 on 16/8/9.
//  Copyright © 2016年 LieMi. All rights reserved.
//

#import "BaseResponse.h"

@implementation BaseResponse

- (void)setErrcode:(NSInteger)errcode
{
    _errcode = errcode;
    self.success = (errcode == 0) ? YES : NO;
}

@end
