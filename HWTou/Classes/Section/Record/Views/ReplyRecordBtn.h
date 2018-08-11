//
//  ReplyRecordBtn.h
//  HWTou
//
//  Created by Reyna on 2017/12/19.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString *const AudioRecorderPath = @"audioPath";          ///<文件路径 string
static NSString *const AudioRecorderName = @"audioName";          ///<文件名称 string
static NSString *const AudioRecorderDuration = @"audioDuration";  ///<音频时长 string

@class ReplyRecordBtn;
@protocol ReplyRecordBtnDelegate <NSObject>
/**
 *  录音结束后的代理方法
 *
 *  @param audioRecorder 所在类
 *  @param audioInfo     录音文件信息
 *  @param flag          YES发送录音文件，NO不发送录音文件
 */
- (void)buttonAudioRecorder:(ReplyRecordBtn *)audioRecorder didFinishRcordWithAudioInfo:(NSDictionary *)audioInfo sendFlag:(BOOL)flag;

@end

@interface ReplyRecordBtn : UIButton

@property(assign,nonatomic) NSInteger recorderDuration; //录音最大时长
@property(assign,nonatomic) id<ReplyRecordBtnDelegate> delegate;
/**
 *  开始录音时，切换显示图片
 *
 *  @param image UIControlNormal状态下的图片
 */
- (void)setChangeImage:(UIImage *)image;
/**
 *  开始录音时，切换显示标题
 *
 *  @param title UIControlNormal状态下的标题
 */
- (void)setChangeTitle:(NSString *)title;
/**
 *  开始录音时，切换显示背景图片
 *
 *  @param backgroundImage UIControlNormal状态下的背景图片
 */
- (void)setChangeBackgroundImage:(UIImage *)backgroundImage;
/**
 *  开始录音时，上滑切换显示图片
 *
 *  @param image UIControlNormal状态下的图片
 */
- (void)setUpChangeImage:(UIImage *)image;
/**
 *  开始录音时，上滑切换显示标题
 *
 *  @param title UIControlNormal状态下的标题
 */
- (void)setUpChangeTitle:(NSString *)title;
/**
 *  开始录音时，上滑切换显示背景图片
 *
 *  @param backgroundImage UIControlNormal状态下的背景图片
 */
- (void)setUpChangeBackgroundImage:(UIImage *)backgroundImage;

@end
