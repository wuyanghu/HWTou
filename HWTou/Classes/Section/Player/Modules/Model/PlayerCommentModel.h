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
@property (nonatomic, copy) NSString *commentLocation;//评论位置
@property (nonatomic, assign) int parentCommentId;
@property (nonatomic, assign) int state;
@property (nonatomic, assign) int isPraise;
@property (nonatomic, assign) int isM;//是否是管理员评论：0：不是，1：是
@property (nonatomic, assign) int isTop;//是否置顶：0：不是，1：是
@property (nonatomic, assign) int duration;
@property (nonatomic, copy) NSString *vid;//videoID唯一性
@property (nonatomic, assign) int commentFlag;//评论类别：0.纯文字 1.语音 2.含图片 3.含视频 4.红包
@property (nonatomic, copy) NSString *commentImgUrl;//评论视频的封面图
@property (nonatomic, assign) int redState;//评论红包显示标志 ：0：未发生过关系状态，1：已领完状态，2：已领取状态，3：已过期状态
@property (nonatomic, strong) NSMutableArray *commentUrlArray;//评论含图片时的图片数组
@property (nonatomic, strong) SubCommentModel *subModel;

@property (nonatomic, copy) NSString *dateAndReplyNum;
@property (nonatomic, assign) CGFloat commentHeight;//评论高度
@property (nonatomic, assign) CGFloat imgHeight;//图片高度
@property (nonatomic, assign) CGFloat imgsHeight;//图片总高度
@property (nonatomic, assign) CGFloat replyTotalHeight;//回复总高度
@property (nonatomic, assign) CGFloat cellTotalHeight;//cell总高度
@property (nonatomic, assign) CGFloat locationWidth;//位置长度
@property (nonatomic, assign) CGFloat dateWidth;//日期长度
@property (nonatomic, assign) CGFloat moreWidth;//更多长度

@end
