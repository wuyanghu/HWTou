//
//  RdAppLogger.h
//  ZhongRongJinFu
//
//  Created by Yosef Lin on 9/25/15.
//  Copyright (c) 2015 Yosef Lin. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * 日志服务
 */
@interface RdAppLogger : NSObject

+(RdAppLogger*)sharedInstance;
+(NSString*)logFilePathName;
+(void)backupPreviousLogFile;

/**
 * 是否允许打印到终端。DEBUG模式默认开，RELEASE模式强制关闭
 */
@property(nonatomic,assign)BOOL allowPrintToTerminal;

/**
 * 日志文件最大尺寸，设为0为不限制
 */
@property(nonatomic,assign)NSUInteger maximumFileSize;

/**
 * 打开日志服务。app启动时需要调用一次
 */
-(void)open;

/**
 * 结束日志服务
 */
-(void)close;

/**
 * 写入调试信息
 *
 * @param format 格式化字符串
 */
-(void)traceWithFormat:(NSString*)format, ...;

/**
 * 写入警告信息
 *
 * @param format 格式化字符串
 */
-(void)warningWithFormat:(NSString*)format, ...;

/**
 * 写入错误信息
 *
 * @param format 格式化字符串
 */
-(void)errorWithFormat:(NSString*)format, ...;


@end
