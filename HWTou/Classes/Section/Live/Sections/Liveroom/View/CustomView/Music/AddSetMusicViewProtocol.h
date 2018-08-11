//
//  AddSetMusicViewProtocol.h
//  HWTou
//
//  Created by robinson on 2018/3/20.
//  Copyright © 2018年 LieMi. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol AddSetMusicViewDelegate <NSObject>
- (void)addSetMusicAction;
- (void)didSelectMixAuido:(NSURL *)url
               sendVolume:(CGFloat)sendVolume
           playbackVolume:(CGFloat)playbackVolume;
- (void)didPauseMixAudio;

- (void)didResumeMixAudio;

- (void)didUpdateMixAuido:(CGFloat)sendVolume
           playbackVolume:(CGFloat)playbackVolume;
@end

@protocol MyMusicTableViewCellDelegate
- (void)delMusicAction;
@end
