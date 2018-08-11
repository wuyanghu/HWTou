//
//  VoiceReplyView.h
//  HWTou
//
//  Created by Reyna on 2018/1/4.
//  Copyright © 2018年 LieMi. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol VoiceReplyViewDelegate
- (void)voiceReplyViewClick;
@end

@interface VoiceReplyView : UIView

@property (nonatomic, assign) int voiceDuration;

- (void)registerWithVoiceUrl:(NSString *)voiceUrl;

@property (nonatomic, assign) BOOL isClickPlay;//点击是否播放
@property (nonatomic, weak) id<VoiceReplyViewDelegate> voiceReplyDelegate;

- (void)startSelfAnimation;
- (void)stopSelfAnimation;

- (void)clearPlay;

@end
