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
@property (nonatomic, assign) int duration;
@property (nonatomic, assign) int isTop;//是否置顶：0：不是，1：是
@property (nonatomic, assign) int isM;//是否是管理员评论：0：不是，1：是
@property (nonatomic, copy) NSString *vid;//videoID唯一性
@property (nonatomic, assign) int commentFlag;//评论类别：0.纯文字 1.语音 2.含图片 3.含视频
@property (nonatomic, copy) NSString *commentImgUrl;//评论视频的封面图

//添加的数据
@property (nonatomic, copy) NSString *replyString;
@property (nonatomic, strong) NSMutableArray *commentUrlArray;//评论含图片时的图片数组

@property (nonatomic, assign) CGFloat subCellHeight;//cell总高度
@property (nonatomic, assign) CGFloat locationWidth;//位置长度
@property (nonatomic, assign) CGFloat dateWidth;//日期长度
@property (nonatomic, assign) CGFloat subReplyHeight;//回复高度
@property (nonatomic, assign) CGFloat imgHeight;//图片高度
@property (nonatomic, assign) CGFloat imgsHeight;//图片总高度

@property (nonatomic, copy) NSString *first_replyString;
@property (nonatomic, assign) CGFloat first_replyWidth;
@property (nonatomic, assign) CGFloat first_replyHeight;

@end
