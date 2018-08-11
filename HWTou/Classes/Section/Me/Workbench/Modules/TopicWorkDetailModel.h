//
//  TopicWorkDetailModel.h
//  HWTou
//
//  Created by robinson on 2017/12/1.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseModel.h"

typedef NS_ENUM(NSInteger,buttonType) {
    commentBtnType,//评论按钮
    playBtnType,//播放按钮
    moreBtnType,//更多按钮
    exchangeBtnType,//换一批按钮
    
    enterBtnType,//录入语音
    editBtnType,//编辑封面
    cancelBtnType,//取消
    issueBtnType,//发布
    
    likeBtnType,//点赞
    contentPlayStateBtnType,//评论
    commentPlayBtnType,//播放语音
    
    arrowsBtnType,//箭头
};

//button点击事件代理
@protocol TopicButtonSelectedDelegate
- (void)buttonSelected:(UIButton *)button;
@end

//获取话题工作台状态
@interface TopicWorkDetailModel : BaseModel

@property (nonatomic,assign) NSInteger isTopicM;//是否是话题管理员：0，否，1：是
@property (nonatomic,assign) NSInteger isChatM;//是否是聊吧超级管理员：0，否，1：是
@property (nonatomic,assign) NSInteger isChannelM;//是否是广播管理员：0，否，1：是
@property (nonatomic,assign) NSInteger isChatAnchor;//是否是聊吧主播：0，否，1：是
@property (nonatomic,copy) NSString * avater;
@property (nonatomic,copy) NSString *nickname;
@property (nonatomic,copy) NSString *joinDate;
@property (nonatomic,assign) NSInteger allLookNum;
@property (nonatomic,assign) NSInteger preLookNum;
@property (nonatomic,assign) NSInteger allCollectNum;
@property (nonatomic,assign) NSInteger preCollectNum;
@property (nonatomic,assign) NSInteger allTargetMoney;
@property (nonatomic,assign) NSInteger preTargetMoney;

@end

@interface MyTopicListModel : BaseModel
@property (nonatomic,assign) NSInteger topicId;
@property (nonatomic,copy) NSString * bmg;
@property (nonatomic,copy) NSString * title;
@property (nonatomic,copy) NSString * content;
@property (nonatomic,assign) NSInteger createUid;
@property (nonatomic,copy) NSString * nickname;
@property (nonatomic,assign) NSInteger lookNum;
@property (nonatomic,assign) NSInteger commentNum;
@property (nonatomic, assign) int isRed;
@end

@interface TopicLabelListModel : BaseModel
@property (nonatomic,assign) NSInteger labelId;
@property (nonatomic,copy) NSString * labelName;
@end

@interface TopicBannerListModel : BaseModel
@property (nonatomic,assign) NSInteger barId;
@property (nonatomic,copy) NSString * barImgUrl;
@property (nonatomic,copy) NSString * linkUrl;
@property (nonatomic,copy) NSString * barTitle;
@end
