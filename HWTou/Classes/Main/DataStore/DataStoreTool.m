//
//  DataStoreTool.m
//
//  Created by PP on 15/8/13.
//  Copyright (c) 2016年 PP. All rights reserved.
//
//  

#import "DataStoreTool.h"

@implementation DataStoreTool

#pragma mark - 获取Sandbox目录路径
+ (NSString *)getTempDirectory
{
    return NSTemporaryDirectory();
}

+ (NSString *)getDocumentDirectory
{
    NSArray *directories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    return [directories firstObject];
}

+ (NSString *)getCachesDirectory
{
    NSArray *directories = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    return [directories firstObject];
}

+ (NSString *)currentDirAppendDir:(NSString *)currentDir appendDir:(NSString *)appendDir
{
    NSString *pathDir = [currentDir stringByAppendingPathComponent:appendDir];
    if (![[NSFileManager defaultManager] fileExistsAtPath:pathDir])
    {
        [[NSFileManager defaultManager] createDirectoryAtPath:pathDir withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    return pathDir;
}

#pragma mark - Private Method
+ (NSString *)getUserDataDir
{
    NSString *filePath = [self currentDirAppendDir:[self getDocumentDirectory] appendDir:Data_Store_Folder];
    return filePath;
}
@end
