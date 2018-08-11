//
//  NoLiveFooterViewDelegate.h
//  HWTou
//
//  Created by robinson on 2018/3/19.
//  Copyright © 2018年 LieMi. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger{
    NoLiveFooterViewTypePlay,//播放背景音乐
    NoLiveFooterViewTypePause,//暂停背景音乐
    NoLiveFooterViewTypeInteract,//连麦
    NoLiveFooterViewTypeSend,//发送消息
    NoLiveFooterViewTypeRed,//红包
    NoLiveFooterViewTypeGift,//打赏
    NoLiveFooterViewTypeSuperMore,//超级管理员更多
    NoLiveFooterViewTypeMore,//没有主播更多
}NoLiveFooterViewType;

@protocol NoLiveFooterViewDelegate <NSObject>
- (void)noLiveFooterViewAction:(NoLiveFooterViewType)type;
@end

@protocol LiveFooterViewDelegate <NSObject>
- (void)liveFooterViewAction:(NoLiveFooterViewType)type;
@end

typedef enum : NSUInteger{
    startLiveType,//开始直播
    noVoiceType,//没有声音
    voiceType,//有声音
    interactType,//连麦
    specialMusicType,//特效音
    bmgMusicType,//背景音
    moreType,//更多
}AnchorFooterViewType;

@protocol AnchorFooterViewDelegate<NSObject>
- (void)anchorFooterViewAction:(AnchorFooterViewType)type;
@end

typedef enum : NSUInteger{
    wzType,//评论
    tpType,//图片
    spType,//视频
    hbType,//红包
    htType,//话题
    jsType,//结束直播
    interactorType,//连麦
}anchorMoreType;

typedef enum : NSUInteger{
    allMuteType,//全员禁言
    allRelieveMuteType,//全员解除禁言
    stopLiveType,//全员直播
    commentType,//评论
    commentPhotoType,//图片评论
    redType,//红包
    closeType,//关闭
    SuperManagerMoreTypeinteractor,//连麦
}SuperManagerMoreType;

@protocol AnchorMoreFooterViewDelegate<NSObject>
- (void)anchorMoreFooterViewAction:(SuperManagerMoreType)type;
@end


typedef enum : NSUInteger{
    scType,//删除评论
    jyType,//禁言
    tcType,//踢出房间
    bljlType,//爆料奖励
    yjjyType,//永久禁言
    fjsbType,//封禁设备
}superManagerViewType;

@class NTESMessageModel;

@protocol SuperManagerViewDelegate<NSObject>
- (void)superManagerWork:(superManagerViewType)type messageModel:(NTESMessageModel *) messageModel;
@end

@protocol LiveSuperManagerFooterViewDelegate<NSObject>
- (void)liveSuperManagerFooterViewAction:(NoLiveFooterViewType)type;
@end

typedef enum : NSUInteger{
    LiveHeaderViewTypeNotice,//公告
    LiveHeaderViewTypeGift,//打赏
    LiveHeaderViewTypeAttend,//关注
    LiveHeaderViewTypeHeader,//关注
}LiveHeaderViewType;

@protocol LiveHeaderViewDelegate<NSObject>
- (void)liveHeaderViewAction:(LiveHeaderViewType)type;
@end

@protocol NoLiveHeaderViewDelegate<NSObject>
- (void)noLiveHeaderViewAction:(LiveHeaderViewType)type;
@end

