//
//  AudioPlayerFooterView.h
//  HWTou
//
//  Created by robinson on 2017/11/27.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlayerCommentModel.h"
#import "ReplyRecordBtn.h"

@protocol AudioPlayerFooterViewDelegate
- (void)userComment:(NSString *)conent playerCommentModel:(PlayerCommentModel *)playerCommentModel;//用户进行评论
- (void)userCollect;//用户收藏
- (void)redPacketAction;//红包
- (void)moneySupAction;//打赏
- (void)userCommentWithVoice:(NSString *)vidString playerCommentModel:(PlayerCommentModel *)playerCommentModel;//用户进行语音评论
- (void)userSwithCommentType;//用户切换评论方式（使用文字或者发表图片视频）
@end

@interface AudioPlayerFooterView : UIView<UITextFieldDelegate,ReplyRecordBtnDelegate>

@property (nonatomic,strong) UIButton * switchBtn;//切换时语音还是文字输入
@property (nonatomic,strong) UITextField * inputTextField;//输入框
@property (nonatomic,strong) UIButton * collectBtn;//收藏
@property (nonatomic, strong) UIButton *redPacketBtn;//红包
@property (nonatomic, strong) UIButton *moneySupBtn;//打赏
@property (nonatomic,strong) ReplyRecordBtn * replyRecordBtn;//录音

@property (nonatomic, assign) int  isCollected;//是否收藏
@property (nonatomic,assign) BOOL isRecord;
@property (nonatomic,strong) PlayerCommentModel * model;//点击回复，否则为nil

@property (nonatomic,weak) id<AudioPlayerFooterViewDelegate> footerViewDelegate;

- (instancetype)initWithIsHaveMoneySup:(BOOL)isHave;

- (void)replyComment;//回复评论内容,响应焦点
- (void)commentFinish;//评论完，取消焦点，清空数据

@end
