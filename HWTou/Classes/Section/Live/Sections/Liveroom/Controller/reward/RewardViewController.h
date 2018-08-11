//
//  RewardViewController.h
//  HWTou
//
//  Created by robinson on 2018/3/27.
//  Copyright © 2018年 LieMi. All rights reserved.
//

#import "BaseViewController.h"
@class GetChatInfoModel,SaveRoomInfoModel;

@interface RewardViewController : BaseViewController
@property (nonatomic, strong) GetChatInfoModel * getChatInfoModel;
@property (nonatomic, strong) SaveRoomInfoModel * saveRoomInfoModel;
@end
