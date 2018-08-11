//
//  TopicUpload.h
//  HWTou
//
//  Created by Reyna on 2017/12/7.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TopicUpload : NSObject

+ (void)uploadVideoWithAudiopath:(NSString *)audioPath
                            tags:(NSString *)tags
                        audioSize:(double)size
                        labelIds:(NSString *)labelIds
                       frameImage:(NSArray *)images
                            title:(NSString *)title
                             content:(NSString *)content
                              lat:(double)lat
                              lng:(double)lng
                    successHandle:(void(^)())success
                         progress:(void(^)(long, long))progress
                       failHandle:(void(^)(NSString *))fail;

@end
