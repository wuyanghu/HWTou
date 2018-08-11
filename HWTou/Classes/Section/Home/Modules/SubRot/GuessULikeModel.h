//
//  GuessULikeModel.h
//  HWTou
//
//  Created by robinson on 2017/12/11.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "BaseModel.h"

//猜你喜欢列表
@interface GuessULikeModel : BaseModel
@property (nonatomic,copy) NSString * playingUrl;//播放地址
@property (nonatomic,copy) NSString * bmgs;//封面图
@property (nonatomic,copy) NSString * title;// 标题
@property (nonatomic,copy) NSString * name;//广播名
@property (nonatomic,copy) NSString * content;//内容
@property (nonatomic,copy) NSString * createTime;//创建时间
@property (nonatomic,assign) NSInteger lookNum;//观看数
@property (nonatomic,copy) NSString * playing;//广播正在直播描述
@property (nonatomic,assign) NSInteger collectNum;//收藏数
@property (nonatomic,copy) NSString * createBy;//广播话题创建人UID
@property (nonatomic,assign) NSInteger rank;//观看数跟收藏数之和
@property (nonatomic,assign) NSInteger rtcId;//广播，话题，聊吧ID
@property (nonatomic,assign) NSInteger flag;//标志，1：广播，2：话题，3：聊吧
@property (nonatomic, assign) int isRed;//是否有可抢的红包，0：否，1：是

@property (nonatomic,assign) BOOL isWorkChat;//针对聊吧，在工作台进入为yes

@property (nonatomic,assign) NSInteger roomId;//聊天室id
@property (nonatomic,assign) BOOL isSuperManager;//超级管理员
@end
