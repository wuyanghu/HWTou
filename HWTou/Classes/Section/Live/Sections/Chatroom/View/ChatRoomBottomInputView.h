//
//  ChatRoomBottomInputView.h
//  HWTou
//
//  Created by Reyna on 2018/1/22.
//  Copyright © 2018年 LieMi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlayerCommentModel.h"

#define INPUT_DETAIL_HEIGHT 462

@protocol ChatRoomBottomInputViewDelegate
- (void)cancelBtnAction;//取消
- (void)publishBtnAction:(NSString *)replyStr location:(NSString *)location data:(NSString *)data replyFlag:(int)replyFlag commentModel:(PlayerCommentModel *)model;//发布
- (void)swithCommentTypeAction;//用户切换评论方式（发表语音内容）
@end

@interface ChatRoomBottomInputView : UIView

@property (nonatomic, weak) id<ChatRoomBottomInputViewDelegate> ChatRoomBottomInputViewDelegate;

@property (nonatomic, strong) PlayerCommentModel *defaultModel;//回复默认的model
@property (nonatomic, strong) PlayerCommentModel *model;//点击回复，否则为nil

- (void)resignEditing:(BOOL)isEditing;//更改响应

@end
