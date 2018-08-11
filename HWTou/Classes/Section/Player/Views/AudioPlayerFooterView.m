//
//  AudioPlayerFooterView.m
//  HWTou
//
//  Created by robinson on 2017/11/27.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "AudioPlayerFooterView.h"
#import <AVFoundation/AVFoundation.h>
#import "PublicHeader.h"
#import "ReplyRecordBtn.h"
#import "VoiceUpload.h"

typedef NS_ENUM(NSInteger,buttonTag){
    collectBtnTag,
    switchBtnTag,
};

@implementation AudioPlayerFooterView

- (instancetype)initWithIsHaveMoneySup:(BOOL)isHave {
    self = [super init];
    if (self) {
        
        UIView * lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 0.5)];
        lineView.backgroundColor = UIColorFromHex(0xDBD6D6);
        [self addSubview:lineView];
        
        [self addSubview:self.switchBtn];
        [self addSubview:self.inputTextField];
        [self addSubview:self.replyRecordBtn];
        [self addSubview:self.collectBtn];
//        [self addSubview:self.redPacketBtn];
//        if (isHave) {
//            [self addSubview:self.moneySupBtn];
//        }
        
        [self.switchBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.equalTo(CGSizeMake(30, 30));
            make.left.top.equalTo(self).offset(10);
        }];
        
        [self.inputTextField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.switchBtn.mas_right).offset(10);
            make.bottom.equalTo(self).offset(-10);
            make.height.equalTo(30);
            make.right.equalTo(self.collectBtn.mas_left).offset(-10);
        }];
        
        [self.replyRecordBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.switchBtn.mas_right).offset(10);
            make.bottom.equalTo(self).offset(-10);
            make.height.equalTo(30);
            make.right.equalTo(self.collectBtn.mas_left).offset(-10);
        }];
        
        [self.collectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.switchBtn);
            make.size.equalTo(self.switchBtn);
            make.right.equalTo(self).offset(-10);
        }];

//        if (isHave) {
//            [self.collectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.top.equalTo(self.switchBtn);
//                make.size.equalTo(self.switchBtn);
//                make.right.equalTo(self).offset(-90);
//            }];
//            
//            [self.redPacketBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.top.equalTo(self.switchBtn);
//                make.size.equalTo(self.switchBtn);
//                make.right.equalTo(self).offset(-50);
//            }];
//            
//            [self.moneySupBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.top.equalTo(self.switchBtn);
//                make.size.equalTo(self.switchBtn);
//                make.right.equalTo(self).offset(-10);
//            }];
//        }
//        else {
//            [self.collectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.top.equalTo(self.switchBtn);
//                make.size.equalTo(self.switchBtn);
//                make.right.equalTo(self).offset(-50);
//            }];
//            
//            [self.redPacketBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.top.equalTo(self.switchBtn);
//                make.size.equalTo(self.switchBtn);
//                make.right.equalTo(self).offset(-10);
//            }];
//        }
    
        _isRecord = YES;
        self.inputTextField.hidden = YES;
    }
    return self;
}

#pragma mark - click
- (void)buttonClick:(UIButton *)button{
    
    if ([AccountManager isNeedLogin]) {
        [AccountManager showLoginView];
        return;
    }
    
    if (button.tag == collectBtnTag) {
        button.selected = !button.selected;
        [_footerViewDelegate userCollect];
    }else if (button.tag == switchBtnTag){
//        if (_isRecord) {
//            _isRecord = NO;
//            self.inputTextField.hidden = NO;
//            self.replyRecordBtn.hidden = YES;
//        }else{
//            _isRecord = YES;
//            self.inputTextField.hidden = YES;
//            self.replyRecordBtn.hidden = NO;
//        }
        if (self.footerViewDelegate) {
            [self.footerViewDelegate userSwithCommentType];
        }
    }
}

- (void)redPacketAction:(UIButton *)btn {
    
    if ([AccountManager isNeedLogin]) {
        [AccountManager showLoginView];
        return;
    }
    
    if (_footerViewDelegate) {
        [_footerViewDelegate redPacketAction];
    }
}

- (void)moneySupAction:(UIButton *)btn {
    
    if ([AccountManager isNeedLogin]) {
        [AccountManager showLoginView];
        return;
    }
    
    if (_footerViewDelegate) {
        [_footerViewDelegate moneySupAction];
    }
}

- (void)onTouch {

    if ([AccountManager isNeedLogin]) {
        [AccountManager showLoginView];
        return;
    }
}

#pragma mark - ReplyRecordBtnDelegate
- (void)buttonAudioRecorder:(ReplyRecordBtn *)audioRecorder didFinishRcordWithAudioInfo:(NSDictionary *)audioInfo sendFlag:(BOOL)flag{
    
    if (flag) {
        NSLog(@"\n文件名称:%@\n音频时长:%@\n文件路径:%@",audioInfo[AudioRecorderName],audioInfo[AudioRecorderDuration],audioInfo[AudioRecorderPath]);
        NSString *fileName = [audioInfo objectForKey:AudioRecorderName];
        NSString *voicePath = [audioInfo objectForKey:AudioRecorderPath];
        
//        AVAudioSession *audioSession = [AVAudioSession sharedInstance];
//        //设置类别,此处只支持支持播放
//        [audioSession setCategory:AVAudioSessionCategoryPlayback error:nil];
//        NSURL *urlAudio=[NSURL fileURLWithPath:audioInfo[AudioRecorderPath]];
//        _player=[[AVAudioPlayer alloc]initWithContentsOfURL:urlAudio error:nil];
//        [_player play];
        
        NSData *data = [NSData dataWithContentsOfFile:voicePath];
        [VoiceUpload uploadVoiceWithVoicepath:voicePath title:fileName tags:@"aac" voiceSize:data.length lat:0 lng:0 successHandle:^(NSString *vidString) {
            
            if (self.footerViewDelegate) {
                [self.footerViewDelegate userCommentWithVoice:vidString playerCommentModel:self.model];
            }
        } progress:^(long uploadedSize, long totalSize) {
            
        } failHandle:^(NSString *failMsg) {
            
        }];
        
    }else{
        NSLog(@"取消录音");
    }
}

