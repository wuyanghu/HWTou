//
//  BgMusicModel.h
//  HWTou
//
//  Created by robinson on 2018/3/28.
//  Copyright © 2018年 LieMi. All rights reserved.
//

#import "BaseModel.h"

@interface BgMusicModel : BaseModel
@property (nonatomic,assign) NSInteger mId;//音乐ID
@property (nonatomic,copy) NSString * mUrl ;//音乐地址
@property (nonatomic,assign) NSInteger mRank;//排序值
@property (nonatomic,assign) NSInteger chatId;//聊吧ID
@end
