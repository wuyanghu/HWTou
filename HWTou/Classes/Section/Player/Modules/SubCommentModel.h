//
//  SubCommentModel.h
//  HWTou
//
//  Created by Reyna on 2017/11/26.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "BaseModel.h"

@interface SubCommentModel : BaseModel

@property (nonatomic, copy) NSString *replyAvater;
@property (nonatomic, copy) NSString *replyNickName;
@property (nonatomic, copy) NSString *createTime;
@property (nonatomic, assign) int toUid;
@property (nonatomic, copy) NSString *toNickName;
@property (nonatomic, assign) int fromUid;
@property (nonatomic, copy) NSString *replyText;
@property (nonatomic, copy) NSString *replyUrl;
@property (nonatomic, copy) NSString *commentLocation;
@property (nonatomic, assign) int praiseNum;
@property (nonatomic, assign) int replyCommentId;
@property (nonatomic, assign) int state;
@property (nonatomic, assign) int showState;
@property (nonatomic, assign) int isPraise;

@property (nonatomic, copy) NSString *replyString;
@property (nonatomic, assign) CGFloat replyHeight;

@property (nonatomic, assign) CGFloat subCellHeight;
@property (nonatomic, assign) CGFloat dateWidth;
@property (nonatomic, assign) CGFloat subReplyHeight;

@end
