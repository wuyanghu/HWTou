//
//  RedPacketIsHaveTipView.h
//  HWTou
//
//  Created by Reyna on 2018/3/9.
//  Copyright © 2018年 LieMi. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RedPacketIsHaveTipViewDelegate
- (void)tipBtnActionWithRedRId:(NSString *)redRId nickName:(NSString *)nickName avater:(NSString *)avater;
@end

@interface RedPacketIsHaveTipView : UIView
@property (nonatomic,weak) id<RedPacketIsHaveTipViewDelegate> delegate;

@property (nonatomic, assign) int rtcId;


//开启红包轮询
- (void)startLookingForRedPacket;

//刷新
- (void)fireLookingForRedPacket;

//停止红包轮询
- (void)stopLookingForRedPacket;

@end