#pragma mark - uitextfield
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (![textField.text isEqualToString:@""]) {
        [_footerViewDelegate userComment:textField.text playerCommentModel:self.model];
    }
    [textField resignFirstResponder];//取消第一响应者
    return YES;
}

//回复评论内容,响应焦点
- (void)replyComment{
    [_inputTextField becomeFirstResponder];
}

//评论完，取消焦点，清空数据
- (void)commentFinish {
    _model = nil;
    _inputTextField.text = @"";
    [_inputTextField resignFirstResponder];
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    _model = nil;
}

#pragma mark - setter
- (void)setIsCollected:(int)isCollected{
    _isCollected = isCollected;
    if (isCollected == 1) {
        self.collectBtn.selected = YES;
    }else{
        self.collectBtn.selected = NO;
    }
}

#pragma mark - getter

- (ReplyRecordBtn *)replyRecordBtn{
    if (!_replyRecordBtn) {
        _replyRecordBtn = [[ReplyRecordBtn alloc] init];
//        [_replyRecordBtn setTitle:@"按住说话" forState:UIControlStateNormal];
        //        [_replyRecordBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
//        [_replyRecordBtn setChangeTitle:@"松开发送"];
//        [_replyRecordBtn setUpChangeTitle:@"松开取消"];
        [_replyRecordBtn setImage:[UIImage imageNamed:@"tab_anzhu"] forState:UIControlStateNormal];
        [_replyRecordBtn setChangeImage:[UIImage imageNamed:@"tab_songkai"]];
        [_replyRecordBtn setUpChangeImage:[UIImage imageNamed:@"tab_songkai"]];
//        _replyRecordBtn.titleLabel.font = SYSTEM_FONT(14);
//        [_replyRecordBtn setTitleColor:UIColorFromHex(0x8e8f91) forState:UIControlStateNormal];
//        _replyRecordBtn.backgroundColor = UIColorFromHex(0xf3f4f6);
//        _replyRecordBtn.layer.cornerRadius = 15.f;
//        _replyRecordBtn.layer.masksToBounds = YES;
        [_replyRecordBtn addTarget:self
                            action:@selector(onTouch) forControlEvents:UIControlEventTouchDown];
        _replyRecordBtn.delegate = self;
    }
    return _replyRecordBtn;
}

- (UIButton *)switchBtn{
    if (!_switchBtn) {
        _switchBtn = [BasisUITool getBtnWithTarget:self action:@selector(buttonClick:)];
        [_switchBtn setBackgroundImage:[UIImage imageNamed:@"tab_text"] forState:UIControlStateNormal];
        [_switchBtn setBackgroundImage:[UIImage imageNamed:@"tab_yy"] forState:UIControlStateSelected];
        _switchBtn.selected = NO;
        _switchBtn.tag = switchBtnTag;
    }
    return _switchBtn;
}

- (UITextField *)inputTextField{
    if (!_inputTextField) {
        _inputTextField = [BasisUITool getTextFieldWithTextColor:UIColorFromHex(0x8e8f91) withSize:14 withPlaceholder:@"写评论" withDelegate:self];
        _inputTextField.backgroundColor = UIColorFromHex(0xf3f4f6);
        _inputTextField.returnKeyType = UIReturnKeyDone;
    }
    return _inputTextField;
}

- (UIButton *)collectBtn{
    if (!_collectBtn) {
        _collectBtn = [BasisUITool getBtnWithTarget:self action:@selector(buttonClick:)];
        [_collectBtn setBackgroundImage:[UIImage imageNamed:@"db_collection"] forState:UIControlStateNormal];
        [_collectBtn setBackgroundImage:[UIImage imageNamed:@"db_collectionclick"] forState:UIControlStateSelected];
        _collectBtn.tag = collectBtnTag;
    }
    return _collectBtn;
}

- (UIButton *)redPacketBtn {
    if (!_redPacketBtn) {
        _redPacketBtn = [BasisUITool getBtnWithTarget:self action:@selector(redPacketAction:)];
        [_redPacketBtn setBackgroundImage:[UIImage imageNamed:@"lk_btn_hb"] forState:UIControlStateNormal];
    }
    return _redPacketBtn;
}

- (UIButton *)moneySupBtn {
    if (!_moneySupBtn) {
        _moneySupBtn = [BasisUITool getBtnWithTarget:self action:@selector(moneySupAction:)];
        [_moneySupBtn setBackgroundImage:[UIImage imageNamed:@"lk_btn_ds"] forState:UIControlStateNormal];
    }
    return _moneySupBtn;
}

#pragma mark - isEmpty

- (BOOL)isEmpty:(NSString *)str {
    
    if (!str) {
        return YES;
    } else {
        NSCharacterSet *set = [NSCharacterSet whitespaceAndNewlineCharacterSet];
        NSString *trimedString = [str stringByTrimmingCharactersInSet:set];
        if ([trimedString length] == 0) {
            return YES;
        } else {
            return NO;
        }
    }
}

@end
