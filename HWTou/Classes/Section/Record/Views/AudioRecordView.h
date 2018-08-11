//
//  AudioRecordView.h
//  HWTou
//
//  Created by Reyna on 2017/12/26.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import <UIKit/UIKit.h>

/** 录制状态 */
typedef NS_ENUM(NSUInteger, FayeVoiceState) {
    FayeVoiceStateDefault = 0, //默认状态
    FayeVoiceStateRecording,  //录音中
    FayeVoiceStateRecordPause //暂停录音
};

@protocol AudioRecordViewDelegate
- (void)playBtnAction;
- (void)saveBtnAction;
- (void)fayeRecordStateValueChanged:(NSString *)stateString;
@end

@interface AudioRecordView : UIView
@property (nonatomic,weak) id<AudioRecordViewDelegate> delegate;

@property (nonatomic, assign) FayeVoiceState state;

/** 清空录制 */
- (void)clearRecord;

@end
