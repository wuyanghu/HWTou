//
//  VoiceUpload.m
//  HWTou
//
//  Created by Reyna on 2017/12/20.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "VoiceUpload.h"
#import "VODUtil.h"
#import "UploadRequest.h"
#import "NSString+XK.h"
#import "HUDProgressTool.h"
#import "PublicHeader.h"

static VODUtil *videoUpload;

@implementation VoiceUpload

+ (void)uploadVoiceWithVoicepath:(NSString *)voicePath
                           title:(NSString *)title
                            tags:(NSString *)tags
                       voiceSize:(double)size
                             lat:(double)lat
                             lng:(double)lng
                   successHandle:(void (^)(NSString *))success
                        progress:(void (^)(long, long))progress
                      failHandle:(void (^)(NSString *))fail {
    
//    [HUDProgressTool showIndicatorWithText:nil];
    dispatch_async(dispatch_get_main_queue(), ^{
        [HUDProgressTool showIndicatorWithText:@"上传音频文件中...0%"];
    });
    
    [UploadRequest createUploadVideoWithFileName:voicePath title:title desc:tags size:(long)size tags:tags success:^(NSDictionary *response) {
        
        if ([[response objectForKey:@"status"] intValue] == 200) {
            NSDictionary *dataDic = [response objectForKey:@"data"];
            NSString *uploadauth = [dataDic objectForKey:@"uploadauth"];
            NSString *uploadaddress = [dataDic objectForKey:@"uploadaddress"];
            NSString *videoid = [dataDic objectForKey:@"videoid"];
            
            if (uploadauth == nil || uploadaddress == nil) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [HUDProgressTool showErrorWithText:@"上传凭证错误"];
                });
                fail(@"上传凭证错误");
                return;
            }
            
            NSString *json1 = [NSString debase64FromString:uploadauth];
            NSDictionary *authDict = [NSString translationJsontoDict:json1];
            
            NSString *json2 = [NSString debase64FromString:uploadaddress];
            NSDictionary *arressDict = [NSString translationJsontoDict:json2];
            
            NSString *SecurityToken = authDict[@"SecurityToken"];
            NSString *AccessKeyId = authDict[@"AccessKeyId"];
            NSString *AccessKeySecret = authDict[@"AccessKeySecret"];
            NSString *Expiration = authDict[@"Expiration"];
            
            NSString *Endpoint = arressDict[@"Endpoint"];
            NSString *Bucket = arressDict[@"Bucket"];
            NSString *fileName = arressDict[@"FileName"];
            
            OnUploadSucceedListener testSuccessCallbackFunc = ^(UploadFileInfo* fileInfo) {
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    [HUDProgressTool dismiss];
//                });
                if (success) {
                    success(videoid);
                }
            };
            
            OnUploadFailedListener testFailedCallbackFunc = ^(UploadFileInfo *fileInfo, NSString *code, NSString* message){
                //HUD 上传失败
                
                NSLog(@"%@", fileInfo);
                dispatch_async(dispatch_get_main_queue(), ^{
                    [HUDProgressTool showErrorWithText:@"上传失败"];
                });
                if (fail) {
                    fail(@"音乐上传失败");
                }
            };
            
            OnUploadProgressListener testProgressCallbackFunc = ^(UploadFileInfo* fileInfo, long uploadedSize, long totalSize) {
                
                NSLog(@"=======%ld========%ld======",totalSize,uploadedSize);
                if (progress) {
                    progress(uploadedSize, totalSize);
                }
                CGFloat percent = uploadedSize/(totalSize*1.0) * 100;
                dispatch_async(dispatch_get_main_queue(), ^{
                    [HUDProgressTool showIndicatorWithText:[NSString stringWithFormat:@"上传音频文件中...%.f%%",percent]];
                });
            };
            
            OnUploadStartedListener testUploadStartedCallbackFunc = ^(UploadFileInfo* fileInfo) {
                NSLog(@"upload started .");
                [videoUpload setUploadAuth:fileInfo upLoadAuth:uploadauth uploadAddress:uploadaddress];
            };
            
            VODUploadListener *listener = [[VODUploadListener alloc] init];
            
            listener.success = testSuccessCallbackFunc;
            listener.failure = testFailedCallbackFunc;
            listener.progress = testProgressCallbackFunc;
            listener.started = testUploadStartedCallbackFunc;
            videoUpload = [[VODUtil alloc] initWithListener:listener AccessKeyId:AccessKeyId AccessKeySecret:AccessKeySecret ExpireTime:Expiration SecretToken:SecurityToken];
            
            //        [videoUpload addFile:[NSURL fileURLWithPath:videoPath] Endpoint:Endpoint Bucket:Bucket FileName:fileName];
            [videoUpload addFile:[NSURL URLWithString:voicePath] Endpoint:Endpoint Bucket:Bucket FileName:fileName];
            
            [videoUpload start];
        }
        
    } failure:^(NSError *error) {
        
        [HUDProgressTool showErrorWithText:ReqErrCode_Custom_ErrorInfo];
    }];
}

