//
//  PlayerHistoryModel.h
//  HWTou
//
//  Created by Reyna on 2017/12/5.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "BaseModel.h"

@interface PlayerHistoryModel : BaseModel <NSCoding>

@property (nonatomic, copy) NSString *bmg;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, assign) int rtcId;
@property (nonatomic, assign) int roomId;
@property (nonatomic, assign) int flag;//1广播2话题3聊吧
@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *content;
@property (nonatomic, assign) int lookNum;
@property (nonatomic, copy) NSString *playing;
@property (nonatomic, copy) NSString *lookTime;
@property (nonatomic, copy) NSString *listenUrl;

@property (nonatomic, assign) BOOL isPause;
@property (nonatomic, assign) BOOL isWorkChat;

- (void)contentSelfWithPlayerModel:(id)PlayerModel;

@end
