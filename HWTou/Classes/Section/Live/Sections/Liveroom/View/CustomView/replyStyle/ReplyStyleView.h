//
//  ReplyStyleView.h
//  HWTou
//
//  Created by Reyna on 2018/1/22.
//  Copyright © 2018年 LieMi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlayerCommentModel.h"

#define INPUT_DETAIL_HEIGHT 462

@protocol ReplyStyleViewDelegate
- (void)cancelBtnAction;//取消
- (void)publishBtnAction:(NSString *)replyStr location:(NSString *)location data:(NSString *)data replyFlag:(int)replyFlag commentModel:(PlayerCommentModel *)model;//发布
- (void)voiceActoin:(NSString *)voiceUrl;
- (void)imageAction:(NSArray *)imageArray;
- (void)swithCommentTypeAction;//用户切换评论方式（发表语音内容）
@end

@interface ReplyStyleView : UIView

@property (nonatomic, weak) id<ReplyStyleViewDelegate> replyStyleViewDelegate;

@property (nonatomic, strong) PlayerCommentModel *defaultModel;//回复默认的model
@property (nonatomic, strong) PlayerCommentModel *model;//点击回复，否则为nil

- (void)resignEditing:(BOOL)isEditing;//更改响应

@end
