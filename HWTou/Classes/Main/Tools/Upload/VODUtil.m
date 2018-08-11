//
//  VODUtil.m
//  HWTou
//
//  Created by Reyna on 2017/12/4.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "VODUtil.h"

static NSString* const mpAccessKeyId = @"LTAIyhkgJq0TGCsl";
static NSString* const mpAccessKeySecret = @"llPYepr4aWKCZA9yNmsXB8ya0nm37j";

static VODUploadClient *uploader;

static int pos = 0;

@interface VODUtil ()
{
    NSDictionary *UploadAuth;
    NSDictionary *UploadAddress;
}

@end

@implementation VODUtil

- (void)addFile:(NSURL *)url Endpoint:(NSString *)endpoint Bucket:(NSString *)bucketName FileName:(NSString *)FileName {
    NSString *filePath = [url path];
    //        NSString *ossObject = [NSString stringWithFormat:@"uploadtest/%@", FileName];
    
    
    VodInfo *vodInfo = [[VodInfo alloc] init];
    vodInfo.title = [NSString stringWithFormat:@"IOS标题%d", pos];
    vodInfo.desc = [NSString stringWithFormat:@"IOS描述%d", pos];
    vodInfo.cateId = @(19);
    vodInfo.coverUrl = [NSString stringWithFormat:@"http://www.taobao.com/IOS封面URL%d", pos];
    vodInfo.tags = [NSString stringWithFormat:@"IOS标签1%d, IOS标签2%d", pos, pos];
    
    [uploader addFile:filePath vodInfo:vodInfo];
    
    
    NSLog(@"Add file: %@", filePath);
    pos++;
}

- (id)initWithListener:listener AccessKeyId:(NSString *)AccessKeyId AccessKeySecret:(NSString *)AccessKeySecret ExpireTime:(NSString *)ExpireTime SecretToken:(NSString *)SecretToken {
    self = [super init];
    if (self) {
        uploader = [[VODUploadClient alloc] init];
        [uploader init:AccessKeyId accessKeySecret:AccessKeySecret secretToken:SecretToken expireTime:ExpireTime listener:listener];
        //        [uploader init:listener];
    }
    return self;
}

- (void)setUploadAuth:(UploadFileInfo *)fileInfo upLoadAuth:(NSString *)upLoadAuth uploadAddress:(NSString *)uploadAddress {
    
    [uploader setUploadAuthAndAddress:fileInfo
                           uploadAuth:upLoadAuth
                        uploadAddress:uploadAddress];
    
}

- (void) start {
    [uploader start];
}

@end
