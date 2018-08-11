//
//  NTESAudienceLiveViewController.h
//  NIMLiveDemo
//
//  Created by chris on 16/8/15.
//  Copyright © 2016年 Netease. All rights reserved.
//

#import "NTESLivePlayerViewController.h"
@class SaveRoomInfoModel,GetChatInfoModel;

@interface NTESAudienceLiveViewController : NTESLivePlayerViewController

- (instancetype)initWithChatroomId:(NSString *)chatroomId streamUrl:(NSString *)url roomInfoModel:(SaveRoomInfoModel *)roomInfoModel chatInfoModel:(GetChatInfoModel *) chatInfoModel;
@property (nonatomic,assign) NSInteger rtcId;
@end
