//
//  iPodReaderUtil.h
//  HWTou
//
//  Created by Reyna on 2017/12/7.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MediaPlayer/MediaPlayer.h>

@interface iPodReaderUtil : NSObject

+ (void)exportAudioWithMPItem:(MPMediaItem *)item exportPath:(NSString *)exportPath success:(void (^)(NSString *type,NSInteger size))success progress:(void (^)(NSInteger currentSize,NSInteger totalSize))progress failure:(void (^) ())failure;;

@end
