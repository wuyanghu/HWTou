//
//  NSError+URLErrorCode.m
//
//  Created by PP on 16/8/1.
//  Copyright (c) 2016年 PP. All rights reserved.
//

#import "NSError+URLErrorCode.h"

@implementation NSError (URLErrorCode)

- (NSString *)urlErrorCodeDescribe
{
    NSString *result = nil;
    switch (self.code) {
        case NSURLErrorNotConnectedToInternet:
        case NSURLErrorNetworkConnectionLost:
            result = @"网络不给力，请稍后重试";
            break;
        case NSURLErrorTimedOut:
            result = @"连接服务器超时，请稍后重试";
            break;
        case NSURLErrorCannotConnectToHost:
        case NSURLErrorRedirectToNonExistentLocation:
            result = @"无法连接服务器";
            break;
        case NSURLErrorBadServerResponse:
            result = @"服务器出错，请稍后重试";
            break;
        default:
            result = @"网络不给力，请稍后重试";
            break;
    }
    return result;
}

@end
