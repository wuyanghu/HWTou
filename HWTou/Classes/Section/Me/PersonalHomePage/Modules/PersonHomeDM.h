//
//  PersonHomeDM.h
//  HWTou
//
//  Created by robinson on 2017/11/20.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseModel.h"

#define MR_IMG @"bg_img_1"

@interface PersonHomeDM : BaseModel

@property (nonatomic,assign) NSInteger isShield;//是否屏蔽：0，否，1：是
@property (nonatomic,assign) NSInteger isFocus;//是否关注：0，否，1：是
@property (nonatomic,copy) NSString * bmgs;//背景图，以逗号隔开
@property (nonatomic,copy) NSString * introduce;//声音介绍
@property (nonatomic,copy) NSString * headUrl;
@property (nonatomic,copy) NSString * nickname;
@property (nonatomic,assign) NSInteger fansNum;//粉丝数
@property (nonatomic,assign) NSInteger focusNum;//关注数
@property (nonatomic,copy) NSString * city;//城市
@property (nonatomic,assign) NSInteger sex;//性别：0：保密，1：2：
@property (nonatomic,copy) NSString * sign;//签名
@property (nonatomic,strong) NSArray * focusUsers;//最近关注列表
@property (nonatomic,assign) NSInteger uid;//用户ID
@property (nonatomic,copy) NSString * inviteCode;//邀请码

@property (nonatomic,assign) BOOL isSelf;
- (NSArray *)getBgBmgs;//得到背景图
- (NSString *)getCity;//城市
- (NSString *)getSign;//签名
- (NSString *)getSex;//得到性别
- (NSInteger)setSexInt:(NSString *)sexStr;//设置性别
- (NSInteger)isSelfUid;//判断是不是自己的  自己返回0
@end

@interface FocusUserListDM:BaseModel
@property (nonatomic,assign) NSInteger uid;
@property (nonatomic,copy) NSString * headUrl;
@property (nonatomic,copy) NSString * nickname;
@property (nonatomic,copy) NSString * sign;
@end

@interface CityInfoModel:NSObject

@property (nonatomic,copy) NSString * id;
@property (nonatomic,copy) NSString * name;
@property (nonatomic,copy) NSString * parentid;
@property (nonatomic,copy) NSString * parentname;
@property (nonatomic,copy) NSString * areacode;
@property (nonatomic,copy) NSString * zipcode;
@property (nonatomic,copy) NSString * depth;

@end
//用户动态
@interface UserDetailModel:BaseModel
@property (nonatomic,assign) NSInteger markId;
@property (nonatomic,copy) NSString * avater;
@property (nonatomic,copy) NSString * nickname;
@property (nonatomic,copy) NSString * markText;
@property (nonatomic,copy) NSString * markUrl;
@property (nonatomic,assign) NSInteger praise;
@property (nonatomic,assign) NSInteger rtcId;
@property (nonatomic,assign) NSInteger flag;
@property (nonatomic,assign) NSInteger markState;
@property (nonatomic,assign) NSInteger createUid;
@property (nonatomic,copy) NSString * bmg;
@property (nonatomic,copy) NSString * title;
@property (nonatomic,assign) NSInteger lookNum;
@property (nonatomic,copy) NSString * dateTime;
@property (nonatomic,copy) NSString * playing;//正在直播
@property (nonatomic,copy) NSString * markNickName;//话题动态的用户昵称
@property (nonatomic,copy) NSString * listenUrl;//播放地址
@property (nonatomic,assign) NSInteger isPaise;
@property (nonatomic,assign) NSInteger commentId;
@property (nonatomic,assign) NSInteger commentDuration;//用户动态
@property (nonatomic,assign) NSInteger commentFlag;//评论标志 ：0：文字评论，1：语音评论，2：含图片评论，3：含视频评论，

- (BOOL)getIsPraise;
@end

