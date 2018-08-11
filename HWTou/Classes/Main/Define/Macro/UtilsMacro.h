//
//  UtilsMacro.h
//
//  Created by PP on 15/7/3.
//  Copyright (c) 2016年 PP. All rights reserved.
//
//  工具类型的宏定义

#ifndef UtilsMacro_h
#define UtilsMacro_h

/**************************************************************/
#pragma mark - 颜色类相关

// 十六进制值取色(HEX, alpha)
#define UIColorFromHexA(rgbValue, alp)          [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16)) / 255.0    \
                                                                green:((float)((rgbValue & 0xFF00) >> 8)) / 255.0       \
                                                                 blue:((float)(rgbValue & 0xFF)) / 255.0                \
                                                                alpha:alp]
// 获取RGB Alpha颜色
//#define UIColorFromRGBA(R, G, B, A)             [UIColor colorWithRed:R/255.0f green:G/255.0f blue:B/255.0f alpha:A]

// 十六进制值取色(HEX)
#define UIColorFromHex(rgbValue)                UIColorFromHexA(rgbValue, 1.0)

// 获取RGB颜色
//#define UIColorFromRGB(R, G, B)                 UIColorFromRGBA(R, G, B, 1.0f)

/**************************************************************/

// 获取主屏幕的高度
#define kMainScreenHeight                       ([UIScreen mainScreen].bounds.size.height)
// 获取主屏幕的宽度
#define kMainScreenWidth                        ([UIScreen mainScreen].bounds.size.width)

// 绘制1个像素的线
#define Single_Line_Width                       (1 / [UIScreen mainScreen].scale)
#define Single_Line_Adjust_Offset               ((1 / [UIScreen mainScreen].scale) / 2)

// 16:9 和 4:3 比例值
#define kScale_16_9                             1.777777
#define kScale_4_3                              1.333333
#define kScale_9_16                             0.5625
#define kScale_3_4                              0.75

/**************************************************************/

#pragma mark - 打印日志相关

#define TICK   NSDate *startTime = [NSDate date]
#define TOCK   NSLog(@"Time: %f", -[startTime timeIntervalSinceNow])

// DEBUG  模式下打印日志,当前行
#ifdef DEBUG
    #define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
    #define DLog(...)
#endif

//DEBUG  模式下打印日志,当前行 并弹出一个警告
#ifdef DEBUG
    #define ULog(fmt, ...)  { UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"%s\n [Line %d] ", __PRETTY_FUNCTION__, __LINE__] message:[NSString stringWithFormat:fmt, ##__VA_ARGS__]  delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil]; [alert show]; }
#else
    #define ULog(...)
#endif

/**************************************************************/

#pragma mark - 系统相关
//----------------------系统----------------------------

// 是否iPad
#define isPad (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)

//判断当前屏幕是不是iPhone4
#define isScreeniPhone4  (([[UIScreen mainScreen] bounds].size.height) == 480)

// 获取系统版本
#define CurrentSystemVersion [[UIDevice currentDevice] systemVersion]
#define IOS_VERSION [CurrentSystemVersion floatValue]

// 获取当前语言
#define CurrentLanguage ([[NSLocale preferredLanguages] objectAtIndex:0])

// 判断设备的操做系统是不是ios7
#define IOS_7_X (IOS_VERSION >= 7.0f && IOS_VERSION < 8.0f)

//检查系统版本
#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

/**************************************************************/

#pragma mark - GCD

// GCD
#define BACK(block) dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), block)
#define MAIN(block) dispatch_async(dispatch_get_main_queue(),block)

// 由角度获取弧度 有弧度获取角度
#define degreesToRadian(x) (M_PI * (x) / 180.0)
#define radianToDegrees(radian) (radian*180.0)/(M_PI)

#define WeakObj(obj)    __weak typeof(obj)      obj##Weak = obj;
#define StrongObj(obj)  __strong typeof(obj)    obj = obj##Weak;

/**************************************************************/

#pragma mark - 适配
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_8_0

#define kGregorianCalendar  NSCalendarIdentifierGregorian
#define kSizeWithFont(NSString,UIFont) [NSString sizeWithAttributes:@{NSFontAttributeName:UIFont}]

#else

#define kGregorianCalendar  NSGregorianCalendar
#define kSizeWithFont(NSString,UIFont) [NSString sizeWithFont:UIFont constrainedToSize:CGSizeMake(INT32_MAX, INT32_MAX) lineBreakMode:NSLineBreakByTruncatingTail]

#endif

/**************************************************************/

#pragma mark - 图片

#define MIN(A,B) __NSMIN_IMPL__(A,B,__COUNTER__)

// 读取本地图片
#define LOADIMAGE(file,ext) [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:file ofType:ext]]

// 定义UIImage对象
#define IMAGE(A) [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:A ofType:nil]]

// 定义UIImage对象
#define ImageNamed(_pointer) [UIImage imageNamed:_pointer]

/**************************************************************/

#pragma mark - 数组 or 字典 读取宏

#define OBJECTOFNSDICTIONARYBYKEY(obj,dictionary,key); @try\
{\
obj = [dictionary objectForKey:key];\
}\
@catch(NSException * exception)\
{\
NSLog(@"dictionary exception:%@",exception);\
}\
@finally\
{\
}

#define SETOBJECT(dic,value,key);if(value != nil && key != nil){\
[dic setObject:value forKey:key]; \
}

#define REPLACEOBJECTATINDEX(obj,array,index); @try\
{\
[array replaceObjectAtIndex:index withObject:obj];\
}\
@catch(NSException * exception)\
{\
NSLog(@"Array replace cross-border exception:%@",exception);\
}\
@finally\
{\
}

#define REMOVEOBJECTOFARRAYATINDEX(array,index); @try\
{\
[array removeObjectAtIndex:index];\
}\
@catch(NSException * exception)\
{\
NSLog(@"Array remove cross-border exception:%@",exception);\
}\
@finally\
{\
}

#define OBJECTOFARRAYATINDEX(obj,array,index); @try\
{\
obj = [array objectAtIndex:index];\
}\
@catch(NSException * exception)\
{\
NSLog(@"Array cross-border exception:%@",exception);\
}\
@finally\
{\
}

/**************************************************************/

#pragma mark - 其他
// 是否为空或是[NSNull null]
#define IsNilOrNull(_ref)   (((_ref) == nil) || ([(_ref) isEqual:[NSNull null]]))
// 数组是否为空
#define IsArrEmpty(_ref)    (((_ref) == nil) || ([(_ref) isEqual:[NSNull null]]) || ([(_ref) count] == 0))
// 字符串是否为空
#define IsStrEmpty(_ref)    (((_ref) == nil) || ([(_ref) isEqual:[NSNull null]]) || ([(_ref)isEqualToString:@""]))
// 通知移除
#define NoticeRemove(id,obj) [[NSNotificationCenter defaultCenter] removeObserver:id name:obj object:nil];

/**************************************************************/

#endif
