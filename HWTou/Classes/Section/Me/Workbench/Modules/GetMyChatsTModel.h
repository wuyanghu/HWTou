//
//  GetMyChatsTModel.h
//  HWTou
//
//  Created by robinson on 2018/3/16.
//  Copyright © 2018年 LieMi. All rights reserved.
//

#import "BaseModel.h"

@interface GetMyChatsTModel : BaseModel
@property (nonatomic,copy) NSString * bmgs;//封面图
@property (nonatomic,copy) NSString * title;// 标题
@property (nonatomic,copy) NSString * name;//广播名
@property (nonatomic,copy) NSString * content;//内容
@property (nonatomic,copy) NSString * createTime;//创建时间
@property (nonatomic,assign) NSInteger lookNum;//观看数
@property (nonatomic,assign) NSInteger commentNum;//评论数
@property (nonatomic,assign) NSInteger collectNum;//收藏数
@property (nonatomic,assign) NSInteger rtcId;//广播，话题，聊吧ID
@property (nonatomic,assign) NSInteger flag;//标志，1：广播，2：话题，3：聊吧
@property (nonatomic,assign) NSInteger isOnline;//是否有主播在线，0:否，1：是
@property (nonatomic,copy) NSString * anchorName;//主播昵称
@property (nonatomic,assign) NSInteger anchorId;//主播ID
@property (nonatomic,assign) NSInteger roomId;//聊天室id
@end
