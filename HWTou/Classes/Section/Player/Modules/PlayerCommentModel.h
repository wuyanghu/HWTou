//
//  PlayerCommentModel.h
//  HWTou
//
//  Created by Reyna on 2017/11/26.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "BaseModel.h"
#import "SubCommentModel.h"

@interface PlayerCommentModel : BaseModel

@property (nonatomic, copy) NSString *avater;
@property (nonatomic, copy) NSString *nickName;
@property (nonatomic, copy) NSString *createTime;
@property (nonatomic, assign) int replyNum;
@property (nonatomic, assign) int praiseNum;
@property (nonatomic, assign) int parentUid;
@property (nonatomic, copy) NSString *commentText;
@property (nonatomic, copy) NSString *commentUrl;
@property (nonatomic, copy) NSString *commentLocation;
@property (nonatomic, assign) int parentCommentId;
@property (nonatomic, assign) int state;
@property (nonatomic, assign) int isPraise;
@property (nonatomic, strong) SubCommentModel *subModel;

@property (nonatomic, copy) NSString *dateAndReplyNum;
@property (nonatomic, assign) CGFloat commentHeight;
@property (nonatomic, assign) CGFloat replyTotalHeight;
@property (nonatomic, assign) CGFloat cellTotalHeight;
@property (nonatomic, assign) CGFloat dateWidth;
@property (nonatomic, assign) CGFloat moreWidth;

@end
