//
//  VersionUpdateTool.m
//
//  Created by 彭鹏 on 2017/6/12.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "VersionUpdateTool.h"
#import <UIKit/UIKit.h>
#import "PublicHeader.h"

#define kServerUrl      @"http://itunes.apple.com/lookup"
#define kAppleID        @"1224914966"

@interface AppStoreInfoDM : NSObject

@property (nonatomic, copy) NSString *trackViewUrl; // 下载地址
@property (nonatomic, copy) NSString *releaseNotes; // 更新描述
@property (nonatomic, copy) NSString *trackId;      // 应用名
@property (nonatomic, copy) NSString *bundleId;     // 包名
@property (nonatomic, copy) NSString *version;      // 版本信息

- (instancetype)initWithDict:(NSDictionary *)dict;

@end

@implementation AppStoreInfoDM

- (instancetype)initWithDict:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        self.version = [dict objectForKey:@"version"];
        self.bundleId = [dict objectForKey:@"bundleId"];
        self.trackId = [dict objectForKey:@"trackId"];
        self.releaseNotes = [dict objectForKey:@"releaseNotes"];
        self.trackViewUrl = [dict objectForKey:@"trackViewUrl"];
    }
    return self;
}

@end

@interface VersionUpdateTool () <UIAlertViewDelegate>

@property (nonatomic, strong) AppStoreInfoDM *dmInfo;
@property (nonatomic, copy) VersionCheckCompleted completed;

@end

@implementation VersionUpdateTool

static id instance = nil;

+ (instancetype)shared
{
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        instance = [[[self class] alloc] init];
    });
    return instance;
}

- (void)checkUpdate:(VersionCheckCompleted)completed
{
    self.completed = completed;
    // 拼接请求地址&参数
    NSString *strUrl = [NSString stringWithFormat:@"%@?id=%@", kServerUrl, kAppleID];
    NSURL *url = [NSURL URLWithString:strUrl];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:3];
    // 网络请求
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
    NSURLSessionDataTask *task =
    [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error) {
            NSLog(@"网络请求错误: %@", error);
            !self.completed ?: self.completed(error, nil);
            return;
        }
        
        // 解析数据处理
        NSDictionary *dictResult = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
        
        if (error) {
            NSLog(@"数据解析失败: %@", error);
            !self.completed ?: self.completed(error, nil);
            return;
        }
        
        NSArray *results = [dictResult objectForKey:@"results"];
        if (results.count == 0) {
            NSLog(@"error : results is nil");
            !self.completed ?: self.completed(error, nil);
            return;
        }
        
        NSDictionary *appInfo = [results firstObject];
        
        AppStoreInfoDM *dmInfo = [[AppStoreInfoDM alloc] initWithDict:appInfo];
        self.dmInfo = dmInfo;
        if ([self compareVersion:dmInfo.version]) {
            [self showUpdateAlert:dmInfo];
        }
        !self.completed ?: self.completed(nil, dmInfo.version);
    }];
    
    [task resume];
}

- (void)showUpdateAlert:(AppStoreInfoDM *)dmInfo
{
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"发现新版本" message:dmInfo.releaseNotes delegate:self cancelButtonTitle:nil otherButtonTitles:@"取消", @"升级", nil];
        [alert show];
    });
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        NSURL *url = [NSURL URLWithString:self.dmInfo.trackViewUrl];
        [[UIApplication sharedApplication] openURL:url];
    }
}

// 与本地版本比较
- (BOOL)compareVersion:(NSString *)newVersion
{
    // 获取当前设备中应用的版本号
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    NSString *curVersion = [infoDic objectForKey:@"CFBundleShortVersionString"];
    
    NSComparisonResult result = [curVersion compare:newVersion options:NSCaseInsensitiveSearch];
    NSLog(@"%ld", result);
    
    if (result == NSOrderedAscending) {
        return YES;
    } else {
        // 本地版本 >= App Store版本
        return NO;
    }
}

@end
