//
//  IflyMscManager.m
//  HWTou
//
//  Created by robinson on 2018/1/19.
//  Copyright © 2018年 LieMi. All rights reserved.
//

#import "IflyMscManager.h"
#import "IFlyMSC/IFlyMSC.h"
#import "IATConfig.h"
#import "ISRDataHelper.h"
#import "TTSConfig.h"

@interface IflyMscManager()<IFlySpeechRecognizerDelegate,IFlySpeechSynthesizerDelegate>
{
    NSString * toUrl;
}
@property (nonatomic, strong) IFlySpeechSynthesizer * iFlySpeechSynthesizer;//(文字合成语音)
@property (nonatomic, strong) IFlySpeechRecognizer *iFlySpeechRecognizer;//(语音转文字)
@end

@implementation IflyMscManager

#pragma mark - 转换方法
//文字转语音
- (void)textToVoice:(NSString *)text textToVoiceBlock:(TextToVoiceBlock)textToVoiceBlock{
    _textToVoiceBlock = textToVoiceBlock;
    toUrl = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"voiceUrl"];
    [_iFlySpeechSynthesizer synthesize:text toUri:toUrl];
    
}

//语音转文字
- (void)voiceToText:(NSString *)voiceUrl voiceToTextBlock:(VoiceToTextBlock)voiceToTextBlock{
    _voiceToTextBlock = [voiceToTextBlock copy];
    
    [self.iFlySpeechRecognizer setParameter:@"-1" forKey:@"audio_source"];
    //启动识别服务
    [self.iFlySpeechRecognizer startListening];
    
    NSString * toUrl = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:voiceUrl];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSData * data = [fileManager contentsAtPath:toUrl];
    
    [self.iFlySpeechRecognizer writeAudio:data];//写入音频，让SDK识别。建议将音频数据分段写入。
    //音频写入结束或出错时，必须调用结束识别接口
    [self.iFlySpeechRecognizer stopListening];//音频数据写入完成，进入等待状态
}

#pragma mark - 语音转文字delegate
- (void) onError:(IFlySpeechError *) errorCode{
    
}

- (void) onResults:(NSArray *) results isLast:(BOOL)isLast{
    NSLog(@"语音回调放方法");
    NSMutableString *resultString = [[NSMutableString alloc] init];
    NSDictionary *dic = results[0];
    
    for (NSString *key in dic) {
        [resultString appendFormat:@"%@",key];
    }
    
    NSString * resultFromJson =  nil;
    
    if([IATConfig sharedInstance].isTranslate){
        
        NSDictionary *resultDic  = [NSJSONSerialization JSONObjectWithData:    //The result type must be utf8, otherwise an unknown error will happen.
                                    [resultString dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:nil];
        if(resultDic != nil){
            NSDictionary *trans_result = [resultDic objectForKey:@"trans_result"];
            
            if([[IATConfig sharedInstance].language isEqualToString:@"en_us"]){
                NSString *dst = [trans_result objectForKey:@"dst"];
                NSLog(@"dst=%@",dst);
                resultFromJson = [NSString stringWithFormat:@"%@\ndst:%@",resultString,dst];
            }
            else{
                NSString *src = [trans_result objectForKey:@"src"];
                NSLog(@"src=%@",src);
                resultFromJson = [NSString stringWithFormat:@"%@\nsrc:%@",resultString,src];
            }
        }
    }
    else{
        resultFromJson = [ISRDataHelper stringFromJson:resultString];
    }
    
    _voiceToTextBlock(resultFromJson);
    
}


- (void) onCompleted:(IFlySpeechError*) error{
    _textToVoiceBlock(toUrl);
}

#pragma mark - 初始化

+ (instancetype)sharedInstance {
    static IflyMscManager *_instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    return _instance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initMakeVoice];
        [self initRecognizer];
    }
    return self;
}

-(void)initMakeVoice{
    
    TTSConfig *instance = [TTSConfig sharedInstance];
    if (instance == nil) {
        return;
    }
    //合成服务单例
    if (_iFlySpeechSynthesizer == nil) {
        _iFlySpeechSynthesizer = [IFlySpeechSynthesizer sharedInstance];
    }
    
    _iFlySpeechSynthesizer.delegate = self;
    
    //设置语速1-100
    [_iFlySpeechSynthesizer setParameter:instance.speed forKey:[IFlySpeechConstant SPEED]];
    
    //设置音量1-100
    [_iFlySpeechSynthesizer setParameter:instance.volume forKey:[IFlySpeechConstant VOLUME]];
    
    //设置音调1-100
    [_iFlySpeechSynthesizer setParameter:instance.pitch forKey:[IFlySpeechConstant PITCH]];
    
    //设置采样率
    [_iFlySpeechSynthesizer setParameter:instance.sampleRate forKey:[IFlySpeechConstant SAMPLE_RATE]];
    
    //设置发音人
    [_iFlySpeechSynthesizer setParameter:instance.vcnName forKey:[IFlySpeechConstant VOICE_NAME]];
    
}

-(void)initRecognizer{
    //单例模式，无UI的实例
    if (_iFlySpeechRecognizer == nil) {
        _iFlySpeechRecognizer = [IFlySpeechRecognizer sharedInstance];
        
        [_iFlySpeechRecognizer setParameter:@"" forKey:[IFlySpeechConstant PARAMS]];
        
        //设置听写模式
        [_iFlySpeechRecognizer setParameter:@"iat" forKey:[IFlySpeechConstant IFLY_DOMAIN]];
    }
    _iFlySpeechRecognizer.delegate = self;
    
    if (_iFlySpeechRecognizer != nil) {
        IATConfig *instance = [IATConfig sharedInstance];
        
        //设置最长录音时间
        [_iFlySpeechRecognizer setParameter:instance.speechTimeout forKey:[IFlySpeechConstant SPEECH_TIMEOUT]];
        //设置后端点
        [_iFlySpeechRecognizer setParameter:instance.vadEos forKey:[IFlySpeechConstant VAD_EOS]];
        //设置前端点
        [_iFlySpeechRecognizer setParameter:instance.vadBos forKey:[IFlySpeechConstant VAD_BOS]];
        //网络等待时间
        [_iFlySpeechRecognizer setParameter:@"20000" forKey:[IFlySpeechConstant NET_TIMEOUT]];
        
        //设置采样率，推荐使用16K
        [_iFlySpeechRecognizer setParameter:instance.sampleRate forKey:[IFlySpeechConstant SAMPLE_RATE]];
        
        if ([instance.language isEqualToString:[IATConfig chinese]]) {
            //设置语言
            [_iFlySpeechRecognizer setParameter:instance.language forKey:[IFlySpeechConstant LANGUAGE]];
            //设置方言
            [_iFlySpeechRecognizer setParameter:instance.accent forKey:[IFlySpeechConstant ACCENT]];
        }else if ([instance.language isEqualToString:[IATConfig english]]) {
            [_iFlySpeechRecognizer setParameter:instance.language forKey:[IFlySpeechConstant LANGUAGE]];
        }
        //设置是否返回标点符号
        [_iFlySpeechRecognizer setParameter:instance.dot forKey:[IFlySpeechConstant ASR_PTT]];
        
    }
    
}

@end
