//
//  FayeFileManager.h
//  HWTou
//
//  Created by Reyna on 2017/12/27.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FayeFileManager : NSObject

// 文件夹路径
+ (NSString *)fayeFolderPath;

// 变声保存的文件路径
+ (NSString *)soundTouchSavePathWithFileName:(NSString *)fileName;

// 音频文件保存的整个路径
+ (NSString *)filePath;

// 删除文件
+ (void)removeFile:(NSString *)filePath;

//是否存在WAV声音文件
+ (BOOL)isExistWAVVoice;

@end
