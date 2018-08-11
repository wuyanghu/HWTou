//
//  NTESLiveAudienceHandler.h
//  NIMLiveDemo
//
//  Created by chris on 16/8/17.
//  Copyright © 2016年 Netease. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NTESLiveViewDefine.h"

@class SaveRoomInfoModel;

typedef void(^NTESPlayerShutdownCompletion)(void);

@protocol NTESLiveAudienceHandlerDelegate <NSObject>

@optional

- (void)didUpdateConnectors;

- (void)didUpdateUserOnMic;

- (void)willStartByPassing:(NTESPlayerShutdownCompletion)completion;

- (void)joinMeetingError:(NSError *)error;

- (void)didStartByPassing;

- (void)didStopByPassing;

- (void)didUpdateLiveType:(NTESLiveType)type;

- (void)didUpdateLiveStatus;

- (void)didUpdateLiveOrientation:(NIMVideoOrientation)orientation;

- (void)didUpdateMute:(NTESLiveMuteType)type;

- (void)didStartLive;

- (void)didStopLive:(NSString *)userId;
@end

@protocol NTESLiveAudienceHandlerDatasource <NSObject>

@required


@end

@interface NTESLiveAudienceHandler : NSObject

@property (nonatomic,weak) id<NTESLiveAudienceHandlerDelegate> delegate;

@property (nonatomic,weak) id<NTESLiveAudienceHandlerDatasource> datasource;

@property (nonatomic,assign) BOOL isWaitingForAgreeConnect;

@property (nonatomic,strong) NIMNetCallMeeting *currentMeeting;

- (instancetype)initWithChatroom:(NIMChatroom *)room roomInfoModel:(SaveRoomInfoModel *)roomInfoModel;

- (void)dealWithBypassMessage:(NIMMessage *)message;

- (void)dealWithNotificationMessage:(NIMMessage *)message;

- (void)dealWithBypassCustomNotification:(NIMCustomSystemNotification *)notification;
- (void)refreshModel:(SaveRoomInfoModel *)roomInfoModel meetingName:(NSString *)meetingName;

@end
