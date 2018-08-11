//
//  AudioRecorder.h
//  HWTou
//
//  Created by Reyna on 2017/12/27.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <UIKit/UIKit.h>
#import "SingletonMacro.h"

#define FayeDocumentPath [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject]

typedef void(^Success)(BOOL ret);

@protocol AudioRecorderDelegate <NSObject>

/**
 * 准备中
 */
- (void)recorderPrepare;

/**
 * 录音中
 */
- (void)recorderRecording;

/**
 * 录音失败
 */
- (void)recorderFailed:(NSString *)failedMessage;

@end

@interface AudioRecorder : NSObject

@property (nonatomic,copy, readonly) NSString *recordPath;
@property (nonatomic,weak) id<AudioRecorderDelegate> delegate; // 代理
@property (nonatomic,assign) BOOL isRecording;
/**
 *  单例
 */
SingletonH();

/**
 *  开始录音
 */
- (void)beginRecordWithRecordPath:(NSString *)recordPath;

/**
 *  结束录音
 */
- (void)endRecord;

/**
 *  暂停录音
 */
- (void)pauseRecord;

/**
 *  删除录音
 */
- (void)deleteRecord;

/**
 *  返回分贝值
 */
- (float)levels;

@end
