//
//  SetRedPacketCardView.h
//  HWTou
//
//  Created by Reyna on 2018/2/28.
//  Copyright © 2018年 LieMi. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RedPacketCardViewDelegate
- (void)setRedPacketActionWithTotalPirce:(int)totalPrice num:(int)num payType:(int)payType;
@end

@interface SetRedPacketCardView : UIView
@property (nonatomic,weak) id<RedPacketCardViewDelegate> delegate;

@property (nonatomic, copy) dispatch_block_t dismissBlock;

- (void)show;

- (void)dismiss;

@end
