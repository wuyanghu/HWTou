//
//  NetworkMonitorTool.m
//
//  Created by PP on 15/10/14.
//  Copyright (c) 2016年 LieMi. All rights reserved.
//

#import "NetworkMonitorTool.h"
#import <AFNetworking/AFNetworking.h>

@interface NetworkMonitorTool ()

@property (nonatomic, assign) NetworkStatus networkStatus;

@property (nonatomic, copy) NetworkStatusChangedBlock networkStatusChangedBlock;

@end

@implementation NetworkMonitorTool

+ (instancetype)shared {
    static NetworkMonitorTool *shared = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        shared = [[self alloc] init];
    });
    
    return shared;
}

// 开启网络监控
- (void)startMonitor
{
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        
        NSLog(@"Currnt Network Status: %d", (int)status);
        switch (status)
        {
            case AFNetworkReachabilityStatusUnknown: // 未知网络
                self.networkStatus = NetworkStatusUnknown;
                break;
                
            case AFNetworkReachabilityStatusNotReachable: // 没有网络(断网)
                self.networkStatus = NetworkStatusNotReachable;
                break;
                
            case AFNetworkReachabilityStatusReachableViaWWAN: // 手机自带网络
                self.networkStatus = NetworkStatusReachableWWAN;
                break;
                
            case AFNetworkReachabilityStatusReachableViaWiFi: // WIFI
                self.networkStatus = NetworkStatusReachableWiFi;
                break;
        }
        
        if (self.networkStatusChangedBlock)
        {
            self.networkStatusChangedBlock(self.networkStatus);
        }
    }];
    [manager startMonitoring];
}

- (void)stopMonitor
{
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    [manager stopMonitoring];
}

- (void)setReachabilityStatusChangedBlock:(NetworkStatusChangedBlock)block
{
    self.networkStatusChangedBlock = block;
}

- (BOOL)isReachableNetwork
{
    return ([self isNetworkStatusWWAN] || [self isNetworkStatusWiFi]);
}

- (BOOL)isNetworkStatusWiFi
{
    return self.networkStatus == NetworkStatusReachableWiFi;
}

- (BOOL)isNetworkStatusWWAN
{
    return self.networkStatus == NetworkStatusReachableWWAN;
}
@end
