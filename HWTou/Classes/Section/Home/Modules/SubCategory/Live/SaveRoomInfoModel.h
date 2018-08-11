//
//  SaveRoomInfoModel.h
//  HWTou
//
//  Created by robinson on 2018/3/15.
//  Copyright © 2018年 LieMi. All rights reserved.
//

#import "BaseModel.h"

@interface SaveRoomInfoModel : BaseModel
@property (nonatomic,assign) NSInteger chatId;//聊吧ID
@property (nonatomic,assign) NSInteger userId;//主播ID
@property (nonatomic,copy) NSString * anchorPhone;//主播手机号
@property (nonatomic,copy) NSString * cid;//频道ID
@property (nonatomic,copy) NSString * pushUrl;//推流地址
@property (nonatomic,copy) NSString * rtmpPullUrl;//拉流地址
@property (nonatomic,copy) NSString * roomName;//房间名
@property (nonatomic,assign) NSInteger avType;//直播模式，1：音频，2：视频

@property (nonatomic,assign) BOOL isSuperManager;//超级管理员
@end
