//
//  AudioPlayView.h
//  HWTou
//
//  Created by Reyna on 2017/12/27.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AudioPlayViewDelegate
- (void)rerecordBtnAction;
- (void)saveBtnAction;
@end

@interface AudioPlayView : UIView

@property (nonatomic,weak) id<AudioPlayViewDelegate> delegate;
@property (nonatomic,assign) CGFloat progressValue;

/** 清除播放 */
- (void)clearPlayer;

@end
