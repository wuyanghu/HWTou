//
//  TopicUpload.m
//  HWTou
//
//  Created by Reyna on 2017/12/7.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "TopicUpload.h"
#import "VODUtil.h"
#import "UploadRequest.h"
#import "TopicRequest.h"
#import "NSString+XK.h"
#import "ComImageUpload.h"
#import "HUDProgressTool.h"
#import "PublicHeader.h"

static VODUtil *videoUpload;

@implementation TopicUpload

+ (void)uploadVideoWithAudiopath:(NSString *)audioPath
                            tags:(NSString *)tags
                       audioSize:(double)size
                        labelIds:(NSString *)labelIds
                      frameImage:(NSArray *)images
                           title:(NSString *)title
                         content:(NSString *)content
                             lat:(double)lat
                             lng:(double)lng
                   successHandle:(void (^)())success
                        progress:(void (^)(long, long))progress
                      failHandle:(void (^)(NSString *))fail {
    
    //只有内容没有音频
    if ([audioPath isEqualToString:@""]) {
        
        [ComImageUpload batchWithImages:images success:^(NSArray<NSString *> *url) {
            
            NSString *bmgs = @"";
            for (int i=0; i<url.count; i++) {
                if (i == 0) {
                    NSString *us = url[i];
                    bmgs = [bmgs stringByAppendingString:us];
                }
                else {
                    NSString *us = [NSString stringWithFormat:@",%@",url[i]];
                    bmgs = [bmgs stringByAppendingString:us];
                }
            }
            
            [TopicRequest createTopicWithBmgUrls:bmgs listenUrl:@"" labelIds:labelIds title:title content:content success:^(NSDictionary *response) {
                
                if ([[response objectForKey:@"status"] intValue] == 200) {
                    success();
                }
                else {
                    fail([response objectForKey:@"msg"]);
                }
            } failure:^(NSError *error) {
                [HUDProgressTool showErrorWithText:ReqErrCode_Custom_ErrorInfo];
            }];
            
        } failure:^(NSString *errMsg) {
            fail(errMsg);
        }];
        
    }
    //存在音频
    else {
        
        [UploadRequest createUploadVideoWithFileName:audioPath title:title desc:tags size:(long)size tags:tags success:^(NSDictionary *response) {
            
            if ([[response objectForKey:@"status"] intValue] == 200) {
                NSDictionary *dataDic = [response objectForKey:@"data"];
                NSString *uploadauth = [dataDic objectForKey:@"uploadauth"];
                NSString *uploadaddress = [dataDic objectForKey:@"uploadaddress"];
                NSString *videoid = [dataDic objectForKey:@"videoid"];
                
                if (uploadauth == nil || uploadaddress == nil) {
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
                    
                    [ComImageUpload batchWithImages:images success:^(NSArray<NSString *> *url) {
                        
                        //                    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10 * NSEC_PER_SEC));
                        
                        //                    dispatch_after(delayTime, dispatch_get_main_queue(), ^{
                        
//                        [TopicRequest getPlayInfoWithVid:videoid success:^(NSDictionary *response) {
//
//                            if ([[response objectForKey:@"status"] intValue] == 200) {
//                                NSArray *playInfoListArr = [[response objectForKey:@"data"] objectForKey:@"playInfoList"];
//                                NSString *playMp4URL = [playInfoListArr.lastObject objectForKey:@"playURL"];
                        
                                NSString *bmgs = @"";
                                for (int i=0; i<url.count; i++) {
                                    if (i == 0) {
                                        NSString *us = url[i];
                                        bmgs = [bmgs stringByAppendingString:us];
                                    }
                                    else {
                                        NSString *us = [NSString stringWithFormat:@",%@",url[i]];
                                        bmgs = [bmgs stringByAppendingString:us];
                                    }
                                }
                                
                                [TopicRequest createTopicWithBmgUrls:bmgs listenUrl:videoid labelIds:labelIds title:title content:content success:^(NSDictionary *response) {
                                    
                                    if ([[response objectForKey:@"status"] intValue] == 200) {
                                        success();
                                    }
                                    else {
                                        fail([response objectForKey:@"msg"]);
                                    }
                                } failure:^(NSError *error) {
                                    [HUDProgressTool showErrorWithText:ReqErrCode_Custom_ErrorInfo];
                                }];
                        
//                            }
//                            else {
//                                fail(@"获取音频地址失败");
//                            }
//
//                        } failure:^(NSError *error) {
//                            [HUDProgressTool showErrorWithText:ReqErrCode_Custom_ErrorInfo];
//                        }];
                        //                    });
                        
                        
                    } failure:^(NSString *errMsg) {
                        fail(errMsg);
                    }];
                    
                };
                
                OnUploadFailedListener testFailedCallbackFunc = ^(UploadFileInfo *fileInfo, NSString *code, NSString* message){
                    //HUD 上传失败
                    
                    NSLog(@"%@", fileInfo);
                    NSLog(@"failed code = %@, error message = %@", code, message);
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
                [videoUpload addFile:[NSURL URLWithString:audioPath] Endpoint:Endpoint Bucket:Bucket FileName:fileName];
                
                [videoUpload start];
            }
            
        } failure:^(NSError *error) {
            
            [HUDProgressTool showErrorWithText:ReqErrCode_Custom_ErrorInfo];
        }];
    }
}

@end
