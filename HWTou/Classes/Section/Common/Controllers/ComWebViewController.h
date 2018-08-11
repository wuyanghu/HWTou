//
//  ComWebViewController.h
//
//  Created by pengpeng on 17/3/27.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import <WebKit/WebKit.h>
#import "BaseViewController.h"

typedef void(^ComWebScriptHandle)(NSString *method, id param);

@interface ComWebViewController : BaseViewController

/**
 WKWebView 控件
 */
@property (nonatomic, readonly) WKWebView *webView;

/** JS调用OC方法回调 */
@property (nonatomic, copy) ComWebScriptHandle handleScript;

/** Web页面URL地址 */
@property (nonatomic, copy) NSString *webUrl;

/**
 注册供JS调用的方法
 
 @param name   调用的方法名
 */
- (void)addScriptMethod:(NSString *)name;

/**
 加载Web页面
 
 @param webUrl 地址
 */
- (BOOL)loadWebWithUrl:(NSString *)webUrl;

/**
 重新加载Web页面
 
 @param webUrl 地址
 */
- (BOOL)reloadWebWithUrl:(NSString *)webUrl;

@end
