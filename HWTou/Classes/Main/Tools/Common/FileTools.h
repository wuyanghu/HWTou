//
//  FileTools.h
//  CNClient
//
//  Created by 赤 那 on 15/6/25.
//  Copyright (c) 2015年 赤 那 All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FileTools : NSObject

#pragma mark - 基础操作
// 文件是否存在
+ (BOOL)isExsitFile:(NSString *)filePath;

// 创建文件
+ (BOOL)createFile:(NSString *)filePath deleteOld:(BOOL)flag;

// 删除文件
+ (BOOL)deleteFile:(NSString *)filePath;

// 删除路径下的所有文件
+ (BOOL)deleteAllFile:(NSString *)dir;

// 文件大小
+ (unsigned long long)fileSizeWithPath:(NSString *)filePath;

// 把一个移动到另外一个位置，或更改文件名
+ (BOOL)moveFile:(NSString *)srcFilePath toFilePath:(NSString *)destFilePath;

// APPList解析工具
+ (NSString *)getFileResourcePath:(NSString *)fileName;

// library路径
+ (NSString *)libraryPath;

// 获取 Application/document 路径
+ (NSString *)documentPath;

// 根据文件名返回路径
+ (NSString*)pathInDocument:(NSString*)fileName;

// 获取软件的唯一标识
+ (NSString *)getAppUid;

// 根据传入的文件夹名、用户ID 获取相应目录路径
+ (NSString *)getUserDir:(NSString *)folderName userId:(NSString *)uid;

@end
