//
//  VoiceUpload.h
//  HWTou
//
//  Created by Reyna on 2017/12/20.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VoiceUpload : NSObject

+ (void)uploadVoiceWithVoicepath:(NSString *)voicePath
                           title:(NSString *)title
                            tags:(NSString *)tags
                       voiceSize:(double)size
                             lat:(double)lat
                             lng:(double)lng
                   successHandle:(void(^)(NSString *))success
                        progress:(void(^)(long, long))progress
                      failHandle:(void(^)(NSString *))fail;

+ (void)uploadVideoWithVideoPath:(NSString *)voicePath
                           title:(NSString *)title
                            tags:(NSString *)tags
                       videoSize:(double)size
                             lat:(double)lat
                             lng:(double)lng
                   successHandle:(void(^)(NSString *))success
                        progress:(void(^)(long, long))progress
                      failHandle:(void(^)(NSString *))fail;

@end
