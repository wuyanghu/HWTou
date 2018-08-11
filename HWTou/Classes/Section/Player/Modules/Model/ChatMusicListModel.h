//
//  ChatMusicListModel.h
//  HWTou
//
//  Created by robinson on 2018/1/23.
//  Copyright © 2018年 LieMi. All rights reserved.
//

#import "BaseModel.h"
//聊吧背景音乐
@interface ChatMusicListModel : BaseModel
@property (nonatomic,assign) NSInteger mId;//音乐Id
@property (nonatomic,copy) NSString * mName;//音乐名
@property (nonatomic,copy) NSString * mUrl;//音乐地址
@property (nonatomic,assign) NSInteger mRank;//音乐排序值
@property (nonatomic,assign) NSInteger chatId;//音乐对应聊吧Id

@property (nonatomic,assign) NSTimeInterval bgCurrentTime;//记录背景的播放时长
@end
