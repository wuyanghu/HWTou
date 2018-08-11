//
//  GetChatRecordsModel.h
//  HWTou
//
//  Created by robinson on 2018/3/27.
//  Copyright © 2018年 LieMi. All rights reserved.
//

#import "BaseModel.h"

@interface GetChatRecordsModel : BaseModel
@property (nonatomic,assign) NSInteger rId;//直播记录ID
@property (nonatomic,assign) NSInteger chatId;//聊吧ID
@property (nonatomic,assign) NSInteger anchorId;//主播ID
@property (nonatomic,copy) NSString * nickName;//主播昵称
@property (nonatomic,assign) NSInteger phone;//主播手机号
@property (nonatomic,copy) NSString * chatAvater;//聊吧封面图
@property (nonatomic,copy) NSString * avater;//主播头像
@property (nonatomic,copy) NSString * chatName;// 聊吧名
@property (nonatomic,copy) NSString * onlineTime;//上线时间
@property (nonatomic,copy) NSString * offlineTime;//下线时间
@property (nonatomic,copy) NSString * duration;//在线时长
@property (nonatomic,assign) NSInteger onlineNum;//累计在线人数
@property (nonatomic,assign) NSInteger commentNum;//累计评论数
@property (nonatomic,copy) NSString * tipMoney;//累计打赏数
@property (nonatomic,assign) NSInteger totalCount;//总条数
@end
