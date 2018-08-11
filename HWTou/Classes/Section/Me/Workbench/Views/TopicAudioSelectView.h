//
//  TopicAudioSelectView.h
//  HWTou
//
//  Created by Reyna on 2017/12/7.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>

@interface TopicAudioSelectView : UIView

typedef void (^AudioSelectBlock)(MPMediaItem *item);

- (void)show;

@property (nonatomic, copy) AudioSelectBlock selectBlock;
@property (nonatomic, copy) dispatch_block_t dismissBlock;

@end
