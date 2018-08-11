//
//  RdAppTracker.h
//  demoapp
//
//  Created by Yosef Lin on 2/15/16.
//  Copyright © 2016 RongDu Tech. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RdAppTracker;

/**
 * 分析跟踪器插件接口
 */
@protocol RdAppTrackerPlugin

/**
 * 记录事件
 *
 * @param eventName 事件名称
 */
-(void)trackEvent:(NSString*)eventName;

/**
 * 记录进入页面事件
 *
 * @param pageName 页面名称
 */
-(void)trackPageAppear:(NSString*)pageName;

/**
 * 记录离开页面事件
 *
 * @param pageName 页面名称
 */
-(void)trackPageDisappear:(NSString*)pageName;

/**
 * 插件被添加到跟踪器时触发
 *
 * @param tracker 跟踪器实例
 */
-(void)onAdded:(RdAppTracker*)tracker;

/**
 * 插件被从跟踪器移除时触发
 *
 * @param tracker 跟踪器实例
 */
-(void)onRemoved:(RdAppTracker*)tracker;

@end

/**
 * 分析跟踪器
 */
@interface RdAppTracker : NSObject

/**
 * app标识
 */
@property(nonatomic,strong)NSString* appId;

/**
 * 获取跟踪器单件实例
 */
+(RdAppTracker*)sharedInstance;

/**
 * 记录事件
 *
 * @param eventName 事件名称
 */
-(void)trackEvent:(NSString*)eventName;

/**
 * 记录进入页面事件
 *
 * @param pageName 页面名称
 */
-(void)trackPageAppear:(NSString*)pageName;

/**
 * 记录离开页面事件
 *
 * @param pageName 页面名称
 */
-(void)trackPageDisappear:(NSString*)pageName;

/**
 * 添加跟踪器插件
 *
 * @param plugin 插件实例
 */
-(void)AddPlugin:(id<RdAppTrackerPlugin>)plugin;

/**
 * 移除跟踪器插件
 *
 * @param plugin 插件实例
 */
-(void)RemovePlugin:(id<RdAppTrackerPlugin>)plugin;

@end
