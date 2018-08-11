//
//  VODUtil.h
//  HWTou
//
//  Created by Reyna on 2017/12/4.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <VODUpload/VODUploadClient.h>

@interface VODUtil : NSObject

- (void)addFile:(NSURL *)url Endpoint:(NSString *)endpoint Bucket:(NSString *)bucketName FileName:(NSString *)FileName;

- (id)initWithListener:listener AccessKeyId:(NSString *)AccessKeyId AccessKeySecret:(NSString *)AccessKeySecret ExpireTime:(NSString *)ExpireTime SecretToken:(NSString *)SecretToken;

- (void)start;

- (void)setUploadAuth:(UploadFileInfo *)fileInfo upLoadAuth:(NSString *)upLoadAuth uploadAddress:(NSString *)uploadAddress;

@end
