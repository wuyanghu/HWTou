//
//  DateFormatTool.h
//
//  Created by PP on 15/6/24.
//  Copyright (c) 2016年 LieMi. All rights reserved.
//
//  日期格式化工具类

#import <Foundation/Foundation.h>


/*********************** date time struct **********************/
typedef struct
{
    int year;
    int month;
    int day;
    int hour;
    int minute;
    int second;
} ABSTIME, *PABSTIME;

@interface DateFormatTool : NSObject

/**
 *  @brief  将日期格式化成字符串
 *
 *  @param  date   日期类型
 *  @param  format 格式描述
 *
 *  @return 格式化后的字符串
 */
+ (NSString *)stringFormatFromDate:(NSDate *)date withFormat:(NSString *)format;

/**
 *  @brief  将字符串格式化成日期类
 *
 *  @param  string 日期字符串
 *  @param  format 格式描述
 *
 *  @return 格式化后的日期类
 */
+ (NSDate *)dateFormatFromString:(NSString *)string withFormat:(NSString *)format;

/**
 *  @brief 通过1979毫秒值格式化成日期类
 *
 *  @param secs   毫秒值
 *  @param format 格式描述
 *
 *  @return 格式化后的日期类
 */
+ (NSDate *)dateWithTimeIntervalSince1970:(NSTimeInterval)secs withFormat:(NSString *)format;

/**
 *  @brief  将字符串转化成绝对时间(ABSTIME)
 *
 *  @param  string  [in]  日期字符串(必须是标准的格式)
 *  @param  absTime [out] 绝对时间
 *
 */
+ (void)absTimeFormatFromString:(NSString *)string withAbsTime:(ABSTIME *)absTime;

/**
 *  @brief  将日期转化成绝对时间(ABSTIME)
 *
 *  @param  date  [in]  日期字符串(必须是标准的格式)
 *  @param  absTime [out] 绝对时间
 *
 */
+ (void)absTimeFormatFromDate:(NSDate *)date withAbsTime:(ABSTIME *)absTime;

/**
 *  @brief  提取年月日
 *
 *  @param  date 原日期
 *
 *  @return 仅包含年月日的日期
 */
+ (NSDate *)extractDate:(NSDate *)date;
+ (NSTimeInterval)extractDateTimeInterval:(NSDate *)date;

/**
 *  @brief  日期转换 MM.dd
 *
 *  @param  string date 字符串
 *
 *  @return MM.dd 周
 */
+ (NSString *)dateConversion:(NSString *)string;

/**
 *  @brief  日期比较
 *
 *  @param  aDate   比较的时间
 *  @param  bDate   被比较的时间
 *
 *  @return -1 : bDate 比 aDate 小; 0 : 相等; 1 : bDate 比 aDate 大
 */
+ (NSInteger)compareDate:(NSDate *)aDate withDate:(NSDate *)bDate;

/**
 *  @brief  获取当前时间
 *
 *  @return 当前时间
 */
+ (NSDate *)obtainCurrentTime;

@end
