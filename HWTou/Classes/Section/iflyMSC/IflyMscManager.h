//
//  IflyMscManager.h
//  HWTou
//  科大讯飞
//  Created by robinson on 2018/1/19.
//  Copyright © 2018年 LieMi. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^VoiceToTextBlock)(NSString * text);
typedef void(^TextToVoiceBlock)(NSString * voiceUrl);

@interface IflyMscManager : NSObject
@property (nonatomic,copy) VoiceToTextBlock voiceToTextBlock;
@property (nonatomic,copy) TextToVoiceBlock textToVoiceBlock;
+ (instancetype)sharedInstance;
/*
 语音转文字
 voiceUrl:沙盒目录下documnent的语音路径
 voiceToTextBlock:回调结果
 */
- (void)voiceToText:(NSString *)voiceUrl voiceToTextBlock:(VoiceToTextBlock)voiceToTextBlock;
/*
 文字转语音
 text:需要转换的内容
 voiceToTextBlock:回调结果,返回沙盒目录下documnent的语音路径
 */
- (void)textToVoice:(NSString *)text textToVoiceBlock:(TextToVoiceBlock)textToVoiceBlock;
@end
