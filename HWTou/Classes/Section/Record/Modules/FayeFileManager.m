//
//  FayeFileManager.m
//  HWTou
//
//  Created by Reyna on 2017/12/27.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "FayeFileManager.h"

@implementation FayeFileManager

+ (NSString *)fayeFolderPath {
    NSString *documentDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *fayeFolderPath = [NSString stringWithFormat:@"%@/FayeVoice",documentDir];
    BOOL isExist =  [[NSFileManager defaultManager] fileExistsAtPath:fayeFolderPath];
    if (!isExist) {
        [[NSFileManager defaultManager] createDirectoryAtPath:fayeFolderPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return fayeFolderPath;
}

+ (NSString *)soundTouchSavePathWithFileName:(NSString *)fileName {
    //    NSString *fileName = [self fileName];
    
    NSString *wavfilepath = [NSString stringWithFormat:@"%@/SoundTouch",[FayeFileManager fayeFolderPath]];
    
    NSString *writeFilePath = [NSString stringWithFormat:@"%@/%@",wavfilepath, fileName];
    BOOL isExist =  [[NSFileManager defaultManager] fileExistsAtPath:writeFilePath];
    if (isExist) {
        //如果存在则移除 以防止 文件冲突
        //        NSError *err = nil;
        [FayeFileManager removeFile:writeFilePath];
        //        [[NSFileManager defaultManager] removeItemAtPath:writeFilePath error:&err];
    }
    
    BOOL isExistDic =  [[NSFileManager defaultManager] fileExistsAtPath:wavfilepath];
    if (!isExistDic) {
        [[NSFileManager defaultManager] createDirectoryAtPath:wavfilepath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    return writeFilePath;
}


+ (NSString *)fileName {
    NSString *fileName = [NSString stringWithFormat:@"FayeVoice%lld.wav",(long long)[NSDate timeIntervalSinceReferenceDate]];
    return fileName;
}

+ (NSString *)filePath {
    NSString *path = [FayeFileManager fayeFolderPath];
//    NSString *fileName = [FayeFileManager fileName];
    NSString *fileName = @"FayeVoice.wav";
    return [path stringByAppendingPathComponent:fileName];
}

+ (void)removeFile:(NSString *)filePath {
    BOOL isExist =  [[NSFileManager defaultManager] fileExistsAtPath:filePath];
    if (isExist) {
        [[NSFileManager defaultManager] removeItemAtPath:filePath error:nil];
    }
}

+ (BOOL)isExistWAVVoice {
    
    return [[NSFileManager defaultManager] fileExistsAtPath:[self filePath]];
}

@end