+ (void)uploadVideoWithVideoPath:(NSString *)voicePath
                           title:(NSString *)title
                            tags:(NSString *)tags
                       videoSize:(double)size
                             lat:(double)lat
                             lng:(double)lng
                   successHandle:(void (^)(NSString *))success
                        progress:(void (^)(long, long))progress
                      failHandle:(void (^)(NSString *))fail {
    
    //    [HUDProgressTool showIndicatorWithText:nil];
    dispatch_async(dispatch_get_main_queue(), ^{
        [HUDProgressTool showIndicatorWithText:@"上传视频文件中...0%"];
    });
    
    [UploadRequest createUploadVideoWithFileName:voicePath title:title desc:tags size:(long)size tags:tags success:^(NSDictionary *response) {
        
        if ([[response objectForKey:@"status"] intValue] == 200) {
            NSDictionary *dataDic = [response objectForKey:@"data"];
            NSString *uploadauth = [dataDic objectForKey:@"uploadauth"];
            NSString *uploadaddress = [dataDic objectForKey:@"uploadaddress"];
            NSString *videoid = [dataDic objectForKey:@"videoid"];
            
            if (uploadauth == nil || uploadaddress == nil) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [HUDProgressTool showErrorWithText:@"上传凭证错误"];
                });
                fail(@"上传凭证错误");
                return;
            }
            
            NSString *json1 = [NSString debase64FromString:uploadauth];
            NSDictionary *authDict = [NSString translationJsontoDict:json1];
            
            NSString *json2 = [NSString debase64FromString:uploadaddress];
            NSDictionary *arressDict = [NSString translationJsontoDict:json2];
            
            NSString *SecurityToken = authDict[@"SecurityToken"];
            NSString *AccessKeyId = authDict[@"AccessKeyId"];
            NSString *AccessKeySecret = authDict[@"AccessKeySecret"];
            NSString *Expiration = authDict[@"Expiration"];
            
            NSString *Endpoint = arressDict[@"Endpoint"];
            NSString *Bucket = arressDict[@"Bucket"];
            NSString *fileName = arressDict[@"FileName"];
            
            OnUploadSucceedListener testSuccessCallbackFunc = ^(UploadFileInfo* fileInfo) {
                //                dispatch_async(dispatch_get_main_queue(), ^{
                //                    [HUDProgressTool dismiss];
                //                });
                if (success) {
                    success(videoid);
                }
            };
            
            OnUploadFailedListener testFailedCallbackFunc = ^(UploadFileInfo *fileInfo, NSString *code, NSString* message){
                //HUD 上传失败
                
                NSLog(@"%@", fileInfo);
                dispatch_async(dispatch_get_main_queue(), ^{
                    [HUDProgressTool showErrorWithText:@"上传失败"];
                });
                if (fail) {
                    fail(@"视频上传失败");
                }
            };
            
            OnUploadProgressListener testProgressCallbackFunc = ^(UploadFileInfo* fileInfo, long uploadedSize, long totalSize) {
                
                NSLog(@"=======%ld========%ld======",totalSize,uploadedSize);
                if (progress) {
                    progress(uploadedSize, totalSize);
                }
                CGFloat percent = uploadedSize/(totalSize*1.0) * 100;
                dispatch_async(dispatch_get_main_queue(), ^{
                    [HUDProgressTool showIndicatorWithText:[NSString stringWithFormat:@"上传视频文件中...%.f%%",percent]];
                });
            };
            
            OnUploadStartedListener testUploadStartedCallbackFunc = ^(UploadFileInfo* fileInfo) {
                NSLog(@"upload started .");
                [videoUpload setUploadAuth:fileInfo upLoadAuth:uploadauth uploadAddress:uploadaddress];
            };
            
            VODUploadListener *listener = [[VODUploadListener alloc] init];
            
            listener.success = testSuccessCallbackFunc;
            listener.failure = testFailedCallbackFunc;
            listener.progress = testProgressCallbackFunc;
            listener.started = testUploadStartedCallbackFunc;
            videoUpload = [[VODUtil alloc] initWithListener:listener AccessKeyId:AccessKeyId AccessKeySecret:AccessKeySecret ExpireTime:Expiration SecretToken:SecurityToken];
            
            //        [videoUpload addFile:[NSURL fileURLWithPath:videoPath] Endpoint:Endpoint Bucket:Bucket FileName:fileName];
            [videoUpload addFile:[NSURL URLWithString:voicePath] Endpoint:Endpoint Bucket:Bucket FileName:fileName];
            
            [videoUpload start];
        }
        
    } failure:^(NSError *error) {
        
        [HUDProgressTool showErrorWithText:ReqErrCode_Custom_ErrorInfo];
    }];
}

@end
