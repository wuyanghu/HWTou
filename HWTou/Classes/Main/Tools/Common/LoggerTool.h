//
//  LoggerTool.h
//
//  Created by PP on 16/7/12.
//  Copyright (c) 2016年 LieMi. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
  日志开关宏,在发布应用的时候 需要定义宏来取消日志输出
  开启日志输出:#define LOGGER_DISABLE (0) 或者不定义
  关闭日志输出:#define LOGGER_DISABLE (1)
 */

#define LOGGER_DISABLE (0)

#if LOGGER_DISABLE

#define NSLoggerE(fmt, ...)
#define NSLoggerW(fmt, ...)
#define NSLoggerI(fmt, ...)
#define NSLoggerD(fmt, ...)

#else

#define LogFile        [NSString stringWithFormat:@"%s",__FILE__]
#define LogFunction    [NSString stringWithFormat:@"%s",__FUNCTION__]

#define NSLoggerE(fmt, ...)   [LoggerTool logLevel:LOGGER_LEVEL_ERROR file:LogFile function:LogFunction line:__LINE__       \
                                               log:([NSString stringWithFormat:(@"" fmt),##__VA_ARGS__])]

#define NSLoggerW(fmt, ...)   [LoggerTool logLevel:LOGGER_LEVEL_WARNING file:LogFile function:LogFunction line:__LINE__     \
                                               log:([NSString stringWithFormat:(@"" fmt),##__VA_ARGS__])]

#define NSLoggerI(fmt, ...)   [LoggerTool logLevel:LOGGER_LEVEL_INFO file:LogFile function:LogFunction line:__LINE__        \
                                                log:([NSString stringWithFormat:(@"" fmt),##__VA_ARGS__])]

#define NSLoggerD(fmt, ...)   [LoggerTool logLevel:LOGGER_LEVEL_DEBUG file:LogFile function:LogFunction line:__LINE__       \
                                               log:([NSString stringWithFormat:(@"" fmt),##__VA_ARGS__])]

#endif

/**
 * 可用的日志等级
 */
typedef enum
{
    /**
     *  DEBUG等级日志输出,设置该等级后会显示DEBUG, INFO, WARNING, ERROR打印的日志
     */
    LOGGER_LEVEL_DEBUG = 0,
    
    /**
     *  INFO等级日志输出,设置该等级后会显示INFO, WARNING, ERROR打印的日志
     */
    LOGGER_LEVEL_INFO,
    
    /**
     *  WARNING等级日志输出,设置该等级后会显示WARNING, ERROR打印的日志
     */
    LOGGER_LEVEL_WARNING,
    
    /**
     *  ERROR等级日志输出,设置该等级后会显示ERROR打印的日志
     */
    LOGGER_LEVEL_ERROR,
    /**
     *  无效的日志等级
     */
    LOGGER_LEVEL_INVALID
    
}LOGGER_LEVEL;

@interface LoggerTool : NSObject

/**
 *  @brief 输出Log日志
 *
 *  @param level    日志级别
 *  @param file     文件路径
 *  @param function 函数名
 *  @param line     行数
 *  @param log      log内容
 */
+ (void)logLevel:(LOGGER_LEVEL)level file:(NSString *)file function:(NSString *)function line:(NSUInteger)line log:(NSString *)log;

/**
 *  @brief 设置日志输出的等级
 *
 *  @param level 日志等级
 */
+ (void)setLogLevel:(LOGGER_LEVEL)level;

@end
