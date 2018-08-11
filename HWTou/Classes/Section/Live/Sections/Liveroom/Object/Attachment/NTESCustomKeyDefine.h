//
//  NTESCustomKeyDefine.h
//  NIMLiveDemo
//
//  Created by chris on 16/3/30.
//  Copyright © 2016年 Netease. All rights reserved.
//

#ifndef NTESCustomKeyDefine_h
#define NTESCustomKeyDefine_h

typedef NS_ENUM(NSInteger,NTESCustomAttachType)
{
    NTESCustomAttachTypePresent,//礼物
    NTESCustomAttachTypeLike,//点赞
    NTESCustomAttachTypeConnectedMic,//同意互动链接
    NTESCustomAttachTypeDisconnectedMic,//断开互动链接
    NTESCustomAttachTypeAnchorOnLine,//主播上线通知
    NTESCustomAttachTypeGiveAReward,//打赏
    NTESCustomAttachTypeDiscloseReward,//爆料奖励
    
};


//key
#define NTESCMType             @"type"
#define NTESCMData             @"data"
#define NTESCMPresentType      @"present"
#define NTESCMPresentCount     @"count"
#define NTESCMConnectMicUid    @"uid"
#define NTESCMConnectMicNick   @"nick"
#define NTESCMConnectMicName   @"name"
#define NTESCMConnectMicAvatar @"avatar"
#define NTESCMCallStyle        @"style"
#define NTESCMGiftMoney        @"account"

#define NTESCMMeetingName      @"meetingName"

#define NTESCMOrientation      @"orientation"

#endif /* NTESCustomKeyDefine_h */
