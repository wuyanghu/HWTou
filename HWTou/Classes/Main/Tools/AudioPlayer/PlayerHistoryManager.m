//
//  PlayerHistoryManager.m
//  HWTou
//
//  Created by Reyna on 2017/12/6.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "PlayerHistoryManager.h"

#define DIR_PATH @"history"
#define FILE_NAME @"newestPHModel"

@interface PlayerHistoryManager()

@property (nonatomic, strong) PlayerHistoryModel *newestPHModel;

@end

@implementation PlayerHistoryManager

+ (instancetype)sharedInstance {
    static PlayerHistoryManager *manager = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        manager = [[self alloc] init];
    });
    
    return manager;
}

- (void)writeNewestPlayerHistoryModel:(PlayerHistoryModel *)phModel {
    
    NSDate *nowDate = [NSDate date];
    NSString *str = [self dateToString:nowDate withDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    phModel.lookTime = [NSString stringWithFormat:@"%@",str];
    
    self.newestPHModel = phModel;
    
    NSMutableData *data = [[NSMutableData alloc] init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    [archiver encodeObject:phModel forKey:FILE_NAME];
    [archiver finishEncoding];
    NSString *fileName = [[self cachePath] stringByAppendingPathComponent:FILE_NAME];
    if([data writeToFile:fileName atomically:YES]){
        NSLog(@"归档成功");
    }
}

- (PlayerHistoryModel *)readNewestPlayerHistoryModel {
    
    if (self.newestPHModel) {
        
        return self.newestPHModel;
    }
    
    
    NSData *undata = [[NSData alloc] initWithContentsOfFile:[[self cachePath] stringByAppendingPathComponent:FILE_NAME]];
    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:undata];
    PlayerHistoryModel *unModel = [unarchiver decodeObjectForKey:FILE_NAME];
    NSLog(@"%@",unModel);
    [unarchiver finishDecoding];
    
    return unModel;
}

- (NSString *)cachePath {
    
    NSString *dirPath = [[self rootPath] stringByAppendingPathComponent:DIR_PATH];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDir = YES;
    BOOL existed = [fileManager fileExistsAtPath:dirPath isDirectory:&isDir];
    if (!existed) {
        [fileManager createDirectoryAtPath:dirPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return dirPath;
}

//日期格式转字符串
- (NSString *)dateToString:(NSDate *)date withDateFormat:(NSString *)format
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:format];
    NSString *strDate = [dateFormatter stringFromDate:date];
    return strDate;
}

- (NSString *)rootPath {
    return NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
}
@end
