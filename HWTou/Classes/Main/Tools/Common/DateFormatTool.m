//
//  DateFormatTool.m
//
//  Created by PP on 15/6/24.
//  Copyright (c) 2016年 LieMi. All rights reserved.
//

#import "DateFormatTool.h"

@implementation DateFormatTool

+ (NSDateFormatter *)getDateFormat:(NSString *)format
{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    if (nil == format)
    {
        [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    }
    else
    {
        [dateFormat setDateFormat:format];
    }
    
    return dateFormat;
}

+ (NSString *)stringFormatFromDate:(NSDate *)date withFormat:(NSString *)format
{
    return [[self getDateFormat:format] stringFromDate:date];
}

+ (NSDate *)dateFormatFromString:(NSString *)string withFormat:(NSString *)format
{
    return [[self getDateFormat:format] dateFromString:string];
}

+ (NSDate *)dateWithTimeIntervalSince1970:(NSTimeInterval)secs withFormat:(NSString *)format
{
    NSDate *formatDate = [NSDate dateWithTimeIntervalSince1970:secs];
    if (format)
    {
        NSString *date = [self stringFormatFromDate:formatDate withFormat:format];
        formatDate = [self dateFormatFromString:date withFormat:format];
    }
    return formatDate;
}

+ (void)absTimeFormatFromString:(NSString *)string withAbsTime:(ABSTIME *)absTime
{
    NSDate *date = [self dateFormatFromString:string withFormat:nil];
    
    [self absTimeFormatFromDate:date withAbsTime:absTime];
}

+ (void)absTimeFormatFromDate:(NSDate *)date withAbsTime:(ABSTIME *)absTime
{
    NSString *year   = [[self getDateFormat:@"yyyy"] stringFromDate:date];
    NSString *month  = [[self getDateFormat:@"MM"]   stringFromDate:date];
    NSString *day    = [[self getDateFormat:@"dd"]   stringFromDate:date];
    NSString *hour   = [[self getDateFormat:@"HH"]   stringFromDate:date];
    NSString *minute = [[self getDateFormat:@"mm"]   stringFromDate:date];
    NSString *second = [[self getDateFormat:@"ss"]   stringFromDate:date];
    
    absTime->year   = [year intValue];
    absTime->month  = [month intValue];
    absTime->day    = [day intValue];
    absTime->hour   = [hour intValue];
    absTime->minute = [minute intValue];
    absTime->second = [second intValue];
}

+ (NSTimeInterval)extractDateTimeInterval:(NSDate *)date
{
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    // 以秒为单位返回当前时间与系统格林尼治时间的差
    NSTimeInterval time = [zone secondsFromGMTForDate:date];
    NSTimeInterval interval = [date timeIntervalSince1970] + time;
    int daySeconds = 24 * 60 * 60;
    NSInteger allDays = interval / daySeconds;
    
    NSTimeInterval timeInterval = allDays * daySeconds - time;
    return timeInterval;
}

+ (NSDate *)extractDate:(NSDate *)date
{
    NSTimeInterval timeInterval = [self extractDateTimeInterval:date];
    NSDate *nowDate = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    return nowDate;
}

+ (NSString *)dateConversion:(NSString *)string{

    NSDate *date = [[self getDateFormat:nil] dateFromString:string];
    
    NSString *weekStr = [self weekdayStringFromDate:date];
    
    NSString *dateStr = [self stringFormatFromDate:date withFormat:@"MM.dd"];
    
    NSString *results = [NSString stringWithFormat:@"%@ %@",dateStr,weekStr];
    
    return results;
    
}

+ (NSString*)weekdayStringFromDate:(NSDate *)inputDate{
    
    NSArray *weekdays = [NSArray arrayWithObjects:
                         [NSNull null], @"周日", @"周一", @"周二", @"周三", @"周四", @"周五", @"周六", nil];
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    NSTimeZone *timeZone = [[NSTimeZone alloc] initWithName:@"Asia/Shanghai"];
    
    [calendar setTimeZone: timeZone];
    
    NSCalendarUnit calendarUnit = NSCalendarUnitWeekday;
    
    NSDateComponents *theComponents = [calendar components:calendarUnit fromDate:inputDate];
    
    return [weekdays objectAtIndex:theComponents.weekday];
    
}

+ (NSInteger)compareDate:(NSDate *)aDate withDate:(NSDate *)bDate{

    NSInteger results;
    
    NSComparisonResult result = [aDate compare:bDate];
    
    if (result == NSOrderedSame) {
        results = 0;
    } else if (result == NSOrderedAscending) {
        //bDate比aDate大
        results = 1;
    } else {
        //bDate比aDate小
        results = -1;
    }
    
    return results;
    
}

+ (NSDate *)obtainCurrentTime {
    
    NSDateFormatter *dateFormatter = [self getDateFormat:nil];
    
    NSString *dateString = [dateFormatter stringFromDate:[NSDate date]];
    
    return [dateFormatter dateFromString:dateString];
    
}

@end
