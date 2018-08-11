//
//  LoggerTool.m
//
//  Created by PP on 16/7/12.
//  Copyright (c) 2016年 LieMi. All rights reserved.
//

#import "LoggerTool.h"

@implementation LoggerTool

static LOGGER_LEVEL kLogLevel = LOGGER_LEVEL_DEBUG;

+ (void)logLevel:(LOGGER_LEVEL)level file:(NSString *)file function:(NSString *)function line:(NSUInteger)line log:(NSString *)log
{
    if (level > LOGGER_LEVEL_INVALID)
    {
        return;
    }
    
    if (kLogLevel <= level)
    {
        NSString *strLevel = nil;
        switch (level)
        {
            case LOGGER_LEVEL_DEBUG:
                strLevel = @"D";
                break;
            case LOGGER_LEVEL_INFO:
                strLevel = @"I";
                break;
            case LOGGER_LEVEL_WARNING:
                strLevel = @"W";
                break;
            case LOGGER_LEVEL_ERROR:
                strLevel = @"E";
                break;
            default:
                break;
        }
        
        NSLog(@"[%@]%@(Line:%lu): %@", strLevel, function, (unsigned long)line, log);
    }
}

+ (void)setLogLevel:(LOGGER_LEVEL)level
{
    if (level > LOGGER_LEVEL_INVALID)
    {
        kLogLevel = LOGGER_LEVEL_INVALID;
    }
    else
    {
        kLogLevel = level;
    }
}

@end
