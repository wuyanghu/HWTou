//
//  DeviceInfoTool.h
//
//  Created by PP on 15/8/28.
//  Copyright (c) 2016年 LieMi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

@interface DeviceInfoTool : NSObject

/**
 *  @brief  获取当前设备类型
 *
 *  @return 设备类型
 */
+ (NSString *)getCurrentDeviceModel;

/**
 *  @brief  获取设备系统版本号
 *
 *  @return 系统版本号
 */
+ (NSString *)getSystemVersion;

/**
 *  @brief  获取应用程序版本号
 *
 *  @return 应用程序版本号
 */
+ (NSString *)getApplicationVersion;

/**
 *  @brief  获取应用程序包名
 *
 *  @return 包名
 */
+ (NSString *)getBundleIdentifier;

/**
 *  @brief  获取Bundle版本(bulid)
 *
 *  @return Bundle版本号
 */
+ (NSString *)getBundleVersion;

/**
 *  获取屏幕像素
 *
 *  @return 像素大小
 */
+ (CGSize)getScreenPixel;

/**
 *  获取当前连接WiFi的ssid
 *
 *  @return ssid
 */
+ (NSString *)getCurrentWiFiSSID;

/**
 *  获取当前连接网络状态
 *
 *  @return 网络状态
 */
+ (NSString *)getNetworkStatus;

+ (CGFloat)getTabbarHeight;
+ (CGFloat)getNavigationBarHeight;

@end
