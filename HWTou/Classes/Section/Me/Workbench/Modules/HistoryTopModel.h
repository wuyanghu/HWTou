//
//  HistoryTopModel.h
//  HWTou
//
//  Created by robinson on 2018/1/4.
//  Copyright © 2018年 LieMi. All rights reserved.
//

#import "BaseModel.h"

@interface HistoryTopModel : BaseModel
@property (nonatomic,assign) NSInteger uid;//评论用户ID
@property (nonatomic,copy) NSString * avater;//评论用户头像
@property (nonatomic,copy) NSString * nickName;//昵称
@property (nonatomic,assign) NSInteger comId;//评论ID
@property (nonatomic,assign) NSInteger praiseNum;//点赞数
@property (nonatomic,copy) NSString * createTime ;//评论时间
@property (nonatomic,copy) NSString * topTime;// 置顶时间
@property (nonatomic,copy) NSString * topUid ;//置顶管理员ID
@property (nonatomic,assign) NSInteger isPraise;//是否点赞，0：否，1：是
@property (nonatomic,copy) NSString * comUrl;//评论声音路径
@property (nonatomic,assign) NSInteger duration;//评论时长
@property (nonatomic,assign) NSInteger isTop;//是否置顶0：否，1：是
@property (nonatomic,copy) NSString * vid;//播放 vid
@end
