//
//  NetworkMonitorTool.h
//
//  Created by PP on 15/10/14.
//  Copyright (c) 2016年 LieMi. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, NetworkStatus) {
    NetworkStatusUnknown            = -1,
    NetworkStatusNotReachable       = 0,
    NetworkStatusReachableWWAN      = 1,
    NetworkStatusReachableWiFi      = 2,
};

typedef void (^NetworkStatusChangedBlock)(NetworkStatus status);

@interface NetworkMonitorTool : NSObject

/**
 *  @brief  当前网络状态
 */
@property (readonly, nonatomic, assign) NetworkStatus networkStatus;

/** 是否有网络 */
@property (readonly, nonatomic, assign, getter = isReachableNetwork) BOOL reachableNetwork;

/** 是否为移动蜂窝网络 */
@property (readonly, nonatomic, assign, getter = isNetworkStatusWWAN) BOOL networkStatusWWAN;

/** 是否为无线网络WiFi */
@property (readonly, nonatomic, assign, getter = isNetworkStatusWiFi) BOOL networkStatusWiFi;

/**
 *  @brief  实例化单例对象
 */
+ (instancetype)shared;

/**
 *  @brief  开启网络监控
 */
- (void)startMonitor;

/**
 *  @brief  停止网络监控
 */
- (void)stopMonitor;

/**
 *  @brief 网络状态改变时回调的block
 */
- (void)setNetworkStatusChangedBlock:(NetworkStatusChangedBlock)block;

@end
