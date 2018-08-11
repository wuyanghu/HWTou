//
//  AudioPlayerCommentCell.h
//  HWTou
//
//  Created by Reyna on 2017/11/22.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlayerCommentModel.h"
#import "SubCommentModel.h"
#import "PlayerHistoryModel.h"

@protocol AudioPlayerCommentDelegate
- (void)moreBtnAction:(PlayerCommentModel *)model;
- (void)replyBtnActionWithToUid:(PlayerCommentModel *)model;
- (void)zanBtnActionWithCommentId:(int)commentId;
- (void)deleteBtnActionWithCommentId:(int)commentId;
- (void)userInfoActionWithUserId:(int)userId;
- (void)topBtnAction:(PlayerCommentModel *)model;
- (void)videoBtnAction:(NSString *)videoUrl;
- (void)imgBtnAction:(NSArray *)imgsArr index:(NSInteger)index;
- (void)getRedPacketWithCommentModel:(PlayerCommentModel *)commentModel;
@end

@interface AudioPlayerCommentCell : UITableViewCell
@property (nonatomic,weak) id<AudioPlayerCommentDelegate> delegate;

+ (NSString *)cellReuseIdentifierInfo;

- (void)bind:(PlayerCommentModel *)model historyModel:(PlayerHistoryModel *)historyModel;

- (void)content:(SubCommentModel *)model historyModel:(PlayerHistoryModel *)historyModel;

@end
