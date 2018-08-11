//
//  FileTools.m
//  CNClient
//
//  Created by 赤 那 on 15/6/25.
//  Copyright (c) 2015年 赤 那 All rights reserved.
//

#import "FileTools.h"

@implementation FileTools

#pragma mark - 基础操作

//文件是否存在
+ (BOOL)isExsitFile:(NSString *)filePath{
    
    if (!filePath || filePath.length == 0) return NO;
    
    NSFileManager *manager = [NSFileManager defaultManager];
    
    if ([manager fileExistsAtPath:filePath]) return YES;
    
    return NO;
    
}

//创建文件
+ (BOOL)createFile:(NSString *)filePath deleteOld:(BOOL)flag{
    
    NSFileManager *manager = [NSFileManager defaultManager];
    
    if (![manager fileExistsAtPath:filePath]){
        
        return [manager createFileAtPath:filePath contents:nil attributes:nil];
        
    }else{
        
        if (flag){
            
            if ([manager removeItemAtPath:filePath error:nil]){
                
                return [manager createFileAtPath:filePath contents:nil attributes:nil];
                
            }else{
                
                return NO;
                
            }
            
        }else{
            
            return YES;
            
        }
        
    }
    
}

//删除文件
+ (BOOL)deleteFile:(NSString *)filePath{
    
    NSFileManager *manager = [NSFileManager defaultManager];
    
    if (![manager fileExistsAtPath:filePath]) return YES;
    
    if ([manager removeItemAtPath:filePath error:nil]) return YES;
    
    return NO;
    
}

// 删除对应路径下的所有文件
+ (BOOL)deleteAllFile:(NSString *)dir{
    
    NSFileManager *manager = [NSFileManager defaultManager];
    
    NSError *err = nil;
    NSArray *allFiles = [manager contentsOfDirectoryAtPath:dir error:&err];
    
    if (err){
        
        NSLog(@"Failed to get all files in directory:%@ \n. The error is:%@\n", dir, err);
        
        return NO;
        
    }else{
        
        for (NSString *fileName in allFiles){
            
            if (![self deleteFile:[dir stringByAppendingPathComponent:fileName]]) return NO;
            
        }
        
    }
    
    return YES;
    
}

// 文件大小
+ (unsigned long long)fileSizeWithPath:(NSString *)filePath{
    
    NSFileManager *manager = [NSFileManager defaultManager];
    
    if ([manager fileExistsAtPath:filePath]){
        
        return [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
        
    }
    
    return 0;
    
}

// 把一个移动到另外一个位置，或修改文件名
+ (BOOL)moveFile:(NSString *)srcFilePath toFilePath:(NSString *)destFilePath{
    
    NSParameterAssert(srcFilePath);
    NSParameterAssert(destFilePath);
    
    NSError *err = nil;
    
    return [[NSFileManager defaultManager] moveItemAtPath:srcFilePath
                                                   toPath:destFilePath
                                                    error:&err];
    
}

// APPList解析工具
+ (NSString *)getFileResourcePath:(NSString *)fileName{
    
    if (nil == fileName || [fileName length] == 0) return nil;
    
    // 获取资源目录路径
    NSString *resourceDir = [[NSBundle mainBundle] resourcePath];
    
    return [resourceDir stringByAppendingPathComponent:fileName];
    
}

// 获取library路径
+ (NSString *) libraryPath{
    
    return [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
}

// 获取document路径
+ (NSString *)documentPath{
    
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
}

// 根据文件名返回路径
+ (NSString *)pathInDocument:(NSString*)fileName{
    
    return [[FileTools documentPath] stringByAppendingPathComponent:fileName];
    
}

// 获取软件的唯一标识
+ (NSString *)getAppUid{
    
    NSString *path = [[NSBundle mainBundle] bundlePath];
    NSArray *pathCompents = [path pathComponents];
    
    if ([pathCompents count] >= 2) return [pathCompents objectAtIndex:[pathCompents count] - 2];
    
    return nil;
    
}

// 根据传入的文件夹名、用户ID 获取相应目录路径
+ (NSString *)getUserDir:(NSString *)folderName userId:(NSString *)uid{
    
    NSString *path = nil;
    
    if (uid.length > 0  && folderName.length > 0) {
        
        NSString *fileDir = [FileTools pathInDocument:folderName];
        
        NSString *userDir = [fileDir stringByAppendingPathComponent:uid];
        
        BOOL isDir;
        
        if ([[NSFileManager defaultManager] fileExistsAtPath:userDir isDirectory:&isDir] && isDir) {
            
            path =  userDir;
            
        }
        
        if (path != nil) {
            
            [[NSFileManager defaultManager] createDirectoryAtPath:userDir
                                      withIntermediateDirectories:YES
                                                       attributes:nil
                                                            error:nil];
            
        }
        
        path = userDir;
        
    }
    
    return path;
    
}

@end
