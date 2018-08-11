//
//  FayeRecordStateView.h
//  HWTou
//
//  Created by Reyna on 2017/12/27.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,FayeRecordState) {
    FayeRecordStateDefault = 0,       // 按住说话
    FayeRecordStateClickRecord,       // 点击录音<还未录音>
    FayeRecordStateTouchChangeVoice,  // 按住变声
    FayeRecordStateListen,            // 试听
    FayeRecordStateCancel,            // 取消
    FayeRecordStatePrepare,           // 准备中
    FayeRecordStateRecording,         // 录音中
    FayeRecordStateRecordFinished,    // 录音结束<已经录音>
    FayeRecordStatePreparePlay,       // 准备播放
    FayeRecordStatePlay,              // 播放
    FayeRecordStatePlayPause          // 播放暂停
} ;

@protocol FayeRecordStateViewDelegate
- (void)recordTimeOver;
@end

@interface FayeRecordStateView : UIView

@property (nonatomic,weak) id<FayeRecordStateViewDelegate> delegate;

@property (nonatomic, assign) FayeRecordState recordState; //录音状态

@property (nonatomic, copy) void(^playProgress)(CGFloat progress);

- (instancetype)initWithFrame:(CGRect)frame isPlayerStateView:(BOOL)isPlayerStateView;

// 开始录音
- (void)beginRecord;

// 结束录音
- (void)endRecord;

@end
