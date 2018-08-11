//
//  IPAddrTool.h
//  HWTou
//
//  Created by Reyna on 2018/3/9.
//  Copyright © 2018年 LieMi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IPAddrTool : NSObject

/***
 * 获取IP地址
 * input 是否Ipv4的IP
 * output：IP地址
 ***/
+ (NSString *)getIPAddress:(BOOL)preferIPv4;

@end
