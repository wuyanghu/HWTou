//
//  RdAppCrashDumper.h
//  demoapp
//
//  Created by Liang Shen on 2/16/16.
//  Copyright © 2016 RongDu Tech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RdAppCrashDumper : NSObject

+ (void)setupCrashDumper;

/**
 *  将捕获到的崩溃日志 上传至服务器
 */
+ (void)uploadExceptionLog;

/**
 *  将Log日志重定向输出到文件中保存
 */
+ (void)redirectNSlogToDocumentFolder;

@end
